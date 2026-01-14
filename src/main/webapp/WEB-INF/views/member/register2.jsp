<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입-관심사입력</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
function goSave() {
	$("#frm").submit();
}

</script>

</head>
<body>
<div class="container">
	 <form id="frm" action="/gotoday/member/register2" method="POST">
	    <h3>전시 or 팝업</h3>
	    <input type="radio" name="event" value="exhibition"> 전시
	    <input type="radio" name="event" value="popup"> 팝업
	
	    <h3>핫플레이스</h3>
	    <input type="checkbox" name="location" value="seongsu"> 성수
	    <input type="checkbox" name="location" value="hongdae"> 홍대
	    <input type="checkbox" name="location" value="yeouido"> 여의도
	    <input type="checkbox" name="location" value="gangnam"> 강남
	    <input type="checkbox" name="location" value="hyehwa"> 혜화
	    <input type="checkbox" name="location" value="hannam"> 한남
	
	    <h3>관심 분야</h3>
	    <input type="checkbox" name="interest" value="food"> 식품
	    <input type="checkbox" name="interest" value="character"> 캐릭터
	    <input type="checkbox" name="interest" value="cosmetics"> 화장품
	    <input type="checkbox" name="interest" value="media"> 미디어
	    <input type="checkbox" name="interest" value="art"> 미술
	    <input type="checkbox" name="interest" value="fashion"> 패션
	    <input type="checkbox" name="interest" value="digitaltech"> 디지털/테크
	    <input type="checkbox" name="interest" value="fidspets"> 키즈/반려동물
	    <input type="checkbox" name="interest" value="etc"> 기타
	
		<br>
	    <a href="javascript:;" class="btn next-btn" onclick="goSave();">다음단계</a> 
	</form>
</div>
</body>
</html>