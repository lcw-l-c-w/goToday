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
$(function() {
	// URL 파라미터로 초기 탭 설정
	const urlParams = new URLSearchParams(window.location.search);
	const type = urlParams.get('type');
	if (type === 'pw') {
		switchTab('pw');
	} else {
		switchTab('id');
	}

	// 휴대전화 자동(-) 처리
	$("#phone_id, #phone_pw").on("input", function() {
		let number = $(this).val().replace(/[^0-9]/g, "");
		let formatted = "";

		if (number.length < 4) {
			formatted = number;
		} else if (number.length < 7) {
			formatted = number.substr(0, 3) + "-" + number.substr(3);
		} else if (number.length <= 11) {
			formatted = number.substr(0, 3) + "-" + number.substr(3, 4) + "-" + number.substr(7);
		} else {
			formatted = number.substr(0, 3) + "-" + number.substr(3, 4) + "-" + number.substr(7, 4);
		}

		$(this).val(formatted);
	});
});

// 탭 전환
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

// 아이디 찾기 AJAX
function fnFindId() {
	// DB 저장용 하이픈 제거
	let phone = $('#phone_id').val().replace(/-/g, "");

	$.post("${pageContext.request.contextPath}/member/find_id", {
		name: $('#name').val(),
		birthday: $('#birthday').val(),
		phone_number: phone
	}, function(data) {
		if (data === "fail") {
			$('#resultBox').show().html("<span class='result-error'>일치하는 정보가 없습니다.</span>");
		} else {
			$('#resultBox').show().html(
				"찾으시는 아이디는<br>" +
				"<strong class='result-highlight'>" + data + "</strong> 입니다."
			);
		}
	});
}

// 비밀번호 찾기 AJAX
function fnFindPw() {
	// DB 저장용 하이픈 제거
	let phone = $('#phone_pw').val().replace(/-/g, "");

	$.post("${pageContext.request.contextPath}/member/find_pw", {
		email: $('#email').val(),
		phone_number: phone
	}, function(data) {
		if (data === "fail") {
			$('#resultBox').show().html(
				"<span class='result-error'>일치하는 정보가 없습니다.</span>"
			);
		} else {
			$('#resultBox').show().html(
				"발급된 임시 비밀번호는<br>" +
				"<strong class='result-highlight'>" + data + "</strong> 입니다."
			);
		}
	});
}
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