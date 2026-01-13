package kr.co.gotoday.content;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.co.gotoday.user.UserVO;

public class ContentController {

	
	
	 @GetMapping("/main")
	 public String main(Model model, UserVO vo, HttpServletRequest request) {
		 HttpSession session = request.getSession();
		 UserVO login = (UserVO)session.getAttribute("loginSess");
		 if(login == null) { // 비회원인 경우
			 
		 } else if(login.getUserTagList() == null) { // 회원이지만 태그가 없는 경우
			 
		 } else { // 회원이고 태그도 있는 경우
			 
		 }
		 
		 return "main/main";
	 }
}
