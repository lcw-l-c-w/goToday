<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 - 정보입력</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
$(function () {
    function ChangeForm() {
        let role = $("input[name='role']:checked").val();
        $("#vendorNo").toggle(role === "1");
        $("#nameLabel").text(role === "1" ? "등록자명" : "이름");

        // 선택 변경 시 필드 초기화
        $("#vendor_no").val('');
        $("#name").val('');
        $("#email_prefix").val('');
        $("#email_domain").val('');
        $("#password").val('');
        $("#password_confirm").val('');
        $("#birthday").val('');
        $("#phone_number").val('');
        $("input[name='gender']").prop("checked", false);

        emailChecked = false;
        $("#emailCheckMsg").text('');
    }

    $("input[name='role']").on("change", ChangeForm);
 	// 초기 load 시
    ChangeForm(); 
});

let emailChecked = false;

function goSave() {
    let emailPrefix = $("#email_prefix").val();
    let emailDomain = $("#email_domain").val();
    let email = emailPrefix + "@" + emailDomain;

    if(!$("input[name='role']:checked").val()) {
    	alert("회원유형을 선택해주세요.");
        return;
    }
    
    if (emailPrefix === '' || emailDomain === '') {
        alert("이메일을 입력해주세요");
        return;
    }

    if (!emailChecked) {
        alert("이메일 중복확인을 해주세요");
        return;
    }
 
    $("#email").val(email);

    if ($("#password").val() == '') {
    	alert("비밀번호를 입력해주세요.")
    	return;
    }
    
    if ($("#password_confirm").val() == '') {
    	alert("비밀번호 확인을 입력해주세요.")
    	return;
    }
    
    if ($("#password").val() !== $("#password_confirm").val()) {
        alert("비밀번호가 일치하지 않습니다.");
        return;
    }
    
    if($("#name").val() == '') {
    	alert("이름을 입력해주세요.");
        return;
    }
    
    if($("#birthday").val() == '') {
    	alert("생년월일을 입력해주세요.");
        return;
    }
    
    let phoneRegex = /^[0-9]+$/;
    if(!phoneRegex.test($("#phone_number").val())) {
		alert("전화번호는 숫자만 입력해주세요.")
		return;
    }
    
    if(!$("input[name='gender']:checked").val()) {
    	alert("성별을 선택해주세요.");
        return;
    }
    
    if($("#phone_number").val() == '') {
    	alert("전화번호를 입력해주세요.");
        return;
    }
    
    let birthdayRegex = /^[0-9]+$/;
    if(!birthdayRegex.test($("#birthday").val())) {
    	alert("생년월일은 숫자만 입력해주세요.");
    	return;
    }
    	
    $("#frm").submit();
}

function emailCheck() {
    let email = $("#email_prefix").val() + "@" + $("#email_domain").val();

    if ($("#email_prefix").val() === '' || $("#email_domain").val() === '') {
        $("#emailCheckMsg").text("이메일을 입력해주세요");
        return;
    }
    
    if (!$("#email_domain").val().endsWith(".com")
    		&& !$("#email_domain").val().endsWith(".co.kr")) {
    	$("#emailCheckMsg").text("도메인 형식을 다시 확인해주세요.")
    	return;
    }

    $.ajax({
        url: "/gotoday/member/emailCheck",
        data: { email: email },
        success: function(res) {
            if (res == 0) {
                $("#emailCheckMsg").text("사용 가능한 이메일입니다.");
                emailChecked = true;
            } else {
                $("#emailCheckMsg").text("이미 사용 중인 이메일입니다.");
                emailChecked = false;
            }
        }
    });
}

// 이메일 입력 필드 변경 감지
$(document).ready(function() {
    $("#email_prefix, #email_domain").on("input change", function() {
        emailChecked = false; // 이메일 변경 시 중복확인 초기화
        $("#emailCheckMsg").text(""); // 메시지 초기화
    });
});
</script>
</head>

<body>
<h2>회원가입 - 정보입력</h2>
<form id="frm"
      action="/gotoday/member/register1"
      method="POST">

	<p>
		회원유형 선택
		<br>
		<label>
		    <input type="radio" id="user" name="role" value="0" 
		    	${role == 0 ? 'checked' : ''}>개인 회원
		</label>
		<label>
		    <input type="radio" id="vendor" name="role" value="1"
		    	${role == 1 ? 'checked' : ''}>기업 회원
		</label>
	</p>
    <!-- 서버로 실제 전달될 email -->
    <input type="hidden" name="email" id="email">

    <p>
        이메일<br>
        <input type="text" id="email_prefix" name="email_prefix">
        @
        <input type="text" id="email_domain" name="email_domain">
        <br>
        <button type="button" onclick="emailCheck()">중복확인</button>
        <br>
        <span id="emailCheckMsg"></span>
    </p>

    <p>
        비밀번호<br>
        <input type="password" id="password" name="password" >
    </p>

    <p>
        비밀번호 확인<br>
        <input type="password" id="password_confirm" name="password_confirm" >
    </p>
    
	<p>		
		<div id="vendorNo" style="display: ${role == 1 ? 'block' : 'none'}">
			사업자등록번호<br>
			<input type="text" id="vendor_no" name="vendor_no">
		</div>
	</p>
	
    <p>
	    <span id="nameLabel">${role == 1 ? '등록자명' : '이름'}</span><br>
	    <input type="text" id="name" name="name">
	</p>
	
    <p>
        생년월일<br>
        <input type="text" id="birthday" name="birthday" placeholder="YYYYMMDD">
    </p>

    <p>
        성별<br>
        <label><input type="radio" id="genderM" name="gender" value="M"> 남</label>
        <label><input type="radio" id="genderF" name="gender" value="F"> 여</label>
    </p>

    <p>
        전화번호<br>
        <input type="tel" id="phone_number" name="phone_number">
    </p>

    <div id="socialLogin">
	    <a href="https://kauth.kakao.com/oauth/authorize?client_id=${REST_API_KEY}&redirect_uri=${REDIRECT_URI}&response_type=code&scope=account_email,profile_nickname">
		    카카오 로그인</a>
	    <br>
	    <a href="/naver">네이버 로그인</a>
	</div>
		
    <p>
        <button type="button" onclick="history.back()">이전단계</button>
        <button type="button" onclick="goSave()">회원가입</button>
    </p>

</form>

</body>
</html>
