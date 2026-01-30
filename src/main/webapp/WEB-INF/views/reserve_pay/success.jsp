<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <title>결제 처리 중 | GoToday</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reserve_pay/success.css">
</head>

<body>

<div class="payment-wrapper">
  <!-- 로고 -->
  <div class="logo">
    <img src="${pageContext.request.contextPath}/upload/logo/logo.png" alt="GoToday">
  </div>

  <!-- 타이틀 -->
  <div id="title" class="title loading">결제 승인 처리 중...</div>

  <!-- 메시지 -->
  <div id="message" class="message" style="display:none;"></div>

  <!-- 예약 코드 -->
  <div id="reservationCode" class="reservation-code" style="display:none;"></div>

  <!-- 버튼 -->
  <div class="actions" id="actions" style="display:none;">
    <button id="btn-mypage" class="btn btn-primary">예약 내역 확인</button>
    <button id="btn-home" class="btn btn-secondary">메인으로 가기</button>
  </div>
</div>

<script>
  const paymentKey = "${paymentKey}";
  const orderId = "${orderId}";
  const amount = "${amount}";
  const contextPath = "${pageContext.request.contextPath}";

  const titleEl = document.getElementById("title");
  const messageEl = document.getElementById("message");
  const codeEl = document.getElementById("reservationCode");
  const actionsEl = document.getElementById("actions");

  async function confirm() {
    const requestData = {
      paymentKey: paymentKey,
      orderId: orderId,
      amount: amount,
    };

    try {
      const response = await fetch(contextPath + "/reserve/confirm", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(requestData),
      });

      const json = await response.json();

      if (json.success) {
        //성공
        titleEl.textContent = "결제가 완료되었습니다!";
        titleEl.className = "title success";

        messageEl.style.display = "block";
        messageEl.textContent = json.msg || "결제가 정상적으로 완료되었습니다.";

        codeEl.style.display = "block";
        codeEl.textContent = "예약코드: "+ json.reservationCode;

        actionsEl.style.display = "flex";
        bindActionButtons();

      } else {
        //실패 → 즉시 fail 페이지로 이동
        window.location.href =
          contextPath + "/reserve/fail.do?message=" + encodeURIComponent(json.msg || "결제 처리에 실패했습니다.");
      }

    } catch (error) {
      console.error("결제 승인 오류:", error);
      window.location.href =
        contextPath + "/reserve/fail.do?message=" + encodeURIComponent("결제 처리 중 오류가 발생했습니다.");
    }
  }

  function bindActionButtons() {
    const mypageBtn = document.getElementById("btn-mypage");
    const homeBtn = document.getElementById("btn-home");

    mypageBtn.addEventListener("click", function () {
      window.location.href = contextPath + "/mypage";
    });

    homeBtn.addEventListener("click", function () {
      window.location.href = contextPath + "/main";
    });
  }

  // 0원 결제 여부
  const isFreePayment = (amount === "0" || amount === 0 || amount === "");

  if (isFreePayment) {
    //무료 결제: 서버에서 이미 처리 끝난 상태
    titleEl.textContent = "예약이 완료되었습니다!";
    titleEl.className = "title success";

    messageEl.style.display = "block";
    messageEl.textContent = "무료 전시 예약이 정상적으로 완료되었습니다.";

    codeEl.style.display = "block";
    codeEl.textContent = "예약코드: ${reservationCode}";

    actionsEl.style.display = "flex";
    bindActionButtons();

  } else {
    //유료 결제만 토스 승인 호출
    confirm();
  }
</script>

</body>
</html>