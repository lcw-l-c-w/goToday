<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>티켓 결제</title>
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
            <h1>무한도전 특별전 2026-01-01(목) ~ 2026-02-28(토)</h1>
        </section>

        <!-- 결제 폼 -->
        <form action="#" method="post">
            <!-- 서버 연동용 hidden (나중에 값 세팅) -->
            <input type="hidden" name="contentId" value="" />
            <input type="hidden" name="scheduleId" value="" />
            <input type="hidden" name="reservationId" value="" />

            <!-- ===================== 티켓 결제 / 주문 상세 ===================== -->
            <section aria-label="티켓 결제">
                <h2>티켓 결제</h2>

                <details open>
                    <summary>티켓 주문 상세</summary>

                    <div>
                        <!-- 주문 정보(나중에 서버 바인딩/반복) -->
                        <p>
                            <strong name="contentTitle"
                                >무한 도전 특별전</strong
                            ><br />
                            <span name="contentPlace"
                                >더서울라이티움(위치)</span
                            >
                        </p>

                        <!-- 티켓 라인(나중에 반복 가능) -->
                        <div>
                            <p><strong>입장권</strong> <span>1</span></p>

                            <!-- 티켓 식별/가격/수량 -->
                            <input
                                type="hidden"
                                name="ticketTypeId"
                                value=""
                            />
                            <input
                                type="hidden"
                                name="ticketName"
                                value=""
                            />

                            <div>
                                <label>
                                    가격정보(예: 성인(만 19세 이상))
                                    <input
                                        type="hidden"
                                        name="ticketLabel"
                                        value=""
                                    />
                                </label>
                            </div>

                            <div>
                                <label>
                                    단가
                                    <input
                                        type="text"
                                        name="ticketUnitPrice"
                                        value=""
                                    />
                                </label>
                            </div>

                            <div>
                                <label>
                                    수량
                                    <input
                                        type="text"
                                        name="ticketQty"
                                        value=""
                                    />
                                </label>
                            </div>

                            <div>
                                <label>
                                    소계(티켓금액)
                                    <input
                                        type="text"
                                        name="ticketSubtotal"
                                        value=""
                                    />
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
                        <input type="text" name="receiverName" value="" />
                    </label>
                </div>

                <div>
                    <label>
                        생년월일
                        <input
                            type="text"
                            name="receiverBirth"
                            value=""
                            placeholder="YYYY-MM-DD"
                        />
                    </label>
                </div>

                <div>
                    <label>
                        이메일
                        <input type="text" name="receiverEmail" value="" />
                    </label>
                </div>

                <div>
                    <label>
                        휴대폰
                        <input type="text" name="receiverPhone" value="" />
                    </label>
                </div>

                <p>
                    티켓 수령 및 본인 확인을 위해 정확한 정보를
                    입력해주세요.
                </p>
            </section>

            <hr />

            <!-- ===================== 티켓 수령 방법 ===================== -->
            <section aria-label="티켓 수령 방법">
                <h2>티켓 수령 방법</h2>

                <div>
                    <label>
                        <input
                            type="radio"
                            name="deliveryMethod"
                            value="ONSITE"
                        />
                        현장수령
                    </label>

                    <label>
                        <input
                            type="radio"
                            name="deliveryMethod"
                            value="MOBILE"
                        />
                        모바일 티켓
                    </label>
                </div>

                <p>모바일 티켓은 상세보기에서 확인이 가능합니다.</p>
            </section>

            <hr />

            <!-- ===================== 결제 수단 ===================== -->
            <section aria-label="결제 수단">
                <h2>결제 수단</h2>

                <!-- 토스페이먼츠 자리(나중에 JS SDK 붙일 자리) -->
                <div>
                    <p>토스 페이먼츠</p>
                    <input
                        type="hidden"
                        name="paymentProvider"
                        value="TOSS"
                    />
                    <input type="hidden" name="paymentMethod" value="" />
                    <p>(결제 위젯/버튼이 들어갈 영역 - 나중에 연결)</p>
                </div>
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
                        <input
                            type="checkbox"
                            name="agreeCancelPolicy"
                            value="Y"
                        />
                        (필수) 취소 규정 안내
                    </label>
                </div>

                <div>
                    <label>
                        <input
                            type="checkbox"
                            name="agreePrivacy"
                            value="Y"
                        />
                        (필수) 개인정보 이용/제공 동의
                    </label>
                </div>

                <div>
                    <a href="#" name="linkThirdParty"
                        >개인정보 제3자 제공 안내</a
                    >
                </div>
            </section>

            <hr />

            <!-- ===================== 결제 정보(우측 카드 영역) ===================== -->
            <section aria-label="결제 정보">
                <h2>결제 정보</h2>

                <div>
                    <p>티켓 금액</p>
                    <input type="text" name="ticketAmount" value="" />
                </div>

                <div>
                    <p>최종 결제금액</p>
                    <input type="text" name="finalAmount" value="" />
                </div>

                <div>
                    <button type="submit" name="btnPay">
                        총 000원 결제하기
                    </button>
                </div>
            </section>
        </form>
    </main>
</body>
</html>