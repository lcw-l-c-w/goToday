<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                <c:if test="${map.isPrev == true}">
                    <li><a href="javascript:getComment(${map.startPage-1})">&lt;-</a></li>
                </c:if>

                <c:forEach var="p" begin="${map.startPage}" end="${map.endPage}">
                    <li>
                        <a href="javascript:getComment(${p});" 
                           <c:if test="${vo.page == p}">class='current'</c:if>>${p}</a>
                    </li>
                </c:forEach>

                <c:if test="${map.isNext == true}">
                    <li><a href="javascript:getComment(${map.endPage+1})">-&gt;</a></li>
                </c:if>
            </ul>
        </div>
        
    </div>
</body>
</html>