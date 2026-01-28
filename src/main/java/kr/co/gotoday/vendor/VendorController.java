package kr.co.gotoday.vendor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentEnum;
import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.reservation.VendorReservationSearchDTO;
import kr.co.gotoday.user.UserVO;

@Controller
public class VendorController {
	
	@Autowired
	private VendorService vendorService;
	
	@GetMapping("/vendor/main")
	public String adminMain(HttpSession session, Model model) {
		UserVO login = (UserVO)session.getAttribute("loginSess");
		 // 로그인 체크
	    if (login == null) {
	        model.addAttribute("cmd", "move");
	        model.addAttribute("msg", "로그인이 필요합니다.");
	        model.addAttribute("url", "login");
	        return "common/return";
	    }
		if(login.getRole()==0) {
			model.addAttribute("cmd", "move");
			model.addAttribute("msg", "업체 전용 페이지입니다.");
			model.addAttribute("url", "main");
			return "common/return";
		}
		return "vendor/main";
	}
	
	//content 관리 페이지
	@GetMapping("/vendor/content_manage")
	public String contentManage() {
		
		return "vendor/content_manage";
	}
	
	//content list 별도
	@GetMapping("/vendor/content_manage/list")
	@ResponseBody
	public Map<String, Object> contentList(
			@RequestParam(required = false) String keyword,
			@RequestParam(required = false) String status,
			@RequestParam(required = false) Integer page,
			HttpSession session
			){
		UserVO login = (UserVO) session.getAttribute("loginSess");
		if (login == null) {
		    return Map.of("list", List.of());
		}
		if (keyword != null) keyword = keyword.trim();
	    if (status != null && status.trim().isEmpty()) status = null;
		
		Map<String, Object> map = vendorService.getFilterList(login.getUser_id(), keyword, status, page);
		
		return map;
	}

	//content list 별도
	@GetMapping("/vendor/reserve_pay_manage/list")
	@ResponseBody
	public Map<String, Object> reserveList(
			VendorReservationSearchDTO dto,
			HttpSession session
			){
		UserVO login = (UserVO) session.getAttribute("loginSess");
		if (login == null) {
			return Map.of("list", List.of());
		}
		
		dto.setUser_id(login.getUser_id());
		Map<String, Object> map = vendorService.findReservationByVendor(dto);
		
		return map;
	}
	
	//content 등록 폼
	@GetMapping("/vendor/content_create")
	public String createContent(
			@RequestParam(required = false) Integer content_id,
			Model model,
			HttpSession session
			) {
		UserVO login = (UserVO)session.getAttribute("loginSess");
		if(login == null) {
			return "redirect:/member/login";
		}
		//수정일 때
		if(content_id != null) {
			ContentVO contentVO = vendorService.getContent(content_id);
			
			//보안: 본인 글 체크
			if(contentVO.getUser_id() != login.getUser_id()) {
				return "redirect:/vendor/content_manage";
			}
			List<ContentScheduleVO> scheduleList = vendorService.getContentSchedule(content_id);
			
			model.addAttribute("isEdit", true);
			model.addAttribute("contentVO", contentVO);
			model.addAttribute("scheduleList", scheduleList);
		} else {
			model.addAttribute("isEdit", false);
		}
		
		return "vendor/content_create";
	}
	
	//content 등록 처리
	@PostMapping("/vendor/content_create")
	public String createContent(
			ContentVO contentVo, 
			ContentScheduleVO contentScheduleVO,
			Model model, 
			HttpServletRequest request, 
			@RequestParam(value="main_image_file", required = false)MultipartFile file,
			@RequestParam(value="Time[]", required = false) List<String> timeList,
			@RequestParam(value="total_ticket", required = false) Integer total_ticket
			) {
		try {
			HttpSession sess = request.getSession();
			UserVO login = (UserVO)sess.getAttribute("loginSess");
			if (login == null) {
				return "redirect:/member/login"; 
			}
			contentVo.setUser_id(login.getUser_id());
			
			contentVo.setContent_status(ContentEnum.STATUS_REQUESTED.name());
			contentVo.setIs_active(true);
			contentVo.setIs_delete(false);
			int r = vendorService.createContent(contentVo, contentScheduleVO, file, request, timeList, total_ticket);
			
			if (contentScheduleVO != null && contentScheduleVO.getTotal_ticket() != null) {
				contentScheduleVO.setCurrent_ticket(contentScheduleVO.getTotal_ticket());
			}
			
			if(r > 0) {
				model.addAttribute("cmd", "move");
				model.addAttribute("msg", "정상적으로 등록되었습니다.");
				model.addAttribute("url", "content_manage");
			}else {
				model.addAttribute("cmd", "back");
				model.addAttribute("msg", "등록 오류, 다시 작성해주세요.");
			}
			return "common/return";
			
		} catch (Exception e) {
			e.printStackTrace();
			
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "등록 오류, 다시 작성해주세요.");
			
			return "common/return";
		}
	}
	//update
	@PostMapping("/vendor/content_update")
	public String updateContent(
			ContentVO contentVo, 
			ContentScheduleVO contentScheduleVO,
			Model model, 
			HttpServletRequest request, 
			@RequestParam(value="main_image_file", required = false)MultipartFile file,
			@RequestParam(value="Time[]", required = false) List<String> timeList,
			@RequestParam(value="total_ticket", required = false) Integer total_ticket
			) {
		HttpSession sess = request.getSession();
		UserVO login = (UserVO)sess.getAttribute("loginSess");
		if (login == null) {
		    return "redirect:/member/login"; 
		}
		contentVo.setUser_id(login.getUser_id());
		
		contentVo.setContent_status(ContentEnum.STATUS_REQUESTED.name());
		contentVo.setIs_active(true);
		contentVo.setIs_delete(false);
		int r = vendorService.updateContent(contentVo, contentScheduleVO, file, request, timeList, total_ticket);
		
		if (contentScheduleVO != null && contentScheduleVO.getTotal_ticket() != null) {
		    contentScheduleVO.setCurrent_ticket(contentScheduleVO.getTotal_ticket());
		}
		
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
	
	// 수정한 컨트롤러 코드
	@PostMapping("/vendor/reserve_pay_manage/update_status")
	@ResponseBody
	public Map<String, Object> updateStatus(
	    @RequestParam("reserve_id") int reserve_id, // "reserve_id"라고 명시
	    @RequestParam("status") String status          // "status"라고 명시
	) {
	    Map<String, Object> resultMap = new HashMap<>();
	    try {
	        int result = vendorService.updateReservationStatus(reserve_id);
	        
	        if(result > 0) {
	            resultMap.put("success", true);
	        } else {
	            resultMap.put("success", false);
	            resultMap.put("message", "해당 예약 건을 찾을 수 없습니다.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("success", false);
	        resultMap.put("message", e.getMessage());
	    }
	    return resultMap;
	}
	
	
	@GetMapping("/vendor/reserve_pay_manage")
	public String contentReserve() {
		
		return "vendor/reserve_pay_manage";
	}

}
