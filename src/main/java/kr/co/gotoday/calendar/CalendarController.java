package kr.co.gotoday.calendar;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.gotoday.user.CalendarVO;
import kr.co.gotoday.user.UserVO; // 본인 프로젝트의 UserVO 경로 확인 필수!

@Controller
public class CalendarController {

	@Autowired
	private CalendarService calendarService;

	// 캘린더 PICK 저장 (AJAX 요청)
	// 주소: /calendar/add
	@PostMapping("/calendar/add")
	@ResponseBody
	public Map<String, Object> addCalendar(@RequestBody Map<String, String> params, HttpSession session) {

		Map<String, Object> result = new HashMap<>();

		// 1. 로그인 체크 (세션 이름 "loginSess" 사용)
		UserVO user = (UserVO) session.getAttribute("loginSess");

		if (user == null) {
			result.put("success", false);
			result.put("msg", "로그인이 필요한 서비스입니다.");
			return result;
		}

		try {
			// 2. 프론트(JSP)에서 보낸 데이터 꺼내기
			int contentId = Integer.parseInt(params.get("contentId"));
			String date = params.get("date"); // "2026-01-20"
			String time = params.get("time"); // "14:00"

			// 3. 날짜와 시간 합치기 (selected_at 포맷 만들기)
			String selectedAt = date + " " + time;

			// 4. VO 생성 및 데이터 세팅
			CalendarVO vo = new CalendarVO();
			vo.setUser_id(user.getUser_id());
			vo.setContent_id(contentId);
			vo.setSelected_at(selectedAt);
			vo.setType("PICK"); // ★ 요청하신 대로 PICK으로 고정!

			// 5. 서비스 호출 (DB 저장)
			calendarService.addPick(vo);

			// 6. 성공 결과 리턴
			result.put("success", true);
			result.put("msg", "나의 캘린더에 저장되었습니다!");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("msg", "저장 실패: " + e.getMessage());
		}

		return result;
	}

	@PostMapping("/calendar/remove")
	@ResponseBody
	public Map<String, Object> removeCalendar(@RequestBody Map<String, Integer> params, HttpSession session) {

		Map<String, Object> result = new HashMap<>();

		// 1. 로그인 체크 (필수)
		UserVO user = (UserVO) session.getAttribute("loginSess");
		if (user == null) {
			result.put("success", false);
			result.put("msg", "로그인이 필요한 서비스입니다.");
			return result;
		}

		try {
			// 2. 파라미터 받기 (삭제할 calendar_id)
			// Postman Body: { "calendarId": 5 }
			int calendarId = params.get("calendarId");

			// 3. VO에 담기 (삭제할 번호 + 내 아이디)
			CalendarVO vo = new CalendarVO();
			vo.setCalendar_id(calendarId);
			vo.setUser_id(user.getUser_id()); // 내 아이디를 넣어야 내 것만 지워짐

			// 4. 서비스 호출 (삭제)
			calendarService.removeCalendar(vo);

			result.put("success", true);
			result.put("msg", "삭제되었습니다.");

		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", false);
			result.put("msg", "삭제 실패: " + e.getMessage());
		}

		return result;
	}
}
