<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보 수정 | GoToday</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage_user_info.css">
<script>
$(function() {
	// DB에서 가져온 전화번호 하이픈 적용
	let phoneVal = $("input[name='phone_number']").val();
	if (phoneVal) {
		phoneVal = phoneVal.replace(/[^0-9]/g, "");
		let formatted = "";
		if(phoneVal.length < 4) {
			formatted = phoneVal;
		} else if(phoneVal.length < 7) {
			formatted = phoneVal.substr(0, 3) + "-" + phoneVal.substr(3);
		} else if(phoneVal.length <= 11) {
			formatted = phoneVal.substr(0, 3) + "-" + phoneVal.substr(3, 4) + "-" + phoneVal.substr(7);
		} else {
			formatted = phoneVal.substr(0, 3) + "-" + phoneVal.substr(3, 4) + "-" + phoneVal.substr(7, 4);
		}
		$("input[name='phone_number']").val(formatted);
	}

	// 입력 시 자동 하이픈
	$("input[name='phone_number']").on("input", function() {
		let number = $(this).val().replace(/[^0-9]/g, "");
		let formatted = "";
		if(number.length < 4) {
			formatted = number;
		} else if(number.length < 7) {
			formatted = number.substr(0, 3) + "-" + number.substr(3);
		} else if(number.length <= 11) {
			formatted = number.substr(0, 3) + "-" + number.substr(3, 4) + "-" + number.substr(7);
		} else {
			formatted = number.substr(0, 3) + "-" + number.substr(3, 4) + "-" + number.substr(7, 4);
		}
		$(this).val(formatted);
	});
});

$(function() {
	// 성별 데이터 세팅
	var genderVal = "${user.gender}"; 
	if (genderVal) {
		$('input[name="gender"][value="' + genderVal + '"]').prop('checked', true);
	}
	
	// 생년월일 데이터 세팅 (YYYYMMDD -> YYYY-MM-DD)
	var birthVal = "${user.birthday}"; 
	if (birthVal && birthVal.length === 8) {
		var formattedDate = birthVal.substring(0,4) + '-' + 
							birthVal.substring(4,6) + '-' + 
							birthVal.substring(6,8);
		$('#birthday_date').val(formattedDate);
	}
});

function beforeSubmit() {
	// 생년월일 데이터 세팅 (YYYY-MM-DD -> YYYYMMDD)
	let dateVal = $("#birthday_date").val();
	if (!dateVal) {
		alert("생년월일을 선택해주세요.");
		return false;
	}
	$("#birthday").val(dateVal.replace(/-/g, ""));

	// 비밀번호 일치 확인
	let pw = $('input[name="password"]').val();
	let pwConfirm = $('input[name="confirmPassword"]').val();
	if (pw !== pwConfirm) {
		alert("비밀번호가 일치하지 않습니다.");
		return false;
	}

	// 전화번호 하이픈 제거 후 전송
	let phoneNumber = $("input[name='phone_number']").val().replace(/-/g, "");
	$("input[name='phone_number']").val(phoneNumber);
	
	alert('정보가 성공적으로 수정되었습니다.');
	return true;
}
</script>
</head>
<body>
<h1 class="page-title">내 정보 수정</h1>
<form id="frm" action="${pageContext.request.contextPath}/mypage/user_info" method="POST" class="form-wrapper" onsubmit="return beforeSubmit();">
	<div class="form-row">
		<label class="form-label">이메일</label>
		<div class="form-input-wrapper">
			<input type="text" name="email" value="${user.email}" class="form-input" readonly>
		</div>
	</div>

	<c:choose>
		<c:when test="${user.role == 0 && user.login_type == 'L'}">
			<div class="form-row">
				<label class="form-label">변경할 비밀번호</label>
				<div class="form-input-wrapper">
					<input type="password" name="password" class="form-input" placeholder="미입력 시 기존 비밀번호가 유지됩니다.">
				</div>
			</div>
			<div class="form-row">
				<label class="form-label">비밀번호 확인</label>
				<div class="form-input-wrapper">
					<input type="password" name="confirmPassword" class="form-input" placeholder="미입력 시 기존 비밀번호가 유지됩니다.">
				</div>
			</div>
			<div class="form-row">
				<label class="form-label">이름</label>
				<div class="form-input-wrapper">
					<input type="text" name="name" value="${user.name}" class="form-input">
				</div>
			</div>
		</c:when>

		<c:when test="${user.role == 0 && user.login_type != 'L'}">
			<div class="form-row">
				<label class="form-label">이름</label>
				<div class="form-input-wrapper">
					<input type="text" name="name" value="${user.name}" class="form-input" readonly>
				</div>
			</div>
		</c:when>

		<c:when test="${user.role == 1}">
			<div class="form-row">
				<label class="form-label">패스워드</label>
				<div class="form-input-wrapper">
					<input type="password" name="password" class="form-input" placeholder="미입력 시 기존 비밀번호가 유지됩니다.">
				</div>
			</div>
			<div class="form-row">
				<label class="form-label">패스워드 확인</label>
				<div class="form-input-wrapper">
					<input type="password" name="confirmPassword" class="form-input" placeholder="미입력 시 기존 비밀번호가 유지됩니다.">
				</div>
			</div>
			<div class="form-row">
				<label class="form-label">사업자등록번호</label>
				<div class="form-input-wrapper">
					<input type="text" name="bizNo" class="form-input" placeholder="미입력 시 기존 등록번호가 유지됩니다.">
				</div>
			</div>
			<div class="form-row">
				<label class="form-label">이름</label>
				<div class="form-input-wrapper">
					<input type="text" name="name" value="${user.name}" class="form-input">
				</div>
			</div>
		</c:when>
	</c:choose>

	<div class="form-row">
		<label class="form-label">전화번호</label>
		<div class="form-input-wrapper">
			<input type="text" name="phone_number" value="${user.phone_number}" class="form-input">
		</div>
	</div>

	<div class="form-row">
		<label class="form-label">생년월일</label>
		<div class="form-input-wrapper">
			<input type="date" id="birthday_date" class="form-input">
			<input type="hidden" id="birthday" name="birthday">
		</div>
	</div>
	
	<script>
		// 페이지 로드 시 즉시 실행
		(function() {
			const dateInput = document.getElementById('birthday_date');
			
			// 접속 클라이언트 PC 오늘 날짜 기준
			const now = new Date();
			const year = now.getFullYear();
			const month = String(now.getMonth() + 1).padStart(2, '0');
			const day = String(now.getDate()).padStart(2, '0');
			const todayStr = year + "-" + month + "-" + day;
	
			// 미래 날짜 비활성화
			dateInput.max = todayStr;
	
			// 기존 데이터 세팅
			var birthVal = "${user.birthday}"; 
			if (birthVal && birthVal.length === 8) {
				var formattedDate = birthVal.substring(0,4) + '-' + 
									birthVal.substring(4,6) + '-' + 
									birthVal.substring(6,8);
				dateInput.value = formattedDate;
			}
		})();
	</script>
	
	<div class="form-row">
		<label class="form-label">성별</label>
		<div class="form-input-wrapper">
			<div class="gender-group">
				<label class="gender-label">
					<input type="radio" name="gender" value="M" ${user.gender == 'M' ? 'checked' : ''}> <span>남</span>
				</label>
				<label class="gender-label">
					<input type="radio" name="gender" value="F" ${user.gender == 'F' ? 'checked' : ''}> <span>여</span>
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