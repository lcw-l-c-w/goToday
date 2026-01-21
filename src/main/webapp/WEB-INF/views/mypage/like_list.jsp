<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 관리 | GoToday</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<style>
:root {
    --main-color: #4dc3ff;
    --bg-gray: #f8f9fa;
    --text-gray: #666;
}

body {
    font-family: 'Pretendard', sans-serif;
    background-color: transparent;
    margin: 0;
    padding: 0;
}

.page-title {
    font-size: 32px;
    font-weight: 700;
    margin-bottom: 40px;
    color: #111;
}

/* 컨테이너 */
.like-container {
    width: 100%;
    max-width: 800px;
}

/* 카드 */
.like-item {
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

.item-info {
    flex: 1;
}

/* D-day 배지 */
.date-badge {
    display: inline-block;
    padding: 4px 12px;
    background: #e1f5fe;
    color: #03a9f4;
    border-radius: 50px;
    font-size: 13px;
    font-weight: 700;
}

/* 제목 */
.item-title {
    font-size: 19px;
    font-weight: 700;
    color: #333;
    text-decoration: none;
}

/* 버튼 */
.btn-group {
    display: flex;
    gap: 10px;
}

.btn-action {
    padding: 10px 20px;
    border-radius: 12px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    border: none;
}

.btn-reserve {
    background: #e0e0e0;
    color: #333;
}

.btn-reserve:hover {
    background: #d0d0d0;
}

/* 이미지 */
.poster-img {
    width: 100px;
    height: 140px;
    background: #f0f0f0;
    border-radius: 12px;
    margin-left: 20px;
    object-fit: cover;
}

/* empty */
.empty-msg {
    text-align: center;
    padding: 100px 0;
    background: #fff;
    border-radius: 20px;
    color: var(--text-gray);
    font-size: 16px;
}
</style>
</head>

<body>

<h1 class="page-title">찜 관리</h1>

<div class="like-container">

    <!-- 오늘 날짜 -->
    <jsp:useBean id="now" class="java.util.Date" />
    <fmt:parseNumber value="${now.time / (1000*60*60*24)}"
                     integerOnly="true"
                     var="nowDays" />

    <c:choose>
        <c:when test="${not empty likeList}">
            <c:forEach var="item" items="${likeList}">

                <!-- 종료일 기준 D-day 계산 -->
                <fmt:parseNumber value="${item.end_at.time / (1000*60*60*24)}"
                                 integerOnly="true"
                                 var="endDays" />
                <c:set var="dDay" value="${endDays - nowDays}" />

                <div class="like-item">
                    <div class="item-info">

                        <!-- D-day + 제목 -->
                        <div style="display:flex; align-items:center; gap:10px; margin-bottom:6px;">
                            <span class="date-badge">
                                <c:choose>
                                    <c:when test="${dDay > 0}">D-${dDay}</c:when>
                                    <c:when test="${dDay == 0}">D-Day</c:when>
                                    <c:otherwise>종료</c:otherwise>
                                </c:choose>
                            </span>

							<a href="${pageContext.request.contextPath}/detail/${item.content_id}"
							   class="item-title" 
							   target="_top">
							    ${item.title}
							</a>
                        </div>

                        <!-- 기간 -->
                        <div style="font-size:14px; color:#999; margin-bottom:15px; font-weight:500;">
                            <fmt:formatDate value="${item.start_at}" pattern="yyyy.MM.dd"/>
                            ~
                            <fmt:formatDate value="${item.end_at}" pattern="yyyy.MM.dd"/>
                        </div>

                        <!-- 버튼 -->
                        <div class="btn-group">
                            <button type="button"
                                    class="btn-action btn-reserve"
                                    onclick="top.location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
                                예약하러 가기
                            </button>
                        </div>
                    </div>

                    <!-- 포스터 -->
                    <c:choose>
                        <c:when test="${not empty item.main_image_path}">
                            <a href="${pageContext.request.contextPath}/detail/${item.content_id}" target="_top">
							    <img src="${pageContext.request.contextPath}${item.main_image_path}"
							         class="poster-img"
							         alt="포스터">
							</a>
                        </c:when>
                        <c:otherwise>
                            <div class="poster-img"
                                 style="display:flex; align-items:center; justify-content:center; font-size:12px; color:#aaa;">
                                No Image
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </c:forEach>
        </c:when>

        <c:otherwise>
            <div class="empty-msg">
                찜한 내역이 없습니다.
            </div>
        </c:otherwise>
    </c:choose>

</div>
</body>
</html>
