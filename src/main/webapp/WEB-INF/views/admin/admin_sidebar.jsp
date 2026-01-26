<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined"
	rel="stylesheet" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_sidebar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_user_manage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_content_manage.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin_content_request.css">

<aside class="sidebar">
	<div class="sidebar-header">
		<h1 class="logo">ExhibiReserve</h1>
		<p class="logo-sub">ADMIN MANAGEMENT</p>
	</div>

	<nav class="sidebar-nav">
		<ul>
			<li class="sidebar-item"><a href="${pageContext.request.contextPath}/admin/content_request?isIframe=true"  target="adminFrame"><span
					class="material-symbols-outlined">dashboard</span> 승인 요청</a></li>
			<li class="sidebar-item"><a href="${pageContext.request.contextPath}/admin/content_manage?isIframe=true"  target="adminFrame"><span
					class="material-symbols-outlined">description</span> 전시 관리</a></li>
			<li class="sidebar-item"><a href="${pageContext.request.contextPath}/admin/user_manage?isIframe=true"  target="adminFrame"><span
					class="material-symbols-outlined">person</span> 사용자 관리</a></li>
			<li class="sidebar-item"><a href="${pageContext.request.contextPath}/reply/index?isIframe=true"  target="adminFrame"><span
					class="material-symbols-outlined">support_agent</span> 관리자 문의하기</a></li>
			<li class="sidebar-item"><a href="${pageContext.request.contextPath}/mypage/logout"
				onclick="return confirmLogout();"><span
					class="material-symbols-outlined">logout</span> 로그아웃</a></li>
		</ul>
	</nav>

	<div class="sidebar-footer">
		<div class="user-box">
			<p class="user-role">Signed in as</p>
			<div class="name-wrapper user-name-trigger">
				<strong class="user-name"> <c:choose>
						<c:when test="${not empty loginSess}">
		                        관리자
		                    </c:when>
						<c:otherwise>
		                        잘못된 접근입니다.
		                    </c:otherwise>
					</c:choose>
				</strong> 
				<a href="${pageContext.request.contextPath}/main" class="home-icon-btn" title="메인으로 이동"> <span
					class="material-symbols-outlined">home</span>
				</a>
			</div>
		</div>
	</div>
</aside>

<script>
	const ctx = '${pageContext.request.contextPath}';

	function confirmLogout() {
		if (confirm("로그아웃 하시겠습니까?")) {
			return true;
		} else {
			return false;
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
    
    document.addEventListener('DOMContentLoaded', function() {
        const sidebarItems = document.querySelectorAll('.sidebar-item');
        // 현재 메인의 iframe이 전시 관리(content_manage)를 띄우고 있으므로 이를 기본값으로 설정
        const defaultPath = "${pageContext.request.contextPath}/admin/content_manage";

        sidebarItems.forEach(item => {
            const link = item.querySelector('a');
            const href = link.getAttribute('href');

            // 1. 초기 로드 시 활성화 체크
            // 현재 주소에 href가 포함되어 있거나, 첫 진입 시 defaultPath와 일치하면 active 추가
            if (href.includes(defaultPath)) {
                item.classList.add('active');
            }

            // 2. 클릭 시 활성화 변경 (기존 로직)
            link.addEventListener('click', function() {
                sidebarItems.forEach(i => i.classList.remove('active'));
                item.classList.add('active');
            });
        });
    });
</script>
