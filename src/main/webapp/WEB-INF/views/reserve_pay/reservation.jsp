<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>예약/결제 - 수량 선택</title>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; margin: 20px; }
    .debug-box { background: #f0f0f0; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
    .debug-box h3 { color: #e74c3c; margin-top: 0; }
    .ticket-section { margin: 20px 0; padding: 20px; border: 1px solid #ddd; border-radius: 8px; }
    .ticket-item { display: flex; justify-content: space-between; align-items: center; padding: 15px; margin: 10px 0; background: #f9f9f9; border-radius: 5px; }
    .ticket-info { flex: 1; }
    .ticket-info p { margin: 0; color: #666; font-size: 14px; }
    .ticket-info strong { font-size: 18px; color: #333; }
    .qty-control { display: flex; align-items: center; gap: 10px; }
    .qty-control button { width: 36px; height: 36px; font-size: 20px; cursor: pointer; border: 1px solid #ddd; background: #fff; border-radius: 5px; }
    .qty-control button:hover { background: #e0e0e0; }
    .qty-control input { width: 50px; text-align: center; font-size: 16px; border: 1px solid #ddd; border-radius: 5px; padding: 5px; }
    .total-section { background: #2c3e50; color: white; padding: 20px; border-radius: 8px; margin: 20px 0; }
    .total-section p { margin: 0; font-size: 14px; }
    .total-section strong { font-size: 28px; }
    .submit-btn { width: 100%; padding: 15px; font-size: 18px; background: #3498db; color: white; border: none; border-radius: 8px; cursor: pointer; }
    .submit-btn:hover { background: #2980b9; }
    h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
</style>
</head>
<body>

<!-- ===================== HEADER ===================== -->
<header>
    <a href="#" aria-label="GoToday 홈"><strong>GoToday</strong></a>
    <nav aria-label="메인 메뉴" style="margin: 10px 0;">
        <a href="#">Q&amp;A</a> |
        <a href="#">PopUp</a> |
        <a href="#">Exhibition</a>
    </nav>
</header>

<hr />

<!-- ===================== DEBUG: 서버에서 받은 데이터 확인 ===================== -->
<div class="debug-box">
    <h3>[DEBUG] 서버에서 받은 데이터 (model)</h3>
    <p><strong>reservationDTO.content_id:</strong> ${reservationDTO.content_id}</p>
    <p><strong>reservationDTO.reserved_for_at:</strong> ${reservationDTO.reserved_for_at}</p>
    <p><strong>reservationDTO.time_zone:</strong> ${reservationDTO.time_zone}</p>
    <hr/>
    <p><strong>contentVo.title:</strong> ${contentVo.title}</p>
    <p><strong>contentVo.adult_price:</strong> ${contentVo.adult_price}원</p>
    <p><strong>contentVo.teen_price:</strong> ${contentVo.teen_price}원</p>
    <p><strong>contentVo.child_price:</strong> ${contentVo.child_price}원</p>
</div>

<!-- ===================== MAIN ===================== -->
<main>
    <h1>${contentVo.title} - 수량 선택</h1>
    <p>예약 날짜: <strong>${reservationDTO.reserved_for_at} ${reservationDTO.time_zone}</strong></p>

    <!-- 수량 선택 폼 -->
    <form action="${pageContext.request.contextPath}/reserve/quantity.do" method="post">
        <!-- hidden: content_id 전달 -->
        <input type="hidden" name="content_id" value="${reservationDTO.content_id}" />

        <div class="ticket-section">
            <h2>티켓 선택</h2>

            <!-- 성인 -->
            <div class="ticket-item">
                <div class="ticket-info">
                    <p>성인 (만 19세 이상)</p>
                    <strong>${contentVo.adult_price}원</strong>
                </div>
                <div class="qty-control">
                    <button type="button" onclick="changeQty('adult_qty', -1)">-</button>
                    <input type="number" id="adult_qty" name="adult_qty" value="0" min="0" max="10" readonly />
                    <button type="button" onclick="changeQty('adult_qty', 1)">+</button>
                </div>
            </div>

            <!-- 청소년 -->
            <div class="ticket-item">
                <div class="ticket-info">
                    <p>청소년 (만 13~18세)</p>
                    <strong>${contentVo.teen_price}원</strong>
                </div>
                <div class="qty-control">
                    <button type="button" onclick="changeQty('teen_qty', -1)">-</button>
                    <input type="number" id="teen_qty" name="teen_qty" value="0" min="0" max="10" readonly />
                    <button type="button" onclick="changeQty('teen_qty', 1)">+</button>
                </div>
            </div>

            <!-- 어린이 -->
            <div class="ticket-item">
                <div class="ticket-info">
                    <p>어린이 (만 4~12세)</p>
                    <strong>${contentVo.child_price}원</strong>
                </div>
                <div class="qty-control">
                    <button type="button" onclick="changeQty('child_qty', -1)">-</button>
                    <input type="number" id="child_qty" name="child_qty" value="0" min="0" max="10" readonly />
                    <button type="button" onclick="changeQty('child_qty', 1)">+</button>
                </div>
            </div>
        </div>

        <!-- 총 금액 -->
        <div class="total-section">
            <p>총 금액</p>
            <strong><span id="totalAmountText">0</span>원</strong>
            <input type="hidden" id="total_price" name="total_price" value="0" />
        </div>

        <!-- 예매하기 버튼 -->
        <button type="submit" class="submit-btn">예매하기</button>
    </form>
</main>

<hr />

<!-- ===================== FOOTER ===================== -->
<footer>
    <p>Team Project</p>
</footer>

<!-- ===================== JavaScript ===================== -->
<script>
    // 가격 정보 (서버에서 받은 값)
    const prices = {
        adult: parseInt("${contentVo.adult_price}") || 0,
        teen: parseInt("${contentVo.teen_price}") || 0,
        child: parseInt("${contentVo.child_price}") || 0
    };

    // 수량 변경 함수
    function changeQty(inputId, delta) {
        const input = document.getElementById(inputId);
        let currentVal = parseInt(input.value) || 0;
        let newVal = currentVal + delta;

        // 범위 제한 (0 ~ 10)
        if (newVal < 0) newVal = 0;
        if (newVal > 10) newVal = 10;

        input.value = newVal;
        calculateTotal();
    }

    // 총 금액 계산 함수
    function calculateTotal() {
        const adultQty = parseInt(document.getElementById('adult_qty').value) || 0;
        const teenQty = parseInt(document.getElementById('teen_qty').value) || 0;
        const childQty = parseInt(document.getElementById('child_qty').value) || 0;

        const total = (adultQty * prices.adult) + (teenQty * prices.teen) + (childQty * prices.child);

        // 화면 표시
        document.getElementById('totalAmountText').textContent = total.toLocaleString();
        // hidden input에 값 설정
        document.getElementById('total_price').value = total;
    }

    // 초기 계산
    calculateTotal();
</script>
</body>
</html>
