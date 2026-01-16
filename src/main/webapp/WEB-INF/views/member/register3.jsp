<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입-가입완료</title>
</head>
<body>
<div class="container">
    <div class="step-container">
        <span class="step">정보입력</span>
        <span class="step">관심사 입력</span>
        <span class="step active">가입완료</span>
    </div>

        <p>
            ${user.name}님의 가입이 완료되었습니다~
        </p>
        <a href="/gotoday/member/login" >로그인하러 가기</a>
		<a href="/gotoday/member/logout">로그아웃</a>
</div>
</body>
</html>