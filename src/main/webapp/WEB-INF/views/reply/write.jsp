<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isIframe" value="${param.isIframe}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>문의 작성</title>
<META name="viewport"
	content="width=device-width, height=device-height, initial-scale=1.0, user-scalable=no">
<script>
    window.__CTX__ = "${pageContext.request.contextPath}";
    console.log("Context Path 확인:", window.__CTX__); 
</script>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />
<link rel="stylesheet" href="${ctx}/css/reset.css" />
<link rel="stylesheet" href="${ctx}/css/contents.css" />
<script src="${ctx}/smarteditor/js/HuskyEZCreator.js"></script>
<script>
	var oEditors = [];
	$(function() {
		nhn.husky.EZCreator.createInIFrame({
			oAppRef : oEditors,
			elPlaceHolder : "body",
			sSkinURI : "${ctx}/smarteditor/SmartEditor2Skin.html",
			htParams : {
				bUseToolbar : true, // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true, // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true, // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				fOnBeforeUnload : function() {
				}
			}, //boolean
			fOnAppLoad : function() {
				
			},
			fCreator : "createSEditor2"
		});
	})
	function goSave() {
		oEditors[0].exec('UPDATE_CONTENTS_FIELD', []);

		var title = document.getElementById("title");
		if (title.value.trim() == "") {
			alert("제목을 입력해주세요.");
			title.focus();
			return false;
		}

		// 3. 내용 유효성 검사 (스마트 에디터 공백 체크)
		var body = document.getElementById("body").value;
		if (body == "" || body == null || body == "&nbsp;"
				|| body == "<p>&nbsp;</p>" || body == "<p><br></p>") {
			alert("내용을 입력해주세요.");
			oEditors[0].exec("FOCUS"); // 에디터에 포커스
			return false;
		}

		document.getElementById("frm").submit();
	}
</script>
</head>
<body>
	<c:if test="${isIframe != 'true'}">
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
	</c:if>
	<div class="wrap ${isIframe == 'true' ? 'no-header' : ''}">
		<div class="wrap">
			<div class="sub">
				<div class="size">
					<h3 class="sub_title">문의사항 작성</h3>

					<div class="bbs">
						<form method="post" name="frm" id="frm" action="insert"
							enctype="multipart/form-data">
							<input type="hidden" name="isIframe" value="${isIframe}">
							<table class="board_write">
								<tbody>
									<tr>
										<th>제목</th>
										<td><input type="text" name="title" id="title"
											class="wid100" required></td>
									</tr>
									<tr>
										<th>내용</th>
										<td><textarea name="body" id="body"
												style="width: 100%; height: 300px;"></textarea></td>
									</tr>
								</tbody>
							</table>
							<div class="btnSet" style="text-align: right;">
								<a class="btn" href="index?isIframe=${isIframe}"
									style="background-color: #888 !important; margin-right: 5px;">취소</a>
								<a class="btn" href="javascript:goSave();">저장 </a>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>