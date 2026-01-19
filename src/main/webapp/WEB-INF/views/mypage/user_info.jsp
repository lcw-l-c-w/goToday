<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보 수정</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(function() {
    // 성별 라디오 체크
    var gender = '${user.gender}';
    if (gender === 'M') {
        $('input[name="gender"][value="M"]').prop('checked', true);
    } else if (gender === 'F') {
        $('input[name="gender"][value="F"]').prop('checked', true);
    }
});
</script>
</head>
<body>
<h3>내 정보 수정</h3>
<form action="/gotoday/mypage/user_info" method="post">
    <table>
        <!-- 이메일 -->
        <tr>
            <td>이메일</td>
            <td><input type="text" name="email" value="${user.email}" readonly></td>
        </tr>

        <!-- 역할과 로그인 타입에 따른 패스워드/이름 -->
        <c:choose>
            <c:when test="${user.role == 0 && user.login_type == 'L'}">
                <tr>
                    <td>패스워드</td>
                    <td>
                        <input type="password" name="password" placeholder="미입력 시 기존 비밀번호 유지">
                    </td>
                </tr>
                <tr>
                    <td>패스워드 확인</td>
                    <td>
                        <input type="password" name="confirmPassword" placeholder="미입력 시 기존 비밀번호 유지">
                    </td>
                </tr>
                <tr>
                    <td>이름</td>
                    <td><input type="text" name="name" value="${user.name}"></td>
                </tr>
            </c:when>

            <c:when test="${user.role == 0 && user.login_type != 'L'}">
                <tr>
                    <td>이름</td>
                    <td><input type="text" name="name" value="${user.name}" readonly></td>
                </tr>
            </c:when>

            <c:when test="${user.role == 1}">
                <tr>
                    <td>패스워드</td>
                    <td>
                        <input type="password" name="password" placeholder="미입력 시 기존 비밀번호 유지">
                    </td>
                </tr>
                <tr>
                    <td>패스워드 확인</td>
                    <td>
                        <input type="password" name="confirmPassword" placeholder="미입력 시 기존 비밀번호 유지">
                    </td>
                </tr>
                <tr>
                    <td>사업자등록번호</td>
                    <td><input type="text" name="bizNo"></td>
                </tr>
                <tr>
                    <td>이름</td>
                    <td><input type="text" name="name" value="${user.name}"></td>
                </tr>
            </c:when>
        </c:choose>

        <!-- 생일 (텍스트) -->
        <tr>
            <td>생일</td>
            <td><input type="text" name="birthday" value="${user.birthday}" placeholder="YYYY-MM-DD"></td>
        </tr>

        <!-- 성별 라디오 -->
        <tr>
            <td>성별</td>
            <td>
                <input type="radio" name="gender" value="M"> 남
                <input type="radio" name="gender" value="F"> 여
            </td>
        </tr>

        <!-- 전화번호 -->
        <tr>
            <td>전화번호</td>
            <td><input type="text" name="phone_number" value="${user.phone_number}"></td>
        </tr>

        <!-- 제출 버튼 -->
        <tr>
            <td colspan="2">
                <button type="submit">수정</button>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
