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
        --dark-gray: #222;
        --text-gray: #666;
        --light-bg: #f8f9fa;
        --border-color: #eee;
        --danger-color: #ff4d4d;
    }

    body {
        font-family: 'Pretendard', -apple-system, sans-serif;
        background-color: #fff;
        color: var(--dark-gray);
        margin: 0; padding: 0;
        line-height: 1.6;
    }

    .container {
        max-width: 800px;
        margin: 50px auto;
        padding: 0 20px;
    }

    /* 헤더 섹션 */
    .view-header {
        border-bottom: 2px solid var(--dark-gray);
        padding-bottom: 20px;
        margin-bottom: 30px;
    }

    .view-header h1 {
        font-size: 26px;
        font-weight: 700;
        margin: 0 0 15px 0;
        color: #111;
    }

    .view-meta {
        display: flex;
        align-items: center;
        color: #999;
        font-size: 14px;
        gap: 15px;
    }

    /* 본문 영역 */
    .content-box {
        padding: 20px 0 10px; /* 하단 패딩 조절 */
        min-height: 200px;
        font-size: 16px;
        color: #333;
        border-bottom: 1px solid var(--border-color);
        position: relative;
    }

    .attached-photo img {
        max-width: 100%;
        border-radius: 12px;
        margin-top: 20px;
    }

    .update-date {
        margin-top: 40px; /* 본문과 간격 확보 */
        margin-bottom: 10px;
        font-size: 13px;
        color: #bbb;
        text-align: right;
        font-style: italic;
    }

    /* 관리자 답변 섹션 */
    .admin-section {
        margin-top: 40px;
        background-color: var(--light-bg);
        border-radius: 12px;
        padding: 30px;
        border: 1px solid #f0f0f0;
    }

    .admin-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
        padding-bottom: 15px;
        border-bottom: 1px solid #eef0f2;
    }

    .admin-title {
        font-weight: 700;
        font-size: 15px;
        color: var(--main-color);
    }

    .admin-date { font-size: 13px; color: #aaa; }

    /* 버튼 그룹 레이아웃 */
    .btn-group {
        margin-top: 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 10px 22px;
        border-radius: 6px;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        transition: 0.2s ease;
        cursor: pointer;
        border: none;
    }

    /* 왼쪽 목록 버튼 */
    .btn-list { background: #f1f1f1; color: #666; }
    .btn-list:hover { background: #e5e5e5; }

    /* 오른쪽 버튼들 공통 */
    .right-btns { display: flex; gap: 8px; }
    
    .btn-action { 
        background-color: #fff; 
        border: 1px solid #ddd; 
        color: #555; 
    }
    
    .btn-action:hover { 
        border-color: var(--main-color); 
        color: var(--main-color); 
        background-color: #f9fdff;
    }

    /* 삭제/위험 버튼 커스텀 */
    .btn-danger:hover { 
        border-color: var(--danger-color) !important; 
        color: var(--danger-color) !important; 
        background-color: #fff5f5 !important;
    }

    /* 답변 등록용 강조 버튼 */
    .btn-primary {
        background-color: var(--main-color);
        color: white;
    }
    .btn-primary:hover {
        background-color: #3db2f0;
    }
</style>

    <script>
    function del(creply_id, content_id,gno,vendor_id) {
    	if (confirm('이 문의사항을 정말 삭제하시겠습니까?')) {
            // jQuery의 $.post(주소, 보낼데이터, 성공시실행할함수)
            $.post('${ctx}/detail/tab/inquiry/delete', {
                creply_id: creply_id,
                content_id: content_id,
                gno:gno,
                vendor_id:vendor_id
            }, function(res) {
                // 삭제 후 처리는 컨트롤러의 리턴 방식에 따라 달라집니다.
                // 만약 컨트롤러가 알림창을 띄우는 common/return 페이지를 준다면, 
                // 아래처럼 바로 리다이렉트 주소를 지정하는 게 속 편합니다.
                alert("삭제되었습니다.");
                location.href = "${ctx}/detail/" + content_id + "?tab=inquiry";
            });
        }
    }
  
    </script>
</head> 
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="container">
        <header class="view-header">
            <h1>${vo.title}</h1>
            <div class="view-meta">
                <span>작성자: ${vo.writer}</span>
                <span>작성일: 
                <c:if test="${not empty vo.created_at}">
            <fmt:parseDate value="${vo.created_at}" var="parsedDate" pattern="yyyy-MM-dd HH:mm:ss"/>
            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/>
        </c:if>
                </span>   </div>
        </header>

        <div class="content-box" style="white-space: pre-wrap;">${vo.body}
        <c:if test="${not empty vo.file_path}">
        <div class="attached-photo" style="margin-top:20px;">
            <img src="${pageContext.request.contextPath}${vo.file_path}" 
                 style="max-width:100%; border-radius:8px; border:1px solid #eee;">
        </div>
    </c:if>
    <c:if test="${not empty vo.update_at}">
    <div class="update-date" style="margin-top:20px; font-size: 13px; color: #999; text-align: right;">
        <fmt:parseDate value="${vo.update_at}" var="parsedUpdateDate" pattern="yyyy-MM-dd HH:mm:ss"/>
        해당 글은 <fmt:formatDate value="${parsedUpdateDate}" pattern="yyyy-MM-dd HH:mm"/>에 수정되었습니다.
    </div>
    </c:if>
    </div>

        <c:if test="${not empty vendorList}">
            <div class="admin-section">
                <div class="admin-header">
                    <div class="admin-title">
                        <span></span> 담당자 답변
                    </div>
                    <div class="admin-date">
                        <c:if test="${not empty vendorList.created_at}">
            <fmt:parseDate value="${vendorList.created_at}" var="parsedDate" pattern="yyyy-MM-dd HH:mm:ss"/>
            <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm"/>
        </c:if>
                    </div>
                </div>
                <div class="admin-content" style="white-space: pre-wrap;">${vendorList.body}</div>
				<c:if test="${not empty vendorList.file_path}">
        		<div class="attached-photo" style="margin-top:20px;">
            	<img src="${pageContext.request.contextPath}${vendorList.file_path}" 
                 style="max-width:100%; border-radius:8px; border:1px solid #eee;">
       			 </div>
    		</c:if>            
            </div>
        </c:if>

 <div class="btn-group">
    <div class="left-btns">
        <a href="${ctx}/detail/${vo.content_id}?tab=inquiry" class="btn btn-list">목록으로</a>
    </div>
    
    <div class="right-btns">
        <%-- 1. 유저 본인인 경우: 수정 & 삭제 --%>
        <c:if test="${not empty loginSess and loginSess.user_id == vo.user_id}">
            <a href="${ctx}/detail/inquiry/modify?creply_id=${vo.creply_id}" class="btn btn-action">수정하기</a>
            <a href="javascript:del(${vo.creply_id}, ${vo.content_id}, ${vo.gno});" class="btn btn-action btn-danger">삭제하기</a>
        </c:if>
        
        <%-- 2. 관리자(Vendor)인 경우 --%>
        <c:if test="${loginSess.role == 1 and loginSess.user_id == vo.vendor_id}">
            <c:choose>
                <%-- 답변 등록 --%>
                <c:when test="${empty vendorList}">
                    <a href="${ctx}/detail/inquiry/write/vendor.do?creply_id=${vo.creply_id}" class="btn btn-primary">답변 등록</a>
                </c:when>
                <%-- 답변 수정 & 삭제 --%>
                <c:otherwise>
                    <a href="${ctx}/detail/inquiry/modify?creply_id=${vendorList.creply_id}" class="btn btn-action">답변 수정</a>
                    <a href="javascript:del(${vendorList.creply_id}, ${vo.content_id}, ${vendorList.gno},${vendorList.vendor_id});" class="btn btn-action btn-danger">답변 삭제</a>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>
</div>
            </div>
        </div>
    
</body> 
</html>