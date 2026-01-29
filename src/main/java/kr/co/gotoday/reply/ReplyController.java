package kr.co.gotoday.reply;

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
public class ReplyController {

	@Autowired
	private ReplyService service;
	
	@GetMapping("/reply/index")
	public String index(Model model, ReplyVO vo) {
		model.addAttribute("map", service.list(vo));
		return "reply/index";
	}
	
	@GetMapping("/reply/write")
	public String write() {
		return "reply/write";
	}
	
	@GetMapping("/reply/view")
	public String view(Model model, ReplyVO vo, HttpServletRequest request, RedirectAttributes ra) {
		HttpSession sess = request.getSession();
		UserVO login = (UserVO)sess.getAttribute("loginSess");
		
		ReplyVO reply = service.detail(vo);
		
		if(reply == null) {
			model.addAttribute("msg", "해당 게시글이 존재하지 않습니다..");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		if (login == null) {
			ra.addFlashAttribute("msg", "로그인이 필요합니다.");
			return "redirect:/member/login";
	    }
		
		boolean isAdmin = !login.getEmail().contains("@");
		
		if(reply.getWriter()==1) {
			
		} else if(!isAdmin && reply.getWriter() != login.getUser_id()) {
			model.addAttribute("msg", "본인 게시글만 열람할 수 있습니다.");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		
		model.addAttribute("Admin", isAdmin);
		model.addAttribute("vo", service.detail(vo));
		model.addAttribute("login", login);
		
		// 관리자 답변 존재 여부
	    ReplyVO adminReply = service.getAdminReply(vo.getReply_id());
	    model.addAttribute("adminReply", adminReply);
	    
		return "reply/view";
	}
	
	@PostMapping("/reply/insert")
	public String insert(Model model, HttpServletRequest request, ReplyVO vo, RedirectAttributes ra) {
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
	
	@GetMapping("/reply/reply")
	public String reply(Model model, ReplyVO vo, HttpServletRequest request) {
		HttpSession sess = request.getSession();
		UserVO login = (UserVO)sess.getAttribute("loginSess");
		if(login.getEmail().contains("@")) {
			String isIframe = request.getParameter("isIframe");
			return "redirect:/reply/index?isIframe=" + isIframe;
		}
		String isIframe = request.getParameter("isIframe");
		ReplyVO origin = service.detail(vo);
		ReplyVO replyVo = new ReplyVO();
		replyVo.setGno(origin.getReply_id());
		replyVo.setWriter(login.getUser_id());
		
		model.addAttribute("origin", origin);
		model.addAttribute("vo", replyVo);
		
		return "reply/reply";
	}
	
	@PostMapping("/reply/reply")
	public String replyProcess(Model model, HttpServletRequest request, ReplyVO vo) {
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
	@GetMapping("/reply/delete")
	public String delete(Model model, HttpServletRequest request, ReplyVO vo) {
		int r = service.delete(vo.getReply_id());
		String isIframe = request.getParameter("isIframe");
		if (r > 0) {
			model.addAttribute("cmd", "move");
			model.addAttribute("msg", "정상적으로 삭제되었습니다.");
			model.addAttribute("url", "index?isIframe=" + isIframe);
		} else {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "등록 오류");
		}
		return "common/return";
	}
	
	@GetMapping("/reply/deleteAdminOnly")
	public String deleteAdminOnly(Model model, HttpServletRequest request, ReplyVO vo) {
		int r = service.deleteAdminOnly(vo.getReply_id());
		String isIframe = request.getParameter("isIframe");
		if (r > 0) {
			model.addAttribute("cmd", "move");
			model.addAttribute("msg", "정상적으로 삭제되었습니다.");
			model.addAttribute("url", "index?isIframe=" + isIframe);
		} else {
			model.addAttribute("cmd", "back");
			model.addAttribute("msg", "등록 오류");
		}
		return "common/return";
	}
}
