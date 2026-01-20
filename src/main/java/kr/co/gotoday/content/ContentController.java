package kr.co.gotoday.content;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.gotoday.user.UserVO;

@Controller
public class ContentController {
	// 주입
	@Autowired
	private ContentService contentService;

	// 상세보기
	@GetMapping("/detail/{content_id}") // @pathVariable @RequestParam 햇갈려...
	public String contentDetail(Model model, @PathVariable("content_id") int content_id, HttpSession session) {
		System.out.println("▶ Controller 진입, content_id = " + content_id);
		UserVO user = (UserVO) session.getAttribute("loginSess");
//		if (user == null) {
//			sysout
//		    return "member/login";
//		}
		Integer user_id = (user != null) ? user.getUser_id() : null;
		// content
		Object result = contentService.getDetailContents(content_id, user_id);
		System.out.println("▶ Service 반환값 = " + result);

		model.addAttribute("content", result);
		return "content/content_detail";
	}

	// 날짜 조회(.ajax)
	@GetMapping("/schedule/date")
	@ResponseBody
	public List<String> dateReservation(@RequestParam Integer content_id) {
		return contentService.getAvailableDatesByContent(content_id);
	}

	// 시간 조회 (.ajax)
	@GetMapping("/schedule/time")
	@ResponseBody
	public List<ContentScheduleVO> timeReservation(@RequestParam Integer content_id,
			@RequestParam String scheduled_at) {
		return contentService.getAvailableTimesByContent(content_id, scheduled_at);
	}

	// 예약 post 보내기
	@PostMapping("/reservation/select")
	@ResponseBody
	public void selectReservation(@RequestParam Integer content_id, @RequestParam String date,
			@RequestParam String time, @RequestParam Integer schedule_id, HttpSession sess) {
		sess.setAttribute("reservation_contentID", content_id);
		sess.setAttribute("reservation_date", date);
		sess.setAttribute("reservation_time", time);
	}

	// 예약 페이지 보내기
	@GetMapping("/reservation/select")
	public String selectTicket(HttpSession sess, Model model) {
		model.addAttribute("content_id", sess.getAttribute("reservation_contentID"));
		model.addAttribute("scheduled_at", sess.getAttribute("reservation_date"));
		model.addAttribute("time_zone", sess.getAttribute("reservation_time"));
		return "redirect:/reserve/quantity.do";
	}

}
