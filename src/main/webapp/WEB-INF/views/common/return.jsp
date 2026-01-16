<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	//서버에서 저장된 msg가 담김.
	alert('${msg}');
	<c:if test = "${cmd == 'back'}">
		history.back;
	</c:if> 
	<c:if test = "${cmd == 'move'}">
		location.href = "${url}";
	</c:if>
	
</script>
</head>
<body>

</body>
</html>