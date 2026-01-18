<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관심사 수정</title>
</head>
<body>

<form id="frm" action="/gotoday/member/userLikeEdit" method="POST">
    
    <h3>전시 or 팝업</h3>
    <input type="radio" name="event" value="exhibition"
        <c:if test="${userTags.contains('exhibition')}">checked</c:if>> 전시

    <input type="radio" name="event" value="popup"
        <c:if test="${userTags.contains('popup')}">checked</c:if>> 팝업


    <h3>핫플레이스</h3>
    <input type="checkbox" name="location" value="seongsu"
        <c:if test="${userTags.contains('seongsu')}">checked</c:if>> 성수

    <input type="checkbox" name="location" value="hongdae"
        <c:if test="${userTags.contains('hongdae')}">checked</c:if>> 홍대

    <input type="checkbox" name="location" value="yeouido"
        <c:if test="${userTags.contains('yeouido')}">checked</c:if>> 여의도

    <input type="checkbox" name="location" value="gangnam"
        <c:if test="${userTags.contains('gangnam')}">checked</c:if>> 강남

    <input type="checkbox" name="location" value="hyehwa"
        <c:if test="${userTags.contains('hyehwa')}">checked</c:if>> 혜화

    <input type="checkbox" name="location" value="hannam"
        <c:if test="${userTags.contains('hannam')}">checked</c:if>> 한남


    <h3>관심 분야</h3>
    <input type="checkbox" name="interest" value="food"
        <c:if test="${userTags.contains('food')}">checked</c:if>> 식품

    <input type="checkbox" name="interest" value="character"
        <c:if test="${userTags.contains('character')}">checked</c:if>> 캐릭터

    <input type="checkbox" name="interest" value="cosmetics"
        <c:if test="${userTags.contains('cosmetics')}">checked</c:if>> 화장품

    <input type="checkbox" name="interest" value="media"
        <c:if test="${userTags.contains('media')}">checked</c:if>> 미디어

    <input type="checkbox" name="interest" value="art"
        <c:if test="${userTags.contains('art')}">checked</c:if>> 미술

    <input type="checkbox" name="interest" value="fashion"
        <c:if test="${userTags.contains('fashion')}">checked</c:if>> 패션

    <input type="checkbox" name="interest" value="digitaltech"
        <c:if test="${userTags.contains('digitaltech')}">checked</c:if>> 디지털/테크

    <input type="checkbox" name="interest" value="kidspets"
        <c:if test="${userTags.contains('kidspets')}">checked</c:if>> 키즈/반려동물

    <input type="checkbox" name="interest" value="etc"
        <c:if test="${userTags.contains('etc')}">checked</c:if>> 기타


    <br><br>
    <button type="submit">확인</button>
</form>

</body>
</html>
