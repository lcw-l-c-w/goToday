package kr.co.gotoday.mypage;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.gotoday.user.UserService;
import kr.co.gotoday.user.UserVO;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MypageController {

	private final UserService userService;
	
	// 관심사 수정
    @GetMapping("/mypage/like_list")
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
        return "mypage/like_list";
    }
    // 관심사 수정
    @PostMapping("/mypage/like_list")
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

        return "/gotoday/mypage";
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
        return "member/userInfoEdit";
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
            // 세션 최신화: userMapper → userService
            UserVO updatedUser = userService.loginByEmail(loginUser.getEmail());
            session.setAttribute("loginSess", updatedUser);
            return "/gotoday/mypage";
        } else {
            model.addAttribute("msg", "회원 정보 수정 중 오류가 발생했습니다.");
            model.addAttribute("cmd", "back");
            return "common/return";
        }
    }
}
