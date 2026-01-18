package kr.co.gotoday.admin;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.gotoday.user.UserVO;

@Controller
public class AdminController {
	
	private AdminService adminService;
	
	//content 관리 페이지
	@GetMapping("/admin/content_manage")
	public String adminManage() {
		
		return "admin/content_manage";
	}
	
	@GetMapping("/admin/content_manage/list")
	@ResponseBody
	public Map<String, Object> contentList(
			@RequestParam(required = false) String keyword,
			@RequestParam(required = false) String activate,
			HttpSession session
			) {
		UserVO login = (UserVO) session.getAttribute("loginSess");
		if(login == null) {
			return Map.of("list", List.of());
		}
		if(keyword != null) keyword.trim();
		if(activate != null && activate.trim().isEmpty()) activate = null;
		
		Map<String, Object> map = adminService.getFilterList(login.getUser_id(), keyword, activate);
		
		return map;
	}
	

}
