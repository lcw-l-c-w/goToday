<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>search</title>
</head>
<body>
	<div id="searchdiv">
	    <input type="search" placeholder="검색어를 입력하세요 ">
	    <input type="button" value="검색버튼">
	</div>
	
	<div>
	    <br><hr>
	    <div class="listSearch"> 
	        카테고리  <button data-type="kind" data-value="POPUP"> 팝업</button> <button data-type="kind" data-value="exhibition">전시회</button><br>
	        <hr>
	        지역  <button data-type="region" data-value="SEOUL"> 서울 </button> <button data-type="region" data-value="GYEONGGI/INCHEON"> 경기/인천 </button> <button data-type="region" data-value="DAEJEON/CHUNGCHEONG/GANGWON" > 대전/충청/강원</button> 
	        <button data-type="region" data-value="BUSAN/DAEJEON/ULSAN/GYEONGSANG">부산/대구/울산/경상</button> <button data-type="region" data-value="GWANGJU/JEOLLA"> 광주/전라</button> <button data-type="region" data-value="JEJU"> 제주</button> <br>
	        <hr>
	        분야 <button data-type="category" data-value="FOOD">식품</button> <button data-type="category" data-value="CHARACTER">캐릭터</button> <button data-type="category" data-value="BEAUTY">화장품</button> <button data-type="category" data-value="MEDIA">미디어</button> <button data-type="category" data-value="ART">미술</button> <button data-type="category" data-value="FASHION">패션</button> <button data-type="category" data-value="DIGITAL/TECH">디지털/테크</button> <button data-type="category" data-value="KID/ANIMAL">키즈/반려동물</button> <button data-type="category" data-value="ETC">etc</button> 
	        <hr>
	        날짜 <button data-type="status" data-value="FOOD">현재 진행 중 </button> <button>오픈 예정</button> <button>날짜 지정</button>
	        <hr>
	        예약 여부 <button data-type="reservation_type" data-value="place_enter">현장 입장</button> <button data-type="reservation_type" data-value="reservation">예매 필수</button>
	    </div>
	</div>
	<hr>
	<br>
	<br>
	<div class="list-item">
	    <div class="imageList">
	        <img src="src/dudu.jpg">
	    </div>
	    <div class="info">
	    <div id="title"> 이름 </div> 
	    <div id="contentDate">날짜</div> 
	    <div id="location">장소</div>
	    </div>
	</div>
	<hr>


</body>
</html>