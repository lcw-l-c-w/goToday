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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserController {
	
	private final UserService userService;

	@Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;
    @Value("${kakao.redirect-uri}")
    private String kakaoRedirectUri;
    @Value("${naver.client-id}")
    private String naverClientId;
    @Value("${naver.redirect-uri}")
    private String naverRedirectUri;
    // 로그인 폼
    @GetMapping("/member/login")
	public String login(@RequestParam(required = false) String redirect
			, HttpSession session
	        , Model model) {
    	
    	if (redirect != null) {
            session.setAttribute("redirectAfterLogin", redirect);
        }
    	
    	String state = OAuthStateUtil.generateState();
        session.setAttribute("NAVER_STATE", state);

    	model.addAttribute("REST_API_KEY", kakaoRestApiKey);
        model.addAttribute("REDIRECT_URI", kakaoRedirectUri);
        model.addAttribute("NAVER_CLIENT_ID", naverClientId);
        model.addAttribute("NAVER_REDIRECT_URI", naverRedirectUri);
        model.addAttribute("NAVER_STATE", state);
        return "member/login";		
	}
    
    // 로그인 처리
    @PostMapping("/member/login")
    public String login(HttpSession sess, UserVO vo, Model model) {
        try {
            UserVO userVO = userService.login(vo);
            if (userVO == null) {
                model.addAttribute("msg", "아이디 또는 비밀번호가 올바르지 않습니다.");
                model.addAttribute("cmd", "back");
                return "common/return";
            } else {
            	
            	// 선택한 role과 DB의 role 비교
                if (vo.getRole() != userVO.getRole()) {
                    if (userVO.getRole() == 0) {
                        model.addAttribute("msg", "개인 회원입니다. 개인 회원으로 로그인해주세요.");
                    } else if (userVO.getRole() == 1) {
                        model.addAttribute("msg", "기업 회원입니다. 기업 회원으로 로그인해주세요.");
                    }
                    model.addAttribute("cmd", "back");
                    return "common/return";
                }
            	
                // 로그인 성공 처리
                sess.setAttribute("loginSess", userVO);
                String redirect = (String) sess.getAttribute("redirectAfterLogin");
                sess.removeAttribute("redirectAfterLogin");

                if (redirect != null) {
                    return "redirect:" + redirect;
                }
                return "redirect:/main";
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("msg", "서버 오류가 발생했습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }
    }
    
    // 회원가입 1단계: 정보입력 폼
    @GetMapping("/member/register1")
    public String registerUserStep1(
    		@RequestParam(required = false) Integer role,
    		Model model) {
    	model.addAttribute("role", role != null ? role : 0);
    	model.addAttribute("REST_API_KEY", kakaoRestApiKey);
        model.addAttribute("REDIRECT_URI", kakaoRedirectUri);
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
            model.addAttribute("url", "/member/register1");
            return "common/return";
        }

        List<UserTagVO> userTagList = new ArrayList<>();

        if (event != null) {
        	Long tagId = userService.findTagIdByNameAndCategory(event, "event");
            if (tagId != null) {
                UserTagVO ut = new UserTagVO();
                ut.setTag_id(tagId.intValue());
                ut.setUser_id(user.getUser_id());
                userTagList.add(ut);
            }
        }

        if (location != null) {
            for (String loc : location) {
            	Long tagId = userService.findTagIdByNameAndCategory(loc, "location");
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
            	Long tagId = userService.findTagIdByNameAndCategory(i, "interest");
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
    	
    	// 이미 로그인된 경우 → 재호출 방지
        if (session.getAttribute("loginSess") != null) {
            return "redirect:/main";
        }
        
    	// Access Token 받기
        String accessToken = userService.getKakaoAccessToken(code);      
        // 카카오로부터 사용자 정보 가져오기
        UserVO kakaoUser = userService.getKakaoUserInfo(accessToken);
        // DB에 해당 이메일로 가입된 유저가 있는지 확인
        UserVO dbUser = userService.loginByEmail(kakaoUser.getKakao_email());
        
        
        if (dbUser == null) {
            // 신규 회원) DB에 저장
            userService.insertKakaoUser(kakaoUser);
            dbUser = userService.loginByEmail(kakaoUser.getKakao_email());
            System.out.println("신규 카카오 유저 등록 완료: " + dbUser.getKakao_email());
        } else {
            // 기존 회원) 이미 DB에 있으므로 insert 과정 건너뜀
            System.out.println("기존 카카오 유저 로그인: " + dbUser.getEmail());
        }
        
        session.setAttribute("loginSess", dbUser); 
        
        return "redirect:/main";

	}
    

    // 관리자 로그인
    @GetMapping("/member/login/admin")
    public String loginForAdmin() {
       return "member/loginForAdmin";
    }
  
    @PostMapping("/member/login/admin")
    public String loginForAdmin(HttpSession session
    		, UserVO vo, Model model) {

        UserVO userVO = userService.adminLogin(vo);
        if (userVO == null) {
            model.addAttribute("msg", "관리자 아이디 또는 비밀번호가 올바르지 않습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }

        session.setAttribute("loginSess", userVO);
        return "redirect:/admin/main";
    }
    
	@GetMapping("/naverlogin")
	public String naverCallback(@RequestParam(required = false) String code,
            					@RequestParam(required = false) String state, 
            			        @RequestParam(required=false) String error,
            			        @RequestParam(required=false) String error_description,
            					HttpSession session,
            			        RedirectAttributes ra ) {
		
		// 이미 로그인된경우 다시 로그인 방지
		if(session.getAttribute("loginSess") != null ) {
			return "redirect:/main";
		}

        // 1) 세션에 저장해둔 state 꺼내기
        String savedState = (String) session.getAttribute("NAVER_STATE");
        
        // 2) 재사용 방지: 한 번 쓰면 지우는게 안전
        session.removeAttribute("NAVER_STATE");


        // 3) 검증
        if (savedState == null || state == null || !savedState.equals(state)) {
            // state 불일치 = CSRF 의심
            ra.addFlashAttribute("loginError", "비정상적인 로그인 요청입니다. 다시 시도해주세요.");
            return "redirect:/member/login";
        }
        
        // 2) 네이버가 error를 준 경우(사용자 취소 포함)
        if (error != null) {
            ra.addFlashAttribute("loginError", mapNaverError(error)); // 아래 매핑함수
            return "redirect:/member/login";
        }
		
        // 3) code 없으면 실패
        if (code == null) {
            ra.addFlashAttribute("loginError", "네이버 로그인에 실패했습니다. 다시 시도해주세요.");
            return "redirect:/member/login";
        }
        
		// 네이버 엑세스 토큰 받기
		String naverAccessToken = userService.getNaverAccessToken(code ,savedState);
		
		UserVO naverUser = userService.getNaverUserInfo(naverAccessToken);
		
	       // DB에 해당 이메일로 가입된 유저가 있는지 확인
        UserVO dbUser = userService.loginByNaverKey(naverUser.getNaver_key());
        
        
        if (dbUser == null) {
            // 신규 회원) DB에 저장
            userService.insertNaverUser(naverUser);
            dbUser = userService.loginByNaverKey(naverUser.getNaver_key());
            System.out.println("신규 네이버 유저 등록 완료: " + dbUser.getEmail());
        } else {
            // 기존 회원) 이미 DB에 있으므로 insert 과정 건너뜀
            System.out.println("기존 네이버 유저 로그인: " + dbUser.getEmail());
        }
        
        session.setAttribute("loginSess", dbUser); 

		
		return "redirect:/main";
	}
	
	private String mapNaverError(String error) {
	    // 팀플용 간단 매핑(정교하게 해도 됨)
	    switch (error) {
	        case "access_denied":
	            return "네이버 로그인 동의가 취소되었습니다.";
	        case "invalid_request":
	            return "요청이 올바르지 않습니다. 다시 시도해주세요.";
	        case "unauthorized_client":
	            return "클라이언트 인증에 실패했습니다. 관리자에게 문의하세요.";
	        case "server_error":
	            return "네이버 서버 오류입니다. 잠시 후 다시 시도해주세요.";
	        case "temporarily_unavailable":
	            return "네이버 서비스가 일시적으로 불가합니다. 잠시 후 다시 시도해주세요.";
	        default:
	            return "네이버 로그인 중 오류가 발생했습니다. 다시 시도해주세요.";
	    }
	}
    //페이지 이동
    @GetMapping("/login/process")
    public String movePage(HttpSession sess, Model model) {
    	try{
    		UserVO vo= (UserVO) sess.getAttribute("loginSess");
    		if(vo==null) {
    			model.addAttribute("msg","로그인이 필요한 서비스입니다.");
    			model.addAttribute("cmd", "back");
    			
    			return "member/login";
    	}
    	if(!vo.getEmail().contains("@")) {
    		  sess.setAttribute("loginSess", vo);
    		return "redirect:/admin/main";
    	}
    	UserVO login= userService.getUserById(vo.getUser_id());
    	
    	if(login.getRole()==1) {
    		sess.setAttribute("loginSess", login);
    		return "redirect:/vendor/main";
    	}
    	// admin인경우
    	//개인 회원인 경우
    	else if(login.getRole()==0) {
    		sess.setAttribute("loginSess", login);
    		return "redirect:/mypage/main";
    	}
    	}
    	catch(Exception e) {
    		System.out.println("에러가 발생하였습니다.");
    		return "/main";
    	}
		return null;
    	
    }
    
    // 찾기 페이지 이동
    @GetMapping("/member/find_account")
    public String findAccount() {
        return "member/find_account";
    }

    // 아이디 찾기 처리
    @PostMapping("/member/find_id")
    @ResponseBody
    public String findId(@RequestParam String name, @RequestParam String birthday, @RequestParam String phone_number) {
        String email = userService.findEmail(name, birthday, phone_number);
        return (email != null) ? email : "fail";
    }

    // 비밀번호 찾기 처리
    @PostMapping("/member/find_pw")
    @ResponseBody
    public String findPw(@RequestParam String email, @RequestParam String phone_number) {
        String tempPw = userService.resetPassword(email, phone_number);
        return (tempPw != null) ? tempPw : "fail";
    }
    
  
}
