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

<style>
/* 로그인 페이지 디자인 토큰 적용 */
:root {
  --color-bg-primary: #f5f5f5;
  --color-bg-white: #ffffff;
  --color-text-secondary: #333333;
  --color-text-muted: #9da8be;
  --color-border: #9da8be;
  --color-button-primary: #1a2c50;
  --radius-md: 4px;
}

* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Roboto', sans-serif; background-color: var(--color-bg-primary); min-height: 100vh; }

/* 컨테이너 및 카드 스타일 통일 */
.container {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: calc(100vh - 80px); /* 헤더 높이 고려 */
  padding: 20px 0;
}

.login-card {
  background-color: var(--color-bg-white);
  border-radius: var(--radius-md);
  padding: 40px 50px;
  width: 100%;
  max-width: 450px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.login-title { font-size: 28px; font-weight: 700; text-align: center; margin-bottom: 30px; text-transform: uppercase; }

/* 탭 메뉴 스타일 */
.tab-menu { display: flex; margin-bottom: 30px; border-bottom: 1px solid #eee; }
.tab-menu div { 
    flex: 1; 
    text-align: center; 
    padding: 12px; 
    cursor: pointer; 
    color: var(--color-text-muted);
    font-size: 16px;
    transition: 0.2s;
}
.tab-menu div.active { 
    color: var(--color-button-primary); 
    font-weight: 700; 
    border-bottom: 2px solid var(--color-button-primary); 
}

/* 폼 요소 스타일 통일 */
.find-form { display: none; }
.find-form.active { display: block; }
.form-group { margin-bottom: 25px; }
.form-label { display: block; font-size: 15px; margin-bottom: 6px; color: var(--color-text-secondary); font-weight: 500; }
.form-input { 
    border: none; 
    border-bottom: 1px solid var(--color-border); 
    padding: 8px 0; 
    font-size: 16px; 
    width: 100%; 
    outline: none; 
    transition: border-color 0.2s;
}
.form-input:focus { border-bottom-color: var(--color-button-primary); }

/* 버튼 스타일 통일 */
.btn { 
    width: 100%; 
    padding: 12px; 
    font-size: 17px; 
    border: none; 
    border-radius: var(--radius-md); 
    cursor: pointer; 
    font-weight: 600;
}
.btn-primary { background-color: var(--color-button-primary); color: white; margin-top: 10px; }

/* 결과창 스타일 */
.result-box { 
    margin-top: 25px; 
    padding: 20px; 
    background: #f8f9fa; 
    display: none; 
    text-align: center; 
    border-radius: var(--radius-md); 
    font-size: 15px;
    line-height: 1.6;
    border: 1px dashed var(--color-border);
}

.back-link {
    display: block;
    text-align: center;
    margin-top: 25px;
    color: #888;
    text-decoration: none;
    font-size: 14px;
}
.back-link:hover { text-decoration: underline; }
</style>

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