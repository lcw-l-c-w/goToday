<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>나의 Q&A 상세 | GoToday</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage_reply_detail.css">
</head>
<body>
<h1 class="page-title">나의 Q&A</h1>
    <div class="page-header">
        <button type="button" class="btn-back" onclick="history.back();" title="목록으로">
            &lt;
        </button>
    </div>
<div class="page-wrap">

    <div class="detail-card">
        <div class="question-title">
            Q. ${reply.title}
        </div>
        <div class="meta-info">
            <fmt:formatDate value="${reply.created_at}" pattern="yyyy.MM.dd"/> | ${userName}
        </div>
        <div class="content-area">${reply.body}</div>
    </div>

	<c:if test="${not empty answer}">
	        <div class="detail-card" style="background-color: #f9f9f9;">
	            <div class="answer-header" style="display: block; border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 20px;">
	                <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
	                    <span class="answer-badge">답변 완료</span>
	                    <span class="answer-title">관리자의 답변입니다.</span>
	                </div>
	                <div class="meta-info" style="margin-bottom: 0;">
	                    답변일 : <fmt:formatDate value="${answer.created_at}" pattern="yyyy.MM.dd"/>
	                </div>
	            </div>
	
	            <div class="content-area">${answer.body}</div>
	        </div>
	    </c:if>

		<div class="bottom-actions">
		    <a href="${pageContext.request.contextPath}/reply/view.do?reply_id=${reply.reply_id}" 
		       target="_top" 
		       class="btn-origin-view">
		        원본 페이지로 이동
		    </a>
		</div>
		    
</div>
</body>
</html>