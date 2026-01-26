<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GoToday | 문의사항</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    
    <style>
        /* 기초 레이아웃 */
        body { font-family: 'Pretendard', sans-serif; margin: 0; padding: 0; background-color: #fff; }
        .wrap { width: 100%; }
        
        /* 탭 내부 컨테이너 */
        .dynamic-list-container { max-width: 1100px; margin: 0 auto; padding: 40px 20px; }
        
        /* 헤더 영역 (총 건수 & 버튼) */
        .list-info-header { 
            display: flex; justify-content: space-between; align-items: flex-end;
            padding-bottom: 20px; border-bottom: 2px solid #333; margin-bottom: 10px;
        }
        .total-count { font-size: 16px; color: #333; }
        .total-count strong { color: #4dc3ff; font-size: 18px; }
        
        /* 작성하기 버튼 */
        .btn-write {
            padding: 10px 24px; background: #333; color: #fff;
            border-radius: 4px; font-weight: 500; font-size: 14px;
            transition: 0.2s; border: none; cursor: pointer;
        }
        .btn-write:hover { background: #555; transform: translateY(-1px); }

        /* 리스트 테이블 */
        .custom-table { width: 100%; border-collapse: collapse; table-layout: fixed; }
        .custom-table th { 
            padding: 15px 10px; text-align: center; color: #666;
            font-weight: 600; font-size: 15px; border-bottom: 1px solid #eee;
        }
        .custom-table td { 
            padding: 20px 10px; text-align: center; border-bottom: 1px solid #f9f9f9;
            font-size: 15px; color: #444; vertical-align: middle;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        
        /* 제목(문의내용) 왼쪽 정렬 및 들여쓰기 */
        .text-left { text-align: left !important; padding-left: 20px !important; }
        .title-link { color: #333; text-decoration: none; font-weight: 500; cursor: pointer; }
        .title-link:hover { color: #4dc3ff; text-decoration: underline; }
        
        /* 답변(들여쓰기) 아이콘 */
        .reply-icon { color: #999; font-size: 13px; margin-right: 4px; }

        /* 배지 스타일 */
        .badge {
            padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;
            display: inline-block;
        }
        .badge-waiting { background: #f2f2f2; color: #888; }
        .badge-done { background: #eaf7ff; color: #2b7fc2; }
        
        /* 데이터 없을 때 */
        .empty-msg { 
            text-align: center; padding: 100px 0 !important; color: #bbb; 
            font-size: 16px; background: #fafafa; border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="wrap">
        <div class="dynamic-list-container">
            <div class="list-info-header">
                <button type="button" class="btn-write" onclick="goWriteForm()" >문의하기</button>
            </div>

            <table class="custom-table">
                <colgroup>
                    <col style="width: 110px;"> <col style="width: auto;">  <col style="width: 150px;"> <col style="width: 150px;"> </colgroup>
                <thead>
                    <tr>
                        <th>상태</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty list}">
                            <c:forEach var="item" items="${list}">
                                <tr>
                                    <td>
                                        <span class="badge ${item.reply_status == 1 ? 'badge-done' : 'badge-waiting'}">
                                            ${item.reply_status == 1 ? '답변완료' : '답변대기'}
                                        </span>
                                    </td>
                                    <td class="text-left">
                                        <div style="padding-left: ${item.nested * 20}px;">
                                            <c:if test="${item.nested > 0}">
                                                <span class="reply-icon">└ [답변]</span>
                                            </c:if>
                                            
                                            <c:if test="${item.secret == 1}">
                                                <span title="비밀글">🔒</span>
                                            </c:if>
                                            
                                            <a class="title-link" onclick="goDetail('${item.creply_id}', '${item.secret}', '${item.user_id}')">
                                                ${item.title}
                                            </a>
                                        </div>
                                    </td>
                                    <td>${item.writer}</td>
                                    <td style="color: #999;">
                                        <fmt:parseDate value="${item.created_at}" var="parsedDate" pattern="yyyy-MM-dd HH:mm:ss"/>
    
  										  <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4" class="empty-msg">등록된 문의사항이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // 글쓰기 페이지 이동
        function goWriteForm() {
            
    	var content_id= $("#content_id").val();
    	if(!content_id) {
            // 부모창에 id="content_id"가 없을 경우를 대비한 2차 시도
            content_id = "${list[0].content_id}"; 
        }

        if(!content_id) {
            alert("게시글 정보를 가져올 수 없습니다.");
            return;
        }
            // 단순 이동이 가장 확실하고 빠릅니다.
            location.href = "${pageContext.request.contextPath}/detail/tab/inquiry/write/"+content_id;
                    }

        // 상세 보기 이동
        function goDetail(creply_id, isSecret, authorId) {
            // 비밀글이고 본인이 아닌 경우에 대한 처리
            // 비밀글(1)인 경우
    if(isSecret === '1') {
        // 본인도 아니고 관리자(벤더)도 아닌 경우
        if(currentUserId != authorId && userRole != '1') {
            alert("비밀글은 작성자만 확인할 수 있습니다.");
            return;
        }
    }
            location.href = "${pageContext.request.contextPath}/inquiry/detail/" + creply_id;
        }
    </script>
</body>
</html>