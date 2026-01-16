package kr.co.gotoday.reservation;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.TossInputDTO;
import kr.co.gotoday.user.UserVO;


@Controller
public class ReservationController {

	@Autowired
	ReservationService reservationService;

	@PostMapping("/reserve/schedule.do")
	public String selctSchedule(HttpSession session, ReservationDTO dto, @RequestParam int content_id) {
		ReservationDTO reservation = new ReservationDTO();
		reservation.setReserved_for_at(dto.getReserved_for_at());
		reservation.setTime_zone(dto.getTime_zone());
		reservation.setContent_id(content_id);

		session.setAttribute("schedule", reservation);
		return "redirect:/reserve/quantity.do";
	}

	@GetMapping("/reserve/quantity.do")
	public String showQuantityForm(HttpSession session, Model model) {
		 ReservationDTO dto = (ReservationDTO) session.getAttribute("schedule");

		 // [테스트용] 세션에 schedule이 없으면 임시 데이터 생성
		 if (dto == null) {
			 dto = new ReservationDTO();
			 dto.setContent_id(5);
			 dto.setReserved_for_at("2025-02-15");
			 dto.setTime_zone("14:00");
			 session.setAttribute("schedule", dto);
		 }
		 model.addAttribute("reservationDTO", dto);

		 //컨텐츠 없어서 임시 생성
		 //ContentVO contentVO = contentService.findContentById(reservation.getContent_id());
		 ContentVO contentVO = new ContentVO();
		 contentVO.setTitle("무한도전 특별전");
		 contentVO.setAdult_price(1);
		 contentVO.setTeen_price(12000);
		 contentVO.setChild_price(8000);
		 model.addAttribute("contentVo",contentVO);

		return "reserve_pay/reservation";
	}

	@PostMapping("/reserve/quantity.do")
	public String selectQuantity(HttpSession session, ReservationDTO dto, Model model) {
		ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
		if (reservation == null) {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "예약정보가 누락되었습니다.");
		    return "redirect:/reserve/schedule.do";
		}
		reservation.setAdult_qty(dto.getAdult_qty());
		reservation.setTeen_qty(dto.getTeen_qty());
		reservation.setChild_qty(dto.getChild_qty());

		//ContentVo contentVo = contentService.findContentById(reservation.getContent_id());
		ContentVO contentVO = new ContentVO();
		contentVO.setAdult_price(1);
		contentVO.setTeen_price(12000);
		contentVO.setChild_price(8000);


		int total_price = reservationService.calculate(reservation, contentVO);
		reservation.setTotal_price(total_price);

		session.setAttribute("schedule", reservation);

		return "redirect:/reserve/payment.do";
	}

	//수령인 정보 입력 및 결제 페이지
	@GetMapping("/reserve/payment.do")
	public String showPaymentForm(HttpSession session, Model model){
		ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
		if (reservation == null) {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "예약정보가 누락되었습니다.");
		    return "redirect:/reserve/schedule.do";
		}
		//스케줄 관련 세션 정보를 예약 정보로 모델에 저장
		model.addAttribute("reservation", reservation);

		//컨텐츠 정보를 모델에 저장.
		//ContentVo contentVo = contentService.findContentById(reservation.getContent_id());
		ContentVO contentVO = new ContentVO();
		contentVO.setTitle("무한도전 특별전");
		contentVO.setAdult_price(1);
		contentVO.setTeen_price(12000);
		contentVO.setChild_price(8000);
		model.addAttribute("contentVo",contentVO);

		//기본적으로 세션에 있는 유저의 정보를 가져다가 수령인 란에 저장하기 위해 정보를 모델에 저장
		UserVO userInfo = (UserVO)session.getAttribute("loginSess");

		// [테스트용] 로그인 안 된 경우 임시 사용자 정보 생성
		if (userInfo == null) {
			userInfo = new UserVO();
			userInfo.setUser_id(1);
			userInfo.setName("테스트유저");
			userInfo.setEmail("test@test.com");
			userInfo.setPhone_number(null);
		}
		model.addAttribute("receiver_info", userInfo);

		//금액 정보를 모델에 저장
		model.addAttribute("total_price", reservation.getTotal_price());

		TossInputDTO paymentDTO = new TossInputDTO();

		// 토스 order_key 미리 생성
		String orderId = "ORDER_" + UUID.randomUUID().toString();

		paymentDTO.setOrderId(orderId);
		paymentDTO.setOrderName(contentVO.getTitle()); // 상품명
		paymentDTO.setAmount(reservation.getTotal_price()); // 결제 금액
		paymentDTO.setCustomerName(userInfo.getName()); // 구매자 이름
		paymentDTO.setCustomerEmail(userInfo.getEmail()); // 이메일

		model.addAttribute("payInfo",paymentDTO);
		model.addAttribute("orderId", orderId);

	    session.setAttribute("paymentDTO",paymentDTO);

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

			// 서비스에서 DTO → VO 변환
			reservationService.convertToVO(reservation, reservationVO);

			// 사용자 ID 설정
			UserVO userVo = (UserVO) session.getAttribute("loginSess");
			reservationVO.setUser_id(userVo.getUser_id());

			// Session에 임시예약 정보 저장 (결제 완료 후 사용)
			session.setAttribute("pendingReservation", reservationVO);

			TossInputDTO paymentDTO = (TossInputDTO) session.getAttribute("paymentDTO");

			// 토스페이먼츠 결제 정보 응답
			result.put("success", true);
	        result.put("orderId", paymentDTO.getOrderId());
	        result.put("orderName", paymentDTO.getOrderName());
	        result.put("amount", reservationVO.getTotal_price());
	        result.put("customerName", reservationVO.getReceiver_name());
	        result.put("user_id", reservationVO.getUser_id());
	        result.put("reservation_type", reservationVO.getReservation_type());

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
			@RequestParam String paymentKey,
			@RequestParam String orderId,
			@RequestParam int amount,
			Model model) {

		// 토스에서 받은 파라미터를 모델에 전달 (JSP에서 confirm API 호출 시 사용)
		model.addAttribute("paymentKey", paymentKey);
		model.addAttribute("orderId", orderId);
		model.addAttribute("amount", amount);

		return "reserve_pay/success";
	}

	//토스페이먼츠에서 결제 실패 콜백
	@GetMapping("/reserve/fail.do")
	public String paymentFail(@RequestParam String message, Model model) {
		model.addAttribute("msg", message);
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

		// 2. 세션에서 예약 정보 확인
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
			// 4. 토스 결제 승인 + DB 저장 (하나의 트랜잭션)
			ReservationVO result = reservationService.confirmAndCreateReservation(
					reservationVO, paymentKey, orderId, amount);

			// 세션 정리
			session.removeAttribute("schedule");
			session.removeAttribute("pendingReservation");
			session.removeAttribute("paymentDTO");

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
}
