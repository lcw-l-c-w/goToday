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
        --text-gray: #666;
        --light-bg: #f9f9f9;
        --border-color: #eee;
        --danger-color: #e74c3c;
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
        padding-bottom: 25px;
        margin-bottom: 30px;
    }

    .view-header h1 {
        font-size: 28px;
        font-weight: 700;
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
        color: #444;
    }

    /* 관리자 답변 섹션 */
    .admin-section {
        margin-top: 30px;
        border: 1px solid var(--border-color);
        background-color: #fcfcfc;
        border-radius: 8px;
        overflow: hidden;
    }

    .admin-header {
        padding: 15px 20px;
        background-color: #f4f4f4;
        border-bottom: 1px solid var(--border-color);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .admin-title {
        font-weight: 700;
        color: var(--dark-gray);
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .admin-title::before {
        content: 'A.';
        color: var(--main-color);
        font-size: 18px;
    }

    .admin-content {
        padding: 25px 20px;
        font-size: 15px;
        color: #333;
        line-height: 1.7;
    }

 /* 하단 버튼 그룹 레이아웃 */
.btn-group {
    margin-top: 50px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

/* 왼쪽 [목록으로] 버튼 전용 */
.btn-list { 
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 12px 25px;
    border-radius: 6px;
    text-decoration: none;
    font-weight: 600;
    font-size: 14px;
    background: #eee; 
    color: #666; 
    transition: 0.3s;
}
.btn-list:hover { background: #ddd; }

/* 오른쪽 [수정/삭제/등록] 버튼들 통일 */
.right-btns {
    display: flex;
    gap: 10px;
}

.right-btns .btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 12px 25px;
    border-radius: 6px;
    text-decoration: none;
    font-weight: 600;
    font-size: 14px;
    transition: all 0.3s ease;
    cursor: pointer;
    border: none;
    
    /* 기본 상태: 회색 */
    background-color: #eee !important;
    color: #666 !important;
}

/* 우측 버튼들만 호버 시 하늘색 */
.right-btns .btn:hover {
    background-color: var(--main-color) !important; /* #4dc3ff */
    color: #fff !important;
}
 
</style>

    <script>
    function del(creply_id, content_id,gno) {
    	if (confirm('이 문의사항을 정말 삭제하시겠습니까?')) {
            // jQuery의 $.post(주소, 보낼데이터, 성공시실행할함수)
            $.post('${ctx}/detail/tab/inquiry/delete', {
                creply_id: creply_id,
                content_id: content_id,
                gno:gno
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
            </div>
        </c:if>

        <div class="btn-group">
            <div class="left-btns">
                <a href="${ctx}/detail/${vo.content_id}?tab=inquiry" class="btn btn-list" >목록으로</a>
            </div>
            
            <div class="right-btns">
         
           
    <%-- 1. 유저 본인인 경우: 질문글 수정 & 삭제 --%>
    <c:if test="${not empty loginSess and loginSess.user_id == vo.user_id and not empty vo.creply_id}">
        <a href="${ctx}/detail/inquiry/modify?creply_id=${vo.creply_id}" class="btn">수정하기</a>
        <a href="javascript:del(${vo.creply_id}, ${vo.content_id}, ${vo.gno});" class="btn">삭제하기</a>
    </c:if>
    
    <%-- 2. 관리자(Vendor)인 경우 --%>
    <c:if test="${loginSess.role == 1 and loginSess.user_id == vo.vendor_id and not empty vo.creply_id}">
        <c:choose>
            <%-- 답변이 아직 없는 경우: '답변 등록' --%>
            <c:when test="${empty vendorList}">
                <a href="${ctx}/detail/inquiry/write/vendor.do?creply_id=${vo.creply_id}" class="btn">답변 등록</a>
            </c:when>
            <%-- 답변이 이미 있는 경우: '답변 수정' --%>
            <c:otherwise>
                <a href="${ctx}/detail/inquiry/modify?creply_id=${vendorList.creply_id}" class="btn">답변 수정</a>
         		 
         		 <a class="btn" href="javascript:del(${vo.creply_id}, ${vo.content_id}, ${vo.gno});">답변 삭제</a>
            </c:otherwise>
        </c:choose>
        
    </c:if>
</div>
            </div>
        </div>
    </div>
</body> 
</html>