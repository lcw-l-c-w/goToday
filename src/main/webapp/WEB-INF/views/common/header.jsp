<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    :root { --main-color: #4dc3ff; --text-gray: #666; }
    
    .header { width: 100%; border-bottom: 1px solid #eee; background: #fff; position: sticky; top: 0; z-index: 1000; }
    .nav-container { max-width: 1100px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; padding: 0 20px; height: 70px; }
    .logo img { height: 32px; cursor: pointer; display: block; }
    
    .nav-menu { display: flex; gap: 35px; list-style: none; align-items: center; height: 100%; margin: 0; padding: 0; }
    .nav-menu li { position: relative; height: 100%; display: flex; align-items: center; }
    .nav-menu a { font-weight: 600; font-size: 15px; color: #333; text-decoration: none; transition: color 0.3s ease; height: 100%; display: flex; align-items: center; padding: 0 5px; }
    
    .nav-menu li:hover a { color: var(--main-color); }
    .nav-menu li::after { content: ""; position: absolute; bottom: -1px; left: 0; width: 0; height: 3px; background-color: var(--main-color); transition: width 0.3s ease; }
    .nav-menu li:hover::after { width: 100%; }

    .nav-icons { display: flex; gap: 20px; align-items: center; }
    .search-bar { border-bottom: 1px solid #333; display: flex; align-items: center; padding: 2px 5px; }
    .search-bar input { border: none; outline: none; width: 150px; font-size: 14px; }
    .user-icon { font-size: 22px; cursor: pointer; transition: color 0.2s; color: #333; }
    .user-icon:hover { color: var(--main-color); }
</style>

<header class="header">
    <div class="nav-container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/main">
                <img src="<c:url value='/resources/images/logo.png'/>" alt="Logo">
            </a>
        </div>
        
        <ul class="nav-menu">
            <li><a href="#">Q&A</a></li>
            <li><a href="${pageContext.request.contextPath}/popup">PopUp</a></li> 
            <li><a href="${pageContext.request.contextPath}/exhibition">Exhibition</a></li>
        </ul>

        <div class="nav-icons">
            <div class="search-bar">
                <input type="text" placeholder="검색">
                <span>🔍</span>
            </div>
            <span class="user-icon" id="commonMyPageBtn">👤</span>
        </div>
    </div>
</header>

<script>
$(function() {
    // 네비게이션 로그인 체크 및 이동
    $("#commonMyPageBtn").click(function() {
        // JSP 내장 객체 세션을 체크하되, 외부 JS 파일이 아니므로 EL 사용 가능
        const isLoggedIn = ${not empty loginSess}; 
        if (!isLoggedIn) {
            alert("로그인이 필요한 서비스입니다.");
            location.href = "${pageContext.request.contextPath}/member/login";
        } else {
            location.href = "${pageContext.request.contextPath}/mypage/main";
        }
    });
});
</script>