<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 리뷰 | GoToday</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { background: #ffffff; font-family: 'Pretendard', -apple-system, sans-serif; }
.container { max-width: 900px; margin: 40px auto; }
.page-title { font-size: 28px; font-weight: 700; margin-bottom: 30px; }

.review-item {
    background: #ffffff;
    border-radius: 20px;
    padding: 22px 26px;
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    gap: 20px;
    border: 1px solid #eee;
    box-shadow: 0 4px 15px rgba(0,0,0,0.06);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.review-item:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 22px rgba(77,195,255,0.18);
}

.review-info { flex: 1; display: flex; flex-direction: column; gap: 8px; }
.review-date { font-size: 13px; color: #888; }

.title-line { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.title { font-size: 17px; font-weight: 700; }

.star-rating {
    color: #ffcc00;
    font-size: 14px;
    letter-spacing: 1px;
}
.star-rating .empty { color: #ddd; }

.review-content {
    font-size: 14px;
    color: #555;
    line-height: 1.6;
    margin-top: 5px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.visit-info { font-size: 12px; color: #888; margin-top: 5px; }

.btn-group { display: flex; gap: 8px; margin-top: auto; }
.btn-group button {
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
}

.edit-btn {
    background: white;
    border: 1px solid #4dc3ff;
    color: #4dc3ff;
}
.edit-btn:hover {
    background: #4dc3ff;
    color: white;
}

.delete-btn {
    background: white;
    border: 1px solid #ff4444;
    color: #ff4444;
}
.delete-btn:hover {
    background: #ff4444;
    color: white;
}

.poster img {
    width: 100px;
    height: 140px;
    border-radius: 12px;
    object-fit: cover;
}

.empty-box {
    text-align: center;
    padding: 60px 20px;
    color: #888;
    font-size: 16px;
    background: #f9f9f9;
    border-radius: 20px;
}

.review-image {
    margin-top: 10px;
}
.review-image img {
    max-width: 120px;
    max-height: 80px;
    border-radius: 8px;
    object-fit: cover;
}
</style>
</head>

<body>
<div class="container">
    <h1 class="page-title">나의 리뷰</h1>

    <div class="list-wrapper">
        <c:choose>
            <c:when test="${empty reviewList}">
                <div class="empty-box">작성한 리뷰가 없습니다.</div>
            </c:when>

            <c:otherwise>
                <c:forEach var="r" items="${reviewList}">
                    <div class="review-item">
                        <div class="review-info">
                            <div class="review-date">
                                <fmt:formatDate value="${r.created_at}" pattern="yyyy.MM.dd"/>
                            </div>

                            <div class="title-line">
                                <span class="title">${r.title}</span>
                                <span class="star-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= r.rating}">★</c:when>
                                            <c:otherwise><span class="empty">★</span></c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </span>
                            </div>

                            <div class="review-content">${r.content}</div>

                            <c:if test="${not empty r.image_new}">
                                <div class="review-image">
                                    <img src="/gotoday/uploads/${r.image_new}" alt="리뷰 이미지">
                                </div>
                            </c:if>

                            <div class="visit-info">
                                방문일: ${r.visited_at}
                                <c:if test="${not empty r.visited_time_zone}">
                                    (${r.visited_time_zone})
                                </c:if>
                            </div>

                            <div class="btn-group">
                                <button class="edit-btn" data-reservation-id="${r.reservation_id}">
                                    수정
                                </button>
                                <button class="delete-btn" data-review-id="${r.review_id}">
                                    삭제
                                </button>
                            </div>
                        </div>

                        <div class="poster">
                            <a href="${pageContext.request.contextPath}/detail/${r.content_id}" target="_top">
                                <img src="${pageContext.request.contextPath}${r.main_image_path}" alt="포스터">
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/review/write.jsp" />
<script src="/gotoday/resources/js/review/write.js"></script>

<script>
$(function() {
    // 수정 버튼 클릭
    $(".edit-btn").click(function() {
        const resId = $(this).data("reservation-id");

        $.ajax({
            url: "/gotoday/review/getData",
            type: "GET",
            data: { reservation_id: resId },
            success: function(data) {
                openReviewModal(data);
            },
            error: function() {
                alert("데이터를 불러오는데 실패했습니다.");
            }
        });
    });

    // 삭제 버튼 클릭
    $(".delete-btn").click(function() {
        if (!confirm("정말로 리뷰를 삭제하시겠습니까?")) {
            return;
        }

        const reviewId = $(this).data("review-id");

        $.ajax({
            url: "/gotoday/review/delete.do",
            type: "POST",
            data: { review_id: reviewId },
            success: function(res) {
                if (res.success) {
                    alert("리뷰가 삭제되었습니다.");
                    location.reload();
                } else {
                    alert(res.message || "리뷰 삭제에 실패했습니다.");
                }
            },
            error: function() {
                alert("서버 오류가 발생했습니다.");
            }
        });
    });
});
</script>
</body>
</html>
