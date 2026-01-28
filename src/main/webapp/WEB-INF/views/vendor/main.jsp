<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
html, body {
	height: 100% !important;
	margin: 0;
	padding: 0;
	overflow: hidden; /* 부모 페이지 스크롤 절대 차단 */
}

.container {
	display: flex;
	height: 100vh;
}

.content {
	flex: 1;
	display: flex;
	flex-direction: column;
	background-color: #f3f5f9;
	min-width: 0; /* 배율 대응을 위한 유연한 너비 */
}

.main-content {
	flex: 1;
	position: relative; /* iframe의 높이 기준점 */
}

/* iframe 설정: 900px 고정 대신 100% 채우기 */
iframe[name="vendorFrame"] {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	border: none;
	display: block;
}
</style>
<script>
    // iframe 안에서 열렸다면 최상위로 끌어올림
    if (window.top !== window.self) {
        window.top.location.href = window.location.href;
    }
</script>

<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined"
	rel="stylesheet" />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>VENDOR</title>
</head>
<body>
	<div class="container">
		<jsp:include page="/WEB-INF/views/vendor/vendor_sidebar.jsp" />

		<div class="content">
			<main class="main-content">
				<iframe name="vendorFrame"
					src="${pageContext.request.contextPath}/vendor/content_manage?isIframe=true"
					width="100%" height="100%" style="min-height: 900px;"
					frameborder="0"> </iframe>
			</main>
		</div>
	</div>
</body>
</html>