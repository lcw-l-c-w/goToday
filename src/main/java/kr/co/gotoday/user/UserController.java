package kr.co.gotoday.user;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserController {
	
	private final UserService userService;

    // 로그인 폼
    @GetMapping("/auth/loginUser")
    public String loginUser() {
        return "member/login";
    }
    
    // 로그인 처리
    @PostMapping("/auth/loginUser")
    public String loginUser(HttpSession sess, UserVo vo, Model model) {
        UserVo user = userService.loginUser(vo);
        if (user == null) {
            model.addAttribute("msg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        } else {
            sess.setAttribute("loginSess", user);
            return "redirect:/";
        }
    }
    
    // 회원가입 1단계: 정보입력 폼
    @GetMapping("/registerUser")
    public String registerUserStep1() {
        return "member/register1";
    }
    
    // 회원가입 1단계: 정보입력 처리
    @PostMapping("/registerUser/step1")
    public String step1(HttpSession sess,
                        @RequestParam String email_prefix,
                        @RequestParam String email_domain,
                        @RequestParam String password,
                        @RequestParam String name,
                        @RequestParam String birthday,
                        @RequestParam String gender,
                        @RequestParam String phone_number) {

        String email = email_prefix + "@" + email_domain;

        UserVo tempUser = new UserVo();
        tempUser.setEmail(email);
        tempUser.setPassword(password);
        tempUser.setName(name);
        tempUser.setBirthday(birthday);
        tempUser.setGender(gender);
        tempUser.setPhone_number(phone_number);

        sess.setAttribute("tempUser", tempUser);
        return "member/register2"; // 관심사 입력 페이지
    }
    
    // 회원가입 2단계: 관심사 입력 처리
    @PostMapping("/registerUser/step2")
    public String step2(HttpSession sess,
            @RequestParam(required = false) String event,
            @RequestParam(required = false) String[] location,
            @RequestParam(required = false) String[] interest,
            Model model) {

		UserVo user = (UserVo) sess.getAttribute("tempUser");
		if (user == null) return "redirect:/registerUser";
		
		List<UserTagVO> tagList = new ArrayList<>();
		
		if (event != null) {
			UserTagVO t = new UserTagVO();
			t.setTag_id(userService.findTagIdByName(event).intValue());
			tagList.add(t);
		}
		
		if (location != null) {
			for (String loc : location) {
			    UserTagVO t = new UserTagVO();
			    t.setTag_id(userService.findTagIdByName(loc).intValue());
			    tagList.add(t);
			}
		}
		
		if (interest != null) {
			for (String i : interest) {
			    UserTagVO t = new UserTagVO();
			    t.setTag_id(userService.findTagIdByName(i).intValue());
			    tagList.add(t);
			}
		}
		
		user.setUserTagList(tagList);
		userService.registerUser(user);
		
		sess.removeAttribute("tempUser");
		model.addAttribute("user", user);
		return "member/register3"; // 가입완료 페이지
		}
    
}
