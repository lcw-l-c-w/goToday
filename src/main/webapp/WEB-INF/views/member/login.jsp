<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
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
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_login.css">
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
<!-- header.jsp or layout.jsp -->
<c:if test="${not empty msg}">
<script>
    alert("${msg}");
</script>
</c:if>
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
        
        <div class="find-links">
		    <a href="${pageContext.request.contextPath}/member/find_account?type=id">아이디 찾기</a>
		    <span>|</span>
		    <a href="${pageContext.request.contextPath}/member/find_account?type=pw">비밀번호 찾기</a>
		</div>

        회원이 아니신가요? 
        <button type="button" id="btnRegister" class="btn btn-secondary">SIGN IN</button>
        
        		<!-- 여기: 에러 메시지 영역 -->
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