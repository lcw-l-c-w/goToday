<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입-정보입력</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
function goSave() {
	$("#frm").submit();
}

</script>
</head>
<body>
<div class="container">
    <div class="step-container">
        <span class="step active">정보입력</span>
        <span class="step">관심사 입력</span>
        <span class="step">가입완료</span>
    </div>
    <form id="frm" action="registerUser/step1" method="POST"> 
        <div class="form-group">
            <label class="form-label">이메일</label>
            <div class="email-group">
                <input type="text" name="email_prefix" id="email_prefix" class="input-control" required>
                <span class="email-at">@</span>
                <input type="text" name="email_domain" id="email_domain" class="input-control" placeholder="직접입력" required>
            </div>
            <button type="button" class="check-btn" onclick="checkDuplicateUser()">중복확인</button>
            <span id="emailCheckMsg"></span>
        </div>
        <div class="form-group">
            <label class="form-label">비밀번호</label>
            <input type="password" name="password" id="password" class="input-control" required>
        </div>
        <div class="form-group">
            <label class="form-label">비밀번호 확인</label>
            <input type="password" name="password_confirm" id="password_confirm" class="input-control" required>
        </div>
        <div class="form-group">
            <label class="form-label">이름</label>
            <input type="text" name="name" class="input-control" required>
        </div>
        <div class="form-group">
            <label class="form-label">생년월일</label>
            <input type="text" name="birthday" class="input-control" placeholder="YYYYMMDD" required>
        </div>
        <div class="form-group">
            <label class="form-label">성별</label>
            <div style="flex: 1; display: flex; gap: 20px;">
                <label><input type="radio" name="gender" value="M" required> 남</label>
                <label><input type="radio" name="gender" value="F" required> 여</label>
            </div>
        </div>
        <div class="form-group">
            <label class="form-label">휴대전화</label>
            <input type="tel" name="phone_number" class="input-control" required>
        </div>
        <div class="social-container">
            <a href="/kakao" class="social-btn kakao">카카오 회원가입</a>
            <br>
            <a href="/naver" class="social-btn naver">네이버 회원가입</a>
        </div>
		<div class="footer-btns">
		    <a href="javascript:;" class="btn next-btn" onclick="goSave();">다음단계</a> 
		    <a href="javascript:;" class="btn prev-btn" onclick="history.back();">이전단계</a>
		</div>
    </form>
</div>
</body>
</html>