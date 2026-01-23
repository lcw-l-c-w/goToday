<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>GoToday | 온라인 티켓</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/pretendard@1.3.9/dist/web/static/pretendard.css">

<style>
    :root {
        --ticket-bg: #ffffff;
        --page-bg: #f4f7f9;
        --point-color: #1a5ea0;
        --text-main: #333333;
        --text-sub: #888888;
    }

* {
  font-family: 'Pretendard', -apple-system, BlinkMacSystemFont,
               'Apple SD Gothic Neo', 'Noto Sans KR',
               'Malgun Gothic', Arial, sans-serif;
}

    body {
        background-color: var(--page-bg);
        font-family: inherit;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 100vh;
        justify-content: flex-start;
    }

    /* 1. 상단 헤더 영역 (온라인 티켓 제목 + 인쇄 버튼) */
    .ticket-page-header {
        width: 360px; /* 티켓 너비와 일치 */
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 0px;
        margin-bottom: 15px;
    }

    .ticket-page-header h2 {
        font-size: 20px;
        font-weight: 700;
        color: var(--text-main);
        margin: 0;
    }

    .print-icon-btn {
        cursor: pointer;
        transition: 0.2s;
        display: flex;
        align-items: center;
    }

    .print-icon-btn img {
        width: 24px;
        height: 24px;
        opacity: 0.6;
    }

    .print-icon-btn:hover img {
        opacity: 1;
        transform: translateY(-2px);
    }

    /* 2. 티켓 전체 레이아웃 */
    .ticket-wrapper {
        width: 360px;
        filter: drop-shadow(0 15px 30px rgba(0,0,0,0.1));
        margin-bottom: 60px;
    }

    .ticket-main {
        background: var(--ticket-bg);
        border-radius: 20px 20px 0 0;
        overflow: hidden;
    }

    .poster-area {
        width: 100%;
        height: 200px;
        overflow: hidden;
    }

    .ticket-poster {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .info-area {
        padding: 25px;
        text-align: center;
    }

    .ticket-title {
        font-size: 19px;
        font-weight: 800;
        color: var(--point-color);
        margin-bottom: 20px;
        line-height: 1.4;
        word-break: keep-all;
    }

    .info-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 15px;
        text-align: left;
    }

    .info-item label {
        display: block;
        font-size: 10px;
        color: var(--text-sub);
        margin-bottom: 4px;
        letter-spacing: 0.5px;
    }

    .info-item span {
        font-size: 14px;
        font-weight: 600;
        color: var(--text-main);
    }

    /* 3. 티켓 절취선 영역 */
    .ticket-divider {
        background: var(--ticket-bg);
        height: 30px;
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .ticket-divider::before,
    .ticket-divider::after {
        content: '';
        position: absolute;
        width: 24px;
        height: 24px;
        background-color: var(--page-bg);
        border-radius: 50%;
        top: 50%;
        transform: translateY(-50%);
    }

    .ticket-divider::before { left: -12px; }
    .ticket-divider::after { right: -12px; }

    .dashed-line {
        width: 80%;
        border-top: 2px dashed #f0f0f0;
    }

    /* 4. 티켓 하단 - QR 코드 */
    .ticket-footer {
        background: var(--ticket-bg);
        border-radius: 0 0 20px 20px;
        padding: 25px;
        text-align: center;
        margin-top: -1px;
    }

    .qr-container {
        background: #fcfcfc;
        padding: 15px;
        border: 1px solid #f0f0f0;
        border-radius: 12px;
        display: inline-block;
    }

    .qr-container img {
        width: 100px;
        height: 100px;
        display: block;
    }

    .ticket-id {
        margin-top: 15px;
        font-size: 11px;
        color: #ccc;
        font-family: monospace;
    }
	.ticket-qty{
	font-size:11px;}

    /* 인쇄 설정 */
    @media print {
        .ticket-page-header { display: none; }
        body { background: #fff; }
        .ticket-divider::before, .ticket-divider::after { background-color: #fff !important; border: 1px solid #f0f0f0; }
        .ticket-wrapper { filter: none; margin: 0; }
    }
</style>
</head>
<body>

    <div class="ticket-page-header">
        <h2>온라인 티켓</h2>
        <div class="print-icon-btn" onclick="window.print()" title="인쇄하기">
            <img src="https://cdn-icons-png.flaticon.com/512/446/446991.png" alt="인쇄">
        </div>
    </div>

    <div class="ticket-wrapper">
        <div class="ticket-main">
            <div class="poster-area">
                <img class="ticket-poster" src="<c:url value='${reservation.imgPath}'/>" alt="Poster">
            </div>
            
            <div class="info-area">
                <div class="ticket-title">${reservation.title}</div>
                
                <div class="info-grid">
                    <div class="info-item">
                        <label>ADMISSION</label>
                        <span>${reservation.receiver_name}</span>
                    </div>
                    <div class="info-item">
                        <label>QUANTITY</label>
                        <span>${reservation.totalQty}매</span>
                        <div class="ticket-qty">
                        
                        <c:if test="${reservation.adult_qty >0}">
                        <div id="adultTicket">(어른  : ${reservation.adult_qty}매) </div>
                        </c:if>
                        <c:if test="${reservation.teen_qty >0}">
                        <div id="teenTicket">(청소년 : ${reservation.teen_qty}매)</div>
                        </c:if>
                        <c:if test="${reservation.child_qty >0}">
                        <div id="childTicket">(어린이 : ${reservation.child_qty}매)</div>
                        </c:if>
                         </div>
                    </div>
                    <div class="info-item" style="grid-column: span 2;">
                        <label>DATE & TIME</label>
                        <span>${reservation.reserved_for_at} <small style="color:var(--point-color)">${reservation.time_zone}</small></span>
                    </div>
                    <div class="info-item" style="grid-column: span 2;">
                        <label>LOCATION</label>
                        <span>${reservation.location}</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="ticket-divider">
            <div class="dashed-line"></div>
        </div>

        <div class="ticket-footer">
            <div class="qr-container">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${reservation.reservation_id}" alt="QR">
            </div>
            <div class="ticket-id">RESERVATION ID : ${reservation.reservation_id}</div>
        </div>
    </div>

</body>
</html>