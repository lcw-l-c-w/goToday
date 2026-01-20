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
      <div class="actions" style="margin-top: 20px; display: flex; gap: 12px; justify-content: center;">
		  <button id="btn-mypage" style="padding: 10px 18px; border-radius: 6px; border: none; background: #2c7be5; color: #fff; cursor: pointer;">
		  	예약 내역 확인하기
		  </button>
		
		  <button id="btn-home" style="padding: 10px 18px; border-radius: 6px; border: none; background: #6c757d; color: #fff; cursor: pointer;">
		    메인으로 가기
		  </button>
		</div>
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

      function bindActionButtons() {
   	    const mypageBtn = document.getElementById("btn-mypage");
   	    const homeBtn = document.getElementById("btn-home");

   	    if (mypageBtn) {
   	      mypageBtn.addEventListener("click", function () {
   	        window.location.href = contextPath + "/mypage/reservation";
   	      });
   	    }

   	    if (homeBtn) {
   	      homeBtn.addEventListener("click", function () {
   	        window.location.href = contextPath + "/main.do";
   	      });
   	    }
   	  }
      
      const isFreePayment = (amount === "0" || amount === 0 || amount === "");

      if (isFreePayment) {
        //0원 결제: 서버에서 이미 처리 끝난 상태
        const titleEl = document.getElementById("title");
        const resultEl = document.getElementById("result");
        const messageEl = document.getElementById("message");
        const codeEl = document.getElementById("reservationCode");

        titleEl.textContent = "예약이 완료되었습니다!";
        titleEl.className = "success";
        resultEl.className = "result-box success";
        resultEl.style.display = "block";

        messageEl.textContent = "무료 전시 예약이 정상적으로 완료되었습니다.";
        codeEl.textContent = "예약코드: ${reservationCode}";

        bindActionButtons();
      } else {
        //유료 결제만 토스 승인 호출
        confirm();
      }
      
    </script>
  </body>
</html>
