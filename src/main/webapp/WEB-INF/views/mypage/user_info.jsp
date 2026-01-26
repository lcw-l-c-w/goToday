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
$(document).ready(function() {
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
    // 날짜 input 값을 8자리 숫자로 변환하여 hidden input에 저장
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