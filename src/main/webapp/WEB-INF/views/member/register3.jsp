<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>완료 | GoToday</title>

<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
<style>
    <%@ include file="register.css" %>
</style>
</head>

<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container">
    <div class="tab-nav">
        <div class="tab-item">정보 입력</div>
        <div class="tab-item">관심사 입력</div>
        <div class="tab-item active">가입 완료</div>
    </div>

    <div class="form-container" style="text-align:center;">
        <h2>회원가입이 완료되었습니다</h2>
        <p style="margin-top:20px;">GoToday에 오신 것을 환영합니다.</p>

        <div class="bottom-buttons">
            <a href="/gotoday/main" class="btn-outline">메인으로</a>
        </div>
    </div>
</div>

</body>
</html>
