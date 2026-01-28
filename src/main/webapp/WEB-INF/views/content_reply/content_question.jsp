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
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
    :root {
        --main-color: #4dc3ff;
        --text-dark: #333;
        --text-gray: #666;
        --text-light: #999;
        --border-color: #eee;
        --bg-light: #fcfcfc;
    }

    body { font-family: 'Pretendard', sans-serif; margin: 0; padding: 0; color: var(--text-dark); }

    .dynamic-list-container { max-width: 1000px; margin: 0 auto; padding: 30px 20px; }

    /* 헤더 영역 */
    .list-info-header { 
        display: flex; justify-content: flex-end; /* 버튼만 우측 정렬 */
        padding-bottom: 15px; margin-bottom: 0;
    }

    .btn-write {
        padding: 10px 22px; background: var(--text-dark); color: #fff;
        border-radius: 6px; font-weight: 600; font-size: 14px;
        transition: 0.3s; border: none; cursor: pointer;
    }
    .btn-write:hover { background: #555; }

    /* 테이블 스타일 */
    .custom-table { width: 100%; border-collapse: collapse; border-top: 2px solid var(--text-dark); }
    
    .custom-table th { 
        background-color: #fcfcfc; padding: 16px 10px; text-align: center; 
        color: #444; font-weight: 600; font-size: 14px; border-bottom: 1px solid #ddd;
    }
    
    .custom-table td { 
        padding: 18px 10px; text-align: center; border-bottom: 1px solid var(--border-color);
        font-size: 15px; color: #555; vertical-align: middle;
    }

    /* 제목 영역 특화 */
    .text-left { text-align: left !important; padding-left: 20px !important; }
    .title-wrapper { display: flex; align-items: center; gap: 8px; }
    .title-link { 
        color: var(--text-dark); text-decoration: none; font-weight: 500; 
        cursor: pointer; transition: color 0.2s;
        overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
    }
    .title-link:hover { color: var(--main-color); }

    /* 답변 아이콘 & 비밀글 아이콘 */
    .reply-icon { color: var(--text-light); font-size: 13px; font-weight: 400; }
    .secret-icon { font-size: 12px; color: #ffb800; }

    /* 배지(상태) 스타일 */
    .badge {
        display: inline-flex; align-items: center; justify-content: center;
        width: 70px; height: 26px; border-radius: 4px; font-size: 11px; font-weight: 700;
        letter-spacing: -0.5px;
    }
    .badge-waiting { background: #f5f5f5; color: #999; border: 1px solid #e0e0e0; }
    .badge-done { background: #eaf7ff; color: #2b7fc2; border: 1px solid #cde9ff; }

    /* 담당자 텍스트 스타일 */
    .vendor-label { 
        background: #f0f0f0; color: #777; padding: 2px 6px; 
        border-radius: 3px; font-size: 12px; font-weight: 500; 
    }

    /* 빈 목록 */
    .empty-msg { 
        text-align: center; padding: 80px 0 !important; color: var(--text-light); 
        background: var(--bg-light);
    }
    
    /* 호버 효과 */
    .custom-table tbody tr:hover { background-color: #f9fdff; }
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
                                     <c:if test="${item.nested==0}">
                                        <span class="badge ${item.reply_status == 1 ? 'badge-done' : 'badge-waiting'}">
                                            ${item.reply_status == 1 ? '답변완료' : '답변대기'}
                                        </span>
                                         </c:if>
                                    </td>
                                    <td class="text-left">
                                        <div style="padding-left: ${item.nested * 20}px;">
                                            <c:if test="${item.nested > 0}">
                                                <span class="reply-icon">└ [답변]</span>
                                            </c:if>
                                            
                                            <c:if test="${item.secret == 1}">
                                                <span title="비밀글">🔒</span>
                                            </c:if>
                                            
                                            <a class="title-link" onclick="goDetail('${item.creply_id}', '${item.secret}', '${item.user_id}','${item.vendor_id}')">
                                                ${item.title}
                                            </a>
                                        </div>
                                    </td>
					<td>
    <c:choose>
        <%-- 답변글은 무조건 '담당자' 표시 --%>
        <c:when test="${item.nested > 0}">
            <span class="reply-icon">담당자</span>
        </c:when>

        <c:otherwise>
            <c:choose>
                <%-- [실명 노출 조건] 본인이거나, 총관리자거나, 해당 벤더인 경우 --%>
                <c:when test="${
                                 loginSess.user_id eq item.user_id 
                                || loginSess.role eq 1 
                                || loginSess.user_id eq item.vendor_id}">
                    ${item.writer}
                </c:when>

                <%-- [마스킹 노출 조건] 권한 없는 타인이 비밀글을 볼 때 --%>
                <c:otherwise>
                    <c:set var="wName" value="${item.writer}" />
                    <span >
                        <c:choose>
                            <c:when test="${fn:length(wName) >= 3}">
                                ${fn:substring(wName, 0, 1)}*${fn:substring(wName, fn:length(wName)-1, fn:length(wName))}
                            </c:when>
                            <c:when test="${fn:length(wName) == 2}">
                                ${fn:substring(wName, 0, 1)}*
                            </c:when>
                            <c:otherwise>${wName}</c:otherwise>
                        </c:choose>
                    </span>
                </c:otherwise>
            </c:choose>
        </c:otherwise>
    </c:choose>
</td>
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
    
    var currentUserId = '${loginSess.user_id}';
    var userRole = '${loginSess.role}';

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

        function goDetail(creply_id, isSecret, authorId, vendor_id) {
            // 1. 공개글이면 누구나 통과
            if (isSecret !== '1') {
                location.href = "${pageContext.request.contextPath}/inquiry/detail/" + creply_id;
                return;
            }

            // 2. 비밀글인 경우 권한 확인
            var isAuthor = (currentUserId == authorId);
            var isAdmin = (userRole == '1');
            var isVendor = (currentUserId == vendor_id);

            // 한 명이라도 해당하면 상세페이지 이동
            if (isAuthor || isAdmin || isVendor) {
                location.href = "${pageContext.request.contextPath}/inquiry/detail/" + creply_id;
            } else {
                // 권한 없으면 차단
                alert("비밀글은 작성자 및 담당자만 확인할 수 있습니다.");
            }
        }
    </script>
</body>
</html>