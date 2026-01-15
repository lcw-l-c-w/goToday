1<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>티켓 결제</title>
    <!-- 토스페이먼츠 SDK -->
    <script src="https://js.tosspayments.com/v2/standard"></script>
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

    <!-- ===================== MAIN ===================== -->
    <main>
        <!-- 상단 타이틀(콘텐츠명/기간) -->
        <section aria-label="콘텐츠 타이틀">
            <h1>${contentVo.title} 2026-01-01(목) ~ 2026-02-28(토)</h1>
        </section>

        <!-- 결제 폼 -->
        <form id="paymentForm" action="#" method="post">
            <!-- 서버 연동용 hidden -->
            <input type="hidden" name="contentId" value="${reservation.content_id}" />
            <input type="hidden" name="orderId" value="${paymentDTO.orderId}" />
            <input type="hidden" name="totalPrice" value="${reservation.total_price}" />

            <!-- ===================== 티켓 결제 / 주문 상세 ===================== -->
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

            <!-- ===================== 수령인 정보 ===================== -->
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

            <!-- ===================== 티켓 수령 방법 ===================== -->
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

            <hr />

            <!-- ===================== 결제 수단 (토스페이먼츠 위젯) ===================== -->
            <section aria-label="결제 수단">
                <h2>결제 수단</h2>

                <!-- 토스페이먼츠 결제 위젯 영역 -->
                <div id="payment-method"></div>

                <!-- 토스페이먼츠 약관 동의 영역 -->
                <div id="agreement"></div>
            </section>

            <hr />

            <!-- ===================== 약관 동의 ===================== -->
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

            <!-- ===================== 결제 정보(우측 카드 영역) ===================== -->
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

    <!-- ===================== 토스페이먼츠 결제 스크립트 ===================== -->
    <script>
        main();

        async function main() {
            const button = document.getElementById("payment-button");

            // 결제위젯 초기화
            const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
            const tossPayments = TossPayments(clientKey);

            const customerKey = "xcvul8W8I_rktuXVZPPHS";
            const widgets = tossPayments.widgets({
                customerKey,
            });

            // 결제 금액 설정
            const amount = parseInt("${paymentDTO.amount}") || 0;

            await widgets.setAmount({
                currency: "KRW",
                value: amount,
            });

            // 결제 위젯 렌더링
            await Promise.all([
                widgets.renderPaymentMethods({
                    selector: "#payment-method",
                    variantKey: "DEFAULT",
                }),
                widgets.renderAgreement({
                    selector: "#agreement",
                    variantKey: "AGREEMENT"
                }),
            ]);

            // '결제하기' 버튼 클릭
            button.addEventListener("click", async function () {
                // 수령인 정보 가져오기
                const receiverName = document.querySelector('input[name="receiver_name"]').value;
                const receiverBirth = document.querySelector('input[name="receiver_birth"]').value;
                const receiverPhone = document.querySelector('input[name="receiver_phone"]').value;
                const receiverEmail = document.querySelector('input[name="receiver_email"]').value;
                const receiveType = document.querySelector('input[name="receive_type"]:checked').value;

                // 1. 먼저 서버에 예약 정보 저장 요청 (POST /reserve/payment.do)
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

                    // 2. 서버 응답이 성공이면 토스페이먼츠 결제 요청
                    if (result.success) {
                        console.log("예약 정보 저장 성공, 토스 결제 요청 시작");

                        await widgets.requestPayment({
                            orderId: result.orderId,
                            orderName: result.orderName,
                            customerName: result.customerName || receiverName,
                            customerEmail: receiverEmail,

                            successUrl: window.location.origin + "${pageContext.request.contextPath}/reserve/success.do",
                            failUrl: window.location.origin + "${pageContext.request.contextPath}/reserve/fail.do",
                        });
                    } else {
                        alert("예약 처리 실패: " + result.msg);
                    }
                } catch (error) {
                    console.error("예약 요청 오류:", error);
                    alert("예약 처리 중 오류가 발생했습니다.");
                }
            });
        }
    </script>
</body>
</html>
