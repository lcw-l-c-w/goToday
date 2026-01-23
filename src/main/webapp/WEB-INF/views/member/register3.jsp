<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 완료 | GoToday</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
<style>
	<%@ include file="register.css" %>
	
	/* 가입 완료 페이지 전용 정렬 스타일 */
	.complete-box {
	    text-align: center;
	    padding: 60px 0; /* 아이콘이 빠진 만큼 상하 여백을 충분히 주었습니다 */
	}
	.complete-msg {
	    font-size: 22px;
	    font-weight: 700;
	    margin-bottom: 50px;
	    line-height: 1.5;
	    color: #333;
	}
	/* 버튼 위치 조정 */
	.next-btn-container {
	    display: flex;
	    justify-content: center;
	}
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

        <div class="form-container">
            <div class="complete-box">
                
                <p class="complete-msg">
                    <strong>${user.name}</strong> 님의<br>
                    가입이 완료되었습니다~
                </p>

                <div class="next-btn-container">
                    <a href="/gotoday/member/login" class="next-btn">로그인하러 가기</a>
                </div>

            </div>
        </div>
    </div>
</body>
</html>