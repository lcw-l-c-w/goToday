package kr.co.gotoday.reservation;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.gotoday.content.ContentService;
import kr.co.gotoday.content.ContentVo;
import kr.co.gotoday.user.UserVo;


@Controller
public class ReservationController {
	
	@Autowired
	ReservationService reservationService;
	ContentService contentService;
	
	@PostMapping("/reserve/schedule.do")
	public String selctSchedule(HttpSession session, ReservationDTO dto) {
		ReservationDTO reservation = new ReservationDTO();
		reservation.setReserved_for_at(dto.getReserved_for_at());
		reservation.setTime_zone(dto.getTime_zone());
		reservation.setContent_id(dto.getContent_id());
		
		session.setAttribute("schedule", reservation);
		return "redirect:/reserve/quantity.do";
	}
	
	@GetMapping("/reserve/quantity.do")
	public String showQuantityForm(HttpSession session, Model model) {
		 ReservationDTO dto = (ReservationDTO) session.getAttribute("schedule");
		 if (dto == null) {
		        return "redirect:/content/content_detail";
		 }
		 model.addAttribute("reservationDTO", dto);
		 
		 //ContentVo contentVo = contentService.findContentById(reservation.getContent_id());
		 ContentVo contentVo = new ContentVo();
		 contentVo.setTitle("무한도전");
		 contentVo.setAdult_price(17000);
		 model.addAttribute("contentVo",contentVo);
		 
		return "reserve_pay/reservation";
	}
	
	@PostMapping("/reserve/quantity.do")
	public String selectQuantity(HttpSession session, ReservationDTO dto, Model model) {
		ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
		if (reservation == null) {
		    return "redirect:/reserve/schedule.do";
		}
		reservation.setAdult_qty(dto.getAdult_qty());
		reservation.setTeen_qty(dto.getTeen_qty());
		reservation.setChild_qty(dto.getChild_qty());
		
		//ContentVo contentVo = contentService.findContentById(reservation.getContent_id());
		ContentVo contentVo = new ContentVo();
		contentVo.setAdult_price(17000); 
		
		int total_price = reservationService.calculate(reservation, contentVo);
		reservation.setTotal_price(total_price);
		
		session.setAttribute("schedule", reservation);
			
		return "redirect:/reserve/payment.do";
	}
	
	//수령인 정보 입력 및 결제 페이지 
	@GetMapping("/reserve/payment.do")
	public String showPaymentForm(HttpSession session, ReservationDTO dto, Model model){
		ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
		if (reservation == null) {
		    return "redirect:/reserve/schedule.do";
		}
		//스케줄 관련 세션 정보를 예약 정보로 모델에 저장
		model.addAttribute("reservation", reservation);
		
		//컨텐츠 정보를 모델에 저장.
		//ContentVo contentVo = contentService.findContentById(reservation.getContent_id());
		ContentVo contentVo = new ContentVo();
		contentVo.setTitle("무한도전");
		contentVo.setAdult_price(17000);
		model.addAttribute("contentVo",contentVo);
		
		//기본적으로 세션에 있는 유저의 정보를 가져다가 수령인 란에 저장하기 위해 정보를 모델에 저장
		UserVo userInfo = (UserVo)session.getAttribute("userVo");
		model.addAttribute("receiver_info", userInfo);
		
		//금액 정보를 모델에 저장
		model.addAttribute("total_price", reservation.getTotal_price());
		
		// 토스 orderId 미리 생성
	    String orderId = "ORDER_" + System.currentTimeMillis();
	    model.addAttribute("orderId", orderId);
	    session.setAttribute("orderId", orderId);
	    
		return "reserve_pay/payment";
	}
	
	//결제 요청 -> jsp에서 ajax로 호출  - peding으로 저장한 후 json응답 보내주기
	@PostMapping("/reserve/payment.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> payment(
			ReservationVO reservationVO, 
			HttpSession session ) {
		
		Map<String, Object> result = new HashMap();
		
		try { 
			ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
			if(reservation == null) {
				
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
		if (reservation == null) {
			return ResponseEntity.badRequest().body(null)
		}
		// Session 데이터를 VO로 복사
		String reservedForAt = reservation.getReserved_for_at() +" "+ reservation.getTime_zone();
		reservationVO.setReserved_for_at(reservedForAt);
		reservationVO.setAdult_qty(reservation.getAdult_qty());
		reservationVO.setTeen_qty(reservation.getTeen_qty());
		reservationVO.setChild_qty(reservation.getChild_qty());
		reservationVO.setContent_id(reservation.getContent_id());
		reservationVO.setTotal_price(reservation.getTotal_price());
		
		//예약코드 생성 (밀리타임을코드로)
		String reservationCode = "RES_" + System.currentTimeMillis();
		reservationVO.setReservation_code(reservationCode);
		reservationVO.setReservation_status("PENDING");  // 결제 대기 상태
		
		//화면에서 입력 받는 값은 reservationVO로 바인딩
		reservationVO.getReceiver_name();
		reservationVO.getReceiver_birth();
		reservationVO.getReceiver_phone();
		
		UserVo userVo = (UserVo) session.getAttribute("userVo");
		reservationVO.setUser_id(userVo.getUser_id());

		// Session에 임시예약 정보 저장 (결제 완료 후 사용)
		session.setAttribute("pendingReservation", reservationVO);
		
		
		// 토스페이먼츠 결제 정보 준비(PaymentDTO 형식)
		String orderId = "ORDER_" + System.currentTimeMillis();
		model.addAttribute("orderId", orderId);
		model.addAttribute("orderName", "무한도전 티켓");  // contentVo.getTitle()
		model.addAttribute("amount", reservationVO.getTotal_price());
		model.addAttribute("customerName", reservationVO.getReceiver_name());
				
		return "reserve_pay/payment";  // 토스 결제창 호출하는 페이지
	}
	
	//토스 페이먼츠 결제 성공 콜백 -> 최종확인
	@GetMapping("reserve_pay/success.do")
	public String paymentSuccess(
			@RequestParam String paymentKey,
			@RequestParam String orderId,
			@RequestParam int amount,
			HttpSession session,
			Model model) {
		
		try {
			ReservationVO pendingReservation = (ReservationVO) session.getAttribute("pendingReservation");
			if (pendingReservation == null ) {
				model.addAttribute("msg","예약 정보 누락");
				model.addAttribute("status", "failed");
				return "reserve_pay/payment_fail"; //실패 페이지로 이동
			}
			
			//가격 검증 -> 프론트 단에서 넘어오는 가격은 변동 될 수 있는 정보니 세션에 저장된 값과 동일한지 비교
			if (pendingReservation.getTotal_price() != amount ) {
				model.addAttribute("msg","결제 금액이 일치하지 않습니다");
				model.addAttribute("status", "failed");
				return "reserve_pay/payment_fail"; //실패 페이지로 이동
			}
			
			ReservationVO result = reservationService.createReservationWithPaymentent(
				pendingReservation,
				paymentKey, 
				orderId, 
				amount);
			
			if (result != null) {
				// 성공 시 예약 정보를 모델에 추가
//				model.addAttribute("reservation", pendingReservation);
//				model.addAttribute("reservationCode", pendingReservation.getReservation_code());
				
				// Session 정리
				session.removeAttribute("schedule");
				session.removeAttribute("pendingReservation");
				session.removeAttribute("orderId");
				
				// 예약 완료 페이지로 이동
				return "reserve_pay/payment_complete";
				
			} else {
				model.addAttribute("msg", "예약 저장에 실패했습니다.");
				model.addAttribute("status", "failed");
				return "reserve_pay/payment_fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("msg", "서버 오류가 발생: " + e.getMessage());
			model.addAttribute("status", "failed");
			return "reserve_pay/payment_fail";
		}
	}

	//토스페이먼츠에서 결제 실패 콜백 
	@GetMapping("/payments/fail.do")
	public String paymentFail(@RequestParam String message, Model model) {
		model.addAttribute("msg", message);
		return "reserve_pay/payment_fail";
	}
	
	
	
	
	
}
