<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관심사 수정 | GoToday</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

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

<style>
	 :root { --main-color: #4dc3ff; --color-button-inactive: #d9d9d9; }
	 body { font-family: 'Pretendard', sans-serif; background-color: transparent; margin: 0; padding: 0; }
	 
	 /* 공통 제목 스타일 */
	 .page-title { font-size: 28px; font-weight: 700; margin-bottom: 30px; }
	
	 /* 공통 흰색 박스 스타일 */
	 .form-wrapper { 
	     width: 100%; max-width: 700px; background: #fff; padding: 40px; 
	     border-radius: 20px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); 
	 }
	
	 .form-section { margin-bottom: 35px; }
	 .section-title { font-size: 18px; font-weight: 700; margin-bottom: 20px; text-align: center; }
	 .button-grid { display: flex; flex-wrap: wrap; gap: 15px; justify-content: center; }
	 
	 input[type="radio"], input[type="checkbox"] { display: none; }
	 .btn-option {
	     padding: 10px 24px; border-radius: 50px; background: var(--color-button-inactive);
	     cursor: pointer; font-weight: 600; font-size: 14px; transition: 0.2s;
	 }
	 input:checked + .btn-option { background: var(--main-color); color: white; }
	 
	 /* 전시/팝업 섹션 - 2개 가로 배치 */
	 .event-grid { display: flex; gap: 20px; justify-content: center; }
	 
	 /* 핫플레이스 섹션 - 3-3 배치 */
	 .location-grid {
	     display: grid;
	     grid-template-columns: repeat(3, auto);
	     gap: 18px;
	     row-gap: 22px;
	     justify-content: center;
	     max-width: 500px;
	     margin: 0 auto;
	 }
	 
	 /* 관심분야 섹션 - 4-3-2 배치 */
	 .interest-grid {
	     display: flex;
	     flex-direction: column;
	     gap: 22px;
	     align-items: center;
	 }
	 .interest-row { display: flex; gap: 25px; justify-content: center; }
	 
   	 .btn-submit {
	     width: 100%; max-width: 300px; padding: 15px; background: #333; color: #fff;
	     border: none; border-radius: 12px; font-weight: 700; cursor: pointer; margin-top: 10px;
	 }
	 .btn-submit:hover { background: #000; }
</style>
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
	        <h2 class="section-title">사람들이 많이가는 핫 플레이스</h2>
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