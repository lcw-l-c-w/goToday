package kr.co.gotoday.content;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.co.gotoday.user.UserVO;

@Controller
public class PopupController {
	// 주입
	@Autowired
	private ContentService contentService;

	// Controller -> db접근 x
	// service를 통해서만 데이터 접근 가능 controller-> service는 단방향 규칙
	// controller가 책임져야하는 것 1. 웹정보처리(세션/로그인 여부) 2. 조회 조건 생성(MainContentDTO세팅 )
	// 3.service 결과를 모델에 담기
	@GetMapping("/popup")
	public String MainHome(Model model, HttpSession sess) {
		MainContentDTO mcd = new MainContentDTO();
		// 조회조건 확인
		mcd.setLimit(5);
		mcd.setContent_kind("popup");

		// 로그인 정보 처리 (웹 책임)
		UserVO user = (UserVO) sess.getAttribute("loginSess");
		if (user != null) {
			mcd.setUser_id(user.getUser_id());
			mcd.setUser_tag_id(user.getUserTagList());
		}
		// service 호출
		model.addAttribute("random", contentService.getRandomContents(mcd));
		model.addAttribute("recommend", contentService.getRecommendContents(mcd));

		model.addAttribute("popularList", contentService.getPopularContent(7, "popup"));
		model.addAttribute("upcomingList", contentService.getUpcomingContent(10, "popup"));

		return "main/popup";
	}
}
