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
    :root { --main-color: #4dc3ff; --bg-gray: #f8f9fa; --text-gray: #666; }
    body { font-family: 'Pretendard', sans-serif; background-color: transparent; margin: 0; padding: 0; }
    
    .page-title { font-size: 32px; font-weight: 700; margin-bottom: 40px; color: #111; }

    /* 찜 목록 컨테이너 */
    .like-container { width: 100%; max-width: 800px; }

    /* 개별 카드 스타일 */
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

    .item-info { flex: 1; }
    
    /* 날짜 텍스트 (예: 12.3) */
    .date-text {
        font-size: 14px;
        color: #888;
        font-weight: 500;
        margin-bottom: 6px;
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
        margin-bottom: 12px;
    }
    
    .item-title {
        font-size: 19px;
        font-weight: 700;
        color: #333;
        margin-bottom: 15px;
        display: block;
        text-decoration: none;
    }

    /* 버튼 스타일 */
    .btn-group { display: flex; gap: 10px; }
    .btn-action {
        padding: 10px 20px;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        border: none;
        transition: 0.2s;
    }
    .btn-reserve { background: #e0e0e0; color: #333; }
    .btn-reserve:hover { background: #d0d0d0; }

    /* 포스터 이미지 영역 */
    .poster-img {
        width: 100px;
        height: 140px;
        background: #f0f0f0;
        border-radius: 12px;
        margin-left: 20px;
        object-fit: cover;
    }

    /* 데이터 없을 때 */
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
        <jsp:useBean id="now" class="java.util.Date" />
        <fmt:parseNumber value="${now.time / (1000*60*60*24)}" integerOnly="true" var="nowDays" />

        <c:choose>
            <c:when test="${not empty likeList}">
                <c:forEach var="item" items="${likeList}">
                    <div class="like-item">
					   <div class="item-info">
					    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 5px;">
					        <span class="date-badge" style="margin-bottom: 0;">
					            <c:choose>
					                <c:when test="${dDay > 0}">D-${dDay}</c:when>
					                <c:when test="${dDay == 0}">D-Day</c:when>
					                <c:otherwise>종료</c:otherwise>
					            </c:choose>
					        </span>
					        <a href="${pageContext.request.contextPath}/content/detail?id=${item.content_id}" 
					           class="item-title" style="margin-bottom: 0;">${item.title}</a>
					    </div>
					
					    <div style="font-size: 14px; color: #999; margin-bottom: 15px; font-weight: 500;">
					        <fmt:formatDate value="${item.start_at}" pattern="yyyy.MM.dd"/> ~ 
					        <fmt:formatDate value="${item.end_at}" pattern="yyyy.MM.dd"/>
					    </div>
					
					    <div class="btn-group">
					        <button type="button" class="btn-action btn-reserve">예약하러 가기</button>
					    </div>
					</div>

					<c:choose>
					    <c:when test="${not empty item.main_image_path}">
					        <img src="http://localhost:8081/gotoday${item.main_image_path}" 
					             class="poster-img" alt="포스터">
					    </c:when>
					    <c:otherwise>
					        <div class="poster-img" style="display:flex; align-items:center; justify-content:center; font-size:12px; color:#aaa;">
					            No Image
					        </div>
					    </c:otherwise>
					</c:choose>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-msg">
                    <p>찜한 내역이 없습니다.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>