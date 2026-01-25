<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head> 
    <meta charset="utf-8">
    <title>GoToday | 문의 상세</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"> 
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    
    <style>
        :root {
            --main-color: #4dc3ff;
            --dark-gray: #333;
            --light-bg: #f9f9f9;
            --border-color: #eee;
            --admin-bg: #f0faff;
        }

        body {
            font-family: 'Pretendard', sans-serif;
            background-color: #fff;
            color: var(--dark-gray);
            margin: 0; padding: 0;
            line-height: 1.6;
        }

        .container {
            max-width: 900px;
            margin: 60px auto;
            padding: 0 20px;
        }

        /* 헤더 섹션 */
        .view-header {
            border-bottom: 2px solid var(--dark-gray);
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .view-header .category {
            color: var(--main-color);
            font-weight: 700;
            font-size: 14px;
            text-transform: uppercase;
            margin-bottom: 8px;
            display: block;
        }

        .view-header h1 {
            font-size: 26px;
            margin: 0 0 15px 0;
            letter-spacing: -1px;
        }

        .view-meta {
            display: flex;
            color: #888;
            font-size: 14px;
            gap: 20px;
        }

        /* 본문 영역 */
        .content-box {
            padding: 40px 10px;
            min-height: 200px;
            font-size: 16px;
            border-bottom: 1px solid var(--border-color);
        }

        /* 관리자 답변 영역 */
        .admin-section {
            margin-top: 30px;
            background-color: var(--admin-bg);
            border-radius: 12px;
            padding: 30px;
            border-left: 4px solid var(--main-color);
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            padding-bottom: 10px;
        }

        .admin-title {
            font-weight: 700;
            font-size: 18px;
            color: #2b7fc2;
        }

        .admin-date {
            font-size: 13px;
            color: #888;
        }

        /* 하단 버튼 영역 */
        .btn-group {
            margin-top: 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn {
            display: inline-block;
            padding: 12px 25px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: 0.3s;
            cursor: pointer;
            border: none;
        }

        .btn-list { background: #eee; color: #555; }
        .btn-list:hover { background: #ddd; }

        .btn-delete { background: #ffeded; color: #e74c3c; margin-left: 8px; }
        .btn-delete:hover { background: #ffdada; }

        .btn-reply { background: var(--dark-gray); color: #fff; }
        .btn-reply:hover { background: #555; }
    </style>

    <script>
    function del() {
        if (confirm('이 문의사항을 정말 삭제하시겠습니까?')) {
            location.href='delete.do?reply_id=${vo.reply_id}';
        }
    }
    </script>
</head> 
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="container">
        <header class="view-header">
            <span class="category">Question #${vo.reply_id}</span>
            <h1>${vo.title}</h1>
            <div class="view-meta">
                <span>작성자: ${vo.writer}</span>
                <span>작성일: <fmt:formatDate value="${vo.created_at}" pattern="yyyy-MM-dd HH:mm"/></span>
            </div>
        </header>

        <div class="content-box" style="white-space: pre-wrap;">${vo.body}</div>

        <c:if test="${not empty adminReply}">
            <div class="admin-section">
                <div class="admin-header">
                    <div class="admin-title">
                        <span>💡</span> 담당자 답변
                    </div>
                    <div class="admin-date">
                        <fmt:formatDate value="${adminReply.created_at}" pattern="yyyy-MM-dd HH:mm"/>
                    </div>
                </div>
                <div class="admin-content" style="white-space: pre-wrap;">${adminReply.body}</div>
            </div>
        </c:if>

        <div class="btn-group">
            <div class="left-btns">
                <a href="index.do" class="btn btn-list">목록으로</a>
            </div>
            
            <div class="right-btns">
                <%-- 본인인 경우에만 삭제 버튼 노출 --%>
                <c:if test="${!empty login and login.user_id == vo.writer}">
                    <a href="javascript:del();" class="btn btn-delete">삭제하기</a>
                </c:if>
                
                <%-- 관리자(벤더)이고 아직 답변이 없을 때만 답변 버튼 노출 --%>
                <c:if test="${Admin and empty adminReply}">
                    <a href="reply.do?reply_id=${vo.reply_id}" class="btn btn-reply">답변 등록</a>
                </c:if>
            </div>
        </div>
    </div>
</body> 
</html>