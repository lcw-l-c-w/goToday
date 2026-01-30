package kr.co.gotoday.content;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.co.gotoday.user.UserVO;

@Controller
public class MainController {
	// 주입
	@Autowired
	ContentService contentService;

	// Controller -> db접근 x
	// service를 통해서만 데이터 접근 가능 controller-> service는 단방향 규칙
	// controller가 책임져야하는 것 1. 웹정보처리(세션/로그인 여부) 2. 조회 조건 생성(MainContentDTO세팅 )
	// 3.service 결과를 모델에 담기
	@GetMapping("/main")
	public String MainHome(Model model, HttpSession sess) {
		MainContentDTO mcd = new MainContentDTO();
		// 조회조건 확인
		mcd.setLimit(5);
		mcd.setContent_kind(null);

		// 로그인 정보 처리 (웹 책임)
		UserVO user = (UserVO) sess.getAttribute("loginSess");
		if (user != null) {
			mcd.setUser_id(user.getUser_id());
			List<String> likeTagName= contentService.getUserTagName(user.getUser_id());
			mcd.setUser_tag_name(likeTagName);
		}
		System.out.println("DTO 데이터 확인: " + mcd);
		System.out.println("태그 리스트 사이즈: " + (mcd.getUser_tag_name() != null ? mcd.getUser_tag_name().size() : "null"));
		// service 호출
		model.addAttribute("random", contentService.getRandomContents(mcd));
		model.addAttribute("recommend", contentService.getRecommendContents(mcd));
		model.addAttribute("popularList", contentService.getPopularContent(7, null));
		model.addAttribute("upcomingList", contentService.getUpcomingContent(10, null));

		return "main/main";
	}

}
