<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8" />
    <title>결제 처리 중</title>
    <style>
      body { font-family: 'Malgun Gothic', sans-serif; margin: 40px; text-align: center; }
      .loading { font-size: 18px; color: #666; }
      .success { color: #27ae60; }
      .error { color: #e74c3c; }
      .result-box { margin-top: 30px; padding: 20px; border-radius: 8px; }
      .result-box.success { background: #d5f5e3; }
      .result-box.error { background: #fadbd8; }
    </style>
  </head>
  <body>
    <h2 id="title" class="loading">결제 승인 처리 중...</h2>
    <div id="result" class="result-box" style="display:none;">
      <p id="message"></p>
      <p id="reservationCode"></p>
    </div>

    <script>
      // 서버에서 전달받은 토스 파라미터
      const paymentKey = "${paymentKey}";
      const orderId = "${orderId}";
      const amount = "${amount}";
      const contextPath = "${pageContext.request.contextPath}";

      async function confirm() {
        const requestData = {
          paymentKey: paymentKey,
          orderId: orderId,
          amount: amount,
        };

        try {
          const response = await fetch(contextPath + "/reserve/confirm", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(requestData),
          });

          const json = await response.json();
          const titleEl = document.getElementById("title");
          const resultEl = document.getElementById("result");
          const messageEl = document.getElementById("message");
          const codeEl = document.getElementById("reservationCode");

          if (json.success) {
            // 성공
            titleEl.textContent = "결제가 완료되었습니다!";
            titleEl.className = "success";
            resultEl.className = "result-box success";
            resultEl.style.display = "block";
            messageEl.textContent = json.msg;
            codeEl.textContent = "예약코드: " + json.reservationCode;
          } else {
            // 실패
            titleEl.textContent = "결제 처리 실패";
            titleEl.className = "error";
            resultEl.className = "result-box error";
            resultEl.style.display = "block";
            messageEl.textContent = json.msg;

            // 3초 후 fail 페이지로 이동
            setTimeout(function() {
              window.location.href = contextPath + "/reserve/fail.do?message=" + encodeURIComponent(json.msg);
            }, 3000);
          }
        } catch (error) {
          console.error("결제 승인 오류:", error);
          document.getElementById("title").textContent = "결제 처리 중 오류 발생";
          document.getElementById("title").className = "error";

          setTimeout(function() {
            window.location.href = contextPath + "/reserve/fail.do?message=" + encodeURIComponent("결제 처리 중 오류가 발생했습니다.");
          }, 3000);
        }
      }

      // 페이지 로드 시 자동 실행
      confirm();
    </script>
  </body>
</html>
