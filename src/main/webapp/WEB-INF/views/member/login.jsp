<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
<div class="login-container">
    <h1 class="login-title">LOGIN</h1>
    <form action="/auth/loginUser" method="POST"> 
        <div class="form-group">
            <label class="form-label">이메일 주소</label>
            <input type="email" name="email" class="input-control" placeholder="이메일을 입력하세요" required>
        </div>
        <div class="form-group">
            <label class="form-label">PASSWORD</label>
            <input type="password" name="password" class="input-control" placeholder="비밀번호를 입력하세요" required>
        </div>
        <label class="remember-me">
            <input type="checkbox" name="remember_email"> 아이디 저장
        </label>
        <button type="submit" class="primary-btn">LOGIN</button>
        <div class="signup-prompt">
            회원이 아니신가요?
            <a href="/registerUser" class="sign-in-link">SIGN IN</a>
        </div>
        <div class="social-group">
			<a href="/kakao" class="social-btn kakao">
				카카오 로그인
		    </a>
		    <br>
		    <a href="/naver" class="social-btn naver">
		        네이버 로그인
		    </a>
        </div> 
    </form>
</div>
</body>
</html>