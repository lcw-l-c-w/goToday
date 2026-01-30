<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 관리 | GoToday</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage_like_list.css">
</head>
<body>
<h1 class="page-title">찜 관리</h1>
<div class="container">
	<div class="list-wrapper">
		<!-- 오늘 날짜 -->
		<jsp:useBean id="now" class="java.util.Date" />
		<fmt:parseNumber value="${now.time / (1000*60*60*24)}"
		                 integerOnly="true"
		                 var="nowDays" />
	<div class="items-container">
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
		<c:if test="${pi.totalPage > 0}">
        <div class="pagination">
            <c:if test="${pi.startPage > 1}">
                <a href="?page=${pi.startPage - 1}" class="page-btn prev">&lt;</a>
            </c:if>

            <c:forEach begin="${pi.startPage}" end="${pi.endPage}" var="p">
                <a href="?page=${p}" class="page-btn ${p == pi.page ? 'active' : ''}">${p}</a>
            </c:forEach>

            <c:if test="${pi.endPage < pi.totalPage}">
                <a href="?page=${pi.endPage + 1}" class="page-btn next">&gt;</a>
            </c:if>
        </div>
    </c:if>
	</div>
</div>
</body>
</html>