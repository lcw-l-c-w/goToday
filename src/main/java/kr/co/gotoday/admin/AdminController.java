package kr.co.gotoday.admin;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.user.UserVO;
import kr.co.gotoday.vendor.VendorService;


@Controller
public class AdminController {
	
	@Autowired
	private AdminService adminService;
	@Autowired
	private VendorService vendorService;
	
	
	@GetMapping("/admin/main")
	public String adminMain(HttpSession session, Model model) {
		UserVO login = (UserVO)session.getAttribute("loginSess");
		 // 로그인 체크
	    if (login == null) {
	        model.addAttribute("cmd", "move");
	        model.addAttribute("msg", "로그인이 필요합니다.");
	        model.addAttribute("url", "login");
	        return "common/return";
	    }
		if(login.getEmail().contains("@")) {
			model.addAttribute("cmd", "move");
			model.addAttribute("msg", "관리자 전용 페이지입니다.");
			model.addAttribute("url", "main");
			return "common/return";
		}
		return "admin/main";
	}

	//content 관리 페이지
	@GetMapping("/admin/content_manage")
	public String adminManage() {
		
		return "/admin/content_manage";
	}
	
	@GetMapping("/admin/content_manage/list")
	@ResponseBody
	public Map<String, Object> contentList(
			@RequestParam(required = false) String keyword,
			@RequestParam(required = false) Integer is_active,
			HttpSession session
			) {
		UserVO login = (UserVO) session.getAttribute("loginSess");
		if(login == null) {
			return Map.of("list", List.of());
		}
		// keyword가 존재할 때만 공백 제거 후 다시 할당
		if(keyword != null) {
			keyword = keyword.trim();
		}
		
		Map<String, Object> map = adminService.getFilterList(login.getUser_id(), keyword, is_active);
		
		return map;
	}
	
	@GetMapping("/admin/content_request/list")
	@ResponseBody
	public Map<String, Object> contentListRequest(
	        @RequestParam(required = false) String keyword,
	        @RequestParam String content_status,
	        HttpSession session
			) {
	    UserVO login = (UserVO) session.getAttribute("loginSess");
	    if (login == null) {
	        return Map.of("list", List.of());
	    }

	    if (keyword != null) {
	        keyword = keyword.trim();
	    }

	    return adminService.getRequestList(
	            login.getUser_id(),
	            keyword,
	            content_status
	    );
	}
	
	@GetMapping("/admin/user_manage/list")
	@ResponseBody
	public Map<String, Object> userList(
			@RequestParam(required = false) String keyword,
			@RequestParam(required = false) Integer role,
			HttpSession session
			) {
		UserVO login = (UserVO) session.getAttribute("loginSess");
		if (login == null) {
			return Map.of("list", List.of());
		}
		
		if (keyword != null) {
			keyword = keyword.trim();
		}
		
		return adminService.getUserList(
				login.getUser_id(),
				keyword,
				role
				);
	}
	
	//활성화 상태 변경
	@GetMapping("/admin/content_manage/act")
	@ResponseBody
	public int updateActive(@RequestParam int content_id) {
	    return adminService.updateActive(content_id);
	}

	//삭제 변경
	@GetMapping("/admin/content_manage/delete")
	@ResponseBody
	public int updateDelete(@RequestParam int content_id) {
		return adminService.updateDelete(content_id);
	}
	
	@GetMapping("/admin/content_request")
	public String adminRequest() {
		return "/admin/content_request";
	}
	
	@GetMapping("/admin/content_view/{content_id}")
	public String adminContentView(
			@PathVariable int content_id,
			HttpSession session,
			Model model
			) {
		UserVO login = (UserVO)session.getAttribute("loginSess");
		 // 로그인 체크
	    if (login == null) {
	        model.addAttribute("cmd", "move");
	        model.addAttribute("msg", "로그인이 필요합니다.");
	        model.addAttribute("url", "login");
	        return "common/return";
	    }
		if(login.getEmail().contains("@")) {
			model.addAttribute("cmd", "move");
			model.addAttribute("msg", "관리자 전용 페이지입니다.");
			model.addAttribute("url", "main");
			return "common/return";
		}
		ContentVO contentVO = vendorService.getContent(content_id);
		List<ContentScheduleVO> scheduleList = vendorService.getContentSchedule(content_id);
		
		model.addAttribute("contentVO", contentVO);
		model.addAttribute("scheduleList", scheduleList);
		
		return "/admin/content_view";
	}
	
	//승인 거절
	@PostMapping("/admin/content_request/approve")
	@ResponseBody
	public int updateApprove(@RequestParam int content_id) {
		
		return adminService.updateRequest(content_id);
	}
	
	//승인 거절
	@PostMapping("/admin/content_request/reject")
	@ResponseBody
	public int updateReject(@RequestParam int content_id) {
		
		return adminService.updateRejected(content_id);
	}

	//user 관리 페이지
	@GetMapping("/admin/user_manage")
	public String userManage() {
		return "admin/user_manage";
	}
	
	
	
	

}
















