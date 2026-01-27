package kr.co.gotoday.cancel;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;         // [추가]
import java.time.temporal.ChronoUnit; // [추가]
import java.util.Base64;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.payment.PaymentVO;
import kr.co.gotoday.reservation.ReservationVO;
import kr.co.gotoday.reservation.TossPaymentClient;

@Service
public class CancelServiceImpl implements CancelService{

    @Autowired
    CancelMapper cancelMapper;
    @Autowired
    TossPaymentClient tossPaymentClient;
    
    @Value("${toss.payments.secret-key}")
    private String secretKey;
    
    @Value("${toss.payments.api-url}")
    private String apiUrl;
    

    @Override
    @Transactional
    public void cancelPayment(String orderId, String cancelReason) throws Exception {
        
        // 1. 결제 정보 조회
        PaymentVO payment = cancelMapper.findPaymentByOrderId(orderId);
        if (payment == null) throw new Exception("결제 정보를 찾을 수 없습니다.");
        
        // 2. 예약 정보 조회
        int targetReservationId = payment.getReservation_id();
        ReservationVO reservation = cancelMapper.findReservationByReservationId(targetReservationId);
        if (reservation == null) throw new Exception("예약 정보를 찾을 수 없습니다.");

        // 유무료 분기 - 가빈 추가
        boolean isFreePayment = payment.getOrder_key().startsWith("FREE");

        int cancelAmount = 0;
        String refundStatusLog = "";

        if (isFreePayment) {
            //0원 취소
            cancelAmount = 0;
            refundStatusLog = "FREE_CANCEL";
        } else if ("가상계좌".equals(payment.getPayment_method()) && "WAITING_FOR_DEPOSIT".equals(payment.getPayment_status())) {
        	tossPaymentClient.cancelPayment(payment.getPayment_key(), cancelReason);
        } else {
        
	        // 3. 날짜 계산 및 환불 금액 산정 [핵심 로직 변경]
	        
	        // (1) 날짜 변환 (DB String -> Java LocalDate)
	        String dateStr = reservation.getReserved_for_at(); // "2026-01-26"
	        LocalDate reservedDate = LocalDate.parse(dateStr); 
	        LocalDate today = LocalDate.now();
	
	        // (2) D-Day 계산
	        long daysBetween = ChronoUnit.DAYS.between(today, reservedDate);
	        
	        // (3) 정책 적용 (수수료 제외한 '환불해줄 금액' 계산)
	        long totalAmount = payment.getAmount_price();
	        cancelAmount = 0; // 토스에 보낼 최종 환불 금액
	        refundStatusLog = ""; // DB에 남길 로그
	
	        
	        
	        if(daysBetween>=8) {
	        	cancelAmount = (int)totalAmount;
	        	refundStatusLog = "D-"+daysBetween + "_100%";
	        }
	       
	        else if (daysBetween >= 7) {
	            // 7일 전: 수수료 10% (환불 90%)
	            cancelAmount = (int)(totalAmount * 0.9);
	            refundStatusLog = "D-" + daysBetween + "_90%";
	        } else if (daysBetween >= 3) {
	            // 3일 전: 수수료 30% (환불 70%)
	            cancelAmount = (int)(totalAmount * 0.7);
	            refundStatusLog = "D-" + daysBetween + "_70%";
	        } else if (daysBetween >= 1) {
	            // 1일 전: 수수료 50% (환불 50%)
	            cancelAmount = (int)(totalAmount * 0.5);
	            refundStatusLog = "D-" + daysBetween + "_50%";
	        } else {
	            // 당일 혹은 지난 날짜: 환불 불가
	            throw new Exception("관람일 당일 및 지난 일정은 취소/환불이 불가합니다.");
	        }
	        
	        // 4. 토스페이먼츠 API 호출
	        // 금액(cancelAmount)이 있을 때만 호출
	        if (cancelAmount > 0) {
	            String paymentKey = payment.getPayment_key();
	            // [수정] 금액을 같이 보냄
	            sendCancelRequestToToss(paymentKey, cancelReason, cancelAmount);
	        }
        }
        // --- 5. DB 업데이트 진행 ---
        
        // (1) 캘린더 삭제
        cancelMapper.deleteCalendarByReservationId(targetReservationId);
        
        // (2) 재고 복구
        int cancelTicketCount = reservation.getAdult_qty() + reservation.getChild_qty() + reservation.getTeen_qty();
        int targetScheduleId = reservation.getSchedule_id();
        int stockResult = cancelMapper.increaseTicketStock(targetScheduleId, cancelTicketCount);
        
        // (3) 결제 정보 업데이트 [수정]
        // VO에 계산된 값들을 채워서 Mapper로 보냅니다.
        payment.setPayment_status("CANCELED");
        payment.setRefund_status(refundStatusLog);
        payment.setCancel_amount(cancelAmount);
        
        int payResult = cancelMapper.updatePaymentCancelInfo(payment); // 메서드 이름 변경됨
        
        // (4) 예약 상태 취소
        int resResult = cancelMapper.updateReservationStatusToCancel(targetReservationId);

        if (payResult == 0 || resResult == 0 || stockResult == 0) {
            throw new RuntimeException("DB 상태 업데이트 실패");
        }
    }

    // [수정] 파라미터에 int cancelAmount 추가
    private void sendCancelRequestToToss(String paymentKey, String cancelReason, int cancelAmount) throws Exception {
        URL url = new URL("https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "application/json");
        
        String encodedAuth = Base64.getEncoder().encodeToString((secretKey + ":").getBytes(StandardCharsets.UTF_8));
        connection.setRequestProperty("Authorization", "Basic " + encodedAuth);
        connection.setDoOutput(true);

        // [수정] JSON Body에 cancelAmount 추가
        String jsonBody = "{" +
                          "\"cancelReason\":\"" + cancelReason + "\"," + 
                          "\"cancelAmount\":" + cancelAmount + 
                          "}";

        try (OutputStream os = connection.getOutputStream()) {
            byte[] input = jsonBody.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        int code = connection.getResponseCode();
        if (code != 200) {
            throw new Exception("토스 결제 취소 실패: 응답 코드 " + code);
        }
    }
}