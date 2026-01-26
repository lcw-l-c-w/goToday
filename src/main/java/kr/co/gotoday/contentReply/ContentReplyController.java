package kr.co.gotoday.contentReply;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentService;
import kr.co.gotoday.user.UserVO;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ContentReplyController {

	//주입
	private final ContentReplyService contentReplyService;
	private final ContentService contentService;
	
	@GetMapping("/detail/tab/inquiry")
	public String getQuestion(@RequestParam("content_id") int content_id,Model model) {
		//불러오자 @
		List<ContentReplyVO> replyVO= contentReplyService.showQAALL(content_id);
		model.addAttribute("list",replyVO);
		return "/content_reply/content_question";
	}
    
	//작성폼으로 이동
	@GetMapping("/detail/tab/inquiry/write/{content_id}")
	public String writeQuestion(@PathVariable("content_id") int content_id, Model model,HttpSession sess) {
		UserVO user = (UserVO) sess.getAttribute("loginSess");
	    
	    // 2. 로그인 안 되어 있으면 로그인 페이지로 쫓아내기
	    if (user == null) {
	        model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
	        model.addAttribute("cmd","move");
	        model.addAttribute("url", "/gotoday/member/login");
	        return "common/return"; // 알림창 띄우고 이동하는 공통 뷰
	    }
	    
	    if(user.getRole()==1) {
			//vendor인경우
			model.addAttribute("msg","개인회원만 문의사항을 남길 수 있습니다.");
			model.addAttribute("cmd","move");
			model.addAttribute("url", "/gotoday/detail/" + content_id + "?tab=inquiry");
			return "common/return";
		}
		model.addAttribute("content_id", content_id);
	return "/content_reply/content_reply_write";	
	}
	
	//작성(user인경우에)
	@PostMapping("/detail/tab/inquiry/write")
	public String InsertQuestion(@RequestParam int content_id,Model model, HttpSession sess,ContentReplyVO vo,@RequestParam(value="file", required=false) MultipartFile file, HttpServletRequest request) {
		UserVO user= (UserVO) sess.getAttribute("loginSess");
		
		//로그인 여부 체크 ㄱ ㅍ/9  
		if(user==null) {
			model.addAttribute("msg","로그인이 필요합니다.");
			model.addAttribute("cmd","move");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}
		if(user.getRole()==1) {
			//vendor인경우
			model.addAttribute("msg","개인회원만 문의사항을 남길 수 있습니다.");
			model.addAttribute("cmd","move");
			return "common/return";
		}
		
		// --- [파일 업로드 처리 시작] ---
	    if (file != null && !file.isEmpty()) {
	        try {
	            // 1. 저장할 절대 경로 설정 (webapp/resources/upload/inquiry/)
	            String uploadPath = request.getServletContext().getRealPath("/resources/upload/inquiry/");
	            File folder = new File(uploadPath);
	            if (!folder.exists()) folder.mkdirs(); // 폴더가 없으면 생성

	            // 2. 파일명 중복 방지 (현재시간_원본이름)
	            String originName = file.getOriginalFilename();
	            String saveName = System.currentTimeMillis() + "_" + originName;

	            // 3. 실제 서버 폴더에 파일 저장
	            file.transferTo(new File(uploadPath + saveName));

	            // 4. DB에 저장할 상대 경로를 VO에 세팅
	            // 나중에 <img src="/resources/upload/inquiry/파일명"> 으로 쓰기 위함
	            vo.setFile_path("/resources/upload/inquiry/" + saveName);
	            
	        } catch (Exception e) {
	            System.out.println("파일 업로드 실패: " + e.getMessage());
	        }
	    }
	    
		// 작성자 정보 VO에 설정( 세션에서 꺼낸 id를 수동으로 넣어줘야함)
		vo.setUser_id(user.getUser_id());
		vo.setContent_id(content_id);
       int success=contentReplyService.insertQA(vo);
		if(success==1) {
			//성공했을 경우 	
			model.addAttribute("msg","등록되었습니다.");
			
			return "redirect:/detail/" + content_id + "?tab=inquiry";    
			
		}
		else {
			model.addAttribute("msg", "게시글 등록에 실패했습니다.");
			return "common/return";
		}
	}
	//상인이 답변을 달 경우 
	
	@GetMapping("/detail/inquiry/write/vendor.do")
	public String moveWrite(@RequestParam("creply_id") int creply_id, Model model) {
		List<ContentReplyVO> question = contentReplyService.showDetailByID(creply_id);
		if (question != null && !question.isEmpty()) {
	        model.addAttribute("parent", question.get(0));}
		return "content_reply/content_vendor_write";
	}
	@PostMapping("/detail/inquiry/write/vendor.do")
	public String writeVendor(HttpSession sess, ContentReplyVO vo, Model model,MultipartFile file) {
		UserVO Uservo= (UserVO) sess.getAttribute("loginSess");
		int vendor_id= contentService.selectIdByContentId(vo.getContent_id());
		if(Uservo.getUser_id()!= vendor_id) {
			//같은 상인이 아닌경우에는
			model.addAttribute("msg","관리자만 문의사항을 남길 수 있습니다.");
			model.addAttribute("cmd","back");
			return "common/return";
		}
		//같은 경우에는 
	    vo.setUser_id(Uservo.getUser_id());
	    vo.setWriter(Uservo.getName()); // 상인 이름을 writer로 설정
		
		int success=contentReplyService.vendorCreate(vo);
		if(success==1) {
			//성공했을 경우 	
			model.addAttribute("msg","등록되었습니다.");
			
			return "redirect:/detail/" + vo.getContent_id() + "?tab=inquiry";    
			
		}
		else {
			model.addAttribute("msg", "답변 등록에 실패했습니다.");
			System.out.println(vo);
			return "common/return";
		}
	}
	//수정
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
			model.addAttribute("url", "/gotoday/detail/" + vo.getContent_id() + "?tab=inquiry");
		    return "common/return";
		}
		else {
			model.addAttribute("msg", "게시글 수정에 실패했습니다.다시 시도해주세요.");
			return "common/return";
		}
	
	}
	//삭제 (예외처리할것-> 회원이 삭제할 경우 , 서비스단 vendor껏도 삭제해야하고 / vendor가 삭제하는 경우 상태 변경도 해줘야함)
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
			model.addAttribute("url", "/gotoday/detail/" + vo.getContent_id() + "?tab=inquiry"); // 이동할 경로
		    return "common/return";
		}
		else {
			model.addAttribute("msg", "게시글 삭제에 실패했습니다.다시 시도해주세요.");
			return "common/return";
	}
	}
	
	//나의 리스트 보기 
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
	//조회 
	@GetMapping("/inquiry/detail/{creply_id}")
	public String showQA(@PathVariable int creply_id,HttpSession sess,Model model) {
		// 데이터가 아예 없는 경우 예외 처리 (Index 에러 방지)
		
		UserVO userVO= (UserVO) sess.getAttribute("loginSess");
		List<ContentReplyVO> question = contentReplyService.showDetailByID(creply_id);
		if (question == null) {
	        model.addAttribute("msg", "존재하지 않는 게시글입니다.");
	        model.addAttribute("cmd","back");
	         
	        return "common/return";
	    }
		ContentReplyVO tmp=question.get(0);
		System.out.println("디버깅 - 조회하려는 content_id: " + question.get(0).getContent_id());
		System.out.println("디버깅 - 조회하려는 content_id: " + tmp.getContent_id());
		int vendor_id= contentService.selectIdByContentId(tmp.getContent_id());
		
		question.get(0).setVendor_id(vendor_id);
		model.addAttribute("vo",question.get(0));
		
			if (question.size() > 1) {
		        model.addAttribute("vendorList", question.get(1));
		        System.out.println("디버깅 - 답변 데이터 존재함: " + question.get(1).getBody()); // 로그 확인용
			} else {
			    System.out.println("디버깅 - 답변 데이터가 리스트에 없음");
			
		    }	
		return "/content_reply/view";
	}
  
}
