<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>나의 Q&A 상세 | GoToday</title>

<style>
    /* ===== 전체 배경 ===== */
    body {
        font-family: 'Pretendard', -apple-system, sans-serif;
        margin: 0;
        background: #f5f6f8;
        color: #333;
    }

    /* ===== 페이지 래퍼 ===== */
    .page-wrap {
        max-width: 800px; /* 가로폭을 살짝 줄여 가독성 향상 */
        margin: 40px auto 80px;
        padding: 0 20px;
        box-sizing: border-box;
    }

    /* ===== 상단 헤더 (수정됨) ===== */
    .page-header {
        display: flex;
        justify-content: space-between; /* 양 끝 배치 */
        align-items: center;
        margin-bottom: 30px;
    }

    .page-title { 
        font-size: 32px; 
        font-weight: 700; 
        color: #111;
        margin: 0;
    }

    /* 우측 끝 동그란 < 버튼 (수정됨) */
    .btn-back {
        width: 36px;
        height: 36px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 50%;
        cursor: pointer;
        transition: 0.2s;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        color: #333;
        font-weight: 700;
        font-size: 18px;
        line-height: 1;
        padding-right: 2px; /* < 모양 중앙 보정 */
    }
    .btn-back:hover {
        background-color: #eee;
        transform: scale(1.1);
    }

    /* ===== 공통 카드 스타일 (질문/답변 분리) ===== */
    .detail-card {
        background: #ffffff;
        border-radius: 20px;
        padding: 30px 40px;
        box-shadow: 0 4px 16px rgba(0,0,0,0.04);
        margin-bottom: 24px; /* 카드 간 간격 */
    }

    /* 질문 제목 */
    .question-title {
        font-size: 20px;
        font-weight: 700;
        margin-bottom: 10px;
        color: #000;
    }

    /* 답변 타이틀 */
    .answer-header {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 15px;
        padding-bottom: 15px;
        border-bottom: 1px solid #f0f0f0;
    }

    .answer-badge {
        background: #333;
        color: #fff;
        padding: 4px 10px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
    }

    .answer-title {
        font-size: 18px;
        font-weight: 700;
    }

    /* 메타 정보 */
    .meta-info {
        font-size: 14px;
        color: #888;
        margin-bottom: 20px;
    }

    /* 본문 영역 */
    .content-area {
        padding: 10px 0;
        min-height: 100px;
        white-space: pre-wrap;
        font-size: 16px;
        line-height: 1.8;
    }

	/* 하단 버튼 영역 - 오른쪽 배치 */
	.bottom-actions {
	    margin-top: 30px;
	    display: flex;
	    justify-content: flex-end; /* 오른쪽 정렬 */
	}
	
	.btn-origin-view {
	    display: inline-block;
	    padding: 12px 25px;
	    background-color: #333; /* answer-badge와 동일한 색상 */
	    color: #fff;
	    text-decoration: none;
	    font-size: 15px;
	    font-weight: 600;
	    border-radius: 8px;
	    transition: all 0.3s ease; /* 부드러운 전환 효과 */
	    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
	    border: none;
	    cursor: pointer;
	}
	
	/* 호버 효과 추가 */
	.btn-origin-view:hover {
	    background-color: #000; /* 더 진한 검정 */
	    transform: translateY(-2px); /* 살짝 위로 이동 */
	    box-shadow: 0 6px 12px rgba(0,0,0,0.2); /* 그림자 강화 */
	    color: #fff;
	}
    
</style>
</head>

<body>

<div class="page-wrap">

    <div class="page-header">
        <h1 class="page-title">나의 Q&A</h1>
        <button type="button" class="btn-back" onclick="history.back();" title="목록으로">
            &lt;
        </button>
    </div>

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