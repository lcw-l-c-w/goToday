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

        /* 헤더 디자인 (이미지 스타일 반영) */
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

        /* 폼 레이아웃 */
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

        /* 입력 필드 스타일 */
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

        /* 파일 업로드 영역 */
        .file-upload-wrapper {
            background: var(--light-gray);
            padding: 15px;
            border-radius: 6px;
            border: 1px dashed #ccc;
        }

        .existing-file {
            margin-bottom: 10px;
            font-size: 13px;
            color: #888;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* 하단 버튼 (이미지의 '문의하기' 버튼 스타일 반영) */
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

        .btn-save:hover {
            background-color: #555;
        }

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

        .btn-cancel:hover {
            background-color: var(--light-gray);
        }
    </style>

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
        oEditors.getById['content'].exec('UPDATE_CONTENTS_FIELD',[]);
        if ($("#title").length > 0 && !$("#title").val().trim()) {
            alert("제목을 입력해주세요.");
            $("#title").focus();
            return;
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

        <form method="post" name="frm" id="frm" action="/gotoday/detail/tab/inquiry/modify" enctype="multipart/form-data">
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
                                <c:if test="${!empty item.file_path}">
                                    <div class="existing-file">
                                        <input type="checkbox" name="fileDelete" id="fileDel" value="ok"> 
                                        <label for="fileDel" style="cursor:pointer">기존 파일 삭제 (${item.file_path})</label>
                                    </div>
                                </c:if>
                                <input type="file" name="file" id="file" class="wid100"/>
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