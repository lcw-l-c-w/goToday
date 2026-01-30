<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지 | GoToday</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body { f
	ont-family: 'Pretendard', sans-serif; 
	background-color: #ffffff;
	 /* overflow: hidden; */
}

.container {
    display: flex;
    gap: 40px;
    padding: 60px 8%;
    max-width: 1400px;
    margin: 0 auto;
}

.content {
    flex: 1;
    min-width: 0;
}

.main-content {
    width: 100%;
    background-color: transparent; 
}

.main-content iframe {
    width: 100%;
    min-height: 1080px;
    border: none;
    overflow: hidden;
}

@media (max-width: 1024px) {
    .container { flex-direction: column; padding: 20px; gap: 30px; }
}
</style>
<script>
// /gotoday/main 에서 관심사설정 버튼 클릭시 iframe 적용 /mypage/user_like_edit로 이동
window.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const page = urlParams.get('page');
    
    const iframe = document.querySelector('iframe[name="mainFrame"]');
    
    if (page === 'user_like_edit' && iframe) {
        iframe.src = '${pageContext.request.contextPath}/mypage/user_like_edit';
    }
});
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/recentViewed.jspf" %>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <div class="container">
        <jsp:include page="/WEB-INF/views/mypage/sidebar.jsp" />
        <div class="content">
            <div class="main-content">
                <iframe name="mainFrame" src="${pageContext.request.contextPath}/calendar" width="100%" height="900" frameborder="0"></iframe>
            </div>
        </div>
    </div>
</body>
</html>