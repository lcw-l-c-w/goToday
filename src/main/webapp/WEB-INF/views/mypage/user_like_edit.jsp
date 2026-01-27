<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관심사 수정 | GoToday</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage_user_like_edit.css">
<script>
$(document).ready(function() {
    $('#frm').on('submit', function(e) {
        const eventSelected = $('input[name="event"]:checked').length > 0;
        if(!eventSelected) {
            alert('전시 또는 팝업 중 하나를 선택해주세요.');
            e.preventDefault();
            return false;
        }
        alert('관심사가 성공적으로 수정되었습니다.');
    });
});
</script>
</head>
<body>
	<h1 class="page-title">관심사 수정</h1>
	
	<form id="frm" action="${pageContext.request.contextPath}/mypage/user_like_edit" method="POST" class="form-wrapper">
	    <div class="form-section">
	        <h2 class="section-title">전시 or 팝업</h2>
	        <div class="event-grid">
	            <label>
	                <input type="radio" name="event" value="exhibition" 
	                    <c:if test="${userTags.contains('exhibition')}">checked</c:if>>
	                <span class="btn-option">전시</span>
	            </label>
	            <label>
	                <input type="radio" name="event" value="popup" 
	                    <c:if test="${userTags.contains('popup')}">checked</c:if>>
	                <span class="btn-option">팝업</span>
	            </label>
	        </div>
	    </div>
	
	    <div class="form-section">
	        <h2 class="section-title">사람들이 많이가는 핫 플레이스!</h2>
	        <div class="location-grid">
	            <c:forEach var="loc" items="seongsu,hongdae,yeouido,gangnam,hyehwa,hannam">
	                <label>
	                    <input type="checkbox" name="location" value="${loc}" 
	                        <c:if test="${userTags.contains(loc)}">checked</c:if>>
	                    <span class="btn-option">
	                        <c:choose>
	                            <c:when test="${loc == 'seongsu'}">성수</c:when>
	                            <c:when test="${loc == 'hongdae'}">홍대</c:when>
	                            <c:when test="${loc == 'yeouido'}">여의도</c:when>
	                            <c:when test="${loc == 'gangnam'}">강남</c:when>
	                            <c:when test="${loc == 'hyehwa'}">혜화</c:when>
	                            <c:when test="${loc == 'hannam'}">한남</c:when>
	                        </c:choose>
	                    </span>
	                </label>
	            </c:forEach>
	        </div>
	    </div>
	
	    <div class="form-section">
	        <h2 class="section-title">관심있는 분야</h2>
	        <div class="interest-grid">
	            <!-- 첫 번째 줄: 4개 -->
	            <div class="interest-row">
	                <label>
	                    <input type="checkbox" name="interest" value="food" 
	                        <c:if test="${userTags.contains('food')}">checked</c:if>>
	                    <span class="btn-option">식품</span>
	                </label>
	                <label>
	                    <input type="checkbox" name="interest" value="character" 
	                        <c:if test="${userTags.contains('character')}">checked</c:if>>
	                    <span class="btn-option">캐릭터</span>
	                </label>
	                <label>
	                    <input type="checkbox" name="interest" value="cosmetics" 
	                        <c:if test="${userTags.contains('cosmetics')}">checked</c:if>>
	                    <span class="btn-option">화장품</span>
	                </label>
	                <label>
	                    <input type="checkbox" name="interest" value="media" 
	                        <c:if test="${userTags.contains('media')}">checked</c:if>>
	                    <span class="btn-option">미디어</span>
	                </label>
	            </div>
	            
	            <!-- 두 번째 줄: 3개 -->
	            <div class="interest-row">
	                <label>
	                    <input type="checkbox" name="interest" value="art" 
	                        <c:if test="${userTags.contains('art')}">checked</c:if>>
	                    <span class="btn-option">미술</span>
	                </label>
	                <label>
	                    <input type="checkbox" name="interest" value="fashion" 
	                        <c:if test="${userTags.contains('fashion')}">checked</c:if>>
	                    <span class="btn-option">패션</span>
	                </label>
	                <label>
	                    <input type="checkbox" name="interest" value="digitaltech" 
	                        <c:if test="${userTags.contains('digitaltech')}">checked</c:if>>
	                    <span class="btn-option">디지털/테크</span>
	                </label>
	            </div>
	            
	            <!-- 세 번째 줄: 2개 -->
	            <div class="interest-row">
	                <label>
	                    <input type="checkbox" name="interest" value="kidspets" 
	                        <c:if test="${userTags.contains('kidspets')}">checked</c:if>>
	                    <span class="btn-option">반려동물</span>
	                </label>
	                <label>
	                    <input type="checkbox" name="interest" value="etc" 
	                        <c:if test="${userTags.contains('etc')}">checked</c:if>>
	                    <span class="btn-option">etc</span>
	                </label>
	            </div>
	        </div>
	    </div>
	
		<div style="text-align: center;">
			<button type="submit" class="btn-submit">수정 완료</button>
		</div>
	</form>
</body>
</html>