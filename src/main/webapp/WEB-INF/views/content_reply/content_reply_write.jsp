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
    
    <style>
        :root {
            --main-color: #4dc3ff;
            --dark-gray: #333;
            --light-gray: #f9f9f9;
            --border-color: #eee;
        }

        body {
            font-family: 'Pretendard', sans-serif;
            background-color: #fff;
            color: var(--dark-gray);
            margin: 0; padding: 0;
        }

        .container {
            max-width: 900px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .page-header {
            border-bottom: 2px solid var(--dark-gray);
            padding-bottom: 15px;
            margin-bottom: 40px;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            margin: 0;
            letter-spacing: -1px;
        }

        .edit-form-table {
            width: 100%;
            border-collapse: collapse;
        }

        .edit-form-table th {
            width: 120px;
            text-align: left;
            padding: 20px 10px;
            font-size: 15px;
            border-bottom: 1px solid var(--border-color);
            color: #666;
        }

        .edit-form-table td {
            padding: 15px 10px;
            border-bottom: 1px solid var(--border-color);
        }

        input[type="text"] {
            width: 100%;
            height: 45px;
            padding: 0 15px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 15px;
            box-sizing: border-box;
            outline-color: var(--main-color);
        }

        .file-upload-wrapper {
            background: var(--light-gray);
            padding: 15px;
            border-radius: 6px;
            border: 1px dashed #ccc;
        }

        .btn-area {
            margin-top: 40px;
            text-align: center;
            display: flex;
            justify-content: center;
            gap: 12px;
        }

        .btn-save {
            background-color: var(--dark-gray);
            color: white;
            padding: 14px 40px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            border: none;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-save:hover { background-color: #555; }

        .btn-cancel {
            background-color: #fff;
            color: #666;
            padding: 14px 40px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            border: 1px solid var(--border-color);
            transition: 0.3s;
        }

        .btn-cancel:hover { background-color: var(--light-gray); }
    </style>

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