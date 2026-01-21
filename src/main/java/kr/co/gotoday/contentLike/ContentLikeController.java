package kr.co.gotoday.contentLike;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.user.UserVO;

@Controller
public class ContentLikeController {

	// 주입
	@Autowired
	ContentLikeService contentLikeService;

	// 하트 업데이트
	@PostMapping("/heart")
	@ResponseBody
	public ContentLikeVO updateHeart(@RequestBody ContentVO cvo, HttpSession sess) {
		System.out.println("cvo:"+cvo);
		if (cvo.getContent_id() == 0) {
	        System.out.println("컨트롤러: content_id가 전달되지 않았습니다.");
	        return null; // 400 에러 대신 null 응답을 보냄
	    }
		Object obj = sess.getAttribute("loginSess");
		if (obj == null) {
			// 로그인이 안 된 상태라면 처리 중단
			return null;
		}
		UserVO userVO = (UserVO) sess.getAttribute("loginSess");
		Integer user_id = userVO.getUser_id();

		return contentLikeService.getHeartByContentId(cvo.getContent_id(), user_id);

	}

	@GetMapping("/heart")
	public String details(@RequestParam Integer content_id) {
		return "redirect:/detail/" + content_id;
	}
}
