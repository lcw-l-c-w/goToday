<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>GoToday - 수량 선택</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reserve_pay/reservation.css">
</head>
<body>

    <header class="header">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
    </header>

    <main class="main-wrapper">
        <div class="page-header">
            <h1>${contentVO.title}</h1>
            <p>관람하실 인원을 선택해주세요.</p>
            <p class="purchase-notice">※ 1인당 최대 10매까지 구매 가능합니다.<br>단체 구매는 Q&A 게시판에 문의해주세요.</p>
            <div class="highlight-date">
                📅 방문 예정일: ${reservationDTO.reserved_for_at} (${reservationDTO.time_zone})
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/reserve/quantity.do" method="post">
            <input type="hidden" name="content_id" value="${reservationDTO.content_id}" />

            <div class="card-box">
                <div class="ticket-list">
                    <div class="ticket-item">
                        <div class="ticket-info">
                            <h3>성인</h3>
                            <span>만 19세 이상</span>
                            <span class="ticket-price">${contentVO.adult_price}원</span>
                        </div>
                        <div class="qty-control">
                            <button type="button" class="qty-btn" onclick="changeQty('adult_qty', -1)">-</button>
                            <input type="text" id="adult_qty" name="adult_qty" class="qty-input" value="0" readonly />
                            <button type="button" class="qty-btn" onclick="changeQty('adult_qty', 1)">+</button>
                        </div>
                    </div>

                    <div class="ticket-item">
                        <div class="ticket-info">
                            <h3>청소년</h3>
                            <span>만 13세 ~ 18세</span>
                            <span class="ticket-price">${contentVO.teen_price}원</span>
                        </div>
                        <div class="qty-control">
                            <button type="button" class="qty-btn" onclick="changeQty('teen_qty', -1)">-</button>
                            <input type="text" id="teen_qty" name="teen_qty" class="qty-input" value="0" readonly />
                            <button type="button" class="qty-btn" onclick="changeQty('teen_qty', 1)">+</button>
                        </div>
                    </div>

                    <div class="ticket-item">
                        <div class="ticket-info">
                            <h3>어린이</h3>
                            <span>만 4세 ~ 12세</span>
                            <span class="ticket-price">${contentVO.child_price}원</span>
                        </div>
                        <div class="qty-control">
                            <button type="button" class="qty-btn" onclick="changeQty('child_qty', -1)">-</button>
                            <input type="text" id="child_qty" name="child_qty" class="qty-input" value="0" readonly />
                            <button type="button" class="qty-btn" onclick="changeQty('child_qty', 1)">+</button>
                        </div>
                    </div>
                </div>

                <div class="total-bar">
                    <span class="total-label">총 결제 예정 금액</span>
                    <span class="total-price"><span id="totalAmountText">0</span>원</span>
                </div>
                <input type="hidden" id="total_price" name="total_price" value="0" />
            </div>

            <button type="submit" class="submit-btn" id="submitBtn" disabled>예매하기</button>
        </form>
    </main>

    <script>
        // 가격 정보
        const prices = {
            adult: parseInt("${contentVO.adult_price}") || 0,
            teen: parseInt("${contentVO.teen_price}") || 0,
            child: parseInt("${contentVO.child_price}") || 0
        };

        const CURRENT_QTY = parseInt(${scheduleVO.current_ticket});
        const MAX_TOTAL_QTY = (CURRENT_QTY < 10)? CURRENT_QTY : 10; // 1인당 최대 구매 수량

        // 현재 총 수량 계산
        function getTotalQty() {
            const adultQty = parseInt(document.getElementById('adult_qty').value) || 0;
            const teenQty = parseInt(document.getElementById('teen_qty').value) || 0;
            const childQty = parseInt(document.getElementById('child_qty').value) || 0;
            return adultQty + teenQty + childQty;
        }

        // 수량 변경 함수
        function changeQty(inputId, delta) {
            const input = document.getElementById(inputId);
            let currentVal = parseInt(input.value) || 0;
            let newVal = currentVal + delta;

            // 0 이상
            if (newVal < 0) newVal = 0;

            // 총 수량 10개 제한
            const currentTotal = getTotalQty();
            if (delta > 0 && currentTotal >= MAX_TOTAL_QTY) {
            	if (CURRENT_QTY < 10) {
            		alert('해당 시간대의 남은 티켓 수는 ' + MAX_TOTAL_QTY + '매입니다.');
            	} else {
	                alert('1인당 최대 ' + MAX_TOTAL_QTY + '매까지 구매 가능합니다.\n단체 구매는 Q&A 게시판에 문의해주세요.');            		
            	}
                return;
            }

            input.value = newVal;
            calculateTotal();
        }

        // 총 금액 계산
        function calculateTotal() {
            const adultQty = parseInt(document.getElementById('adult_qty').value) || 0;
            const teenQty = parseInt(document.getElementById('teen_qty').value) || 0;
            const childQty = parseInt(document.getElementById('child_qty').value) || 0;

            const total = (adultQty * prices.adult) + (teenQty * prices.teen) + (childQty * prices.child);
            const totalQty = adultQty + teenQty + childQty;

            document.getElementById('totalAmountText').textContent = total.toLocaleString();
            document.getElementById('total_price').value = total;

            // 수량이 0이면 버튼 비활성화
            const submitBtn = document.getElementById('submitBtn');
            if (totalQty > 0) {
                submitBtn.disabled = false;
            } else {
                submitBtn.disabled = true;
            }
        }

        calculateTotal();
    </script>
</body>
</html>
