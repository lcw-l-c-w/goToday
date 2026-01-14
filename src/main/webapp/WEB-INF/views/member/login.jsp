<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
<h1>LOGIN</h1>
	<form action="/gotoday/member/login" method="POST"> 
	    <label>이메일 주소</label>
	    <input type="email" name="email" placeholder="이메일을 입력하세요" required>
	    <br>
	    <label>PASSWORD</label>
	    <input type="password" name="password" placeholder="비밀번호를 입력하세요" required>
	    <br>
	    <label>
	    <input type="checkbox" name="remember_email"> 아이디 저장
	    </label>
	    <br>
	    <button type="submit">LOGIN</button>
	    <br>
	    회원이 아니신가요?
	    <a href="/gotoday/member/register1">SIGN IN</a>
	    <br>
	    <a href="/kakao">카카오 로그인</a>
	    <br>
	    <a href="/naver">네이버 로그인</a>
	</form>
</body>
</html>