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
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage_review_list.css">
</head>
<body>
<h1 class="page-title">나의 리뷰</h1>
<div class="container">
    <div class="list-wrapper">
        <c:choose>
            <c:when test="${empty reviewList}">
                <div class="empty-box">작성한 리뷰가 없습니다.</div>
            </c:when>

            <c:otherwise>
                <c:forEach var="r" items="${reviewList}">
                    <div class="review-item">
                        <div class="review-left">
                            <div class="review-header">
                                <span class="review-date"><fmt:formatDate value="${r.created_at}" pattern="yyyy.MM.dd"/> 작성</span>
                                <span class="visit-info">| 방문일: ${r.visited_at}<c:if test="${not empty r.visited_time_zone}"> (${r.visited_time_zone})</c:if></span>
                            </div>
                            <div class="title-line">
                                <a href="${pageContext.request.contextPath}/detail/${r.content_id}" target="_top">
                                    <span class="title">${r.title}</span>
                                </a>
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
                        </div>
                        <c:if test="${not empty r.image_new}">
                            <div class="review-image">
                                <img src="${pageContext.request.contextPath}/upload/${r.image_new}" alt="리뷰 이미지"/>
                            </div>
                        </c:if>
                        <div class="btn-group">
                            <button class="edit-btn" data-reservation-id="${r.reservation_id}">수정</button>
                            <button class="delete-btn" data-review-id="${r.review_id}">삭제</button>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/review/write.jsp" />
<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/resources/js/review/write.js"></script>

<script>
$(function() {
    // 수정 버튼 클릭
    $(".edit-btn").click(function() {
        const resId = $(this).data("reservation-id");

        $.ajax({
            url: "${pageContext.request.contextPath}/review/getData",
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
            url: "${pageContext.request.contextPath}/review/delete.do",
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
