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
        if (!oEditors.getById["body"]) {
        alert("에디터 로딩 중입니다. 잠시만 기다려주세요.");
        return;
    }
        oEditors[0].exec('UPDATE_CONTENTS_FIELD',[]);
        
        if(!$("#title").val().trim()) {
            alert("제목을 입력해주세요.");
            $("#title").focus();
            return false;
        }
     // --- 비밀글 값 처리 추가 ---
        if ($("#is_secret").is(":checked")) {
            $("#secret").val("1");
        } else {
            $("#secret").val("0");
        }
        // -------------------------
        // 에디터 내용 유효성 검사 (선택사항)
        var content = $("#body").val();
        if( content == ""  || content == null || content == '&nbsp;' || content == '<p>&nbsp;</p>')  {
             alert("내용을 입력해주세요.");
             oEditors[0].exec("FOCUS"); 
             return false;
        }

        $("#frm").submit();
    }
    </script>
</head> 
<body>
    <div class="container">
        <header class="page-header">
            <h1 class="page-title">문의하기</h1>
            <span style="color: #999; font-size: 14px;">궁금하신 내용을 남겨주시면 정성껏 답변드리겠습니다.</span>
        </header>

        <form method="post" name="frm" id="frm" action="${ctx}/detail/tab/inquiry/write" enctype="multipart/form-data">
               <input type="hidden" name="content_id" value="${content_id}" />
            <table class="edit-form-table">
                <tbody>
                    <tr>
                        <th>제목</th>
                        <td>
                            <input type="text" name="title" id="title" placeholder="제목을 입력하세요"/>
                        </td>
                    </tr>
                    <tr>
            <th>공개 여부</th>
            <td>
                <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
                    <input type="checkbox" name="is_secret" id="is_secret" value="1" style="width: 18px; height: 18px;">
                    <span style="font-size: 15px; color: #333;">비밀글로 문의하기</span>
                </label>
                <input type="hidden" name="secret" id="secret" value="0"> </td>
        </tr>
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
                <button type="button" class="btn-save" onclick="javascript:goSave();">등록하기</button>
            </div>
        </form>
    </div>
</body> 
</html>