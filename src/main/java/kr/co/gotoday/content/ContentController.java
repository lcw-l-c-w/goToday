package kr.co.gotoday.content;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import kr.co.gotoday.user.UserVO;

@Controller
public class ContentController {
	
	@Autowired
	ContentService contentService;
@GetMapping("/detail/{content_id}")//@pathVariable @RequestParam 햇갈려...
public String contentDetail(Model model,@PathVariable("content_id") int content_id, HttpSession session ) {
	 System.out.println("▶ Controller 진입, content_id = " + content_id);
	UserVO user= (UserVO)session.getAttribute("loginUser");
	
			Integer user_id= (user!=null)? user.getUser_id():null;
			 Object result = contentService.getDetailContents(content_id, user_id);
			 System.out.println("▶ Service 반환값 = " + result);

	model.addAttribute("content",result);
	return "content/content_detail";
}
}
