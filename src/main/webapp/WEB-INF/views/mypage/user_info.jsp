<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보 수정 | GoToday</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>


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
    
<style>
    :root { --main-color: #4dc3ff; --color-primary: #41b6e6; }
    body { font-family: 'Pretendard', sans-serif; background-color: transparent; margin: 0; padding: 0; }
    
    .page-title { font-size: 32px; font-weight: 700; margin-bottom: 40px; color: #111; }
    
    .form-wrapper { 
        width: 100%; max-width: 700px; background: #fff; padding: 40px; 
        border-radius: 20px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); 
    }

    .form-row { display: flex; align-items: center; margin-bottom: 20px; }
    .form-label { width: 150px; font-weight: 700; }
    .form-input-wrapper { flex: 1; max-width: 250px; }
    .form-input { 
        width: 100%; height: 45px; background: #eee; border: none; 
        border-radius: 8px; padding: 0 15px; box-sizing: border-box;
    }
    /* 수정 불가(이메일) 스타일 */
    .form-input[readonly] {
        background-color: #f5f5f5;
        color: #888;
        cursor: not-allowed;
        border: 1px solid #e0e0e0;
    }
    
    /* 성별 라디오 버튼 스타일 */
    .gender-group { display: flex; gap: 20px; }
    .gender-label { display: flex; align-items: center; gap: 8px; cursor: pointer; }
    .gender-label input { width: 18px; height: 18px; cursor: pointer; }
    
   	 .btn-submit {
     width: 100%; max-width: 300px; padding: 15px; background: #333; color: #fff;
     border: none; border-radius: 12px; font-weight: 700; cursor: pointer; margin-top: 20px;
	 }
	 .btn-submit:hover { background: #000; }
</style>

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