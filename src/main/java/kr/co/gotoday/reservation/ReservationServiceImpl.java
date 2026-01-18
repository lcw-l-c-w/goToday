package kr.co.gotoday.reservation;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.PaymentMapper;
import kr.co.gotoday.payment.PaymentVO;
import kr.co.gotoday.user.CalendarVO;

@Service
public class ReservationServiceImpl implements ReservationService{
	@Autowired
	ReservationMapper reservationMapper;
	@Autowired
	PaymentMapper paymentMapper;

	private static final Logger log =
	        LoggerFactory.getLogger(ReservationService.class);
	
	@Override
	public int calculate(ReservationDTO reservationDTO, ContentVO contentVO) {
		if (reservationDTO == null || contentVO == null) {
            throw new IllegalArgumentException("예약 정보와 콘텐츠 정보 누락");
        }
		
		int adultPrice = reservationDTO.getAdult_qty() * contentVO.getAdult_price();
		int teenPrice = reservationDTO.getTeen_qty() * contentVO.getTeen_price();
		int childPrice = reservationDTO.getChild_qty() * contentVO.getChild_price();
		
		return adultPrice + teenPrice + childPrice;
	}
	
	@Override
	public ReservationVO convertToVO(ReservationDTO dto, ReservationVO reservationVO) {
		// 시간정보
		reservationVO.setReserved_for_at(dto.getReserved_for_at());
		reservationVO.setTime_zone(dto.getTime_zone());
		reservationVO.setSchedule_id(dto.getSchedule_id());
		
		// 수량 및 금액 정보
		reservationVO.setAdult_qty(dto.getAdult_qty());
		reservationVO.setTeen_qty(dto.getTeen_qty());
		reservationVO.setChild_qty(dto.getChild_qty());
		reservationVO.setTotal_price(dto.getTotal_price());
		
		// 콘텐츠 정보
		reservationVO.setContent_id(dto.getContent_id());
		
		// 임시 예약 생성
		reservationVO.setReservation_code("RES_" + System.currentTimeMillis());
		reservationVO.setReservation_status("PENDING");
		
		return reservationVO;
	}
	
	@Override
	public ReservationVO findByReservationId(int reservation_id) {
		return reservationMapper.findByReservationId(reservation_id);
	}
	
	@Override
	public ReservationVO confirmAndCreateReservation(ReservationVO reservationVO, String paymentKey, String orderId, int amount) {
		PaymentVO paymentVO = null;
		boolean ticketSucceed = false; 
		try {
			// 잔여 확인 후 티켓 선차감 (중복 결제 방지)
			trySubCurrentTicket(reservationVO);
			ticketSucceed = true;
			
			// 토스 결제 승인
			paymentVO = confirmTossPayment(paymentKey, orderId, amount);
			
			// DB 저장 (예약 + 결제)-> 트랜잭션
			return createReservationWithPaymentent(reservationVO, paymentVO);
			
		} catch (Exception e) {
			if (paymentVO != null) {
				try {
					//결제 승인 후 DB저장 실패 로그
					log.error("[예약결제 DB저장 실패]",e);
					// 토스 결제 취소
					cancelTossPayment(paymentKey, "DB 저장 실패로 인한 취소");
				} catch (Exception cancelException) {
					log.error("[토스 결제 취소 실패] paymentKey={}, orderId={}", 
							paymentKey,
							orderId
							);
				}
			}
			//티켓 선차감 했는데 에러가 난 경우 -> 티켓 복구 
			if (ticketSucceed) {
				try {
//					tryAddCurrentTicket();
				} catch (Exception cancelException) {
					log.error("[티켓 복구 실패] scheduleId={},total_qty={}", 
							reservationVO.getSchedule_id(),
							(reservationVO.getAdult_qty() +reservationVO.getTeen_qty() +reservationVO.getChild_qty())
							);
				}
			}
			throw new RuntimeException("예약 처리 중 오류 발생: " + e.getMessage(), e);
		}
	}
	
	@Override
	public int trySubCurrentTicket(ReservationVO reservationVO) throws Exception {
		
		int total_qty = reservationVO.getAdult_qty()
				+reservationVO.getTeen_qty()
				+ reservationVO.getChild_qty();
		
		Map< String, Object> map = new HashMap<String, Object>();
		map.put("total_qty", total_qty);
		map.put("schedule_id", reservationVO.getSchedule_id());
		
		int result = reservationMapper.updateCurrentTicket(map);
		
		if (result < 1) {
			// CAS 실패 = 재고 부족
			throw new Exception("잔여 티켓 수량이 부족합니다.");
		}
		
		return result;
	}

	@Override
	@Transactional
	public ReservationVO createReservationWithPaymentent(ReservationVO reservationVO, PaymentVO paymentVO) throws Exception {
		//예약 상태를 완료로 변경
		reservationVO.setReservation_status("DONE");
		
		// 예약 정보 저장
		int reservationResult = reservationMapper.createReservation(reservationVO);
		if(reservationResult <= 0 ) {
			throw new Exception("에약 정보 저장에 실패했습니다.");
		}
		// 결제 정보 저장 
		paymentVO.setReservation_id(reservationVO.getReservation_id());
		int paymentResult = paymentMapper.createPayment(paymentVO);//			
		if (paymentResult ==0) {
			throw new Exception("결제 정보 저장에 실패했습니다.");
		}
		
		// 저장된 예약 정보 반환
		return reservationVO;
	}

	
	@SuppressWarnings("unchecked")
	@Override
	public PaymentVO confirmTossPayment(String paymentKey, String orderId, int amount) {
		HttpURLConnection connection = null;
		OutputStream outputStream = null;
		InputStream responseStream = null;
		Reader reader = null;

		try {
			// 토스페이먼츠 승인 API 요청 데이터
			JSONObject requestBody = new JSONObject();
			requestBody.put("orderId", orderId);
			requestBody.put("amount", String.valueOf(amount));
			requestBody.put("paymentKey", paymentKey);

			// Secret Key 인코딩-> 설정 파일로 분리 필요)
			String secretKey = "test_sk_DpexMgkW36ym117LE2x48GbR5ozO";
			Base64.Encoder encoder = Base64.getEncoder();
			byte[] encodedBytes = encoder.encode((secretKey + ":").getBytes(StandardCharsets.UTF_8));
			String authorization = "Basic " + new String(encodedBytes);

			// HTTP 연결 설정
			URL url = new URL("https://api.tosspayments.com/v1/payments/confirm");
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestProperty("Authorization", authorization);
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestMethod("POST");
			connection.setDoOutput(true);

			// 요청 전송
			outputStream = connection.getOutputStream();
			outputStream.write(requestBody.toString().getBytes("UTF-8"));
			outputStream.flush();

			// 응답 처리
			int responseCode = connection.getResponseCode();
			boolean isSuccess = responseCode == 200;

			responseStream = isSuccess ? connection.getInputStream() : connection.getErrorStream();
			reader = new InputStreamReader(responseStream, StandardCharsets.UTF_8);

			JSONParser parser = new JSONParser();
			JSONObject tossResponse = (JSONObject) parser.parse(reader);

			// 실패 시 예외 발생
			if (!isSuccess) {
				String errorMessage = (String) tossResponse.get("message");
				throw new RuntimeException("토스 결제 승인 실패: " + errorMessage);
			}

			// 성공 시 PaymentVO 생성 및 반환
			PaymentVO paymentVO = new PaymentVO();
			paymentVO.setPayment_key((String) tossResponse.get("paymentKey"));
			paymentVO.setOrder_key((String) tossResponse.get("orderId"));
			paymentVO.setPayment_method((String) tossResponse.get("method"));
			paymentVO.setPayment_status((String) tossResponse.get("status"));
			paymentVO.setAmount_price((int) tossResponse.get("amo"));
			paymentVO.setRefund_status("NONE");

			return paymentVO;

		} catch (Exception e) {
			throw new RuntimeException("토스 결제 승인 중 오류 발생: " + e.getMessage(), e);
		} finally {
			// 리소스 정리
			if (reader != null) try { reader.close(); } catch (Exception ignored) {}
			if (responseStream != null) try { responseStream.close(); } catch (Exception ignored) {}
			if (outputStream != null) try { outputStream.close(); } catch (Exception ignored) {}
			if (connection != null) connection.disconnect();
		}
	}



	//토스 결제 취소 API 호출
	@SuppressWarnings("unchecked")
	public void cancelTossPayment(String paymentKey, String cancelReason) {
		HttpURLConnection connection = null;
		OutputStream outputStream = null;
		InputStream responseStream = null;
		Reader reader = null;

		try {
			// 취소 요청 데이터
			JSONObject requestBody = new JSONObject();
			requestBody.put("cancelReason", cancelReason);

			// Secret Key 인코딩
			String secretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6";
			Base64.Encoder encoder = Base64.getEncoder();
			byte[] encodedBytes = encoder.encode((secretKey + ":").getBytes(StandardCharsets.UTF_8));
			String authorization = "Basic " + new String(encodedBytes);

			// HTTP 연결 설정
			URL url = new URL("https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel");
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestProperty("Authorization", authorization);
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestMethod("POST");
			connection.setDoOutput(true);

			// 요청 전송
			outputStream = connection.getOutputStream();
			outputStream.write(requestBody.toString().getBytes("UTF-8"));
			outputStream.flush();

			// 응답 처리
			int responseCode = connection.getResponseCode();
			responseStream = (responseCode == 200) ? connection.getInputStream() : connection.getErrorStream();
			reader = new InputStreamReader(responseStream, StandardCharsets.UTF_8);

			JSONParser parser = new JSONParser();
			JSONObject tossResponse = (JSONObject) parser.parse(reader);

			if (responseCode != 200) {
				String errorMessage = (String) tossResponse.get("message");
				throw new RuntimeException("토스 결제 취소 실패: " + errorMessage);
			}

			System.out.println("토스 결제 취소 성공: " + paymentKey);

		} catch (Exception e) {
			throw new RuntimeException("토스 결제 취소 중 오류: " + e.getMessage(), e);
		} finally {
			if (reader != null) try { reader.close(); } catch (Exception ignored) {}
			if (responseStream != null) try { responseStream.close(); } catch (Exception ignored) {}
			if (outputStream != null) try { outputStream.close(); } catch (Exception ignored) {}
			if (connection != null) connection.disconnect();
		}
	}

//	@Override
//	public int createScheduleByReservation(ReservationVO reservationVO, int user_id, int content_id) {
//		
//		CalendarVO calendarVO = new CalendarVO();
//		calendarVO.setSelected_at(reservationVO.getReserved_for_at());
//
//		
//		try {
//			int result = reservationMapper.createScheduleByReservation(map);
//			if(result < 0) {
//				throw new Exception("캘린더에 예약 일정을 저장하는데 오류 발생");
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		
//		return 0;
//	}

	@Override
	public int createScheduleByReservation(ReservationVO reservationVO, int user_id, int content_id) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	 

	
	
}