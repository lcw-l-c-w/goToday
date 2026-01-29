package kr.co.gotoday.mypage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.gotoday.contentReply.ContentReplyService;
import kr.co.gotoday.reply.ReplyVO;
import kr.co.gotoday.reservation.ReservationDetailDTO;
import kr.co.gotoday.reservation.ReservationListDTO;
import kr.co.gotoday.reservation.ReservationService;
import kr.co.gotoday.review.ReviewService;
import kr.co.gotoday.review.ReviewVO;
import kr.co.gotoday.user.UserService;
import kr.co.gotoday.user.UserVO;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MypageController {

	private final UserService userService;
	private final ReservationService reservationService;
	private final MypageService mypageService;
	private final ReviewService reviewService;
	private final ContentReplyService contentReplyService;
	// 메인 화면
    @GetMapping("/mypage/main")
    public String mypageMain(HttpSession session, Model model) {
    	UserVO loginUser = (UserVO) session.getAttribute("loginSess");
    	
    	// 로그인 체크
        if (loginUser == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/gotoday/member/login");
            return "common/return";
        }
        
        // DB에서 최신 정보 가져와서 세션 갱신
        UserVO dbUser = userService.getUserById(loginUser.getUser_id());
        if (dbUser != null) {
            session.setAttribute("userName", dbUser.getName());
            session.setAttribute("userEmail", dbUser.getEmail());
        }
        
        return "mypage/main";
    }
	
    // 로그아웃 처리
    @GetMapping("/mypage/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        System.out.println("로그아웃 성공");
        return "redirect:/main";
    }
    
	// 관심사 수정
    @GetMapping("/mypage/user_like_edit")
    public String userLikeEdit(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/gotoday/member/login");
            return "common/return";
        }

        // 유저가 가진 태그 목록
        List<String> userTags = userService.getUserTagNames(loginUser.getUser_id());
        model.addAttribute("userTags", userTags);
        return "mypage/user_like_edit";
    }
    // 관심사 수정
    @PostMapping("/mypage/user_like_edit")
    public String userLikeChange(
            HttpSession session,
            @RequestParam(required = false) String event,
            @RequestParam(required = false) String[] location,
            @RequestParam(required = false) String[] interest) {

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        int userId = loginUser.getUser_id();

        // 배열 → List 변환
        List<String> locations = new ArrayList<>();
        if (location != null) {
            for (String l : location) {
                locations.add(l);
            }
        }

        List<String> interests = new ArrayList<>();
        if (interest != null) {
            for (String i : interest) {
                interests.add(i);
            }
        }

        // 변경된 서비스 메서드 호출
        userService.updateUserTags(userId, event, locations, interests);

        return "redirect:/calendar";
    }
    
    // 회원 정보 수정
    @GetMapping("/mypage/user_info")
    public String userInfoEdit(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/gotoday/member/login");
            return "common/return";
        }

        // DB에서 최신 정보 가져오기
        UserVO dbUser = userService.getUserById(loginUser.getUser_id());
        model.addAttribute("user", dbUser);
        return "mypage/user_info";
    }
    
    // 회원 정보 수정
    @PostMapping("/mypage/user_info")
    public String userInfoEdit(HttpSession session, UserVO vo, 
            @RequestParam(required = false) String confirmPassword,
            Model model) {

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/member/login");
            return "common/return";
        }

        // 패스워드 확인
        if (vo.getPassword() != null && !vo.getPassword().isEmpty()) {
            if (!vo.getPassword().equals(confirmPassword)) {
                model.addAttribute("msg", "비밀번호와 확인이 일치하지 않습니다.");
                model.addAttribute("cmd", "back");
                return "common/return";
            }
        }

        vo.setUser_id(loginUser.getUser_id());

        boolean result = userService.updateUserInfo(vo);

        if (result) {
        	// DB에서 최신 정보 다시 가져오기
            UserVO updatedUser = userService.getUserById(loginUser.getUser_id());
            // 사이드바용 개별 세션 정보 업데이트
            session.setAttribute("userName", updatedUser.getName());
            session.setAttribute("userEmail", updatedUser.getEmail());
            // 전체 객체 세션 최신화
            session.setAttribute("loginSess", updatedUser);
            return "redirect:/calendar";
            
        } else {
            model.addAttribute("msg", "회원 정보 수정 중 오류가 발생했습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }
    }
    
    // 예약 관리
    @GetMapping("/mypage/reservation")
    public String showReservationList(
    		@RequestParam(required = false, defaultValue = "ALL") String filter, 
    		HttpSession sess, 
    		Model model) {
    	UserVO userVO = (UserVO)sess.getAttribute("loginSess");
    	
    	if (userVO == null) {
            model.addAttribute("cmd", "back");
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
            return "common/return";
        }
    	
    	List<ReservationListDTO> reservationList = reservationService.findReservationListByUserId(userVO.getUser_id(), filter);
    	model.addAttribute("reservationList", reservationList);
    	model.addAttribute("currentFilter", filter);
    	
    	return "mypage/reserve_list";
    }
    // 예약 관리
    @GetMapping("/mypage/reservation/{reservation_id}")
    public String showReservationDetail(HttpSession sess, Model model, @PathVariable("reservation_id") int reservation_id) {
    	UserVO userVO = (UserVO)sess.getAttribute("loginSess");
    	
    	ReservationDetailDTO reservationDetailDTO = reservationService.findReservationDetailById(reservation_id, userVO.getUser_id());
    	model.addAttribute("reservationDetailDTO", reservationDetailDTO);
    	
    	
    	return "mypage/reserve_detail";
    }
    
    // 좋아요 목록
    
    @GetMapping("/mypage/like_list")
    public String myLikeList(HttpSession session, Model model) {

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");

        if (loginUser == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/gotoday/member/login");
            return "common/return";
        }

        List<MypageDTO> likeList =
                mypageService.getMyLikeList(loginUser.getUser_id());

        model.addAttribute("likeList", likeList);

        return "mypage/like_list";
    }
    
    // 찜 예약하러가기
    @GetMapping("/content/detail")
    public String contentDetail(@RequestParam("id") int contentId, Model model) {
        return "content/content_detail";
    }
    
    // 1:1 문의 목록
    @GetMapping("/mypage/reply_list")
    public String myReplyList(HttpSession session, Model model, ReplyVO vo) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        
        if (loginUser == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/gotoday/member/login");
            return "common/return";
        }
        
        // 내가 작성한 문의만 조회하도록 user_id 설정
        vo.setUser_id(loginUser.getUser_id());
        
        // 서비스에서 목록 가져오기
        Map<String, Object> resultMap = mypageService.getMyReplyList(vo);
        
        model.addAttribute("map", resultMap);
        model.addAttribute("vo", vo);
        
        return "mypage/reply_list";
    }
    
    @GetMapping("/mypage/reply_detail")
    public String replyDetail(@RequestParam("reply_id") int replyId, HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        
        if (loginUser == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/gotoday/member/login");
            return "common/return";
        }

        // 문의글 본문 가져오기
        ReplyVO reply = mypageService.getReplyDetail(replyId);
        
        // 본인 글인지 검증 (보안)
        if (reply == null || reply.getUser_id() != loginUser.getUser_id()) {
            model.addAttribute("msg", "권한이 없거나 존재하지 않는 게시물입니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }
        
        
        // 해당 글의 답변(들) 가져오기
        ReplyVO answer = mypageService.getReplyAnswer(replyId);

        model.addAttribute("reply", reply);
        model.addAttribute("answer", answer);
        model.addAttribute("userName", loginUser.getName());
        
        return "mypage/reply_detail";
    }
    
//	@GetMapping("/mypage/myreviews.do")
//	public String showUserReviewList(HttpSession sess, Model model) {
//		UserVO userVO = (UserVO) sess.getAttribute("loginSess");
//		if(userVO == null) {
//			model.addAttribute("cmd","back");
//			model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
//			return "common/return";
//		}
//		List<ReviewVO> reviewList = reviewService.findReviewsByUserId(userVO.getUser_id());
//		model.addAttribute("reviewList", reviewList);
//		return "mypage/review_list";
//	}
    
    @GetMapping("/mypage/myreviews.do")
    public String showUserReviewList(
            HttpSession sess, 
            Model model,
            @RequestParam(value = "page", defaultValue = "1") int page) {
        
        UserVO userVO = (UserVO) sess.getAttribute("loginSess");
        if(userVO == null) {
            model.addAttribute("cmd","back");
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
            return "common/return";
        }

        // --- 페이징 로직 시작 ---
        int limit = 5;      // 한 페이지에 보여줄 글 개수
        int pageBlock = 5;  // 하단에 보여줄 페이지 번호 개수 (1,2,3,4,5)

        // 1. 전체 게시물 수 조회
        int totalCount = reviewService.countReviewsByUserId(userVO.getUser_id());

        // 2. 총 페이지 수 계산
        int totalPage = (int) Math.ceil((double) totalCount / limit);
        
        // 페이지 번호 예외 처리
        if (page < 1) page = 1;
        if (page > totalPage && totalPage > 0) page = totalPage;

        // 3. 현재 페이지에 해당하는 데이터 조회
        List<ReviewVO> reviewList = reviewService.findReviewsByUserIdPaged(userVO.getUser_id(), page, limit);

        // 4. 페이지 네비게이션 계산 (시작번호, 끝번호)
        int startPage = ((page - 1) / pageBlock) * pageBlock + 1;
        int endPage = startPage + pageBlock - 1;
        if (endPage > totalPage) endPage = totalPage;

        // 5. 뷰로 데이터 전달
        model.addAttribute("reviewList", reviewList);
        
        Map<String, Object> paging = new HashMap<>();
        paging.put("page", page);
        paging.put("totalPage", totalPage);
        paging.put("startPage", startPage);
        paging.put("endPage", endPage);
        model.addAttribute("paging", paging); // 페이징 정보 맵 전달

        return "mypage/review_list";
    }
	
/*	
    // 문의사항 목록(채원)
    @GetMapping("/mypage/inquiry_list")
    public String myInquiryList(HttpSession session, Model model, ReplyVO vo) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        
        if (loginUser == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/gotoday/member/login");
            return "common/return";
        }
        
        // 내가 작성한 문의만 조회하도록 user_id 설정
        vo.setUser_id(loginUser.getUser_id());
        
        // 서비스에서 목록 가져오기
        //List<ContentReplyVO> result = contentReplyService.showQAByID(loginUser.getUser_id());
       // int q= contentReplyService.CountQA(loginUser.getUser_id());
        //result.g
        //model.addAttribute("map", result);
        //model.addAttribute("vo", vo);
        
        return "mypage/inquiry_list";
    }
*/
    
    // 1:1 문의사항
	@GetMapping("/mypage/inquiry_list")
	public String myInquiryList(HttpSession session, Model model, MypageDTO dto) {

	    UserVO loginUser = (UserVO) session.getAttribute("loginSess");
	    
        if (loginUser == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/gotoday/member/login");
            return "common/return";
        }
        
        
	    dto.setUser_id(loginUser.getUser_id());

	    Map<String, Object> map = mypageService.getMyInquiryList(dto);

	    model.addAttribute("map", map);
	    model.addAttribute("dto", dto);

	    return "mypage/inquiry_list";
	}
	
	// 1:1 문의사항 상세보기
	@GetMapping("/mypage/inquiry_detail")
	public String inquiryDetail(@RequestParam("creply_id") int creplyId, Model model, HttpSession session) {

	    UserVO loginUser = (UserVO) session.getAttribute("loginSess");
	    if (loginUser == null) {
	        model.addAttribute("msg", "로그인이 필요합니다.");
	        model.addAttribute("cmd", "move");
	        model.addAttribute("url", "/gotoday/member/login");
	        return "common/return";
	    }

	    // 문의 + 답변 내용 조회
	    List<MypageDTO> detailList = mypageService.getInquiryDetail(creplyId);
	    
	    model.addAttribute("detailList", detailList);
	    model.addAttribute("userName", loginUser.getName());
	    
	    return "mypage/inquiry_detail";
	}


}