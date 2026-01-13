package kr.co.gotoday.reservation;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

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
		return "reserve_pay/reservation";
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
		session.setAttribute("schedule", reservation);
		
		//ContentVo contentVo = contentService.findContentById(reservation.getContent_id());
		ContentVo contentVo = new ContentVo();
		contentVo.setAdult_price(17000); 
		model.addAttribute("totalPrice", reservationService.calculate(reservation, contentVo));
			
		return "redirect:/reserve_pay/reservation_result";
	}
	
	@GetMapping("/reserve/payment.do")
	public String showPaymentForm(HttpSession session, ReservationDTO dto, Model model){
		ReservationDTO reservation = (ReservationDTO) session.getAttribute("schedule");
		if (reservation == null) {
		    return "redirect:/reserve/schedule.do";
		}
		model.addAttribute("reservation", reservation);
		
		//ContentVo contentVo = contentService.findContentById(reservation.getContent_id());
		ContentVo contentVo = new ContentVo();
		contentVo.setTitle("무한도전");
		contentVo.setAdult_price(17000);
		model.addAttribute("contentVo",contentVo);
		
		UserVo receiverInfo = (UserVo)session.getAttribute("userVo");
		model.addAttribute("receiverInfo", receiverInfo);
		
		model.addAttribute("totalPrice", reservationService.calculate(reservation, contentVo));
		
		return "reserve_pay/payment";
	}
	
	@PostMapping("/reserve/payment.do")
	public String payment(ReservationVO reservationVO, HttpSession session, Model model) {
		int result = reservationService.payment(reservationVO);
		if(result != 0) {
			return "redirect:/reserve_pay/reservation_result";
		}
		return "/";
	}
	
}
