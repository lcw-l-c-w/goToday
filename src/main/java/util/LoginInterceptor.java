package util;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import kr.co.gotoday.user.UserVO;


@Component
public class LoginInterceptor implements HandlerInterceptor{
	@Override
	public boolean preHandle(HttpServletRequest request, 
							HttpServletResponse response, 
							Object handler)
							throws Exception {
		HttpSession sess = request.getSession();
		UserVO login = (UserVO)sess.getAttribute("loginSess");
		if (login == null) {
            response.setContentType("text/html; charset=utf-8");
            PrintWriter out = response.getWriter();

            out.print("<script>");
            out.print("alert('로그인 후 사용 가능합니다.');");
            out.print("if (window.top !== window.self) {");
            out.print("  window.top.location.href = '/gotoday/member/login';");
            out.print("} else {");
            out.print("  location.href = '/gotoday/member/login';");
            out.print("}");
            out.print("</script>");

            out.close();
            return false;
        }
		return true; // 가던길가
	}
}
