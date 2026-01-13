package kr.co.gotoday.user;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

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

    // 로그인 폼
    @GetMapping("/member/login")
	public void login() {
			
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
    public void registerUserStep1() {
    
    }
    
    // 회원가입 1단계: 정보입력 처리
    @PostMapping("/member/register1")
    public String registerUserStep1(HttpSession sess, 
    		@RequestParam String email_prefix,
            @RequestParam String email_domain,
            @RequestParam String password,
            @RequestParam String name,
            @RequestParam String birthday,
            @RequestParam String gender,
            @RequestParam String phone_number) {

        String email = email_prefix + "@" + email_domain;

        UserVO tempUser = new UserVO();
        
        tempUser.setEmail(email);
        tempUser.setPassword(password);
        tempUser.setName(name);
        tempUser.setBirthday(birthday);
        tempUser.setGender(gender);
        tempUser.setPhone_number(phone_number);

        sess.setAttribute("tempUser", tempUser);
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
            model.addAttribute("url", "/gotoday/registerUser");
            return "common/return";
        }

        List<UserTagVO> userTagList = new ArrayList<>();

        if (event != null) {
            Long tagId = userService.findTagIdByName(event);
            if (tagId != null) {
                UserTagVO ut = new UserTagVO();
                ut.setTag_id(tagId.intValue());
                userTagList.add(ut);
            }
        }

        if (location != null) {
            for (String loc : location) {
                Long tagId = userService.findTagIdByName(loc);
                if (tagId != null) {
                    UserTagVO ut = new UserTagVO();
                    ut.setTag_id(tagId.intValue());
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
                    userTagList.add(ut);
                }
            }
        }

        user.setUserTagList(userTagList);

        boolean result = userService.register(user);

        if (result) {
            sess.removeAttribute("tempUser");
            model.addAttribute("user", user);
            return "member/register3";
        } else {
            model.addAttribute("msg", "회원가입 중 오류가 발생했습니다.");
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
    
}
