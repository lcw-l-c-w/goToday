<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 관리 | GoToday</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    /* 1. 기본 초기화 */
    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        background-color: #f5f5f5; /* 변수 대신 직접 지정하여 오류 방지 */
        font-family: 'Pretendard', -apple-system, sans-serif;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 100vh;
        justify-content: flex-start;
    }

    /* 2. 메인 컨테이너 수정 - 위로 바짝 올리기 */
    .container {
        display: flex;
        gap: 40px; /* 사이드바와의 간격 최적화 */
        padding: 20px 8% 60px 8%; /* 상단 padding을 60px -> 20px로 대폭 축소 */
        max-width: 1400px;
        margin: 0 auto;
        align-items: flex-start; /* 콘텐츠가 위에서부터 시작하도록 고정 */
    }

    .content {
        flex: 1;
    }

    /* 3. 제목 영역 수정 - 여백 최소화 */
    .page-title {
        font-size: 28px;
        font-weight: 700;
        margin-top: 10px; /* 상단 여백 미세 조정 */
        margin-bottom: 25px; /* 티켓 리스트와의 간격 축소 */
    }

    .list-wrapper {
        max-width: 800px;
    }

    /* 4. 티켓 헤더 및 카드 스타일 */
    .ticket-page-header {
        width: 360px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 0; /* 마진 제거 */
        margin-bottom: 10px;
    }

    .ticket-wrapper {
        width: 360px;
        filter: drop-shadow(0 15px 30px rgba(0,0,0,0.1));
        margin-top: 0;
        margin-bottom: 40px;
    }

    .reserve-item {
        background: white;
        border-radius: 20px;
        padding: 25px;
        margin-bottom: 20px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        position: relative;
    }

    /* 배지 스타일 */
    .badge {
        position: absolute;
        top: 20px;
        left: 20px;
        padding: 6px 16px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 700;
        color: white;
        background-color: #4dc3ff; /* 기본 d-day 색상 */
    }

    /* 날짜/시간 영역 */
    .datetime {
        margin-bottom: 20px;
        padding-left: 0;
    }

    .reserve-code {
        font-size: 12px;
        color: #999;
        margin-bottom: 8px;
    }

    .date {
        font-size: 15px;
        font-weight: 600;
        color: #333;
        margin-right: 10px;
    }

    .time {
        font-size: 14px;
        color: #666;
    }

    /* 상태 표시 */
    .state {
        display: inline-block;
        margin-top: 10px;
        font-size: 13px;
        font-weight: 600;
    }

    .state.done { color: #4dc3ff; }
    .state.canceled { color: #ff4444; }
    .state.visited { color: #28a745; }

    .payment-type.waiting {
        display: inline-block;
        margin-left: 10px;
        padding: 4px 12px;
        background-color: #fff3cd;
        color: #856404;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
    }

    .ticket-btn {
        margin-top: 10px;
        padding: 8px 20px;
        background-color: #333;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }

    .ticket-btn:hover { background-color: #4dc3ff; }

    /* 콘텐츠 정보 */
    .reserve-content {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 15px;
        padding: 15px 0;
        border-top: 1px solid #eee;
    }

    .reserve-content p {
        flex: 1;
        font-size: 16px;
        font-weight: 600;
        color: #333;
    }

    .reserve-content img {
        width: 80px;
        height: 80px;
        border-radius: 10px;
        object-fit: cover;
    }

    /* 하단 버튼 */
    .info-btn, .review-btn {
        padding: 10px 24px;
        border: 2px solid #ddd;
        background: white;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        margin-right: 8px;
        transition: all 0.2s;
    }

    .info-btn:hover { border-color: #4dc3ff; color: #4dc3ff; }
    .review-btn { background-color: #4dc3ff; border-color: #4dc3ff; color: white; }

    .paging { text-align: center; margin-top: 40px; font-size: 16px; color: #333; }
    .paging a { margin: 0 5px; text-decoration: none; color: #333; }

    @media (max-width : 768px) {
        .container { padding: 20px; }
        .reserve-content { flex-direction: column; align-items: flex-start; }
        .reserve-content img { width: 100%; height: 200px; }
    }
</style>
</head>
<body>
    <div class="container">
        <div class="content">
            <h1 class="page-title">예약 관리</h1>

            <div class="list-wrapper">
                <c:choose>
                    <c:when test="${empty reservationList}">
                        <div class="empty-box">예약 내역이 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="r" items="${reservationList}">
                            <div class="reserve-item">
                                <div class="badge">${r.dday}</div>

                                <div class="datetime">
                                    <p class="reserve-code">${r.reservation_code}</p>
                                    <span class="date">${r.reserved_for_at}</span> 
                                    <span class="time">${r.time_zone}</span>

                                    <c:choose>
                                        <c:when test="${r.reservation_status eq 'DONE'}">
                                            <p class="state done">예약 완료</p>
                                        </c:when>
                                        <c:when test="${r.reservation_status eq 'CANCELED'}">
                                            <p class="state canceled">예약 취소</p>
                                        </c:when>
                                        <c:when test="${r.reservation_status eq 'VISITED'}">
                                            <p class="state visited">이용 완료</p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="state">${r.reservation_status}</p>
                                        </c:otherwise>
                                    </c:choose>

                                    <c:if test="${r.payment_status eq 'WAITING_FOR_DEPOSIT'}">
                                        <p class="payment-type waiting">입금 대기</p>
                                    </c:if>

                                    <c:if test="${r.receive_type eq 'MOBILE'}">
                                        <button class="ticket-btn" data-reservation-id="${r.reservation_id}">모바일 티켓</button>
                                    </c:if>
                                </div>

                                <div class="reserve-content">
                                    <p>${r.title}</p>
                                    <img src="${r.main_image_path}" alt="포스터">
                                </div>

                                <button class="info-btn" data-reservation-id="${r.reservation_id}">예약정보</button>
                                <c:if test="${r.reservation_status eq 'VISITED'}">
                                    <button class="review-btn" data-reservation-id="${r.reservation_id}" data-content-id="${r.content_id}">리뷰쓰기</button>
                                </c:if>
                            </div>
                        </c:forEach>
                        <div class="paging">&lt;&lt; 1 2 3 4 5 &gt;&gt;</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        $(function() {
            $(".info-btn").click(function() {
                const reservation_id = $(this).data("reservation-id");
                window.location.href = "/gotoday/mypage/reservations/" + reservation_id;
            });

            $(".review-btn").click(function() {
                const reservation_id = $(this).data("reservation-id");
                const content_id = $(this).data("content-id");
                window.location.href = "/gotoday/review/write?reservation_id=" + reservation_id + "&content_id=" + content_id;
            });

            $(".ticket-btn").click(function() {
                const reservation_id = $(this).data("reservation-id");
                window.location.href = "/gotoday/ticket/" + reservation_id;
            });
        });
        
        
</script>

</body>
</html>