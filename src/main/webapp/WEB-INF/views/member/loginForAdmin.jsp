<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그인 | GoToDay</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_loginForAdmin.css">
</head>
<body>

<div class="container">
  <div class="login-card">

    <h1 class="login-title">관리자 LOGIN</h1>

    <form action="${pageContext.request.contextPath}/member/login/admin" method="POST">

      <div class="form-group">
        <label class="form-label">아이디</label>
        <input type="text" name="email"
               class="form-input"
               placeholder="아이디를 입력하세요." required>
      </div>

      <div class="form-group">
        <label class="form-label">패스워드</label>
        <input type="password" name="password"
               class="form-input"
               placeholder="비밀번호를 입력하세요." required>
      </div>

      <div class="checkbox-group">
        <label>
          <input type="checkbox" name="remember_email">
          아이디 저장
        </label>
      </div>

      <button type="submit" class="btn-login">LOGIN</button>

    </form>
  </div>
</div>

</body>
</html>
