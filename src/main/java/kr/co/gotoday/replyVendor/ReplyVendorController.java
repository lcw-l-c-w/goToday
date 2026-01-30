package kr.co.gotoday.replyVendor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.gotoday.user.UserVO;

@Controller
public class ReplyVendorController {
	@Autowired
	private ReplyVendorService service;
	
	
	@GetMapping("/replyVendor/index")
	public String index(Model model, ReplyVendorVO vo, HttpSession sess, RedirectAttributes ra) {
		UserVO login = (UserVO)sess.getAttribute("loginSess");
		if (login == null) {
			ra.addFlashAttribute("msg", "로그인이 필요합니다.");
			return "redirect:/member/login";
	    }
		if(login.getRole()!=1 && login.getEmail().contains("@")) {
			model.addAttribute("msg", "업체 전용 문의 페이지입니다.");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		model.addAttribute("map", service.list(vo));
		model.addAttribute("replyVO", vo); // ⭐ 이거 추가
		return "replyVendor/index";
	}
	
	@GetMapping("/replyVendor/write")
	public String write(Model model, HttpSession sess, RedirectAttributes ra) {
		UserVO login = (UserVO)sess.getAttribute("loginSess");
		if (login == null) {
			ra.addFlashAttribute("msg", "로그인이 필요합니다.");
			return "redirect:/member/login";
	    }
		if(login.getRole()!=1 && login.getEmail().contains("@")) {
			model.addAttribute("msg", "업체 전용 문의 페이지입니다.");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		return "replyVendor/write";
	}
	
	@GetMapping("/replyVendor/view")
	public String view(Model model, ReplyVendorVO vo, HttpServletRequest request, RedirectAttributes ra) {
		HttpSession sess = request.getSession();
		UserVO login = (UserVO)sess.getAttribute("loginSess");
		
		ReplyVendorVO reply = service.detail(vo);
		
		if(reply == null) {
			model.addAttribute("msg", "해당 게시글이 존재하지 않습니다..");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		if (login == null) {
			ra.addFlashAttribute("msg", "로그인이 필요합니다.");
			return "redirect:/member/login";
	    }
		if(login.getRole()!=1 && login.getEmail().contains("@")) {
			model.addAttribute("msg", "업체 전용 문의 페이지입니다.");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		
		boolean isAdmin = !login.getEmail().contains("@");
		
		if(!isAdmin && reply.getWriter() != login.getUser_id()) {
			model.addAttribute("msg", "본인 게시글만 열람할 수 있습니다.");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		
		model.addAttribute("Admin", isAdmin);
		model.addAttribute("vo", service.detail(vo));
		model.addAttribute("login", login);
		
		// 관리자 답변 존재 여부
	    ReplyVendorVO adminReply = service.getAdminReply(vo.getReply_vendor_id());
	    model.addAttribute("adminReply", adminReply);
	    
		return "replyVendor/view";
	}
	
	@PostMapping("/replyVendor/insert")
	public String insert(Model model, HttpServletRequest request, ReplyVendorVO vo, RedirectAttributes ra) {
		HttpSession sess = request.getSession();
		UserVO login = (UserVO)sess.getAttribute("loginSess");
		if (login == null) {
			ra.addFlashAttribute("msg", "로그인이 필요합니다.");
			return "redirect:/member/login";
	    }
		vo.setWriter(login.getUser_id());
		
		boolean isAdmin = !login.getEmail().contains("@");
		String isIframe = request.getParameter("isIframe");
		
		if(isAdmin) {
			vo.setReply_status(0); // 명시적으로
			vo.setAdmin_id(login.getUser_id());
			int r = service.adminCreate(vo);
			if (r > 0) {
				model.addAttribute("cmd", "move");
				model.addAttribute("msg", "정상적으로 등록되었습니다.");
				model.addAttribute("url", "index?isIframe=" + isIframe);
			} else {
				model.addAttribute("cmd", "back");
				model.addAttribute("msg", "등록 오류");
			}
		}else {
			vo.setUser_id(login.getUser_id());
			int r = service.create(vo);
			if (r > 0) {
				model.addAttribute("cmd", "move");
				model.addAttribute("msg", "정상적으로 저장되었습니다.");
				model.addAttribute("url", "index?isIframe=" + isIframe);
			} else {
				model.addAttribute("cmd", "back");
				model.addAttribute("msg", "등록 오류");
			}
		}
		return "common/return";
	}
	
	@GetMapping("/replyVendor/reply")
	public String reply(Model model, ReplyVendorVO vo, HttpServletRequest request, RedirectAttributes ra) {
		HttpSession sess = request.getSession();
		UserVO login = (UserVO)sess.getAttribute("loginSess");
		if (login == null) {
			ra.addFlashAttribute("msg", "로그인이 필요합니다.");
			return "redirect:/member/login";
	    }
		if(login.getRole()!=1 && login.getEmail().contains("@")) {
			model.addAttribute("msg", "업체 전용 문의 페이지입니다.");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		String isIframe = request.getParameter("isIframe");
		ReplyVendorVO origin = service.detail(vo);
		ReplyVendorVO replyVo = new ReplyVendorVO();
		replyVo.setGno(origin.getReply_vendor_id());
		replyVo.setWriter(login.getUser_id());
		
		model.addAttribute("origin", origin);
		model.addAttribute("vo", replyVo);
		
		return "replyVendor/reply";
	}
	
	@PostMapping("/replyVendor/reply")
	public String replyProcess(Model model, HttpServletRequest request, ReplyVendorVO vo) {
		HttpSession sess = request.getSession();
		UserVO login = (UserVO)sess.getAttribute("loginSess");
		String isIframe = request.getParameter("isIframe");
		if(!login.getEmail().contains("@")) {
			vo.setReply_status(1); // 명시적으로
			vo.setWriter(login.getUser_id());
			vo.setAdmin_id(login.getUser_id());
			vo.setReply_status(1);
			int r = service.adminCreate(vo);
			if (r > 0) {
				model.addAttribute("cmd", "move");
				model.addAttribute("msg", "정상적으로 등록되었습니다.");
				model.addAttribute("url", "index?isIframe=" + isIframe);
			} else {
				model.addAttribute("cmd", "back");
				model.addAttribute("msg", "등록 오류");
			}
		}
		return "common/return";
	}
	@GetMapping("/replyVendor/delete")
	public String delete(Model model, HttpServletRequest request, ReplyVendorVO vo) {
		int r = service.delete(vo.getReply_vendor_id());
		String isIframe = request.getParameter("isIframe");
		if (r > 0) {
			model.addAttribute("cmd", "move");
			model.addAttribute("msg", "정상적으로 삭제되었습니다.");
			model.addAttribute("url", "index?isIframe=" + isIframe);
		} else {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "삭제 오류");
		}
		return "common/return";
	}
	
	@GetMapping("/replyVendor/deleteAdminOnly")
	public String deleteAdminOnly(Model model, HttpServletRequest request, ReplyVendorVO vo) {
		int r = service.deleteAdminOnly(vo.getReply_vendor_id());
		String isIframe = request.getParameter("isIframe");
		if (r > 0) {
			model.addAttribute("cmd", "move");
			model.addAttribute("msg", "정상적으로 삭제되었습니다.");
			model.addAttribute("url", "index?isIframe=" + isIframe);
		} else {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "삭제 오류");
		}
		return "common/return";
	}
}
