package kr.co.gotoday.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {
	
	private AdminService adminService;
	
	//content 관리 페이지
	@GetMapping("/admin/content_manage")
	public String adminManage() {
		
		return "admin/content_manage";
	}
	

}
