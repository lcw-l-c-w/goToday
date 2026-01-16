<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입-정보입력</title>
</head>
<body>
<div class="container">
    <div class="step-container">
        <span class="step active">정보입력</span>
        <span class="step">관심사 입력</span>
        <span class="step">가입완료</span>
    </div>
    <form action="/registerUser" method="POST"> 
        <div class="form-group">
            <label class="form-label">이메일</label>
            <div class="email-group">
                <input type="text" name="email_prefix" class="input-control">
                <span class="email-at">@</span>
                <input type="text" name="email_domain" class="input-control" placeholder="직접입력">
            </div>
            <button type="button" class="check-btn" onclick="checkDuplicateUser'">중복확인</button>
     	</div>
        <div class="form-group">
            <label class="form-label">비밀번호</label>
            <input type="password" name="password" class="input-control">
        </div>
        <div class="form-group">
            <label class="form-label">비밀번호 확인</label>
            <input type="password" name="password_confirm" class="input-control">
        </div>
        <div class="form-group">
            <label class="form-label">이름</label>
            <input type="text" name="name" class="input-control">
        </div>
        <div class="form-group">
            <label class="form-label">생년월일</label>
            <input type="text" name="birth_date" class="input-control" placeholder="YYYYMMDD">
        </div>
        <div class="form-group">
            <label class="form-label">성별</label>
            <div style="flex: 1; display: flex; gap: 20px;">
                <label><input type="radio" name="gender" value="M"> 남</label>
                <label><input type="radio" name="gender" value="F"> 여</label>
            </div>
        </div>
        <div class="form-group">
            <label class="form-label">휴대전화</label>
            <input type="tel" name="phone_number" class="input-control">
        </div>
        <div class="social-container">
		    <a href="/kakao" class="social-btn kakao">
		        카카오 회원가입
		    </a>
		    <br>
		    <a href="/naver" class="social-btn naver">
		        네이버 회원가입
		    </a>
		</div>
        <div class="footer-btns">
            <button type="button" class="btn prev-btn" onclick="history.back()">이전단계</button>
            <button type="submit" class="btn next-btn">회원가입</button>
        </div>
    </form>
</div>
</body>
</html>