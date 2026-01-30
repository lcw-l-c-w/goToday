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
<title>1:1 문의사항 | GoToday</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage_reply_list.css">
<script>
    function goView(creplyId) {
        location.href = '${pageContext.request.contextPath}/mypage/inquiry_detail?creply_id=' + creplyId;
    }

    function getComment(page) {
        location.href = "?page=" + page;
    }
</script>
</head>
<body>
    <h1 class="page-title">나의 1:1 문의</h1>

    <div class="inquiry-container">
		<div class="inquiry-header">
		    <div class="total-count">
		        <span><strong>총 ${totalCount}개</strong> | ${dto.page}/${totalPage == 0 ? 1 : totalPage}페이지</span>
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
                                <td>${item.creply_id}</td>
                                <td class="inquiry-title" onclick="goView(${item.creply_id})">${item.title}</td>
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
		<div class="fixed-footer">
			<div class="pagenate clear">
			    <ul class='paging'>
			        <c:if test="${dto.page > 1}">
			            <li><a href="javascript:getComment(${dto.page - 1})">&lt;&lt;</a></li>
			        </c:if>
			        <c:forEach var="p" begin="1" end="${totalPage == 0 ? 1 : totalPage}">
			            <li>
			                <a href="javascript:getComment(${p});" 
			                   <c:if test="${dto.page == p}">class='current'</c:if>>${p}</a>
			            </li>
			        </c:forEach>
			
			        <c:if test="${dto.page < totalPage}">
			            <li><a href="javascript:getComment(${dto.page + 1})">&gt;&gt;</a></li>
			        </c:if>
			    </ul>
			</div>
		</div>
    </div>
</body>
</html>