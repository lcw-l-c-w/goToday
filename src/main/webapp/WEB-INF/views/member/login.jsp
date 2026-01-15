<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
$(function () {
    function socialDisplay() {
        let role = $("input[name='role']:checked").val();
        $("#socialLogin").css("display", role === "1" ? "none" : "block");
    }

    $("input[name='role']").on("change", socialDisplay);
    socialDisplay();
});

</script>

<title>로그인</title>
</head>
<body>
<h1>LOGIN</h1>
	<form action="/gotoday/member/login" method="POST"> 
	
		<label><input type="radio" id="user" name="role" value=0 checked>개인 회원</label>
		<label><input type="radio" id="vendor" name="role" value=1>기업 회원</label>
		<br><br>
		
	    <label>이메일 주소</label>
	    <input type="email" name="email" placeholder="이메일을 입력하세요" required>
	    <br>
	    
	    <label>패스워드</label>
	    <input type="password" name="password" placeholder="비밀번호를 입력하세요" required>
	    <br>
	    
	    <label><input type="checkbox" name="remember_email"> 아이디 저장</label>
	    <br>
	    
	    <button type="submit">LOGIN</button>
	    <br>
	    
	    회원이 아니신가요?
	    <a href="/gotoday/member/register1">SIGN IN</a>
	    <br>
	    
	    <div id="socialLogin">
		    <a href="/kakao">카카오 로그인</a>
		    <br>
		    <a href="/naver">네이버 로그인</a>
		</div>
		
	</form>
</body>
</html>