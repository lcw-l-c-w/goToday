<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>예약/결제</title>
</head>
<body>
<!-- =========================================================
HEADER (나중에 JSP로 바꿀 때 header.jspf로 분리하기 좋음)
========================================================= -->
<header>
    <div>
        <!-- 로고 -->
        <a href="#" aria-label="GoToday 홈">
            <span>GoToday</span>
        </a>
    </div>

    <!-- 상단 메뉴 -->
    <nav aria-label="메인 메뉴">
        <a href="#">Q&amp;A</a>
        <a href="#">PopUp</a>
        <a href="#">Exhibition</a>
    </nav>

    <!-- 우측 아이콘/버튼 -->
    <div>
        <button type="button" name="btnSearch" aria-label="검색">
            🔍
        </button>
        <a href="#" aria-label="마이페이지/유저">👤</a>
        <button type="button" name="btnSignOut">Sign out</button>
    </div>
</header>

<!-- =========================================================
MAIN
========================================================= -->
<main>
    <!-- 결제/예약 폼 (오른쪽 영역 입력값 제출용) -->
    <form action="#" method="post">
        <!-- 나중에 서버 연결할 때 key 값들 -->
        <input type="hidden" name="contentId" value="" />
        <input type="hidden" name="scheduleId" value="" />
        <input type="hidden" name="visitDate" value="" />

        <!-- 전체 2단 레이아웃 -->
        <section aria-label="예약 결제 레이아웃">
            <!-- ===================== LEFT (포스터/정보) ===================== -->
            <div aria-label="콘텐츠 정보 영역">
                <!-- 큰 제목 바 -->
                <div>
                    <h1>
                        무한도전 특별전 2026-01-01(목) ~ 2026-02-28(토)
                    </h1>
                </div>

                <!-- 포스터 -->
                <div>
                    <!-- 나중에 실제 이미지 경로로 교체 -->
                    <img src="#" alt="콘텐츠 포스터" />
                </div>
            </div>

            <!-- ===================== RIGHT (티켓/총액/예매) ===================== -->
            <aside aria-label="티켓 선택 및 결제">
                <!-- 티켓 목록 -->
                <section aria-label="티켓 선택">
                    <!--
      [중요] 지금은 3개 고정 목업.
      나중에 ticketType이 늘어날 수 있으면 JSP에서 반복(c:forEach)로 바꾸면 됨.

      또한 name을 배열형으로 하면 나중에 처리 편해짐:
      ticketTypeId, ticketQty를 "반복 input"으로 두면 Spring에서 List로 받기 쉬움.
      (현재도 이미 반복 input이라 OK)
    -->

                    <!-- Ticket Item 1 -->
                    <article aria-label="티켓 항목 1">
                        <div>
                            <p>연령별</p>
                            <strong>연령별가격</strong>
                        </div>

                        <!-- 서버로 넘길 티켓 타입 ID -->
                        <input
                            type="hidden"
                            name="ticketTypeId"
                            value=""
                        />

                        <!-- 수량 조절 (JS는 나중에) -->
                        <div aria-label="수량 선택">
                            <button
                                type="button"
                                name="btnQtyMinus"
                                aria-label="수량 감소"
                            >
                                -
                            </button>
                            <input
                                type="text"
                                name="ticketQty"
                                value=""
                                inputmode="numeric"
                                aria-label="수량"
                            />
                            <button
                                type="button"
                                name="btnQtyPlus"
                                aria-label="수량 증가"
                            >
                                +
                            </button>
                        </div>
                    </article>

                    <!-- Ticket Item 2 -->
                    <article aria-label="티켓 항목 2">
                        <div>
                            <p>연령별</p>
                            <strong>연령별가격</strong>
                        </div>

                        <input
                            type="hidden"
                            name="ticketTypeId"
                            value=""
                        />

                        <div aria-label="수량 선택">
                            <button
                                type="button"
                                name="btnQtyMinus"
                                aria-label="수량 감소"
                            >
                                -
                            </button>
                            <input
                                type="text"
                                name="ticketQty"
                                value=""
                                inputmode="numeric"
                                aria-label="수량"
                            />
                            <button
                                type="button"
                                name="btnQtyPlus"
                                aria-label="수량 증가"
                            >
                                +
                            </button>
                        </div>
                    </article>

                    <!-- Ticket Item 3 -->
                    <article aria-label="티켓 항목 3">
                        <div>
                            <p>연령별</p>
                            <strong>연령별가격</strong>
                        </div>

                        <input
                            type="hidden"
                            name="ticketTypeId"
                            value=""
                        />

                        <div aria-label="수량 선택">
                            <button
                                type="button"
                                name="btnQtyMinus"
                                aria-label="수량 감소"
                            >
                                -
                            </button>
                            <input
                                type="text"
                                name="ticketQty"
                                value=""
                                inputmode="numeric"
                                aria-label="수량"
                            />
                            <button
                                type="button"
                                name="btnQtyPlus"
                                aria-label="수량 증가"
                            >
                                +
                            </button>
                        </div>
                    </article>
                </section>

                <hr />

                <!-- 총 금액 -->
                <section aria-label="총 금액">
                    <p>총 금액</p>
                    <strong>
                        <!-- 화면 표시용 -->
                        <span id="totalAmountText">0,000원</span>
                    </strong>

                    <!-- 서버 제출용(나중에 계산해서 값 세팅) -->
                    <input type="hidden" name="totalAmount" value="" />
                </section>

                <!-- 예매하기 -->
                <div>
                    <button type="submit" name="btnReserve">
                        예매하기
                    </button>
                </div>
            </aside>
        </section>
    </form>
</main>

<!-- =========================================================
FOOTER (나중에 JSP로 바꿀 때 footer.jspf로 분리하기 좋음)
========================================================= -->
<footer>
    <p>© Team Project</p>
</footer>
    </body>
</html>