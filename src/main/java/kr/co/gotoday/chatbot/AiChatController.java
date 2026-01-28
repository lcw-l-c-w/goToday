package kr.co.gotoday.chatbot;

import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.gotoday.user.UserVO;

@Controller
public class AiChatController {

    @Autowired
    private AiChatService aiChatService;

    // 1. 채팅 테스트 페이지 이동
    @GetMapping("/ai/chat")
    public String chatPage() {
        return "chat/ai_chat"; // jsp 파일 경로
    }

    // 2. 채팅 요청 처리
    @PostMapping(value = "/api/ai-chat", produces = "application/text; charset=utf8")
    @ResponseBody
    public String handleChat(@RequestParam String msg, HttpSession session) {
        
        // 로그인 체크 (개인화된 답변을 위해 필수)
        UserVO user = (UserVO) session.getAttribute("loginSess");
        if (user == null) {
            return "로그인이 필요한 서비스입니다.";
        }

        // 서비스로 토스 (질문 + 사용자ID)
        return aiChatService.processUserRequest(msg, user.getUser_id());
    }
}