<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<style>
.review-summary-box {
    display: flex;
    align-items: center; /* 세로 중앙 정렬 */
    gap: 40px;
    margin: 20px 0;
    padding: 20px;
    background: #fcfcfc; /* 배경을 살짝 넣어 구분감 주기 */
    border-radius: 8px;
}

.summary-left {
    width: 120px; /* 너비 축소 */
    text-align: center;
    border-right: 1px solid #eee; /* 중간 구분선 추가 */
    padding-right: 20px;
}

.avg-score {
    font-size: 28px; /* 36px -> 28px로 축소 */
    font-weight: 800;
    color: #333;
}

.avg-score .max {
    font-size: 14px;
    color: #bbb;
}

.total-count {
    font-size: 13px;
    color: #888;
    margin-top: 4px;
}

/* 중간 막대바 영역 */
.summary-middle {
    flex: 1.5; /* 막대바 영역 비중 확대 */
}

.rating-row {
    display: flex;
    align-items: center;
	gap: 10px;
    margin: 4px 0;
}

.star-label {
    width: 70px;
    font-size: 14px;
    color: #ffc107;
    white-space: nowrap;
}

.bar-bg {
    flex: 1; 
    height: 10px;
    background: #f0f0f0;
    border-radius: 5px;
    overflow: hidden;
    position: relative;
}

.bar-fill {
	height: 100%;
    background: #4dc3ff;
    border-radius: 5px;
    transition: width 0.3s ease
}

.cnt-label {
	width: 35px;
    font-size: 12px;
    color: #888;
    text-align: right;
}

.summary-right {
    flex: 1;
    padding-left: 20px;
    border-left: 1px solid #eee;
}

.time-title {
    font-weight: 700;
    margin-bottom: 10px;
}

.time-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 4px 0;
}

.review-divider {
    margin: 25px 0;
    border: none;
    border-top: 1px solid #eee;
}

/* 리뷰 아이템 */
.review-item {
    border-bottom: 1px solid #eee;
    padding: 20px 0;
}

.review-header {
    display: flex;
    justify-content: space-between;
}

.review-user-name {
    font-weight: 700;
}

.review-timezone {
    font-size: 13px;
    color: #888;
}

.review-rating .star {
    color: #ddd;
}

.review-rating .star.filled {
    color: #ffc107;
}

.review-body {
    margin: 10px 0;
}

.review-images img {
    max-width: 120px;
    border-radius: 6px;
    margin-top: 8px;
}

.review-footer {
    font-size: 12px;
    color: #888;
}

.load-more-btn {
    display: block;
    margin: 30px auto;
    padding: 10px 24px;
    border: 1px solid #333;
    background: #fff;
    border-radius: 20px;
    cursor: pointer;
}

</style>

<div class="review-summary-box">
    <div class="summary-left">
        <div class="avg-score">
            <span class="score">${ratingSummary.avgRating}</span>
            <span class="max"> / 5</span>
        </div>
        <div class="total-count">
            총 ${ratingSummary.totalReviews}개 리뷰
        </div>
    </div>

    <div class="summary-middle">
        <div id="ratingBars">
        	<c:forEach var="i" begin="1" end="5" step="1">
            <c:set var="star" value="${6 - i}" /> <c:set var="count" value="${star == 5 ? ratingSummary.rating_5 : (star == 4 ? ratingSummary.rating_4 : (star == 3 ? ratingSummary.rating_3 : (star == 2 ? ratingSummary.rating_2 : ratingSummary.rating_1)))}" />
            <c:set var="percent" value="${ratingSummary.totalReviews > 0 ? (count / ratingSummary.totalReviews) * 100 : 0}" />
            
            <div class="rating-row">
                <div class="star-label">
                    <c:forEach begin="1" end="${star}"><span style="color: #ffc107;">★</span></c:forEach>
                </div>
                <div class="bar-bg">
                    <div class="bar-fill" style="width: ${percent}%;"></div>
                </div>
                <div class="cnt-label">${count}개</div>
            </div>
        </c:forEach>
        </div>
    </div>

    <div class="summary-right">
        <div class="time-title">시간대별 평점</div>
        <div id="timeZoneSummary">
        	<c:forEach var="entry" items="${avgRatingByTimeZone}">
            <c:if test="${entry.key ne 'always'}"> <div class="time-row">
                    <span>
                        <c:choose>
                            <c:when test="${entry.key eq 'MORNING'}">9:00 - 12:00</c:when>
                            <c:when test="${entry.key eq 'LAUNCH'}">12:00 - 15:00</c:when>
                            <c:when test="${entry.key eq 'AFTERNOON'}">15:00 - 18:00</c:when>
                            <c:when test="${entry.key eq 'EVENING'}">18:00 - 21:00</c:when>
                            <c:otherwise>${entry.key}</c:otherwise>
                        </c:choose>
                    </span>
                    <span style="color: #ffc107;">
                        <c:forEach begin="1" end="5" var="starIdx">
                            ${starIdx <= entry.value ? '★' : '☆'}
                        </c:forEach>
                        <span style="color:#333; font-weight:bold; margin-left:5px;">${entry.value}</span>
                    </span>
                </div>
            </c:if>
        </c:forEach>
        </div>
    </div>
</div>

<hr class="review-divider">

<div id="reviewList">
    <c:forEach var="r" items="${reviewList}">
        <div class="review-item">
            <div class="review-header">
                <div class="review-user">
                    <span class="review-user-name">${r.maskedEmail}</span>
                    <span class="review-timezone">· ${r.visited_time_zone}</span>
                </div>

                <div class="review-rating">
                    <c:forEach begin="1" end="5" var="i">
                        <span class="star ${i <= r.rating ? 'filled' : ''}">★</span>
                    </c:forEach>
                </div>
            </div>

            <div class="review-body">
                <div class="review-content">${r.content}</div>

                <c:if test="${not empty r.image_new}">
                    <div class="review-images">
                        <img src="${pageContext.request.contextPath}/uploads/${r.image_new}">
                    </div>
                </c:if>
            </div>

            <div class="review-footer">
                ${r.visited_at}
            </div>
        </div>
    </c:forEach>
</div>

<div id="reviewList">
    <c:forEach var="r" items="${reviewList}" varStatus="status" end="4">
        <div class="review-item"> ... </div>
    </c:forEach>
</div>

<script>
const ratingSummary = {
	totalReviews: ${ratingSummary.totalReviews},
    avgRating: ${ratingSummary.avgRating},
    rating5: ${ratingSummary.rating_5},
    rating4: ${ratingSummary.rating_4},
    rating3: ${ratingSummary.rating_3},
    rating2: ${ratingSummary.rating_2},
    rating1: ${ratingSummary.rating_1}
};

const timeZoneSummary = ${avgRatingByTimeZone};
const contentId = ${content.content_id};

let currentPage = 1;
let currentSortType = "latest";
</script>
