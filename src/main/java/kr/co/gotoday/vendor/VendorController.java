package kr.co.gotoday.vendor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentVo;
import kr.co.gotoday.user.UserVo;

@Controller
public class VendorController {
	
	@Autowired
	private VendorService vendorService;
	
	//content 관리 페이지
	@GetMapping("vendor/content_manage")
	public String contentManage(Model model, ContentVo contentVo) {
		model.addAttribute("map", vendorService.list(contentVo));
		return "vendor/content_manage";
	}
	
	//content 등록 폼
	@GetMapping("/vendor/content_create")
	public String createContent() {
		
		return "vendor/content_create";
	}
	
	//content 등록 처리
	@PostMapping("/vendor/content_create")
	public String createContent(
			ContentVo contentVo, 
			Model model, 
			HttpServletRequest request
			, MultipartFile file
			) {
//		HttpSession sess = request.getSession();
//		UserVo login = (UserVo)sess.getAttribute("loginSess");
//		contentVo.setUser_id(login.getUser_id());
		int r = vendorService.contentCreate(contentVo, file, request);
		if(r > 0) {
			model.addAttribute("cmd", "move");
			model.addAttribute("msg", "정상적으로 등록되었습니다.");
			model.addAttribute("url", "content_manage");
		}else {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "등록 오류, 다시 작성해주세요.");
		}
		
		return "common/return";
	}
	
	
	

}
