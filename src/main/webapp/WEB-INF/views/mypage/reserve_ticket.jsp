<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>GoToday | 온라인 티켓</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/pretendard@1.3.9/dist/web/static/pretendard.css">
<link rel="stylesheet" href="<c:url value='/css/ticket.css'/>">    

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
           		 <c:set var="qrData" value="http://192.168.0.165:8081/gotoday/common/mobile/${reservation.reservation_id}" />
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${qrData}" alt="QR">
            </div>
            <div class="ticket-id">RESERVATION ID : ${reservation.reservation_code}</div>
        </div>
    </div>

</body>
</html>