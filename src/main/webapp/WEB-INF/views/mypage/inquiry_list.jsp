<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>My Q&amp;A | GoToday</title>
<style>
    /* ===== 전체 배경 및 기본 설정 ===== */
    body {
        font-family: 'Pretendard', -apple-system, sans-serif;
        background-color: transparent;
        margin: 0;
        padding: 0;
        overflow-x: hidden;
        color: #333;
    }

    .page-title { 
        font-size: 28px; 
        font-weight: 700; 
        margin-bottom: 30px; 
        color: #111;
    }
    
    /* ===== 리스트 컨테이너 ===== */
    .inquiry-container {
        background: #fff; 
        border-radius: 20px; 
        padding: 40px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.05); 
        width: 100%; 
        max-width: none;
        margin: 0 auto;
        box-sizing: border-box;
    }
    
    .inquiry-header { 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        margin-bottom: 25px; 
    }
    
    .total-count { 
        font-size: 16px; 
        color: #666; 
    }
    
    /* ===== 테이블 스타일 ===== */
    .inquiry-table { 
        width: 100%; 
        border-collapse: collapse; 
        margin-bottom: 30px; 
    }
    
    .inquiry-table th { 
        background: #f8f9fa; 
        padding: 15px; 
        text-align: center; 
        border-bottom: 2px solid #eee; 
        font-weight: 600;
    }
    
    .inquiry-table td { 
        padding: 15px; 
        text-align: center; 
        border-bottom: 1px solid #eee; 
    }
    
    .inquiry-title { 
        text-align: left; 
        cursor: pointer; 
        color: #333; 
    }
    
    .inquiry-title:hover { 
        text-decoration: underline; 
    }
    
    /* 답변상태 스타일 */
    .status-badge { 
        font-size: 14px; 
        color: #000; 
    }

    /* ===== 페이지 처리 (요청하신 스타일 통합) ===== */
    .pagenate { 
        display: flex; 
        justify-content: center; 
        margin-top: 30px; 
    }

    .paging { 
        list-style: none; 
        display: flex; 
        padding: 0; 
        gap: 8px; 
        align-items: center;
    }

    .paging li a { 
        display: block; 
        padding: 6px 12px; 
        border: 1px solid #ddd; 
        color: #666; 
        text-decoration: none; 
        font-size: 14px; 
        border-radius: 4px; 
        transition: 0.2s;
    }

    /* 현재 페이지 스타일 */
    .paging li a.current { 
        background-color: #333; 
        color: #fff; 
        border-color: #333; 
        font-weight: bold; 
    }

    .paging li a:hover:not(.current) { 
        background-color: #eee; 
    }
    
    .no-data { 
        text-align: center; 
        padding: 60px; 
        color: #999; 
    }
</style>

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

    <h1 class="page-title">나의 1:1 문의사항</h1>

    <div class="inquiry-container">
        <div class="inquiry-header">
            <div class="total-count">
                <span><strong>총 ${map.count}개</strong> | ${vo.page}/${map.totalPage}페이지</span>
            </div>
        </div>

        <table class="inquiry-table">
            <thead>
                <tr>
                    <th width="8%">번호</th>
                    <th width="52%">제목</th>
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