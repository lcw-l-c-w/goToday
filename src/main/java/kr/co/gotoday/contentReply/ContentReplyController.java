package kr.co.gotoday.contentReply;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.gotoday.user.UserVO;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ContentReplyController {

	//주입
	private final ContentReplyService contentReplyService;
	@GetMapping("/detail/tab/inquiry")
	public String getQuestion() {
		return "/content_reply/content_question";
	}
    
	//작성폼으로 이동
	@GetMapping("/detail/tab/inquiry/write")
	public String writeQuestion() {
	return "/content_reply/content_write";	
	}
	
	@PostMapping("/detail/tab/inquiry/write")
	public String InsertQuestion(@RequestParam int content_id,Model model, HttpSession sess,ContentReplyVO vo) {
		UserVO user= (UserVO) sess.getAttribute("loginSess");
		
		//로그인 여부 체크 ㄱ ㅍ/9  
		if(user==null) {
			model.addAttribute("msg","로그인이 필요합니다.");
			model.addAttribute("cmd","back");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}
		// 작성자 정보 VO에 설정( 세션에서 꺼낸 id를 수동으로 넣어줘야함)
		vo.setUser_id(user.getUser_id());
		vo.setContent_id(content_id);
       int success=contentReplyService.insertQA(vo);
		if(success==1) {
			//성공했을 경우 	
			model.addAttribute("msg","등록되었습니다.");
			
			model.addAttribute("url", "/gotoday/detail/tab/inquiry"); // 이동할 경로
		    return "common/return";
			
		}
		else {
			model.addAttribute("msg", "게시글 등록에 실패했습니다.");
			return "common/return";
		}
	}
	
	@PostMapping("/detail/tab/inquiry/modify")
	public String modifyQuestion(HttpSession sess, ContentReplyVO vo, Model model) {
		UserVO user=(UserVO)sess.getAttribute("loginSess");
		
		if(user==null) {
			model.addAttribute("msg","로그인이 필요합니다.");
			model.addAttribute("cmd","back");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}
		vo.setUser_id(user.getUser_id());
		int success= contentReplyService.updateQA(vo);
		if(success==1) {
			//성공했을 경우 	
			model.addAttribute("msg","수정되었습니다.");
			model.addAttribute("url", "/gotoday/detail/tab/inquiry"); // 이동할 경로
		    return "common/return";
		}
		else {
			model.addAttribute("msg", "게시글 수정에 실패했습니다.다시 시도해주세요.");
			return "common/return";
		}
	
	}
	
	@PostMapping("/detail/tab/inquiry/delete")	
	public String deleteQuestion(HttpSession sess, ContentReplyVO vo, Model model) {
		UserVO user=(UserVO)sess.getAttribute("loginSess");
		
		if(user==null) {
			model.addAttribute("msg","로그인이 필요합니다.");
			model.addAttribute("cmd","back");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}
		vo.setUser_id(user.getUser_id());
		int success= contentReplyService.deleteQA(vo);
		if(success==1) {
			//성공했을 경우 	
			model.addAttribute("msg","삭제되었습니다.");
			model.addAttribute("url", "/gotoday/detail/tab/inquiry"); // 이동할 경로
		    return "common/return";
		}
		else {
			model.addAttribute("msg", "게시글 삭제에 실패했습니다.다시 시도해주세요.");
			return "common/return";
	}
	}
	
	
	@GetMapping("/inquiry/my")
	public String showQuestion( HttpSession sess, Model model) {
		UserVO user= (UserVO) sess.getAttribute("loginSess");
		if(user==null) {
			model.addAttribute("msg","로그인이 필요합니다.");
			model.addAttribute("cmd","back");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}
		
		List<ContentReplyVO> voList=contentReplyService.showQAByID(user.getUser_id());
		model.addAttribute("list",voList);
		return "/content_reply/content_question";
				
		
	}
	@GetMapping("/inquiry/detail/{creply_id}")
	public String showQA(@PathVariable int creply_id,HttpSession sess,Model model) {
		UserVO user= (UserVO) sess.getAttribute("loginSess");
		if(user==null) {
			model.addAttribute("msg","로그인이 필요합니다.");
			model.addAttribute("cmd","back");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}
		ContentReplyVO vo = new ContentReplyVO();
		vo.setCreply_id(creply_id);
		List<ContentReplyVO> voList= contentReplyService.showQAByID(creply_id);
		model.addAttribute("list",voList);
		return null;
	}
  
}
