<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그인</title>
</head>
<body>
<h1>관리자 LOGIN</h1>
	<form action="/gotoday/member/loginForAdmin" method="POST"> 
	    <label>아이디</label>
	    <input type="text" name="email" placeholder="아이디를 입력하세요" required>
	    <br>
	    
	    <label>패스워드</label>
	    <input type="password" name="password" placeholder="비밀번호를 입력하세요" required>
	    <br>
	    
	    <label><input type="checkbox" name="remember_email"> 아이디 저장</label>
	    <br>
	    
	    <button type="submit">LOGIN</button>
	    <br>
	  </form>
</body>
</html>