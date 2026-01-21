<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관심사 입력 | GoToday</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
    <%@ include file="register.css" %>
</style>
<script>
function goSave() {
	$("#frm").submit();
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="container">
	    <div class="tab-nav">
	        <div class="tab-item">정보 입력</div>
	        <div class="tab-item active">관심사 입력</div>
	        <div class="tab-item">가입 완료</div>
	    </div>
    
    	<div class="form-container">
			 <form id="frm" action="/gotoday/member/register2" method="POST">
			    
			    <div class="interest-section">
				    <h3>전시 or 팝업</h3>
				    <div class="tag-group">
					    <input type="radio" name="event" id="exhibition" value="exhibition">
                		<label for="exhibition" class="tag-label">전시</label>
					    
					    <input type="radio" name="event" id="popup" value="popup">
                		<label for="popup" class="tag-label">팝업</label>
					</div>
				</div>
				
				<div class="interest-section">
					<h3>핫플레이스</h3>
					<div class="tag-group">
					    <input type="checkbox" name="location" id="seongsu" value="seongsu">
		                <label for="seongsu" class="tag-label">성수</label>
		                
		                <input type="checkbox" name="location" id="hongdae" value="hongdae">
		                <label for="hongdae" class="tag-label">홍대</label>
		                
		                <input type="checkbox" name="location" id="yeouido" value="yeouido">
		                <label for="yeouido" class="tag-label">여의도</label>
		                
		                <input type="checkbox" name="location" id="gangnam" value="gangnam">
		                <label for="gangnam" class="tag-label">강남</label>
		                
		                <input type="checkbox" name="location" id="hyehwa" value="hyehwa">
		                <label for="hyehwa" class="tag-label">혜화</label>
		                
		                <input type="checkbox" name="location" id="hannam" value="hannam">
		                <label for="hannam" class="tag-label">한남</label>
					</div>
				</div>
				    				
				 <div class="interest-section">
				    <h3>관심 분야</h3>
				    <div class="tag-group">
		                <input type="checkbox" name="interest" id="food" value="food">
		                <label for="food" class="tag-label">식품</label>
		                
		                <input type="checkbox" name="interest" id="character" value="character">
		                <label for="character" class="tag-label">캐릭터</label>
		                
		                <input type="checkbox" name="interest" id="cosmetics" value="cosmetics">
		                <label for="cosmetics" class="tag-label">화장품</label>
		                
		                <input type="checkbox" name="interest" id="media" value="media">
		                <label for="media" class="tag-label">미디어</label>
		                
		                <input type="checkbox" name="interest" id="art" value="art">
		                <label for="art" class="tag-label">미술</label>
		                
		                <input type="checkbox" name="interest" id="fashion" value="fashion">
		                <label for="fashion" class="tag-label">패션</label>
		                
		                <input type="checkbox" name="interest" id="digitaltech" value="digitaltech">
		                <label for="digitaltech" class="tag-label">디지털/테크</label>
		                
		                <input type="checkbox" name="interest" id="kidspets" value="kidspets">
		                <label for="kidspets" class="tag-label">키즈/반려동물</label>
		                
		                <input type="checkbox" name="interest" id="etc" value="etc">
		                <label for="etc" class="tag-label">etc</label>
		            </div>
            	</div>
				<br>
				<div class="next-btn-container">
					<a href="javascript:;" class="next-btn" onclick="goSave();">다음단계</a>
				</div>
      		</form>
			</div>
		</div>
</body>
</html>