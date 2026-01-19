package kr.co.gotoday.user;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserController {
	
	private final UserService userService;

	@Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;
    @Value("${kakao.redirect-uri}")
    private String kakaoRedirectUri;
    
    // 로그인 폼
    @GetMapping("/member/login")
	public String login(Model model) {
    	model.addAttribute("REST_API_KEY", kakaoRestApiKey);
        model.addAttribute("REDIRECT_URI", kakaoRedirectUri);
        return "member/login";		
	}
    
    // 로그인 처리
    @PostMapping("/member/login")
    public String login(HttpSession sess, UserVO vo, Model model) {
        UserVO userVO = userService.login(vo);
        if (userVO == null) {
            model.addAttribute("msg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        } else {
            sess.setAttribute("loginSess", userVO);
            return "redirect:/";
        }
    }
    
    // 회원가입 1단계: 정보입력 폼
    @GetMapping("/member/register1")
    public String registerUserStep1(
    		@RequestParam(required = false) Integer role,
    		Model model) {
    	model.addAttribute("role", role != null ? role : 0);
    	return "/member/register1";
    }
    
    // 회원가입 1단계: 정보입력 처리
    @PostMapping("/member/register1")
    public String registerUserStep1(HttpSession sess, UserVO vo, Model model) {	
    	boolean result = userService.registerUserInfo(vo);

        if (!result) {
            model.addAttribute("msg", "회원가입 중 오류가 발생했습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }

        sess.setAttribute("tempUser", vo);

        // 기업회원이면 register2 단계 건너뛰기
        if (vo.getRole() == 1) {
            List<UserTagVO> emptyTagList = new ArrayList<>();
            userService.registerUserTags(emptyTagList);

            // 세션 제거 후 register3로 이동
            sess.removeAttribute("tempUser");
            model.addAttribute("user", vo);
            return "member/register3";
        }

        // 개인회원이면 기존 흐름 유지
        return "redirect:/member/register2";
    }
    
    // 회원가입 2단계: 관심사 입력 처리
    @GetMapping("/member/register2")
    public void registerUserStep2() {
       
    }
    
    // 회원가입 2단계: 관심사 입력 처리
    @PostMapping("/member/register2")
    public String registerUserStep2(
            HttpSession sess,
            @RequestParam(required = false) String event,
            @RequestParam(required = false) String[] location,
            @RequestParam(required = false) String[] interest,
            Model model) {

        UserVO user = (UserVO) sess.getAttribute("tempUser");

        if (user == null) {
            model.addAttribute("msg", "잘못된 접근입니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/gotoday/member/register1");
            return "common/return";
        }

        List<UserTagVO> userTagList = new ArrayList<>();

        if (event != null) {
            Long tagId = userService.findTagIdByName(event);
            if (tagId != null) {
                UserTagVO ut = new UserTagVO();
                ut.setTag_id(tagId.intValue());
                ut.setUser_id(user.getUser_id());
                userTagList.add(ut);
            }
        }

        if (location != null) {
            for (String loc : location) {
                Long tagId = userService.findTagIdByName(loc);
                if (tagId != null) {
                    UserTagVO ut = new UserTagVO();
                    ut.setTag_id(tagId.intValue());
                    ut.setUser_id(user.getUser_id());
                    userTagList.add(ut);
                }
            }
        }

        if (interest != null) {
            for (String i : interest) {
                Long tagId = userService.findTagIdByName(i);
                if (tagId != null) {
                    UserTagVO ut = new UserTagVO();
                    ut.setTag_id(tagId.intValue());
                    ut.setUser_id(user.getUser_id());
                    userTagList.add(ut);
                }
            }
        }

        boolean result = userService.registerUserTags(userTagList);

        if (result) {
            sess.removeAttribute("tempUser");
            model.addAttribute("user", user);
            return "member/register3";
        } else {
            model.addAttribute("msg", "관심사 등록 중 오류가 발생했습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }
    }
    
    // 이메일 중복 체크
    @GetMapping("/member/emailCheck")
    @ResponseBody
    public int emailCheck(@RequestParam String email) {
        return userService.emailCheck(email);
    }
    
    
    // 카카오톡 로그인 확인
    @GetMapping("/kakaoLogin")
    public String kakaoCallback(@RequestParam("code") String code
    		, HttpSession session) {
    	// Access Token 받기
        String accessToken = userService.getKakaoAccessToken(code);      
        // 카카오로부터 사용자 정보 가져오기
        UserVO kakaoUser = userService.getKakaoUserInfo(accessToken);
        // DB에 해당 이메일로 가입된 유저가 있는지 확인
        UserVO dbUser = userService.loginByEmail(kakaoUser.getKakao_email());
        
        
        if (dbUser == null) {
            // 신규 회원) DB에 저장
            userService.insertKakaoUser(kakaoUser);
            dbUser = kakaoUser; 
            System.out.println("신규 카카오 유저 등록 완료: " + dbUser.getKakao_email());
        } else {
            // 기존 회원) 이미 DB에 있으므로 insert 과정 건너뜀
            System.out.println("기존 카카오 유저 로그인: " + dbUser.getEmail());
        }
        
        session.setAttribute("loginSess", dbUser); 
        
        return "redirect:/";

	}
    
    // 로그아웃 처리
    @GetMapping("/member/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        System.out.println("로그아웃 성공");
        return "redirect:/";
    }
    

    // 관리자 로그인
    @GetMapping("/member/loginForAdmin")
    public void loginForAdmin() {
       
    }
  
    @PostMapping("/member/loginForAdmin")
    public String loginForAdmin(HttpSession session
    		, UserVO vo, Model model) {

        UserVO userVO = userService.adminLogin(vo);
        if (userVO == null) {
            model.addAttribute("msg", "관리자 아이디 또는 비밀번호가 올바르지 않습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }

        session.setAttribute("loginSess", userVO);
        return "redirect:/";
    }
    
    // 관심사 수정
    @GetMapping("/member/userLikeEdit")
    public String userLikeEdit(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            model.addAttribute("msg", "로그인이 필요합니다.");
            model.addAttribute("cmd", "move");
            model.addAttribute("url", "/gotoday/member/login");
            return "common/return";
        }

        // 유저가 가진 태그 이름 목록
        List<String> userTags = userService.getUserTagNames(loginUser.getUser_id());
        model.addAttribute("userTags", userTags);
        return "member/userLikeEdit";
    }
    
    @PostMapping("/member/userLikeEdit")
    public String userLikeChange(
            HttpSession session,
            @RequestParam(required = false) String event,
            @RequestParam(required = false) String[] location,
            @RequestParam(required = false) String[] interest) {

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        int userId = loginUser.getUser_id();

        List<String> tagNames = new ArrayList<>();

        if (event != null) tagNames.add(event);
        if (location != null) for (String l : location) tagNames.add(l);
        if (interest != null) for (String i : interest) tagNames.add(i);

        userService.updateUserTags(userId, tagNames);

        return "redirect:/gotoday/mypage";
    }
    
    // 회원 정보 수정
    @GetMapping("/member/userInfoEdit")
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
        return "member/userInfoEdit";
    }
    
    @PostMapping("/member/userInfoEdit")
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
            // 세션 최신화: userMapper → userService
            UserVO updatedUser = userService.loginByEmail(loginUser.getEmail());
            session.setAttribute("loginSess", updatedUser);
            return "redirect:/gotoday/mypage";
        } else {
            model.addAttribute("msg", "회원 정보 수정 중 오류가 발생했습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }
    }
    
}
