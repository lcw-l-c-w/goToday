<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head> 
    <meta charset="utf-8">
    <title></title>
    <META name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, user-scalable=no"> 
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />
    <link rel="stylesheet" href="${ctx}/css/reset.css"/>
    <link rel="stylesheet" href="${ctx}/css/contents.css"/>
    <script>
    function del() {
    	if (confirm('삭제하시겠습니까?')) {
    		location.href='delete.do?reply_id=${vo.reply_id}';
    	}
    }
    function delAdminOnly() {
    	if (confirm('답변을 삭제하시겠습니까?')) {
    		location.href='deleteAdminOnly.do?reply_id=${vo.reply_id}';
    	}
    }
    </script>
</head> 
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
    <div class="wrap">
        <div class="sub">
            <div class="size">
                <h3 class="sub_title">문의사항 #${vo.reply_id} </h3>
                <div class="bbs">
                    <div class="view">
                        <div class="title">
                            <dl>
                                <dt>${vo.title }</dt>
                                <dd class="date">작성일 : <fmt:formatDate value="${vo.created_at }" pattern="YYYY-MM-dd HH:mm:ss"/> </dd>
                            </dl>
                        </div>
                        <div class="cont" style="white-space: pre-wrap;">${vo.body}</div>
                    </div>
	                    <c:if test="${not empty adminReply}">
						    <div class="view admin-answer">
						        <div class="title">
						            <dl>
						                <dt>RE : ${adminReply.title}</dt>
						                <dd class="date">
						                    작성일 :
						                    <fmt:formatDate value="${adminReply.created_at}"
						                                    pattern="yyyy-MM-dd HH:mm:ss"/>
						                </dd>
						            </dl>
						        </div>
						        <div class="cont" style="white-space: pre-wrap;">${adminReply.body}</div>
						    </div>
						</c:if>
                        <div class="btnSet clear">
                            <div class="fl_l">
                            	<a href="index.do" class="btn">목록</a>
                            	<c:if test="${!empty login and login.user_id == vo.writer || !empty login and not empty adminReply}">
	                            	<a href="javascript:del();" class="btn btn-red">문의 삭제</a>
                            	</c:if>
                            	<c:if test="${!empty login and not empty adminReply}">
				                    <a href="javascript:delAdminOnly();" class="btn btn-red">답변 삭제</a>
			                    </c:if>
                            	<c:if test="${Admin and empty adminReply}">
							        <a href="reply.do?reply_id=${vo.reply_id}" class="btn">답변하기</a>
							    </c:if>
                            </div>
                        </div>
                </div>
            </div>
        </div>
    </div>
</body> 
</html>