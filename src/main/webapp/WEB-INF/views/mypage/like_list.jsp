<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 관리 | GoToday</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { background: #ffffff; font-family: 'Pretendard', -apple-system, sans-serif; }
.container { max-width: 900px; margin: 40px auto; }
.page-title { font-size: 28px; font-weight: 700; margin-bottom: 30px; }

.like-item {
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

.like-item:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 22px rgba(77,195,255,0.18);
}

.item-info { flex: 1; display: flex; flex-direction: column; gap: 8px; }

.title-line { display: flex; align-items: center; gap: 8px; }
.badge {
	padding: 4px 10px;
	border-radius: 14px;
	font-size: 12px;
	font-weight: 700;
	background: #e1f5fe;
	color: #03a9f4;
}

.badge.dday {
	background: #fff9c4;
	color: #f57f17;
}
.badge.end {
	background: #f5f5f5;
	color: #666;
}

.title { 
    font-size: 17px; 
    font-weight: 700; 
    color: #333;
    text-decoration: none;
}

.title:hover {
    color: #4dc3ff;
}

.period { font-size: 13px; color: #555; }

.btn-group { display: flex; gap: 8px; margin-top: auto; }
.btn-group button {
	padding: 8px 16px;
	border-radius: 8px;
	font-size: 13px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s ease;
}

.reserve-btn {
    background: white;
    border: 1px solid #4dc3ff;
    color: #4dc3ff;
}
.reserve-btn:hover {
    background: #4dc3ff;
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
    padding: 100px 0;
    background: #fff;
    border-radius: 20px;
    color: #666;
    font-size: 16px;
}
</style>
</head>

<body>
<div class="container">
	<h1 class="page-title">찜 관리</h1>

	<div class="list-wrapper">
		<!-- 오늘 날짜 -->
		<jsp:useBean id="now" class="java.util.Date" />
		<fmt:parseNumber value="${now.time / (1000*60*60*24)}"
		                 integerOnly="true"
		                 var="nowDays" />

		<c:choose>
			<c:when test="${empty likeList}">
				<div class="empty-box">찜한 내역이 없습니다.</div>
			</c:when>

			<c:otherwise>
				<c:forEach var="item" items="${likeList}">
					<!-- 종료일 기준 D-day 계산 -->
					<fmt:parseNumber value="${item.end_at.time / (1000*60*60*24)}"
					                 integerOnly="true"
					                 var="endDays" />
					<c:set var="dDay" value="${endDays - nowDays}" />

					<div class="like-item">
						<div class="item-info">
							<div class="title-line">
								<c:choose>
									<c:when test="${dDay == 0}">
										<span class="badge dday">D-Day</span>
									</c:when>
									<c:when test="${dDay < 0}">
										<span class="badge end">종료</span>
									</c:when>
									<c:otherwise>
										<span class="badge">D-${dDay}</span>
									</c:otherwise>
								</c:choose>

								<a href="${pageContext.request.contextPath}/detail/${item.content_id}"
								   class="title"
								   target="_top">
									${item.title}
								</a>
							</div>

							<div class="period">
								<fmt:formatDate value="${item.start_at}" pattern="yyyy.MM.dd"/>
								~
								<fmt:formatDate value="${item.end_at}" pattern="yyyy.MM.dd"/>
							</div>

							<div class="btn-group">
								<button type="button"
								        class="reserve-btn"
								        onclick="top.location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
									예약하러 가기
								</button>
							</div>
						</div>

						<div class="poster">
							<c:choose>
								<c:when test="${not empty item.main_image_path}">
									<a href="${pageContext.request.contextPath}/detail/${item.content_id}" target="_top">
										<img src="${pageContext.request.contextPath}${item.main_image_path}" alt="포스터">
									</a>
								</c:when>
								<c:otherwise>
									<div style="width:100px; height:140px; border-radius:12px; background:#f0f0f0; display:flex; align-items:center; justify-content:center; font-size:12px; color:#aaa;">
										No Image
									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</body>
</html>