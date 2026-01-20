<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>예약 관리 | GoToday</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Pretendard', -apple-system, sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }

        .container {
            display: flex;
            gap: 60px;
            padding: 60px 8%;
            max-width: 1400px;
            margin: 0 auto;
        }

        .content {
            flex: 1;
        }

        .page-title {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 40px;
        }

        .list-wrapper {
            max-width: 800px;
        }

        .empty-box {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 20px;
            color: #999;
            font-size: 16px;
        }

        .reserve-item {
            background: white;
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
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
        }

        .badge:contains("END") {
            background-color: #ff6b35;
        }

        .badge:contains("D-") {
            background-color: #4dc3ff;
        }

        .badge:contains("CANCEL") {
            background-color: #ff4444;
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

        .state.done {
            color: #4dc3ff;
        }

        .state.canceled {
            color: #ff4444;
        }

        .state.visited {
            color: #28a745;
        }

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

        .ticket-btn:hover {
            background-color: #4dc3ff;
        }

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

        /* 버튼 영역 */
        .info-btn,
        .review-btn {
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

        .info-btn:hover {
            border-color: #4dc3ff;
            color: #4dc3ff;
        }

        .review-btn {
            background-color: #4dc3ff;
            border-color: #4dc3ff;
            color: white;
        }

        .review-btn:hover {
            background-color: #3ab3ef;
        }

        /* 페이징 */
        .paging {
            text-align: center;
            margin-top: 40px;
            font-size: 16px;
            color: #333;
        }

        .paging a {
            margin: 0 5px;
            text-decoration: none;
            color: #333;
        }

        .paging a:hover {
            color: #4dc3ff;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }

            .reserve-item {
                padding: 20px;
            }

            .reserve-content {
                flex-direction: column;
                align-items: flex-start;
            }

            .reserve-content img {
                width: 100%;
                height: 200px;
            }
        }
    </style>
</head>
<body>
            <h1 class="page-title">예약 관리</h1>

            <div class="list-wrapper">
                <c:choose>
                    <c:when test="${empty reservationList}">
                        <div class="empty-box">
                            예약 내역이 없습니다.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="r" items="${reservationList}">
                            <div class="reserve-item">
                                <!-- badge: D-Day / END / CANCEL -->
                                <div class="badge">
                                    ${r.dday}
                                </div>
                                
                                <!-- 예약 정보 + 날짜 + 상태 -->
                                <div class="datetime">
                                    <p class="reserve-code">${r.reservation_code}</p>
                                
                                    <span class="date">${r.reserved_for_at}</span>
                                    <span class="time">${r.time_zone}</span>
                                
                                    <!-- 예약 상태 -->
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
                                
                                    <!-- 결제 상태: 입금 대기만 노출 -->
                                    <c:if test="${r.payment_status eq 'WAITING_FOR_DEPOSIT'}">
                                        <p class="payment-type waiting">입금 대기</p>
                                    </c:if>
                                
                                    <!-- 수령 방식: MOBILE일 때만 버튼 -->
                                    <c:if test="${r.receive_type eq 'MOBILE'}">
                                        <button class="ticket-btn" data-reservation-id="${r.reservation_id}">
                                            모바일 티켓
                                        </button>
                                    </c:if>
                                
                                    <input type="hidden" name="reservation_id" value="${r.reservation_id}">
                                </div>
                                
                                <!-- 콘텐츠 정보 -->
                                <div class="reserve-content">
                                    <p>${r.title}</p>
                                    <img src="${r.main_image_path}" alt="포스터">
                                </div>
                                
                                <!-- 버튼 -->
                                <button class="info-btn" data-reservation-id="${r.reservation_id}">예약정보</button>
                                
                                <c:if test="${r.reservation_status eq 'VISITED'}">
                                    <button class="review-btn" 
                                        data-reservation-id="${r.reservation_id}"
                                        data-content-id="${r.content_id}">
                                        리뷰쓰기
                                    </button>
                                </c:if>
                            </div>
                        </c:forEach>

                        <!-- 페이징 -->
                        <div class="paging">
                            &lt;&lt; 1 2 3 4 5 &gt;&gt;
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>


    <script>
        $(function() {
            $(".info-btn").click(function () {
                const reservation_id = $(this).data("reservation-id");
                window.location.href = "/gotoday/mypage/reservations/" + reservation_id;
            });
            
            $(".review-btn").click(function () {
                const reservation_id = $(this).data("reservation-id");
                const content_id = $(this).data("content-id");
                window.location.href = "/gotoday/review/write?reservation_id="+reservation_id+"&content_id="+content_id;
            });

            $(".ticket-btn").click(function() {
                const reservation_id = $(this).data("reservation-id");
                // 모바일 티켓 표시 로직
                alert("모바일 티켓 표시 - 예약ID: " + reservation_id);
            });
        });
    </script>
</body>
</html>