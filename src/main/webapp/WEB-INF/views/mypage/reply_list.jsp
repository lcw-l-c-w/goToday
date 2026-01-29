<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="totalCount" value="${map.count}" />
<c:set var="totalPage" value="${(totalCount + 4) / 5}" />
<fmt:parseNumber var="totalPage" value="${totalPage}" integerOnly="true" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>My Q&amp;A | GoToday</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage_reply_list.css">
<script>
    function goView(replyId) {
        location.href = '${pageContext.request.contextPath}/mypage/reply_detail?reply_id=' + replyId;
    }

    function getComment(page) {
        location.href = "?page=" + page;
    }
</script>
</head>
<body>
    <h1 class="page-title">나의 Q&A</h1>

    <div class="inquiry-container">
        <div class="inquiry-header">
            <div class="total-count">
                <span><strong>총 ${map.count}개</strong> | ${vo.page}/${map.totalPage}페이지</span>
            </div>
        </div>

        <table class="inquiry-table">
            <thead>
                <tr>
                    <th width="10%">번호</th>
                    <th width="50%">제목</th>
                    <th width="20%">작성일</th>
                    <th width="20%">답변상태</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty map.list}">
                        <tr><td colspan="4" class="no-data">등록된 문의가 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${map.list}">
                            <tr>
                                <td>${item.reply_id}</td>
                                <td class="inquiry-title" onclick="goView(${item.reply_id})">${item.title}</td>
                                <td><fmt:formatDate value="${item.created_at}" pattern="yyyy-MM-dd"/></td>
                                <td>
                                    <span class="status-badge">
                                        <c:choose>
                                            <c:when test="${item.answer_count > 0}">
                                                <strong style="font-weight: 700;">답변 완료</strong>
                                            </c:when>
                                            <c:otherwise>답변 대기</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

	<div class="pagenate clear">
	    <ul class='paging'>
	        <%-- 이전 페이지 버튼 (<-): 현재 페이지가 1보다 크면 무조건 표시 --%>
	        <c:if test="${vo.page > 1}">
	            <li><a href="javascript:getComment(${vo.page - 1})">&lt;&lt;</a></li>
	        </c:if>
	
	        <%-- 페이지 번호 목록: 기존 map 변수 그대로 사용 --%>
	        <c:forEach var="p" begin="${map.startPage}" end="${map.endPage}">
	            <li>
	                <a href="javascript:getComment(${p});" 
	                   <c:if test="${vo.page == p}">class='current'</c:if>>${p}</a>
	            </li>
	        </c:forEach>
	
	        <%-- 다음 페이지 버튼 (->): 현재 페이지가 마지막 페이지보다 작으면 무조건 표시 --%>
	        <c:if test="${vo.page < map.totalPage}">
	            <li><a href="javascript:getComment(${vo.page + 1})">&gt;&gt;</a></li>
	        </c:if>
	    </ul>
	</div>
        
    </div>
</body>
</html>