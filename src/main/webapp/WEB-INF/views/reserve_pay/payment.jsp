<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>티켓 결제</title>
    <script src="https://js.tosspayments.com/v1/payment"></script>
</head>
<body>
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

    <main>
        <section aria-label="콘텐츠 타이틀">
            <h1>${contentVo.title} 2026-01-01(목) ~ 2026-02-28(토)</h1>
        </section>

        <form id="paymentForm" action="#" method="post">
            <input type="hidden" name="contentId" value="${reservation.content_id}" />
            <input type="hidden" name="orderId" value="${paymentDTO.orderId}" />
            <input type="hidden" name="totalPrice" value="${reservation.total_price}" />

            <section aria-label="티켓 결제">
                <h2>티켓 결제</h2>

                <details open>
                    <summary>티켓 주문 상세</summary>

                    <div>
                        <p>
                            <strong name="contentTitle">${contentVo.title}</strong><br />
                            <span name="contentPlace">더서울라이티움(위치)</span>
                        </p>

                        <div>
                            <p><strong>입장권</strong></p>

                            <div>
                                <label>성인: ${reservation.adult_qty}매</label>
                                <label>청소년: ${reservation.teen_qty}매</label>
                                <label>어린이: ${reservation.child_qty}매</label>
                            </div>

                            <div>
                                <label>
                                    단가: ${contentVo.adult_price}원
                                </label>
                            </div>

                            <div>
                                <label>
                                    소계: ${reservation.total_price}원
                                </label>
                            </div>
                        </div>
                    </div>
                </details>
            </section>

            <hr />

            <section aria-label="수령인 정보">
                <h2>수령인 정보</h2>

                <div>
                    <label>
                        예약자
                        <input type="text" name="receiver_name" value="${receiver_info.name}" />
                    </label>
                </div>

                <div>
                    <label>
                        생년월일
                        <input type="text" name="receiver_birth" value="${receiver_info.birthday}" placeholder="YYYY-MM-DD" />
                    </label>
                </div>

                <div>
                    <label>
                        이메일
                        <input type="text" name="receiver_email" value="${receiver_info.email}" />
                    </label>
                </div>

                <div>
                    <label>
                        휴대폰
                        <input type="text" name="receiver_phone" value="${receiver_info.phone_number}" />
                    </label>
                </div>

                <p>티켓 수령 및 본인 확인을 위해 정확한 정보를 입력해주세요.</p>
            </section>

            <hr />

            <section aria-label="티켓 수령 방법">
                <h2>티켓 수령 방법</h2>

                <div>
                    <label>
                        <input type="radio" name="receive_type" value="ONSITE" checked />
                        현장수령
                    </label>

                    <label>
                        <input type="radio" name="receive_type" value="MOBILE" />
                        모바일 티켓
                    </label>
                </div>

                <p>모바일 티켓은 상세보기에서 확인이 가능합니다.</p>
            </section>
            <hr>

			<!-- 결제수단 -->
			<section aria-label="결제 수단 선택">
				<h2>결제 수단</h2>
				<label>
				  <input type="radio" name="payMethod" value="CARD" checked />
				  카드 결제
				</label>
				
				<label>
				  <input type="radio" name="payMethod" value="EASY_PAY" />
				  간편결제
				</label>
				
				<label>
				  <input type="radio" name="payMethod" value="VIRTUAL_ACCOUNT" />
				  가상계좌
				</label>
			</section>

            <hr />

            <section aria-label="약관 동의">
                <h2>약관 동의</h2>

                <div>
                    <label>
                        <input type="checkbox" name="agreeAll" value="Y" />
                        이용약관 전체 동의
                    </label>
                </div>

                <div>
                    <label>
                        <input type="checkbox" name="agreeCancelPolicy" value="Y" />
                        (필수) 취소 규정 안내
                    </label>
                </div>

                <div>
                    <label>
                        <input type="checkbox" name="agreePrivacy" value="Y" />
                        (필수) 개인정보 이용/제공 동의
                    </label>
                </div>

                <div>
                    <a href="#" name="linkThirdParty">개인정보 제3자 제공 안내</a>
                </div>
            </section>

            <hr />

            <section aria-label="결제 정보">
                <h2>결제 정보</h2>

                <div>
                    <p>티켓 금액</p>
                    <span id="ticketAmount">${reservation.total_price}원</span>
                </div>

                <div>
                    <p>최종 결제금액</p>
                    <span id="finalAmount">${reservation.total_price}원</span>
                </div>

                <div>
                    <button type="button" id="payment-button">
                        총 ${reservation.total_price}원 결제하기
                    </button>
                </div>
            </section>
        </form>
    </main>

    <script>
        const button = document.getElementById("payment-button");
        const method = document.querySelector(
        		  'input[name="payMethod"]:checked'
        		).value;
        
        // [수정완료] 내 API 개별 연동 클라이언트 키 (test_ck_Z...)
        const clientKey = "test_ck_mBZ1gQ4YVXgBY9gRN47j3l2KPoqN"; 
        const tossPayments = TossPayments(clientKey);

        button.addEventListener("click", async function () {
            // 수령인 정보 가져오기
            const receiverName = document.querySelector('input[name="receiver_name"]').value;
            const receiverBirth = document.querySelector('input[name="receiver_birth"]').value;
            const receiverPhone = document.querySelector('input[name="receiver_phone"]').value;
            const receiverEmail = document.querySelector('input[name="receiver_email"]').value;
            const receiveType = document.querySelector('input[name="receive_type"]:checked').value;

            // 1. 먼저 서버에 예약 정보 저장 요청
            try {
                const response = await fetch("${pageContext.request.contextPath}/reserve/payment.do", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded",
                    },
                    body: new URLSearchParams({
                        receiver_name: receiverName,
                        receiver_birth: receiverBirth,
                        receiver_phone: receiverPhone,
                        receive_type: receiveType
                    })
                });

                const result = await response.json();
		        const commonOptions = {
		        		  amount: result.amount,
		        		  orderId: result.orderId,
		        		  orderName: result.orderName,
		        		  customerName: receiverName,
		        		  customerEmail: receiverEmail,
		        		// 성공/실패 시 이동할 URL (Context Path 포함)
		                  successUrl: window.location.origin + "${pageContext.request.contextPath}/reserve/success.do",
		                  failUrl: window.location.origin + "${pageContext.request.contextPath}/reserve/fail.do",
		        		};

                // 2. 서버 응답이 성공이면 토스 결제창 호출 (일반 결제창 방식)
                if (result.success) {
                    console.log("예약 정보 저장 성공, 토스 결제창 호출");
                    
	                if (method === "CARD") {
					  tossPayments.requestPayment("카드", commonOptions);
					}
					
					if (method === "EASY_PAY") {
					  tossPayments.requestPayment("간편결제", commonOptions);
					}
					
					if (method === "VIRTUAL_ACCOUNT") {
					  tossPayments.requestPayment("가상계좌", {
					    ...commonOptions,
					    validHours: 24, // 가상계좌 필수 옵션
					  });
					}
                } else {
                    alert("예약 처리 실패: " + result.msg);
                }
            } catch (error) {
                console.error("예약 요청 오류:", error);
                alert("예약 처리 중 오류가 발생했습니다.");
            }
        });
    </script>
</body>
</html>
