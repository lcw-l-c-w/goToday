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
$(function() {
	$('#frm').on('submit', function(e) {
		const eventSelected = $('input[name="event"]:checked').length > 0;
		if (!eventSelected) {
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
				<div class="line-1">
					<label>
						<input type="checkbox" name="location" value="성수"
							<c:if test="${userTags.contains('성수')}">checked</c:if>>
						<span class="btn-option">성수</span>
					</label>
					<label>
						<input type="checkbox" name="location" value="홍대"
							<c:if test="${userTags.contains('홍대')}">checked</c:if>>
						<span class="btn-option">홍대</span>
					</label>
					<label>
						<input type="checkbox" name="location" value="여의도"
							<c:if test="${userTags.contains('여의도')}">checked</c:if>>
						<span class="btn-option">여의도</span>
					</label>
				</div>
				<div class="line-2">
					<label>
						<input type="checkbox" name="location" value="강남"
							<c:if test="${userTags.contains('강남')}">checked</c:if>>
						<span class="btn-option">강남</span>
					</label>
					<label>
						<input type="checkbox" name="location" value="혜화"
							<c:if test="${userTags.contains('혜화')}">checked</c:if>>
						<span class="btn-option">혜화</span>
					</label>
					<label>
						<input type="checkbox" name="location" value="한남"
							<c:if test="${userTags.contains('한남')}">checked</c:if>>
						<span class="btn-option">한남</span>
					</label>
					<label>
						<input type="checkbox" name="location" value="etc"
							<c:if test="${userTags.contains('etc')}">checked</c:if>>
						<span class="btn-option">etc</span>
					</label>
				</div>
			</div>
		</div>

		<div class="form-section">
			<h2 class="section-title">관심있는 분야</h2>
			<div class="interest-grid">
				<div class="interest-row">
					<label>
						<input type="checkbox" name="interest" value="식품"
							<c:if test="${userTags.contains('식품')}">checked</c:if>>
						<span class="btn-option">식품</span>
					</label>
					<label>
						<input type="checkbox" name="interest" value="캐릭터"
							<c:if test="${userTags.contains('캐릭터')}">checked</c:if>>
						<span class="btn-option">캐릭터</span>
					</label>
					<label>
						<input type="checkbox" name="interest" value="화장품"
							<c:if test="${userTags.contains('화장품')}">checked</c:if>>
						<span class="btn-option">화장품</span>
					</label>
					<label>
						<input type="checkbox" name="interest" value="미디어"
							<c:if test="${userTags.contains('미디어')}">checked</c:if>>
						<span class="btn-option">미디어</span>
					</label>
				</div>

				<div class="interest-row">
					<label>
						<input type="checkbox" name="interest" value="미술"
							<c:if test="${userTags.contains('미술')}">checked</c:if>>
						<span class="btn-option">미술</span>
					</label>
					<label>
						<input type="checkbox" name="interest" value="패션"
							<c:if test="${userTags.contains('패션')}">checked</c:if>>
						<span class="btn-option">패션</span>
					</label>
					<label>
						<input type="checkbox" name="interest" value="디지털/테크"
							<c:if test="${userTags.contains('디지털/테크')}">checked</c:if>>
						<span class="btn-option">디지털/테크</span>
					</label>
					<label>
						<input type="checkbox" name="interest" value="키즈/반려동물"
							<c:if test="${userTags.contains('키즈/반려동물')}">checked</c:if>>
						<span class="btn-option">키즈/반려동물</span>
					</label>
					<label>
						<input type="checkbox" name="interest" value="etc"
							<c:if test="${userTags.contains('etc')}">checked</c:if>>
						<span class="btn-option">etc</span>
					</label>
				</div>
			</div>
		</div>

		<div style="text-align:center;">
			<button type="submit" class="btn-submit">수정 완료</button>
		</div>
	</form>
</body>
</html>
