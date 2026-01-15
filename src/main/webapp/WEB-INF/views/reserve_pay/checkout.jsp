<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8" />
    <script src="https://js.tosspayments.com/v2/standard"></script>
  </head>
  <body>
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