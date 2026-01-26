<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>GoToday - 수량 선택</title>
    <style>
        /* [공통 스타일] 팀원 파일(main.jsp) 스타일 적용 */
        :root { --main-color: #4dc3ff; --text-color: #333; --border-color: #eee; --bg-gray: #f9f9f9; } 
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Pretendard', sans-serif; background-color: var(--bg-gray); color: var(--text-color); }
        a { text-decoration: none; color: inherit; }
        
        /* [헤더] main.jsp와 동일 */
        .header { width: 100%; border-bottom: 1px solid #eee; background: #fff; position: sticky; top: 0; z-index: 1000; }
        .nav-container { max-width: 1100px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; padding: 0 20px; height: 70px; }
        .logo img { height: 32px; cursor: pointer; display: block; }
        .nav-menu { display: flex; gap: 35px; height: 100%; list-style: none; align-items: center; }
        .nav-menu a { font-weight: 600; font-size: 15px; color: #333; transition: color 0.3s ease; }
        .nav-menu a:hover { color: var(--main-color); }
        .nav-icons { display: flex; gap: 20px; align-items: center; }
        .user-icon { font-size: 22px; cursor: pointer; transition: color 0.2s; }
        .user-icon:hover { color: var(--main-color); }

        /* [메인 레이아웃] */
        .main-wrapper { max-width: 800px; margin: 40px auto; padding: 0 20px; }

        /* [카드 스타일] */
        .card-box {
            background: #fff; border-radius: 20px; padding: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05); border: 1px solid var(--border-color);
            margin-bottom: 30px;
        }

        /* 타이틀 섹션 */
        .page-header { text-align: center; margin-bottom: 40px; }
        .page-header h1 { font-size: 28px; font-weight: 700; margin-bottom: 10px; }
        .page-header p { font-size: 16px; color: #888; }
        .purchase-notice { font-size: 13px; color: #e74c3c; margin-top: 10px; line-height: 1.6; }
        .highlight-date { color: var(--main-color); font-weight: 600; background: #eef9ff; padding: 5px 15px; border-radius: 20px; display: inline-block; margin-top: 10px; }

        /* 티켓 리스트 */
        .ticket-list { display: flex; flex-direction: column; gap: 20px; }
        .ticket-item { 
            display: flex; justify-content: space-between; align-items: center; 
            padding: 20px; border: 1px solid #f0f0f0; border-radius: 15px; background: #fff;
            transition: 0.3s;
        }
        .ticket-item:hover { border-color: var(--main-color); box-shadow: 0 4px 12px rgba(77, 195, 255, 0.1); }
        
        .ticket-info h3 { font-size: 18px; font-weight: 600; margin-bottom: 5px; }
        .ticket-info span { font-size: 14px; color: #888; }
        .ticket-price { font-size: 18px; font-weight: 700; color: #333; margin-top: 5px; display: block; }

        /* 수량 조절 버튼 */
        .qty-control { display: flex; align-items: center; gap: 10px; background: #f5f5f5; padding: 5px; border-radius: 30px; }
        .qty-btn { 
            width: 32px; height: 32px; border-radius: 50%; border: none; background: #fff; 
            font-size: 18px; color: #555; cursor: pointer; transition: 0.2s;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .qty-btn:hover { background: var(--main-color); color: #fff; }
        .qty-input { 
            width: 40px; text-align: center; border: none; background: transparent; 
            font-size: 18px; font-weight: 600; color: #333; outline: none; 
        }

        /* 총 결제 금액바 */
        .total-bar { 
            display: flex; justify-content: space-between; align-items: center;
            margin-top: 20px; padding-top: 20px; border-top: 2px dashed #eee;
        }
        .total-label { font-size: 18px; font-weight: 600; }
        .total-price { font-size: 28px; font-weight: 800; color: var(--main-color); }

        /* 하단 버튼 */
        .submit-btn {
            width: 100%; padding: 18px; border: none; border-radius: 15px;
            background: var(--main-color); color: #fff; font-size: 20px; font-weight: 700;
            cursor: pointer; transition: 0.3s; box-shadow: 0 10px 20px rgba(77, 195, 255, 0.2);
        }
        .submit-btn:hover:not(:disabled) { background: #38b2f0; transform: translateY(-2px); }
        .submit-btn:disabled { background: #ccc; cursor: not-allowed; box-shadow: none; }
    </style>
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
