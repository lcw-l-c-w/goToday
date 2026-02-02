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
<link rel="stylesheet" href="${ctx}/css/inquiry_view.css">

    <script>
    function del(creply_id, content_id, gno, vendor_id) {
        if (confirm('이 문의사항을 정말 삭제하시겠습니까?')) {
            // 전송할 데이터를 객체로 명확히 생성
            const dataToSend = {
                creply_id: creply_id,
                content_id: content_id,
                gno: gno
            };

            // vendor_id가 파라미터로 넘어왔고 값이 있을 때만 추가
            if (vendor_id !== undefined && vendor_id !== null) {
                dataToSend.vendor_id = vendor_id;
            }

            $.post('${ctx}/detail/tab/inquiry/delete', dataToSend, function(res) {
                alert("삭제되었습니다.");
                location.href = "${ctx}/detail/" + content_id + "?tab=inquiry";
            }).fail(function(xhr) {
                console.log("Error Detail:", xhr.responseText);
                alert("삭제 실패: " + xhr.status);
            });
        }
    }
  
    </script>
</head> 
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="container">
        <header class="view-header">
        <div class="title-area">
    <%-- 비밀글 아이콘 --%>
    <c:if test="${vo.secret == 1}">
        <span class="secret-lock" title="비밀글">🔒</span>
    </c:if>

    <%-- 제목 --%>
    <h1>${vo.title}</h1>
</div>
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
            <a href="javascript:del(${vo.creply_id}, ${vo.content_id}, ${vo.gno},null);" class="btn btn-action btn-danger">삭제하기</a>
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