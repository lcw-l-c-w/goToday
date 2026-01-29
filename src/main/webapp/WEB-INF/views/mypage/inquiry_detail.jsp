<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>나의 1:1 문의 상세 | GoToday</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage_reply_detail.css">

</head>
<body>
    <h1 class="page-title">나의 1:1 문의</h1>
    
    <div class="detail-card">
        <div class="question-title">
            Q. ${detailList[0].title}
        </div>
        <div class="meta-info">
            <fmt:formatDate value="${detailList[0].created_at}" pattern="yyyy.MM.dd"/> | ${userName}
        </div>
        <div class="content-area">${detailList[0].body}</div>
    </div>

    <c:forEach var="item" items="${detailList}">
        <c:if test="${item.nested == 1}">
            <div class="detail-card" style="background-color: #f9f9f9;">
                <div class="answer-header">
                    <span class="answer-badge">답변 완료</span>
                    <span class="answer-title">관리자의 답변입니다.</span>
                    <div class="meta-info">
                        답변일: <fmt:formatDate value="${item.created_at}" pattern="yyyy.MM.dd"/>
                    </div>
                </div>
                <div class="content-area">${item.body}</div>
            </div>
        </c:if>
    </c:forEach>

    <div class="bottom-actions">
        <a href="${pageContext.request.contextPath}/detail/${detailList[0].content_id}" 
           target="_top" 
           class="btn-origin-view">
             원본 페이지로 이동
        </a>
    </div>
</body>
</html>
