package kr.co.gotoday.contentReply;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
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
import util.PageInfo;

@Controller
@RequiredArgsConstructor
public class ContentReplyController {

	@Value("${upload.path}")
	private String uploadPath;
	// 주입
	private final ContentReplyService contentReplyService;
	private final ContentService contentService;

	// ------------------------------------------------------------------

	// 1. 조회 (컨텐츠 내 전체 조회 )
	@GetMapping("/detail/tab/inquiry")
	public String getQuestion(@RequestParam("content_id") int content_id,
			@RequestParam(defaultValue="1") int inquiryPage,
			Model model) {
		// 불러오자 @
	    int count = contentReplyService.countQuestion(content_id);
	    PageInfo pageInfo = PageInfo.of(count, inquiryPage, 8, 5);
	    int offset = PageInfo.offset(inquiryPage, 8);

	    List<ContentReplyVO> list = contentReplyService.selectQuestionPage(content_id, offset, 8);

	    model.addAttribute("inquiryList", list);
	    model.addAttribute("inquiryPageInfo", pageInfo);
	    model.addAttribute("content_id", content_id);

	    return "content_reply/content_question";
	}

	// 작성폼으로 이동
	@GetMapping("/detail/tab/inquiry/write/{content_id}")
	public String writeQuestion(@PathVariable("content_id") int content_id, Model model, HttpSession sess) {
		UserVO user = (UserVO) sess.getAttribute("loginSess");

		// 2. 로그인 안 되어 있으면 로그인 페이지로
		if (user == null) {
			model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
			model.addAttribute("cmd", "move");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}

		if (user.getRole() == 1) {
			// vendor인경우
			model.addAttribute("msg", "개인회원만 문의사항을 남길 수 있습니다.");
			model.addAttribute("cmd", "move");
			model.addAttribute("url", "/gotoday/detail/" + content_id + "?tab=inquiry");
			return "common/return";
		}
		model.addAttribute("content_id", content_id);
		return "/content_reply/content_reply_write";
	}

	// --------------------------------------1.
	// -작성(user인경우에)
	@PostMapping("/detail/tab/inquiry/write")
	public String InsertQuestion(@RequestParam int content_id, Model model, HttpSession sess, ContentReplyVO vo,
			@RequestParam(value = "file", required = false) MultipartFile file, HttpServletRequest request) {
		UserVO user = (UserVO) sess.getAttribute("loginSess");

		// 로그인 여부 체크 ㄱ ㅍ/9
		if (user == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("cmd", "move");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}
		if (user.getRole() == 1) {
			// vendor인경우
			model.addAttribute("msg", "개인회원만 문의사항을 남길 수 있습니다.");
			model.addAttribute("url", "/gotoday/detail/" + content_id + "?tab=inquiry");
			model.addAttribute("cmd", "move");
			return "common/return";
		}

		// --- [파일 업로드 처리 시작] ---
		if (file != null && !file.isEmpty()) {
			try {
				// 1. 저장할 절대 경로 설정 (webapp/resources/upload/inquiry/)
				 uploadPath += "/inquiry/";
				File folder = new File(uploadPath);
				if (!folder.exists())
					folder.mkdirs(); // 폴더가 없으면 생성

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
		int vendor_id = contentService.selectIdByContentId(vo.getContent_id());
		vo.setUser_id(user.getUser_id());
		vo.setContent_id(content_id);
		vo.setVendor_id(vendor_id); //벤더 등록해줘야 나중에 비밀글 확인이 가능함
		int success = contentReplyService.insertQA(vo);
		if (success == 1) {
			// 성공했을 경우
			model.addAttribute("msg", "등록되었습니다.");
			model.addAttribute("url", "/gotoday/detail/" + vo.getContent_id() + "?tab=inquiry");
			model.addAttribute("cmd", "move");
			return "common/return";

		} else {
			model.addAttribute("msg", "게시글 등록에 실패했습니다.");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
	}
	// 상인이 답변을 달 경우

	@GetMapping("/detail/inquiry/write/vendor.do")
	public String moveWrite(@RequestParam("creply_id") int creply_id, Model model) {
		List<ContentReplyVO> question = contentReplyService.showDetailByID(creply_id);
		if (question != null && !question.isEmpty()) {
			model.addAttribute("parent", question.get(0));
		}
		return "content_reply/content_vendor_write";
	}

	@PostMapping("/detail/inquiry/write/vendor.do")
	public String writeVendor(HttpSession sess, ContentReplyVO vo, Model model,@RequestParam(value = "file", required = false) MultipartFile file,HttpServletRequest request) {
		UserVO Uservo = (UserVO) sess.getAttribute("loginSess");
		int vendor_id = contentService.selectIdByContentId(vo.getContent_id());
		if (Uservo.getUser_id() != vendor_id) {
			// 같은 상인이 아닌경우에는
			model.addAttribute("msg", "관리자만 문의사항을 남길 수 있습니다.");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		// 같은 경우에는
		vo.setUser_id(Uservo.getUser_id());
		vo.setWriter(Uservo.getName()); // 상인 이름을 writer로 설정
		vo.setVendor_id(Uservo.getUser_id());
		// --- [파일 업로드 처리 시작] ---
				if (file != null && !file.isEmpty()) {
					try {
						// 1. 저장할 절대 경로 설정 (webapp/resources/upload/inquiry/)
						String uploadPath = request.getServletContext().getRealPath("/resources/upload/inquiry/");
						File folder = new File(uploadPath);
						if (!folder.exists())
							folder.mkdirs(); // 폴더가 없으면 생성

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
		int success = contentReplyService.vendorCreate(vo);
		if (success == 1) {
			// 성공했을 경우
			
			
			int success2=contentReplyService.updateStatus(vo.getGno());
			if(success2==1){
			model.addAttribute("msg", "등록되었습니다.");
			model.addAttribute("url","/gotoday/detail/" + vo.getContent_id() + "?tab=inquiry");
			model.addAttribute("cmd", "move");
			return "common/return";
			}
		}
		
			model.addAttribute("msg", "답변 등록에 실패했습니다.");
			model.addAttribute("cmd","back");
			return "common/return";
		
		
	}

	// -------------------------------------------------------

	// 2.수정
	@GetMapping("/detail/inquiry/modify")
	public String showAndModifyQuestion(HttpSession sess, int creply_id, Model model) {
		// 가지고 가기
		UserVO user = (UserVO) sess.getAttribute("loginSess");

		// 예외처리
		if (user == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("cmd", "move");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}
		// 본인이 아닌경우 막기
		// 일단 불러오기
		ContentReplyVO result = contentReplyService.getReplyForUser(creply_id, user.getUser_id());
		if (result.getUser_id() != user.getUser_id()) {
			model.addAttribute("msg", "본인이 아닌경우 수정이 어렵습니다..");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		int status=contentReplyService.showStatus(result.getGno());
		System.out.println(status);
		if(status>=1) {
			//답변 여부가 있는경우-> 유저는 수정이 어려움
			model.addAttribute("msg", "답변완료된 글은 수정할 수 없습니다.");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
		
		model.addAttribute("item", result);
		return "content_reply/content_reply_edit";
	}

	@PostMapping("/detail/tab/inquiry/modify")
	public String modifyQuestion(HttpSession sess, ContentReplyVO vo, Model model,@RequestParam(value="file", required=false) MultipartFile file,
	        @RequestParam(value="fileDelete", required=false) String fileDelete,HttpServletRequest request) {
		UserVO user = (UserVO) sess.getAttribute("loginSess");

		if (user == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("cmd", "move");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}
		// 2. 기존 데이터 조회 (기존 파일 경로 확인 및 본인 확인용)
	    ContentReplyVO original = contentReplyService.getReplyForUser(vo.getCreply_id(), user.getUser_id());
	    if (original == null) {
	        model.addAttribute("msg", "권한이 없거나 존재하지 않는 게시글입니다.");
	        model.addAttribute("cmd", "back");
	        return "common/return";
	    }
	 // 3. 파일 처리 로직 시작
	    String uploadPath = request.getServletContext().getRealPath("/resources/upload/inquiry/");
	    vo.setFile_path(original.getFile_path()); // 기본적으로 기존 경로 유지

	    // (1) 기존 파일 삭제 체크박스를 선택한 경우
	    if ("ok".equals(fileDelete)) {
	        deletePhysicalFile(request, original.getFile_path());
	        vo.setFile_path(null); // DB에서도 경로 삭제 준비
	    }

	    // (2) 새로운 파일이 업로드된 경우
	    if (file != null && !file.isEmpty()) {
	        // 기존에 파일이 있었다면 물리적 파일 삭제 (교체 작업)
	        if (original.getFile_path() != null) {
	            deletePhysicalFile(request, original.getFile_path());
	        }

	        try {
	            // 폴더 생성
	            File folder = new File(uploadPath);
	            if (!folder.exists()) folder.mkdirs();

	            // 파일 저장
	            String originName = file.getOriginalFilename();
	            String saveName = System.currentTimeMillis() + "_" + originName;
	            file.transferTo(new File(uploadPath + File.separator + saveName));

	            // VO에 새 경로 세팅
	            vo.setFile_path("/resources/upload/inquiry/" + saveName);
	        } catch (Exception e) {
	            System.out.println("파일 업로드 에러: " + e.getMessage());
	        }
	    }
		vo.setUser_id(user.getUser_id());
		int success = contentReplyService.updateQA(vo);
		if (success == 1) {
			// 성공했을 경우
			model.addAttribute("msg", "수정되었습니다.");
			model.addAttribute("url", "/gotoday/detail/" + vo.getContent_id() + "?tab=inquiry");
			model.addAttribute("cmd","move");
			return "common/return";
		} else {
			model.addAttribute("msg", "게시글 수정에 실패했습니다.다시 시도해주세요.");
			model.addAttribute("cmd","back");
			return "common/return";
		}

	}

	// 삭제 (예외처리할것-> 회원이 삭제할 경우 , 서비스단 vendor껏도 삭제해야하고 / vendor가 삭제하는 경우 상태 변경도 해줘야함)
	@PostMapping("/detail/tab/inquiry/delete")
	public String deleteQuestion(HttpSession sess, ContentReplyVO vo, Model model) {
		UserVO user = (UserVO) sess.getAttribute("loginSess");

		if (user == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("cmd", "move");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}

		vo.setUser_id(user.getUser_id());
		int success = contentReplyService.deleteQA(vo);
		if (success == 1) {
			// 성공했을 경우
			model.addAttribute("msg", "삭제되었습니다.");
			model.addAttribute("url", "/gotoday/detail/" + vo.getContent_id() + "?tab=inquiry"); // 이동할 경로
			model.addAttribute("cmd", "move");
			return "common/return";
		} else {
			model.addAttribute("msg", "게시글 삭제에 실패했습니다.다시 시도해주세요.");
			model.addAttribute("cmd", "back");
			return "common/return";
		}
	}

	// 나의 리스트 보기
	@GetMapping("/inquiry/my")
	public String showQuestion(HttpSession sess, Model model) {
		UserVO user = (UserVO) sess.getAttribute("loginSess");
		if (user == null) {
			model.addAttribute("msg", "로그인이 필요합니다.");
			model.addAttribute("cmd", "move");
			model.addAttribute("url", "/gotoday/member/login");
			return "common/return";
		}

		List<ContentReplyVO> voList = contentReplyService.showQAByID(user.getUser_id());
		model.addAttribute("list", voList);
		return "/content_reply/content_question";

	}

	// 조회
	@GetMapping("/inquiry/detail/{creply_id}")
	public String showQA(@PathVariable int creply_id, HttpSession sess, Model model) {
		// 데이터가 아예 없는 경우 예외 처리 (Index 에러 방지)

		UserVO userVO = (UserVO) sess.getAttribute("loginSess");
		List<ContentReplyVO> question = contentReplyService.showDetailByID(creply_id);
		if (question == null) {
			model.addAttribute("msg", "존재하지 않는 게시글입니다.");
			model.addAttribute("cmd", "back");

			return "common/return";
		}
	
		
		ContentReplyVO tmp = question.get(0);
		int vendor_id = contentService.selectIdByContentId(tmp.getContent_id());
		
		question.get(0).setVendor_id(vendor_id);
		model.addAttribute("vo", question.get(0));
		if (question.size() > 1) {
			model.addAttribute("vendorList", question.get(1));
		}

		return "/content_reply/view";
	}
	// 물리적 파일 삭제 공통 메서드
	private void deletePhysicalFile(HttpServletRequest request, String filePath) {
	    if (filePath != null && !filePath.isEmpty()) {
	        String fullPath = request.getServletContext().getRealPath(filePath);
	        File f = new File(fullPath);
	        if (f.exists()) {
	            f.delete();
	        }
	    }
	}
}
