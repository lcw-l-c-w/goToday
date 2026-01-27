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
            overflow: hidden;
        }

        /* 2. HTML 구조에 맞춘 클래스명 수정 */
        .container {
            display: flex;
            height: 100vh; /* 화면 전체 높이 사용 */
            width: 100%;
        }

        .content {
            flex: 1;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .main-content {
            flex: 1;
            height: 100%;
            padding: 0; /* padding은 자식(iframe 내부)에서 처리 */
            margin:0;
        }

        /* 3. iframe을 부모 크기에 꽉 채우기 */
        iframe[name="adminFrame"] {
            width: 100%;
            height: 100% !important;
            border: none;
            display: block;
        }
</style>
<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined"
	rel="stylesheet" />
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ADMIN</title>
</head>
<body>
	<div class="container">
		<jsp:include page="/WEB-INF/views/admin/admin_sidebar.jsp" />

		<div class="content">
			<main class="main-content">
				<iframe name="adminFrame"
					src="${pageContext.request.contextPath}/admin/content_manage?isIframe=true"
					width="100%" height="100%" style="min-height: 900px;"
					frameborder="0"> </iframe>
			</main>
		</div>
	</div>
</body>
</html>