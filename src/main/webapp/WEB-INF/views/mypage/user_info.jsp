<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<style>
    :root { --main-color: #4dc3ff; --color-primary: #41b6e6; }
    body { font-family: 'Pretendard', sans-serif; background-color: transparent; margin: 0; padding: 0; }
    
    .page-title { font-size: 32px; font-weight: 700; margin-bottom: 40px; color: #111; }
    
    /* 관심사 수정과 동일한 박스 스타일 */
    .form-wrapper { 
        width: 100%; max-width: 700px; background: #fff; padding: 40px; 
        border-radius: 20px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); 
    }

    .form-row { display: flex; align-items: center; margin-bottom: 20px; }
    .form-label { width: 150px; font-weight: 700; }
    .form-input { 
        flex: 1; height: 45px; background: #eee; border: none; 
        border-radius: 8px; padding: 0 15px; 
    }
    .btn-submit {
        width: 150px; padding: 12px; background: #fff; border: 2px solid #333;
        font-weight: 700; cursor: pointer; transition: 0.3s;
    }
    .btn-submit:hover { background: #333; color: #fff; }
</style>
</head>
<body>
            <h1 class="page-title">내정보 수정</h1>
            
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
                                <input type="radio" name="gender" value="M"> <span>남</span>
                            </label>
                            <label class="gender-label">
                                <input type="radio" name="gender" value="F"> <span>여</span>
                            </label>
                        </div>
                    </div>
                </div>

                <div class="button-container">
                    <button type="submit" class="btn btn-submit">확인</button>
                </div>
            </form>

    <script>
        $(function() {
            // 성별 라디오 체크
            var gender = '${user.gender}';
            if (gender === 'M') {
                $('input[name="gender"][value="M"]').prop('checked', true);
            } else if (gender === 'F') {
                $('input[name="gender"][value="F"]').prop('checked', true);
            }

            // 생년월일 표시
            var birthday = '${user.birthday}';
            if (birthday && birthday.length === 8) {
                $('#birthday_date').val(
                    birthday.substring(0,4) + '-' +
                    birthday.substring(4,6) + '-' +
                    birthday.substring(6,8)
                );
            }
        });

        function beforeSubmit() {
            let birthdayDate = $("#birthday_date").val();
            if (birthdayDate === '') {
                alert("생년월일을 입력해주세요.");
                return false;
            }

            let birthday = birthdayDate.replaceAll("-", "");
            $("#birthday").val(birthday);

            let password = $('input[name="password"]').val();
            let confirmPassword = $('input[name="confirmPassword"]').val();
            
            if (password !== '' || confirmPassword !== '') {
                if (password !== confirmPassword) {
                    alert("비밀번호가 일치하지 않습니다.");
                    return false;
                }
            }

            alert('정보가 성공적으로 수정되었습니다.');
            return true;
        }

        function logout() {
            if(confirm('로그아웃 하시겠습니까?')) {
                location.href = '${pageContext.request.contextPath}/mypage/logout';
            }
        }

        // 현재 페이지 active 처리
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const sidebarItems = document.querySelectorAll('.sidebar-item');
            
            sidebarItems.forEach(item => {
                if(item.getAttribute('href') === currentPath) {
                    item.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>