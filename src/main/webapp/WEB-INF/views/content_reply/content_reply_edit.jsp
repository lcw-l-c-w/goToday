<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head> 
    <meta charset="utf-8">
    <title>GoToday | 문의 수정</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"> 
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="${ctx}/smarteditor/js/HuskyEZCreator.js"></script> 
    <link rel="stylesheet" href="${ctx}/css/write.css">
   

    <script>
    var oEditors = [];
    $(function() {
        nhn.husky.EZCreator.createInIFrame({
            oAppRef: oEditors,
            elPlaceHolder: "content",
            sSkinURI: "${ctx}/smarteditor/SmartEditor2Skin.html",    
            htParams : {
                bUseToolbar : true,
                bUseVerticalResizer : true,
                bUseModeChanger : true
            },
            fCreator: "createSEditor2"
        });
    });

    function goSave() {
        //제목 비는 거 막기 
    	oEditors.getById['content'].exec('UPDATE_CONTENTS_FIELD',[]);
        if ($("#title").length > 0 && !$("#title").val().trim()) {
            alert("제목을 입력해주세요.");
            $("#title").focus();
            return;
        }
        
        // --- 비밀글 체크하면 반영되게끔 하기  ---
        if ($("#is_secret").is(":checked")) {
            $("#secret").val("1");
        } else {
            $("#secret").val("0");
        }
        //-- 내용 비는 거 막기
        var content = $("#content").val();
        if( content == ""  || content == null || content == '&nbsp;' || content == '<p>&nbsp;</p>')  {
             alert("내용을 입력해주세요.");
             oEditors.getById['content'].exec("FOCUS");
             return false;
        }
        $("#frm").submit();
        
    }
    </script>
</head> 
<body>
    <div class="container">
        <header class="page-header">
            <h1 class="page-title">문의 내용 수정</h1>
           
        </header>

        <form method="post" name="frm" id="frm" action="${ctx}/detail/tab/inquiry/modify" enctype="multipart/form-data">
           <input type="hidden" name="creply_id" value="${item.creply_id}" />
  		  <input type="hidden" name="content_id" value="${item.content_id}" />
            <table class="edit-form-table">
                <tbody>
                <c:if test="${loginSess.role==0}">
                    <tr>
                        <th>제목</th>
                        <td>
                            <input type="text" name="title" id="title"value="${item.title}"/>
                        </td>
                    </tr>
                    </c:if>
             <c:if test="${loginSess.role==0}">       
                    <tr>
                    
            <th>공개 여부</th>
            <td>
                <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                    <input type="checkbox" name="is_secret" id="is_secret" value="1" style="width: 18px; height: 18px;" ${item.secret == 1 ? 'checked' : ''}>
                    <span style="font-size: 15px; color: #333;" >비밀글로 문의하기</span>
                </label>
                <input type="hidden" name="secret" id="secret" value="0"> </td>
        </tr>
        </c:if>
                    <tr>
                        <th>내용</th>
                        <td>
                            <textarea name="body" id="content" style="width:100%; height:400px;">${item.body}</textarea>
                        </td>
                    </tr>
        <tr>
    <th>첨부파일</th>
    <td>
        <div class="file-upload-wrapper">
            <c:if test="${not empty item.file_path}">
                <div class="existing-file" id="oldFileArea" style="margin-bottom: 12px; padding: 8px; background: #eee; border-radius: 4px; display: flex; align-items: center; justify-content: space-between;">
                    <div>
                        <span style="font-size: 13px; color: #555;">기존 파일: </span>
                        <strong style="font-size: 13px; color: var(--dark-gray);">${item.file_path}</strong>
                    </div>
                    
                    <label style="display: flex; align-items: center; gap: 4px; cursor: pointer; color: #d9534f; font-size: 13px;">
                        <input type="checkbox" name="fileDelete" id="fileDel" value="ok"> 
                        삭제하기
                    </label>
                </div>
            </c:if>

            <input type="file" name="file" id="file" class="wid100" onchange="checkFileSelection(this)"/> 
            
            <p style="margin-top: 8px; font-size: 12px; color: #999;">
                <i class="info-icon">※</i> 새로운 파일을 선택하면 기존 파일은 자동으로 삭제되고 교체됩니다.
            </p>
        </div>
    </td>
</tr>
                </tbody>
            </table>
			
            <div class="btn-area">
                <a href="javascript:history.back();" class="btn-cancel">취소</a>
                <button type="button" class="btn-save" onclick="goSave()">수정하기</button>
            </div>
        </form>
    </div>
</body> 
</html>