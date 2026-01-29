<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    :root {
        --main-color: #4dc3ff;
        --color-primary: #41b6e6;
        --color-sidebar-bg: rgba(238, 238, 238, 0.20);
        --border-radius-sidebar: 30px;
    }

    .sidebar {
        width: 250px;
        min-width: 250px;
        background-color: var(--color-sidebar-bg);
        border-radius: var(--border-radius-sidebar);
        border: 3px solid #eee;
        padding: 40px 30px;
        height: fit-content;
        font-family: 'Pretendard', sans-serif;
		position: sticky;
	    top: 130px;         
	    height: fit-content; 
	    align-self: flex-start; 
	    z-index: 10;
    }

    .user-profile {
        text-align: center;
        padding-bottom: 30px;
        margin-bottom: 30px;
        border-bottom: 1px solid #ddd;
    }

    .user-name {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 8px;
        color: #111;
    }

    .user-email {
        font-size: 14px;
        color: #666;
        margin-bottom: 20px;
        word-break: break-all;
    }

    .logout-btn {
        padding: 10px 30px;
        background-color: #333;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .logout-btn:hover {
        background-color: var(--main-color);
    }

    .sidebar-section {
        margin-bottom: 35px;
    }

    .sidebar-title {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 12px;
        color: #111;
    }

    .sidebar-item {
        font-size: 15px;
        font-weight: 400;
        line-height: 2.2;
        cursor: pointer;
        display: block;
        transition: all 0.2s;
        text-decoration: none;
        color: #333;
        padding-left: 5px;
    }

    .sidebar-item:hover {
        color: #999;
    }

    .sidebar-item.active {
        color: var(--color-primary);
        font-weight: 700;
    }
</style>

<aside class="sidebar">
	<div class="user-profile">
	    <div class="user-name">
	        <a href="${pageContext.request.contextPath}/mypage/main" target="_top" style="text-decoration: none; color: inherit;">
	            <strong>${not empty sessionScope.userName ? sessionScope.userName : '홍길동'}</strong> 님
	        </a>
	    </div>
	    <div class="user-email">
	        ${not empty sessionScope.userEmail ? sessionScope.userEmail : 'user@email.com'}
	    </div>
	    <button type="button" class="logout-btn" onclick="logout()">로그아웃</button>
	</div>

    <div class="sidebar-section">
        <h2 class="sidebar-title">주문 관리</h2>
        <a href="${pageContext.request.contextPath}/mypage/reservation" class="sidebar-item" target="mainFrame">예약 관리</a>
        <a href="${pageContext.request.contextPath}/mypage/myreviews.do" class="sidebar-item" target="mainFrame">나의 리뷰</a>
        <a href="${pageContext.request.contextPath}/mypage/like_list" class="sidebar-item" target="mainFrame">찜 관리</a>
    </div>

    <div class="sidebar-section">
        <h2 class="sidebar-title">문의 내역</h2>
        <a href="${pageContext.request.contextPath}/mypage/reply_list" class="sidebar-item" target="mainFrame">Q & A</a>
        <a href="${pageContext.request.contextPath}/mypage/inquiry_list" class="sidebar-item" target="mainFrame">1:1 문의사항</a>
    </div>

    <div class="sidebar-section">
        <h2 class="sidebar-title">회원 관리</h2>
        <a href="${pageContext.request.contextPath}/mypage/user_like_edit" class="sidebar-item" target="mainFrame">관심사 수정</a>
        <a href="${pageContext.request.contextPath}/mypage/user_info" class="sidebar-item" target="mainFrame">내 정보 수정</a>
    </div>
</aside>

<script>
    function logout() {
        if(confirm('로그아웃 하시겠습니까?')) {
            location.href = '${pageContext.request.contextPath}/mypage/logout';
        }
    }

    // 사이드바의 active 클래스를 동적으로 변경
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