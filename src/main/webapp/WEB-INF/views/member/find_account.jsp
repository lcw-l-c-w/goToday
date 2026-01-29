<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>계정 찾기 | GoToday</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_find_account.css">
<script>
function switchTab(type) {
    $('.tab-menu div').removeClass('active');
    $('.find-form').removeClass('active');
    $('#resultBox').hide().text('');
    if(type === 'id') {
        $('#tabId').addClass('active');
        $('#formId').addClass('active');
    } else {
        $('#tabPw').addClass('active');
        $('#formPw').addClass('active');
    }
}

function fnFindId() {
    $.post("/gotoday/member/find_id", {
        name: $('#name').val(),
        birthday: $('#birthday').val(),
        phone_number: $('#phone_id').val()
    }, function(data) {
        if(data === "fail") {
            $('#resultBox').show().html("<span style='color:#e74c3c;'>일치하는 정보가 없습니다.</span>");
        } else {
            $('#resultBox').show().html("찾으시는 아이디는<br><strong style='font-size:18px; color:var(--color-button-primary);'>" + data + "</strong> 입니다.");
        }
    });
}

function fnFindPw() {
    $.post("/gotoday/member/find_pw", {
        email: $('#email').val(),
        phone_number: $('#phone_pw').val()
    }, function(data) {
        if(data === "fail") {
            $('#resultBox').show().html("<span style='color:#e74c3c;'>일치하는 정보가 없습니다.</span>");
        } else {
            $('#resultBox').show().html("임시 비밀번호가 발급되었습니다.<br><strong style='color:#e74c3c; font-size:18px;'>" + data + "</strong><br><small style='color:#777;'>로그인 후 반드시 비밀번호를 변경해주세요.</small>");
        }
    });
}

$(document).ready(function() {
    const urlParams = new URLSearchParams(window.location.search);
    const type = urlParams.get('type');
    if (type === 'pw') {
        switchTab('pw');
    } else {
        switchTab('id');
    }
});
</script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="container">
        <div class="login-card">
            <h1 class="login-title">계정 찾기</h1>
            
            <div class="tab-menu">
                <div id="tabId" class="active" onclick="switchTab('id')">아이디 찾기</div>
                <div id="tabPw" onclick="switchTab('pw')">비밀번호 찾기</div>
            </div>

            <div id="formId" class="find-form active">
                <div class="form-group">
                    <label class="form-label">이름</label>
                    <input type="text" id="name" class="form-input" placeholder="이름을 입력해주세요.">
                </div>
                <div class="form-group">
                    <label class="form-label">생년월일</label>
                    <input type="text" id="birthday" class="form-input" placeholder="8자리 (예: 19990101)">
                </div>
                <div class="form-group">
                    <label class="form-label">휴대폰 번호</label>
                    <input type="text" id="phone_id" class="form-input" placeholder="숫자만 입력해주세요.">
                </div>
                <button type="button" class="btn btn-primary" onclick="fnFindId()">아이디 찾기</button>
            </div>

            <div id="formPw" class="find-form">
                <div class="form-group">
                    <label class="form-label">아이디</label>
                    <input type="email" id="email" class="form-input" placeholder="아이디(가입한 이메일)를 입력해주세요.">
                </div>
                <div class="form-group">
                    <label class="form-label">휴대폰 번호</label>
                    <input type="text" id="phone_pw" class="form-input" placeholder="숫자만 입력해주세요.">
                </div>
                <button type="button" class="btn btn-primary" onclick="fnFindPw()">임시 비밀번호 발급</button>
            </div>

            <div id="resultBox" class="result-box"></div>

            <a href="${pageContext.request.contextPath}/member/login" class="back-link">로그인 화면으로 돌아가기</a>
        </div>
    </div>
</body>
</html>