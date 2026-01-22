package util;

import java.io.PrintWriter;
import java.net.URLEncoder;

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
            Object handler) throws Exception {
		HttpSession sess = request.getSession();
	    UserVO login = (UserVO) sess.getAttribute("loginSess");

	    if ("POST".equalsIgnoreCase(request.getMethod())) {
	        return true;
	    }

	    if (login == null) {
	        String contextPath = request.getContextPath();
	        
	        // 이 요청을 보내기 전 페이지(이전 페이지) 가져오기
	        String referer = request.getHeader("Referer");
	        String redirectUrl = "";

	        if (referer != null && !referer.isEmpty()) {
	            if (referer.contains(contextPath)) {
	                redirectUrl = referer.substring(referer.indexOf(contextPath) + contextPath.length());
	            } else {
	                redirectUrl = "/index.do"; // 외부에서 유입된 경우 기본 페이지 설정
	            }
	        } else {
	            redirectUrl = "/main"; // 이전 페이지 정보가 없는 경우
	        }

	        // URL 인코딩 (특수문자 처리)
	        String encodedUrl = URLEncoder.encode(redirectUrl, "UTF-8");

	        response.setContentType("text/html; charset=utf-8");
	        PrintWriter out = response.getWriter();

	        out.print("<script>");
	        out.print("alert('로그인 후 사용 가능합니다.');");
	        out.print("location.href='" + contextPath + "/member/login?redirect=" + encodedUrl + "';");
	        out.print("</script>");

	        out.close();
	        return false;
	    }
	    return true;
	}
}






