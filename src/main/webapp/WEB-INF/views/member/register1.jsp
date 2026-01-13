<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 - 정보입력</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
function goSave() {
    let emailPrefix = $("#email_prefix").val();
    let emailDomain = $("#email_domain").val();
    let email = emailPrefix + "@" + emailDomain;

    if (emailPrefix === '' || emailDomain === '') {
        alert("이메일을 입력해주세요");
        return;
    }

    // hidden input에 email 세팅 (중요!)
    $("#email").val(email);

    let con = true;
    $.ajax({
        url: "/gotoday/member/emailCheck",
        data: { email: email },
        async: false,
        success: function(res) {
            if (res != 0) {
                alert("중복된 이메일입니다.");
                con = false;
            }
        }
    });

    if (!con) return;

    if ($("#password").val() !== $("#password_confirm").val()) {
        alert("비밀번호가 일치하지 않습니다.");
        return;
    }

    $("#frm").submit();
}

function emailCheck() {
    let email = $("#email_prefix").val() + "@" + $("#email_domain").val();

    if ($("#email_prefix").val() === '' || $("#email_domain").val() === '') {
        alert("이메일을 입력해주세요");
        return;
    }

    $.ajax({
        url: "/gotoday/member/emailCheck",
        data: { email: email },
        success: function(res) {
            if (res == 0) {
                $("#emailCheckMsg").text("사용 가능한 이메일입니다.");
            } else {
                $("#emailCheckMsg").text("이미 사용 중인 이메일입니다.");
            }
        }
    });
}
</script>
</head>

<body>

<h2>회원가입 - 정보입력</h2>

<form id="frm"
      action="/gotoday/member/register1"
      method="POST">

    <!-- 서버로 실제 전달될 email -->
    <input type="hidden" name="email" id="email">

    <p>
        이메일<br>
        <input type="text" id="email_prefix" name="email_prefix">
        @
        <input type="text" id="email_domain" name="email_domain">
        <button type="button" onclick="emailCheck()">중복확인</button>
        <br>
        <span id="emailCheckMsg"></span>
    </p>

    <p>
        비밀번호<br>
        <input type="password" name="password" id="password">
    </p>

    <p>
        비밀번호 확인<br>
        <input type="password" id="password_confirm">
    </p>

    <p>
        이름<br>
        <input type="text" name="name">
    </p>

    <p>
        생년월일<br>
        <input type="text" name="birthday" placeholder="YYYYMMDD">
    </p>

    <p>
        성별<br>
        <label><input type="radio" name="gender" value="M"> 남</label>
        <label><input type="radio" name="gender" value="F"> 여</label>
    </p>

    <p>
        휴대전화<br>
        <input type="tel" name="phone_number">
    </p>

    <p>
        <button type="button" onclick="goSave()">다음단계</button>
        <button type="button" onclick="history.back()">이전단계</button>
    </p>

</form>

</body>
</html>
