<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 관리 | GoToday</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
:root { --main-color: #4dc3ff; --bg-gray: #f8f9fa; --text-gray: #666; }
    body { font-family: 'Pretendard', sans-serif; background-color: transparent; margin: 0; padding: 0; }
    
    .page-title { font-size: 32px; font-weight: 700; margin-bottom: 40px; color: #111; }

    /* 리스트 컨테이너 */
    .reserve-container { width: 100%; max-width: 800px; }

    /* 개별 카드 스타일 (찜 관리 스타일 계승) */
    .reserve-item {
        background: #fff;
        border-radius: 20px;
        padding: 25px 30px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        border: 1px solid #eee;
    }

    .item-info { flex: 1; }

    /* 예약 번호 */
    .reserve-code {
        font-size: 13px;
        color: #999;
        margin-bottom: 8px;
        display: block;
    }
    
    /* 배지 & 제목 한 줄 */
    .item-header { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }

    .date-badge {
        display: inline-block;
        padding: 4px 12px;
        background: #e1f5fe;
        color: #03a9f4;
        border-radius: 50px;
        font-size: 13px;
        font-weight: 700;
    }
    /* 종료/취소 시 배지 색상 변경 */
    .date-badge.end { background: #eee; color: #888; }
    .date-badge.cancel { background: #ffebee; color: #ff4444; }

    .item-title {
        font-size: 19px;
        font-weight: 700;
        color: #333;
        text-decoration: none;
    }

    /* 예약 상세 날짜 및 상태 */
    .item-detail {
        font-size: 14px;
        color: #666;
        margin-bottom: 15px;
        line-height: 1.6;
    }

    .status-text { font-weight: 700; margin-left: 10px; }
    .status-done { color: #4dc3ff; }
    .status-cancel { color: #ff4444; }
    .status-visited { color: #28a745; }

    /* 버튼 스타일 */
    .btn-group { display: flex; gap: 8px; }
    .btn-action {
        padding: 8px 18px;
        border-radius: 10px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        border: 1px solid #ddd;
        background: #fff;
        transition: 0.2s;
    }
    .btn-action:hover { background: #f8f9fa; border-color: var(--main-color); color: var(--main-color); }
    .btn-main { background: var(--main-color); color: #fff; border: none; }
    .btn-main:hover { background: #3ab3ef; color: #fff; }

    /* 포스터 이미지 */
    .poster-img {
        width: 100px;
        height: 130px;
        background: #f0f0f0;
        border-radius: 12px;
        margin-left: 20px;
        object-fit: cover;
    }

    /* 페이징 */
    .paging { text-align: center; margin-top: 40px; padding-bottom: 40px; }
    .paging a { margin: 0 8px; text-decoration: none; color: #999; font-weight: 600; }
    .paging a.active { color: var(--main-color); text-decoration: underline; }

    .empty-msg {
        text-align: center;
        padding: 100px 0;
        background: #fff;
        border-radius: 20px;
        color: var(--text-gray);
    }
</style>
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
</head>
<body>
    <h1 class="page-title">예약 관리</h1>

    <div class="reserve-container">
        <c:choose>
            <c:when test="${not empty reservationList}">
                <c:forEach var="r" items="${reservationList}">
                    <div class="reserve-item">
                        <div class="item-info">
                            <span class="reserve-code">예약번호 ${r.reservation_code}</span>
                            
                            <div class="item-header">
                                <span class="date-badge ${r.reservation_status eq 'CANCELED' ? 'cancel' : (r.dday eq 'END' ? 'end' : '')}">
                                    ${r.dday}
                                </span>
                                <span class="item-title">${r.title}</span>
                            </div>

                            <div class="item-detail">
                                <span>${r.reserved_for_at} (${r.time_zone})</span>
                                <c:choose>
                                    <c:when test="${r.reservation_status eq 'DONE'}">
                                        <span class="status-text status-done">예약 완료</span>
                                    </c:when>
                                    <c:when test="${r.reservation_status eq 'CANCELED'}">
                                        <span class="status-text status-cancel">예약 취소</span>
                                    </c:when>
                                    <c:when test="${r.reservation_status eq 'VISITED'}">
                                        <span class="status-text status-visited">이용 완료</span>
                                    </c:when>
                                </c:choose>
                            </div>

                            <div class="btn-group">
                                <button type="button" class="btn-action" onclick="location.href='/gotoday/mypage/reservations/${r.reservation_id}'">예약정보</button>
                                
                                <c:if test="${r.receive_type eq 'MOBILE' && r.reservation_status ne 'CANCELED'}">
                                    <button type="button" class="btn-action btn-main" onclick="alert('티켓 발권 시스템 준비 중')">모바일 티켓</button>
                                </c:if>

                                <c:if test="${r.reservation_status eq 'VISITED'}">
                                    <button type="button" class="btn-action btn-main" 
                                            onclick="location.href='/gotoday/review/write?reservation_id=${r.reservation_id}&content_id=${r.content_id}'">
                                        리뷰 쓰기
                                    </button>
                                </c:if>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${not empty r.main_image_path}">
                                <img src="http://localhost:8081/gotoday${r.main_image_path}" class="poster-img" alt="포스터">
                            </c:when>
                            <c:otherwise>
                                <div class="poster-img" style="display:flex; align-items:center; justify-content:center; font-size:12px; color:#aaa;">No Image</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>

                <div class="paging">
                    <a href="#">&lt;</a>
                    <a href="#" class="active">1</a>
                    <a href="#">2</a>
                    <a href="#">3</a>
                    <a href="#">&gt;</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-msg">
                    <p>예약 내역이 없습니다.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>

