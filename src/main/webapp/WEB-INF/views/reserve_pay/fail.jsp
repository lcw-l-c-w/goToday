<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <title>결제 실패 | GoToday</title>

  <style>
    body {
      margin: 0;
      font-family: 'Pretendard', 'Malgun Gothic', -apple-system, BlinkMacSystemFont, sans-serif;
      background: #f5f6f8;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      color: #222;
    }

    .payment-wrapper {
      width: 100%;
      max-width: 420px;
      background: #ffffff;
      border-radius: 16px;
      padding: 36px 32px 32px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.08);
      text-align: center;
    }

    .logo {
      margin-bottom: 18px;
    }

    .logo img {
      height: 100px;
      object-fit: contain;
    }

    .title {
      font-size: 20px;
      font-weight: 700;
      margin-bottom: 12px;
    }

    .title.error { color: #e74c3c; }

    .message {
      font-size: 15px;
      color: #555;
      line-height: 1.6;
      margin-bottom: 14px;
      word-break: keep-all;
    }

    .error-code {
      font-size: 13px;
      color: #999;
      margin-bottom: 24px;
    }

    .actions {
      display: flex;
      gap: 12px;
      justify-content: center;
      margin-top: 10px;
    }

    .btn {
      flex: 1;
      padding: 12px 0;
      border-radius: 8px;
      border: none;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
    }

    .btn-primary {
      background: #2c7be5;
      color: #fff;
    }

    .btn-secondary {
      background: #e9ecef;
      color: #333;
    }
  </style>
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
