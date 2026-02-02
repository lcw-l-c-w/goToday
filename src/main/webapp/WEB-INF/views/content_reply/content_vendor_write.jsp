<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head> 
    <meta charset="utf-8">
    <title>GoToday | 문의하기</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"> 
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="${ctx}/smarteditor/js/HuskyEZCreator.js"></script>
    <link rel="stylesheet" href="${ctx}/css/write.css">
   

    <script>
    let isSubmitting = false;
    $(document).ready(function() {
        // 컨트롤러에서 보낸 FlashAttribute "msg"를 확인
        var message = "${msg}"; 
        if(message) {
            alert(message);
        }
    });
    var oEditors = [];
    $(function() {
        nhn.husky.EZCreator.createInIFrame({
            oAppRef: oEditors,
            elPlaceHolder: "body",
            sSkinURI: "${ctx}/smarteditor/SmartEditor2Skin.html",    
            htParams : {
                bUseToolbar : true,
                bUseVerticalResizer : true,
                bUseModeChanger : true,
                fOnBeforeUnload : function(){
                }
                
            },   fOnAppLoad : function() {
                console.log("editor ready");
            },
            fCreator: "createSEditor2"
        });
    });

    function goSave() {
        // 스마트에디터의 내용을 textarea에 동기화
           // 🔒 중복 실행 방지
    if (isSubmitting) {
        return;
    }
        if (!oEditors.getById["body"]) {
        alert("에디터 로딩 중입니다. 잠시만 기다려주세요.");
        return;
    }
        oEditors[0].exec('UPDATE_CONTENTS_FIELD',[]);
        
        if ($("#title").length > 0 && !$("#title").val().trim()) {
            alert("제목을 입력해주세요.");
            $("#title").focus();
            return;
        }
        
        // 에디터 내용 유효성 검사 (선택사항)
        var content = $("#body").val();
        if( content == ""  || content == null || content == '&nbsp;' || content == '<p>&nbsp;</p>')  {
             alert("내용을 입력해주세요.");
             oEditors[0].exec("FOCUS"); 
             return false;
        }
        // 🔒 여기서 잠금
        isSubmitting = true;
        // 버튼 비활성화 + UX
        $(".btn-save")
            .prop("disabled", true)
            .text("등록 중...")
            .css("pointer-events", "none");

        $("#frm").submit();
    }
    </script>
</head> 
<body>
    <div class="container">
        <header class="page-header">
            <h1 class="page-title">답변하기</h1>
            <span style="color: #999; font-size: 14px;">가능하면 상세하게 답변부탁드리겠습니다.</span>
        </header>

        <form method="post" name="frm" id="frm" action="${ctx}/detail/inquiry/write/vendor.do" enctype="multipart/form-data">
                <input type="hidden" name="content_id" value="${parent.content_id}" />
  			<input type="hidden" name="gno" value="${parent.gno}" />           
   				<input type="hidden" name="ono" value="${parent.ono}" />           
  				<input type="hidden" name="nested" value="${parent.nested}" />
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
                    <tr>
                        <th>내용</th>
                        <td>
                            <textarea name="body" id="body" style="width:100%; height:400px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>첨부파일</th>
                        <td>
                            <div class="file-upload-wrapper">
                                <input type="file" name="file" id="file" class="wid100"/>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="btn-area">
                <a href="javascript:history.back();" class="btn-cancel">취소</a>
                <button type="button" class="btn-save" onclick="javascript:goSave();">
                
                등록하기</button>
            </div>
        </form>
    </div>
</body> 
</html>