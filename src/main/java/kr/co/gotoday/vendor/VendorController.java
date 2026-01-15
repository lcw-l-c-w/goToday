package kr.co.gotoday.vendor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentEnum;
import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentVO;

@Controller
public class VendorController {
	
	@Autowired
	private VendorService vendorService;
	
	//content 관리 페이지
	@GetMapping("vendor/content_manage")
	public String contentManage(Model model, ContentVO contentVo) {
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
			ContentVO contentVo, 
			ContentScheduleVO contentScheduleVO,
			Model model, 
			HttpServletRequest request, 
			@RequestParam("main_image_file")MultipartFile file,
			@RequestParam(value="Time[]", required = false) List<String> timeList,
			@RequestParam(value="total_ticket", required = false) int total_ticket
			) {
//		HttpSession sess = request.getSession();
//		UserVo login = (UserVo)sess.getAttribute("loginSess");
//		ContentVO.setUser_id(login.getUser_id());
		
		contentVo.setUser_id(1); //임시 로그인
		contentVo.setContent_status(ContentEnum.STATUS_REQUESTED.name());
		contentVo.setIs_active(true);
		contentVo.setIs_delete(false);
		int r = vendorService.createContent(contentVo, contentScheduleVO, file, request, timeList, total_ticket);
		
		contentScheduleVO.setCurrent_ticket(contentScheduleVO.getTotal_ticket());
		
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
