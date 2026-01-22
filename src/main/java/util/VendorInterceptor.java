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
public class VendorInterceptor implements HandlerInterceptor{
	@Override
	public boolean preHandle(HttpServletRequest request,
            HttpServletResponse response,
            Object handler) throws Exception {
		HttpSession sess = request.getSession();
	    UserVO login = (UserVO) sess.getAttribute("loginSess");

	    if (login != null && login.getRole() == 0) {

	        HttpSession session = request.getSession();
	        session.setAttribute("flashMessage", "업체만 접근 가능합니다.");

	        response.sendRedirect(request.getContextPath() + "/main");
	        return false;
	    }
	    return true;
	}
}