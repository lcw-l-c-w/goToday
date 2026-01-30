<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <title>결제 실패 | GoToday</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reserve_pay/fail.css">
</head>

<body>

<div class="payment-wrapper">

  <!-- 로고 -->
  <div class="logo">
    <img src="${pageContext.request.contextPath}/upload/logo/logo.png" alt="GoToday">
  </div>

  <!-- 타이틀 -->
  <div class="title error">결제에 실패했습니다</div>

  <!-- 실패 메시지 -->
  <div id="message" class="message"></div>

  <!-- 에러 코드 -->
  <div id="code" class="error-code"></div>

  <!-- 버튼 -->
  <div class="actions">
    <button id="btn-home" class="btn btn-secondary">메인으로 가기</button>
  </div>

</div>

<script>
  const urlParams = new URLSearchParams(window.location.search);

  const codeElement = document.getElementById("code");
  const messageElement = document.getElementById("message");

  const errorCode = urlParams.get("code");
  const errorMessage = urlParams.get("message");

  messageElement.textContent =
    errorMessage
      ? errorMessage
      : "결제 처리 중 문제가 발생했습니다. 결제 금액은 청구되지 않았습니다.";

  codeElement.textContent =
    errorCode
      ? "에러 코드: " + errorCode
      : "";

  const contextPath = "${pageContext.request.contextPath}";

  document.getElementById("btn-home").addEventListener("click", function () {
    window.location.href = contextPath + "/main";
  });
</script>

</body>
</html>
