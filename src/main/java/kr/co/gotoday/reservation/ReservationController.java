package kr.co.gotoday.reservation;

import java.io.BufferedReader;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentService;
import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.TossInputDTO;
import kr.co.gotoday.user.UserVO;


@Controller
public class ReservationController {

	@Autowired
	ReservationService reservationService;
	@Autowired
	ContentService contentService;
	
	private static final Logger log =
	        LoggerFactory.getLogger(ReservationController.class);

	@PostMapping(
			value = "/reserve/schedule.do",
		    produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> selectSchedule(HttpSession session, ReservationDTO dto) {
		log.info("===== [selectSchedule] dto = {}", dto);
		// 필수 값 검증
		if (dto.getReserved_for_at() == null || dto.getReserved_for_at().isEmpty()
				|| dto.getTime_zone() == null || dto.getTime_zone().isEmpty()
				|| dto.getContent_id() == 0 || dto.getSchedule_id() == 0) {
			return ResponseEntity.ok("날짜 및 시간 정보가 누락 되었습니다.");
		}
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		LocalDateTime NOW = LocalDateTime.now();

		String[] times = dto.getTime_zone().replace(" ", "").split("~");
	    String startTimeStr = times[0];
	    String endTimeStr   = times[1];
	    
	    LocalDateTime startTime = LocalDateTime.parse(
	            dto.getReserved_for_at() + " " + startTimeStr, formatter);
	    LocalDateTime endTime = LocalDateTime.parse(
	            dto.getReserved_for_at() + " " + endTimeStr, formatter);
		
	    boolean isAllDayType =
	            dto.getContent_time() != null &&
	            endTimeStr.equals(dto.getContent_time().replace(" ", "").split("~")[1]) &&
	            startTimeStr.equals(dto.getContent_time().replace(" ", "").split("~")[0]);
		
	    if (isAllDayType) {
	    	if (NOW.isAfter(endTime)) {
	            return ResponseEntity.ok("이미 운영 시간이 종료된 전시입니다.");
	        }
		} else {
			if (NOW.isAfter(startTime) || NOW.isEqual(startTime)) {
	            return ResponseEntity.ok("지난 회차는 선택하실 수 없습니다.");
	        }
		}

		ReservationDTO reservation = new ReservationDTO();
		reservation.setReserved_for_at(dto.getReserved_for_at());
		reservation.setTime_zone(dto.getTime_zone());
		reservation.setContent_id(dto.getContent_id());
		reservation.setSchedule_id(dto.getSchedule_id());

		session.setAttribute("schedule", reservation);
		return ResponseEntity.ok("OK");
	}

	@GetMapping("/reserve/quantity.do")
	public String showQuantityForm(HttpSession session, Model model) {
		ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
		log.info("===== [showQuantityForm] reservation = {}", reservation);

		if (reservation == null) {
			 model.addAttribute("cmd", "back");
			 model.addAttribute("msg", "예약정보가 누락되었습니다.");
			 return "common/return";
		}
		 
		UserVO userVO = (UserVO) session.getAttribute("loginSess");
		if(userVO.getRole() != 0) {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "일반 사용자만 예약이 가능합니다.");
			return "common/return";
		}

		model.addAttribute("reservationDTO", reservation);
		 
		ContentVO contentVO = contentService.getDetailContents(reservation.getContent_id(), userVO.getUser_id());
		ContentScheduleVO scheduleVO = reservationService.findCurrentTickets(reservation.getSchedule_id());
		model.addAttribute("contentVO",contentVO);
		model.addAttribute("scheduleVO", scheduleVO);

		return "reserve_pay/reservation";
	}

	@PostMapping("/reserve/quantity.do")
	public String selectQuantity(HttpSession session, ReservationDTO dto, Model model) {
		ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
		if (reservation == null) {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "예약정보가 누락되었습니다.");
			return "common/return";
		}
		reservation.setAdult_qty(dto.getAdult_qty());
		reservation.setTeen_qty(dto.getTeen_qty());
		reservation.setChild_qty(dto.getChild_qty());

		UserVO userVO = (UserVO) session.getAttribute("loginSess");
		ContentVO contentVO = contentService.getDetailContents(reservation.getContent_id(), userVO.getUser_id());

		int total_price = reservationService.calculate(reservation, contentVO);
		reservation.setTotal_price(total_price);

		session.setAttribute("schedule", reservation);

		return "redirect:/reserve/payment.do";
	}

	//수령인 정보 입력 및 결제 페이지
	@GetMapping("/reserve/payment.do")
	public String showPaymentForm(HttpSession session, Model model){
		ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
		
		if (reservation == null ) {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "예약정보가 누락되었습니다.");
			return "common/return";
		}
		int totalQty = reservation.getAdult_qty()+ reservation.getChild_qty() + reservation.getTeen_qty();
		log.info("totalQty = {}", totalQty);
		if(totalQty == 0) {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "올바른 접근이 아닙니다.");
			return "common/return";
		}
		//스케줄 관련 세션 정보를 예약 정보로 모델에 저장
		model.addAttribute("reservation", reservation);

		//컨텐츠 정보를 모델에 저장.
		UserVO userVO = (UserVO) session.getAttribute("loginSess");
		ContentVO contentVO = contentService.getDetailContents(reservation.getContent_id(), userVO.getUser_id());
		model.addAttribute("contentVo",contentVO);

		//기본적으로 세션에 있는 유저의 정보를 가져다가 수령인 란에 저장하기 위해 정보를 모델에 저장
		UserVO userInfo = (UserVO)session.getAttribute("loginSess");
		model.addAttribute("receiver_info", userInfo);

		//금액 정보를 모델에 저장
		model.addAttribute("total_price", reservation.getTotal_price());

		// 토스 요청 정보 생성
		TossInputDTO paymentDTO = new TossInputDTO();
		String orderId = "ORDER_" + UUID.randomUUID().toString();

		paymentDTO.setOrderId(orderId);
		paymentDTO.setOrderName(contentVO.getTitle()); // 상품명
		paymentDTO.setAmount(reservation.getTotal_price()); // 결제 금액
		paymentDTO.setCustomerName(userInfo.getName()); // 구매자 이름
		paymentDTO.setCustomerEmail(userInfo.getEmail()); // 이메일
		session.setAttribute("paymentDTO",paymentDTO);

		model.addAttribute("payInfo",paymentDTO);
		model.addAttribute("orderId", orderId);

		return "reserve_pay/payment";
	}

	//결제하기 버튼 누르면 여기로 와서 임시예약정보 세션에 저장
	@PostMapping("/reserve/payment.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> payment(
			ReservationVO reservationVO,
			HttpSession session,
			Model model) {

		Map<String, Object> result = new HashMap<>();

		try {
			ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
		
			if (reservation == null) {
				result.put("success", false);
	            result.put("msg", "예약 정보가 없습니다.");
				return ResponseEntity.badRequest().body(result);
			}

			// 예약자 설정
			UserVO userVO = (UserVO) session.getAttribute("loginSess");
			reservationVO.setUser_id(userVO.getUser_id());

			// 서비스에서 DTO → VO 변환 : 이때 예약 상태 PENDING으로 변경,
			reservationService.convertToVO(reservation, reservationVO);

			// Session에 임시예약 정보 저장 (결제 완료 후 사용)
			session.setAttribute("pendingReservation", reservationVO);

			
			//0원일 때 서비스 분기
			int total_price = reservation.getTotal_price();
			if (total_price == 0) {
				ReservationVO resultVO = reservationService.confirmAndCreateReservation(reservationVO, null, null, 0);
				result.put("success", true);
				result.put("free", true);   // ⭐ 프론트 분기용
				result.put("reservationCode", resultVO.getReservation_code());

				// 세션 정리
	            session.removeAttribute("schedule");
	            session.removeAttribute("pendingReservation");
	            session.removeAttribute("paymentDTO");
	            
	            //success get 접근을 막기 위한 예약코드
	            session.setAttribute("LAST_RESERVATION_CODE", resultVO.getReservation_code());

	            return ResponseEntity.ok(result);
			}


			TossInputDTO paymentDTO = (TossInputDTO) session.getAttribute("paymentDTO");

			session.setAttribute("LAST_RESERVATION_CODE", reservationVO.getReservation_code());
			
			// 토스페이먼츠 결제 요청 정보
			result.put("success", true);
	        result.put("orderId", paymentDTO.getOrderId());
	        result.put("orderName", paymentDTO.getOrderName());
	        result.put("amount", paymentDTO.getAmount());
	        result.put("customerName", userVO.getName());
	        result.put("user_id", reservationVO.getUser_id());
	        result.put("receive_type", reservationVO.getReceive_type());

			return ResponseEntity.ok(result);

		} catch (Exception e) {
			e.printStackTrace();
	        result.put("success", false);
	        result.put("msg", "서버 오류: " + e.getMessage());
	        return ResponseEntity.status(500).body(result);
		}
	}

	//토스 페이먼츠 결제 성공 콜백 -> success.jsp 렌더링 (실제 승인은 /reserve/confirm에서 처리)
	@GetMapping("/reserve/success.do")
	public String paymentSuccess(
			@RequestParam(required=false) String paymentKey,
			@RequestParam(required=false) String orderId,
			@RequestParam(required=false) Integer amount,
			Model model,
			HttpSession session) {
		
		String reservationCode = (String) session.getAttribute("LAST_RESERVATION_CODE");
		
		if(reservationCode == null) {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "올바른 접근이 아닙니다.");
			return "common/return";
		}
		// 토스에서 받은 파라미터를 모델에 전달 (JSP에서 confirm API 호출 시 사용)
		model.addAttribute("paymentKey", paymentKey);
		model.addAttribute("orderId", orderId);
		model.addAttribute("amount", amount ==null ? 0 : amount);
		model.addAttribute("reservationCode", reservationCode);

		return "reserve_pay/success";
	}

	//토스페이먼츠에서 결제 실패 콜백
	@GetMapping("/reserve/fail.do")
	public String paymentFail(@RequestParam(required=false) String message, Model model, HttpSession sess) {
		if(message == null) {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "올바른 접근이 아닙니다.");
			return "common/return";
		}
		model.addAttribute("msg", message);
		
		sess.removeAttribute("pendingReservation");
		sess.removeAttribute("paymentDTO");
	    
		return "reserve_pay/fail";
	}


	//토스 결제 승인 API (success.jsp에서 호출)
	@PostMapping("/reserve/confirm")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> confirmPayment(
			@RequestBody String jsonBody,
			HttpSession session) {

		Map<String, Object> response = new HashMap<>();
		String paymentKey;
		String orderId;
		int amount;

		// 1. 요청 데이터 파싱
		try {
			JSONParser parser = new JSONParser();
			JSONObject requestData = (JSONObject) parser.parse(jsonBody);
			
			paymentKey = (String) requestData.get("paymentKey");
			orderId = (String) requestData.get("orderId");
			
			String amountStr = (String) requestData.get("amount");
			amount = Integer.parseInt(amountStr);
			
		} catch (Exception e) {
			response.put("success", false);
			response.put("msg", "요청 데이터 파싱 오류");
			return ResponseEntity.badRequest().body(response);
		}

		// 2. 세션에서 임시 예약 정보 확인
		ReservationVO reservationVO = (ReservationVO) session.getAttribute("pendingReservation");
		if (reservationVO == null) {
			response.put("success", false);
			response.put("msg", "예약 정보가 없습니다.");
			return ResponseEntity.badRequest().body(response);
		}

		// 3. 금액 검증
		if (reservationVO.getTotal_price() != amount) {
			response.put("success", false);
			response.put("msg", "결제 금액이 일치하지 않습니다.");
			return ResponseEntity.badRequest().body(response);
		}

		try {
			// 4. 예약 프로세스 
			ReservationVO result = reservationService.confirmAndCreateReservation(
					reservationVO, paymentKey, orderId, amount);
			// 세션 정리
			session.removeAttribute("schedule");
			session.removeAttribute("pendingReservation");
			session.removeAttribute("paymentDTO");
			
			//success get 접근을 막기 위한 예약코드
            session.setAttribute("LAST_RESERVATION_CODE", result.getReservation_code());

			response.put("success", true);
			response.put("msg", "예약이 완료되었습니다.");
			response.put("reservationCode", result.getReservation_code());
			return ResponseEntity.ok(response);

		} catch (RuntimeException e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("msg", e.getMessage());
			return ResponseEntity.status(500).body(response);
		}
	}
	
	@PostMapping("/webhook/toss")
	public ResponseEntity<Map<String, Object>> handleTossWebhook(HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();
		
		try {
			//요청 본문 읽기
			StringBuilder requestBody = new StringBuilder();
			BufferedReader reader = request.getReader();
			String line;
			while ((line = reader.readLine()) != null) {
				requestBody.append(line);
			}
			
			String body = requestBody.toString();
			log.info("========================================");
			log.info("[WEBHOOK 수신] {}", body);
			log.info("========================================");
			
			//JSON 파싱
			JSONParser parser = new JSONParser();
			JSONObject webhookData = (JSONObject) parser.parse(body);
				
			String order_key = (String) webhookData.get("orderId");          
			String status = (String) webhookData.get("status");    
			
			log.info("[WEBHOOK] orderId={},status={}", 
					order_key, status);
			
			//상태가 DONE 상태면 DB도 입금 완료 처리
			if ("DONE".equals(status)) {
				reservationService.updatePaymentStatus(order_key);
			}
			
			//성공 응답 (토스에게 200 응답 필수)
			response.put("success", true);
			response.put("message", "Webhook 처리 완료");
			return ResponseEntity.ok(response);
			
		} catch (Exception e) {
			log.error("[WEBHOOK 처리 실패]", e);
			response.put("success", false);
			response.put("message", e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
	
	@PostMapping("/ticket/{reservation_id}")
    public ReservationVO onlineTicket(@PathVariable Integer reservation_id) {
        return reservationService.findByReservationId(reservation_id);
    }
    @GetMapping("/ticket/{reservation_id}")
    public String showTicket(@PathVariable("reservation_id") Integer reservation_id, HttpSession sess,Model model) {
        UserVO userVO= (UserVO) sess.getAttribute("loginSess");
        if(userVO== null || reservation_id==null) {
        	model.addAttribute("msg","로그인이 필요합니다.");
        	 model.addAttribute("cmd", "back");
        	return "redirect:/member/login"; // null 반환 대신 로그인 페이지로 유도
        }
        ReservationVO reservationVO =reservationService.findByReservationId(reservation_id); 
        if(reservationVO==null) {
            model.addAttribute("msg","존재하지 않는 예약입니다");
            return "common/return";
        }
        ContentVO contentVO = contentService.getDetailContentsForTicket(reservationVO.getContent_id(), userVO.getUser_id());
        if(contentVO == null) {
            // 콘텐츠 정보가 사라졌거나 가져올 수 없는 경우에 대한 처리
        	System.out.println("???");
            model.addAttribute("msg", "해당 콘텐츠 정보를 불러올 수 없습니다.");
            return "common/return";
        }
        int totalQty= reservationVO.getChild_qty()+reservationVO.getTeen_qty()+reservationVO.getAdult_qty();
        reservationVO.setTotalQty(totalQty);
        reservationVO.setLocation(contentVO.getLocation());
        reservationVO.setTitle(contentVO.getTitle());
        reservationVO.setImgPath(contentVO.getMain_image_path());
        model.addAttribute("reservation", reservationVO);
        return "mypage/reserve_ticket";
    }

}
