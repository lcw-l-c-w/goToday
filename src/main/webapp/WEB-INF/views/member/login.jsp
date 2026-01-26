<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인 | GoToday</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
$(function() {
  $("#togglePassword").on("click", function() {
    let input = $("#password");
    let type = input.attr("type") === "password" ? "text" : "password";
    input.attr("type", type);
    $(this).css({ "opacity": type === "text" ? "1" : "0.5", "filter": type === "text" ? "hue-rotate(170deg) saturate(3)" : "none" });
  });

  $("input[name='role']").on("change", function() {
    $("#socialLogin").toggle($(this).val() === "0");
  });
  
  $("#btnRegister").on("click", function() {
  	let role = $("input[name='role']:checked").val();
  	location.href = "/gotoday/member/register1?role=" + role;
  });
  
});
</script>
<style>
/* 디자인 토큰 및 기본 스타일 */
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

/* 컨테이너 스타일 */
.container {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: calc(100vh - 80px); /* 헤더 높이 고려 */
  padding: 20px 0;
}

/* 카드 스타일 */
.login-card {
  background-color: var(--color-bg-white);
  border-radius: var(--radius-md);
  padding: 40px 50px;
  width: 100%;
  max-width: 450px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}
.login-title { font-size: 28px; font-weight: 700; text-align: center; margin-bottom: 30px; }

/* 폼 요소 */
.role-selection { display: flex; gap: 18px; margin-bottom: 25px; }
.form-group { margin-bottom: 28px; }
.form-label { display: block; font-size: 16px; margin-bottom: 6px; }
.form-input { border: none; border-bottom: 1px solid var(--color-border); padding: 8px 0; font-size: 18px; width: 100%; outline: none; }
.password-wrapper { position: relative; }

/* 비밀번호 아이콘 개선 */
.password-toggle {
  position: absolute; right: 0; top: 50%; transform: translateY(-50%);
  background: none; border: none; cursor: pointer; opacity: 0.5; transition: 0.2s;
}
.password-toggle:hover { opacity: 1; }
.password-toggle img { width: 22px; height: 22px; }

/* 버튼 */
.btn { width: 100%; padding: 12px; font-size: 18px; border: none; border-radius: var(--radius-md); cursor: pointer; margin-bottom: 15px; }
.btn-primary { background-color: var(--color-button-primary); color: white; }
.btn-secondary { background-color: white; border: 1px solid var(--color-border); }

/* 소셜 로그인 (공식 SVG 로고 적용) */
.social-login { display: flex; gap: 12px; margin-top: 15px; }
.btn-social { flex: 1; padding: 10px; border-radius: 4px; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 8px; font-weight: 600; font-size: 13px; transition: transform 0.1s; }
.btn-social:active { transform: scale(0.96); }
.btn-kakao { background-color: #FEE500; color: #000; }
.btn-naver { background-color: #03C75A; color: #fff; }

.kakao-icon { width: 18px; height: 18px; background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath d='M12 3c-4.97 0-9 3.185-9 7.115 0 2.558 1.712 4.8 4.348 6.148l-.845 3.097c-.102.373.121.754.495.845.132.032.27.022.395-.028l3.633-2.422c.322.033.65.055.974.055 4.97 0 9-3.185 9-7.115S16.97 3 12 3z'/%3E%3C/svg%3E") no-repeat center/contain; }
.naver-icon { width: 14px; height: 14px; background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='white'%3E%3Cpath d='M16.273 12.845L7.376 0H0v24h7.727V11.155L16.624 24H24V0h-7.727v12.845z'/%3E%3C/svg%3E") no-repeat center/contain; }
</style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/common/header.jsp" />
  
  <div class="container">
    <div class="login-card">
      <h1 class="login-title">LOGIN</h1>
      <form action="/gotoday/member/login" method="POST">
        <div class="role-selection">
          <label><input type="radio" name="role" value="0" checked> 개인 회원</label>
          <label><input type="radio" name="role" value="1"> 기업 회원</label>
        </div>
        <div class="form-group">
          <label class="form-label">이메일 주소</label>
          <input type="email" name="email" class="form-input" placeholder="이메일을 입력해주세요." required>
        </div>
        <div class="form-group">
          <label class="form-label">PASSWORD</label>
          <div class="password-wrapper">
            <input type="password" id="password" name="password" class="form-input" placeholder="비밀번호를 입력해주세요." required>
            <button type="button" id="togglePassword" class="password-toggle">
              <img src="${pageContext.request.contextPath}/img/eye-icon.svg" alt="eye">
            </button>
          </div>
        </div>
        
        <button type="submit" class="btn btn-primary">LOGIN</button>
        회원이 아니신가요? 
        <button type="button" id="btnRegister" class="btn btn-secondary">SIGN IN</button>
        
        		<!-- ✅ 여기: 에러 메시지 영역 -->
		<c:if test="${not empty loginError}">
  			<div class="login-error">
    			${loginError}
  			</div>
		</c:if>
        
        <div id="socialLogin" class="social-login">
          <a href="https://kauth.kakao.com/oauth/authorize?client_id=${REST_API_KEY}&redirect_uri=${REDIRECT_URI}&response_type=code&scope=account_email,profile_nickname" class="btn-social btn-kakao">
            <span class="kakao-icon"></span> 카카오 로그인
          </a>
          <a href="https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=${NAVER_CLIENT_ID}&state=${NAVER_STATE}&redirect_uri=${NAVER_REDIRECT_URI}" class="btn-social btn-naver">
            <span class="naver-icon"></span> 네이버 로그인
          </a>
        </div>
      </form>
    </div>
  </div>
</body>
</html>