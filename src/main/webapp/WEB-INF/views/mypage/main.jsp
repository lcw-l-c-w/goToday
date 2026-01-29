<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지 | GoToday</title>
<style>
	* { margin: 0; padding: 0; box-sizing: border-box; }
	body { font-family: 'Pretendard', sans-serif; background-color: #ffffff; }
	
	.container {
	    display: flex;
	    align-items: flex-start;
	    gap: 60px;
	    padding: 60px 8%;
	    max-width: 1400px;
	    margin: 0 auto;
	}
	
	.content {
	    flex: 1;
	    min-width: 0; /* flex 깨짐 방지 */
	}
	
	.main-content {
	    width: 100%;
	    /* iframe의 배경이 투명해야 상세페이지의 곡선 디자인이 잘 보입니다. */
	    background-color: transparent; 
	}
	
	.main-content iframe {
	    width: 100%;
	    min-height: 2000px; /* 상세페이지 길이에 맞춰 넉넉히 설정 */
	    border: none;
	    overflow: hidden; /* iframe 자체 스크롤바 방지 */
	}
	
	@media (max-width: 1024px) {
	    .container { flex-direction: column; padding: 20px; gap: 30px; }
	}
</style>
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