<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관심사 입력 | GoToday</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_register.css">
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
				    <div class="event-grid">
					    <label>
					        <input type="radio" name="event" id="exhibition" value="exhibition">
	                		<span class="tag-label">전시</span>
					    </label>
					    <label>
					        <input type="radio" name="event" id="popup" value="popup">
	                		<span class="tag-label">팝업</span>
					    </label>
					</div>
				</div>
				
				<div class="interest-section">
					<h3>사람들이 많이가는 핫 플레이스</h3>
					<div class="location-grid">
					    <label>
					        <input type="checkbox" name="location" id="seongsu" value="seongsu">
		                	<span class="tag-label">성수</span>
					    </label>
					    <label>
		                	<input type="checkbox" name="location" id="hongdae" value="hongdae">
		                	<span class="tag-label">홍대</span>
					    </label>
					    <label>
		                	<input type="checkbox" name="location" id="yeouido" value="yeouido">
		                	<span class="tag-label">여의도</span>
					    </label>
					    <label>
		                	<input type="checkbox" name="location" id="gangnam" value="gangnam">
		                	<span class="tag-label">강남</span>
					    </label>
					    <label>
		                	<input type="checkbox" name="location" id="hyehwa" value="hyehwa">
		                	<span class="tag-label">혜화</span>
					    </label>
					    <label>
		                	<input type="checkbox" name="location" id="hannam" value="hannam">
		                	<span class="tag-label">한남</span>
					    </label>
					</div>
				</div>
				    				
				 <div class="interest-section">
				    <h3>관심있는 분야</h3>
				    <div class="interest-grid">
				        <!-- 첫 번째 줄: 4개 -->
				        <div class="interest-row">
				            <label>
				                <input type="checkbox" name="interest" id="food" value="food">
				                <span class="tag-label">식품</span>
				            </label>
				            <label>
				                <input type="checkbox" name="interest" id="character" value="character">
				                <span class="tag-label">캐릭터</span>
				            </label>
				            <label>
				                <input type="checkbox" name="interest" id="cosmetics" value="cosmetics">
				                <span class="tag-label">화장품</span>
				            </label>
				            <label>
				                <input type="checkbox" name="interest" id="media" value="media">
				                <span class="tag-label">미디어</span>
				            </label>
				        </div>
				        
				        <!-- 두 번째 줄: 3개 -->
				        <div class="interest-row">
				            <label>
				                <input type="checkbox" name="interest" id="art" value="art">
				                <span class="tag-label">미술</span>
				            </label>
				            <label>
				                <input type="checkbox" name="interest" id="fashion" value="fashion">
				                <span class="tag-label">패션</span>
				            </label>
				            <label>
				                <input type="checkbox" name="interest" id="digitaltech" value="digitaltech">
				                <span class="tag-label">디지털/테크</span>
				            </label>
				        </div>
				        
				        <!-- 세 번째 줄: 2개 -->
				        <div class="interest-row">
				            <label>
				                <input type="checkbox" name="interest" id="kidspets" value="kidspets">
				                <span class="tag-label">반려동물</span>
				            </label>
				            <label>
				                <input type="checkbox" name="interest" id="etc" value="etc">
				                <span class="tag-label">기타</span>
				            </label>
				        </div>
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