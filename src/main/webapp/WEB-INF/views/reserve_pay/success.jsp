<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8" />
  </head>
  <body>
    <h2>결제 성공</h2>
    <p id="paymentKey"></p>
    <p id="orderId"></p>
    <p id="amount"></p>

    <script>
      const urlParams = new URLSearchParams(window.location.search);
      const paymentKey = urlParams.get("paymentKey");
      const orderId = urlParams.get("orderId");
      const amount = urlParams.get("amount");

      async function confirm() {
        const requestData = {
          paymentKey: paymentKey,
          orderId: orderId,
          amount: amount,
        };

        const response = await fetch("/project/confirm", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(requestData),
        });

        const json = await response.json();

        if (!response.ok) {
          // 결제 실패 시 fail.jsp로 이동
          console.log(json);
          window.location.href = `/fail?message=${json.message}&code=${json.code}`;
          return;
        }

        // 결제 성공 시 화면 표시
        console.log(json);
        const paymentKeyElement = document.getElementById("paymentKey");
        const orderIdElement = document.getElementById("orderId");
        const amountElement = document.getElementById("amount");

        orderIdElement.textContent = "주문번호: " + json.orderId;
        amountElement.textContent = "결제 금액: " + json.totalAmount; // 응답 필드명 확인 필요 (보통 totalAmount)
        paymentKeyElement.textContent = "paymentKey: " + json.paymentKey;
      }
      
      confirm();
    </script>
  </body>
</html>