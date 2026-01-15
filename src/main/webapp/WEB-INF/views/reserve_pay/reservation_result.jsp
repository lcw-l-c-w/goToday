<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://js.tosspayments.com/v2/standard"></script>
    <title>예약 완료</title>
</head>
<body>
    <!-- ===================== HEADER ===================== -->
    <header>
        <a href="#" aria-label="GoToday 홈">GoToday</a>

        <nav aria-label="메인 메뉴">
            <a href="#">Q&amp;A</a>
            <a href="#">PopUp</a>
            <a href="#">Exhibition</a>
        </nav>

        <div>
            <button type="button" name="btnSearch" aria-label="검색">
                검색
            </button>
            <a href="#" aria-label="마이페이지">마이페이지</a>
        </div>
    </header>

    <hr />

	<h1>주문서</h1>
    
    <div style="padding: 10px; background-color: #f5f5f5; border-radius: 5px; margin-bottom: 20px;">
        <p><strong>주문 상품:</strong> ${payInfo.orderName}</p>
        <p><strong>결제 금액:</strong> ${payInfo.amount}원</p>
    </div>

    <div id="payment-method"></div>
    <div id="agreement"></div>
    <button class="button" id="payment-button" style="margin-top: 30px">결제하기</button>

    <script>
      main();

      async function main() {
        const button = document.getElementById("payment-button");
        
        // ------  결제위젯 초기화 ------
        const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
        const tossPayments = TossPayments(clientKey);
        
        const customerKey = "xcvul8W8I_rktuXVZPPHS";
        const widgets = tossPayments.widgets({
          customerKey,
        });
        
        
        const amount = parseInt("${payInfo.amount}");

        await widgets.setAmount({
          currency: "KRW",
          value: amount,
        });

        await Promise.all([
          widgets.renderPaymentMethods({
            selector: "#payment-method",
            variantKey: "DEFAULT",
          }),
          widgets.renderAgreement({ selector: "#agreement", variantKey: "AGREEMENT" }),
        ]);

        <!--// '결제하기' 버튼 클릭
        button.addEventListener("click", async function () {
          try {
            // 1. 먼저 서버에 결제 요청 (PENDING 상태로 예약 저장)
            const response = await fetch("/project/reserve/payment.do", {
              method: "POST",
              headers: {
                "Content-Type": "application/x-www-form-urlencoded",
              },
              body: new URLSearchParams({
                receiver_name: "${payInfo.customerName}",
                receiver_birth: "",
                receiver_phone: ""
              })
            });

            const result = await response.json();

            // 2. 서버 응답 확인
            if (!result.success) {
              alert(result.msg || "결제 준비 중 오류가 발생했습니다.");
              return;
            }

            // 3. 서버 응답 데이터로 토스 결제 요청
            await widgets.requestPayment({
              orderId: result.orderId,
              orderName: result.orderName,
              customerName: result.customerName,
              customerEmail: "${payInfo.customerEmail}",

              successUrl: window.location.origin + "/project/success",
              failUrl: window.location.origin + "/project/fail",
            });

          } catch (error) {
            console.error("결제 요청 실패:", error);
            alert("결제 요청 중 오류가 발생했습니다.");
          }
        });
      }-->
      
   // '결제하기' 버튼 클릭
      button.addEventListener("click", async function () {
        await widgets.requestPayment({
          orderId: "${payInfo.orderId}",
          orderName: "${payInfo.orderName}",
          customerName: "${payInfo.customerName}",
          customerEmail: "${payInfo.customerEmail}",
          
          successUrl: window.location.origin + "/project/success",
          failUrl: window.location.origin + "/project/fail",
        });
      });
    }
  </script>
  </body>
</html>