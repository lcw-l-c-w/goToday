<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 관리 | GoToday</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    background: #f5f5f5;
    font-family: 'Pretendard', -apple-system, sans-serif;
}

.container {
    max-width: 900px;
    margin: 40px auto;
}

.page-title {
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 30px;
}

/* 카드 */
.reserve-item {
    background: #fff;
    border-radius: 16px;
    padding: 18px;
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    gap: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

/* 왼쪽 정보 */
.reserve-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.reserve-code {
    font-size: 13px;
    color: #888;
}

/* 제목 줄 */
.title-line {
    display: flex;
    align-items: center;
    gap: 8px;
}

.badge {
    padding: 4px 10px;
    border-radius: 14px;
    font-size: 12px;
    font-weight: 700;
    background: #e1f5fe;
    color: #03a9f4;
}

.title {
    font-size: 17px;
    font-weight: 700;
}

.datetime {
    font-size: 13px;
    color: #555;
}

/* 상태 */
.state-line {
    display: flex;
    gap: 10px;
    font-size: 14px;
}

.state.done { color: #4dc3ff; font-weight: 700; }
.state.canceled { color: #ff4444; font-weight: 700; }
.state.visited { color: #28a745; font-weight: 700; }

.payment.waiting {
    color: #ff9800;
    font-weight: 700;
}

/* 버튼 */
.btn-group {
    display: flex;
    gap: 8px;
    margin-top: auto;
}

.btn-group button {
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
}

.info-btn {
    background: #fff;
    border: 1px solid #ddd;
}

.ticket-btn {
    background: #333;
    color: #fff;
    border: none;
}

.review-btn {
    background: #4dc3ff;
    color: #fff;
    border: none;
}

/* 포스터 */
.poster img {
    width: 100px;
    height: 140px;
    border-radius: 12px;
    object-fit: cover;
}

/* 페이징 */
.paging {
    margin-top: 30px;
    text-align: center;
}

.paging a {
    display: inline-block;
    margin: 0 4px;
    padding: 6px 12px;
    border-radius: 6px;
    font-size: 14px;
    text-decoration: none;
    color: #333;
    border: 1px solid #ddd;
}

.paging a.active {
    background: #4dc3ff;
    color: #fff;
    border-color: #4dc3ff;
}
</style>
</head>

<body>
<div class="container">
    <h1 class="page-title">예약 관리</h1>

    <!-- ================= 페이징 계산 ================= -->
    <c:set var="page" value="${empty param.page ? 1 : param.page}" />
    <c:set var="page" value="${page + 0}" />

    <c:set var="contentPerPage" value="4" />
    <c:set var="pageBtnCount" value="5" />

    <c:set var="totalPage"
           value="${(totalCount + contentPerPage - 1) / contentPerPage}" />

    <c:set var="startPage" value="${page}" />
    <c:set var="endPage" value="${page + pageBtnCount - 1}" />

    <c:if test="${endPage > totalPage}">
        <c:set var="endPage" value="${totalPage}" />
    </c:if>

    <!-- ================= 리스트 ================= -->
    <c:forEach var="r" items="${reservationList}">
        <div class="reserve-item">

            <div class="reserve-info">
                <div class="reserve-code">${r.reservation_code}</div>

                <div class="title-line">
                    <span class="badge">${r.dday}</span>
                    <span class="title">${r.title}</span>
                </div>

                <div class="state-line">
                    <c:choose>
                        <c:when test="${r.reservation_status eq 'DONE'}">
                            <span class="state done">예약 완료</span>
                        </c:when>
                        <c:when test="${r.reservation_status eq 'CANCELED'}">
                            <span class="state canceled">예약 취소</span>
                        </c:when>
                        <c:when test="${r.reservation_status eq 'VISITED'}">
                            <span class="state visited">이용 완료</span>
                        </c:when>
                    </c:choose>

                    <c:if test="${r.payment_status eq 'WAITING_FOR_DEPOSIT'}">
                        <span class="payment waiting">입금대기</span>
                    </c:if>
                    
                    <span class="datetime">| ${r.reserved_for_at} ${r.time_zone}</span>
                </div>

                <div class="btn-group">
                    <button class="info-btn" data-id="${r.reservation_id}">예약정보</button>

                    <c:if test="${r.receive_type eq 'MOBILE'}">
                        <button class="ticket-btn" data-id="${r.reservation_id}">모바일 티켓</button>
                    </c:if>

                    <c:if test="${r.reservation_status eq 'VISITED'}">
                        <button class="review-btn"
                                data-id="${r.reservation_id}"
                                data-content="${r.content_id}">
                            리뷰쓰기
                        </button>
                    </c:if>
                </div>
            </div>

			<div class="poster">
			    <a href="${pageContext.request.contextPath}/detail/${r.content_id}" target="_top">
			        <img src="${pageContext.request.contextPath}${r.main_image_path}" alt="포스터">
			    </a>
			</div>
        </div>
    </c:forEach>

    <!-- ================= 페이징 UI ================= -->
    <div class="paging">
        <c:if test="${page > 1}">
            <a href="?page=${page - 1}">&lt;&lt;</a>
        </c:if>

        <c:forEach var="i" begin="${startPage}" end="${endPage}">
            <a href="?page=${i}" class="${i == page ? 'active' : ''}">
                ${i}
            </a>
        </c:forEach>

        <c:if test="${page < totalPage}">
            <a href="?page=${page + 1}">&gt;&gt;</a>
        </c:if>
    </div>
</div>

<script>
$(function() {
    $(".info-btn").click(function() {
        location.href = "/gotoday/mypage/reservations/" + $(this).data("id");
    });

    $(".ticket-btn").click(function() {
        location.href = "/gotoday/ticket/" + $(this).data("id");
    });

    $(".review-btn").click(function() {
        location.href = "/gotoday/review/write?reservation_id="
            + $(this).data("id")
            + "&content_id=" + $(this).data("content");
    });
});
</script>
</body>
</html>
