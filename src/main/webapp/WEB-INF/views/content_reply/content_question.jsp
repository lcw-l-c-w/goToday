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
	<link rel="stylesheet" href="<c:url value='/css/inquiry_list.css'/>"> 
	</head>
<body>
    <div class="wrap">
       <div class="dynamic-list-container inquiry-container"
     data-content-id="${content_id}"
     data-ajax-url="${pageContext.request.contextPath}/detail/tab/inquiry">
            <div class="list-info-header">
          
            <c:if test="${loginSess.role==0}">
                <button type="button" class="btn-write" onclick="goWriteForm()" >문의하기</button>
            
			</c:if>
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
                        <c:when test="${not empty inquiryList}">
                            <c:forEach var="item" items="${inquiryList}">
                                <tr>
                                    <td>
                                     <c:if test="${item.nested==0}">
                                        <span class="badge ${item.reply_status == 1 ? 'badge-done' : 'badge-waiting'}">
                                            ${item.reply_status == 1 ? '답변완료' : '답변대기'}
                                        </span>
                                         </c:if>
                                    </td>
                      
                    <td class="text-left">
                        <div style="padding-left: 0px;">
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

                <%-- [실명 노출 조건] 본인이거나, 총관리자거나, 해당 벤더인 경우 --%>
               

                <%-- [마스킹 노출 조건] 권한 없는 타인이 비밀글을 볼 때 --%>
               
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
</td>
                                    <td style="color: #999;">
                                        <fmt:parseDate value="${item.created_at}" var="parsedDate" pattern="yyyy-MM-dd HH:mm:ss"/>
    
  										  <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd"/>
                                    </td>
                                </tr>
                                <c:if test="${not empty item.answers}">
                    <c:forEach var="ans" items="${item.answers}">
                        <tr style="background-color: #f9f9f9; border-bottom: 1px solid #eee;">
                            <td></td> <%-- 답변글은 상태 배지 칸을 비움 --%>
                            <td class="text-left">
                                <div style="padding-left: 20px;">
                                    <span class="reply-icon" style="color: #4dc3ff; font-weight: bold; margin-right: 5px;">└ [답변]</span>
                                    <a class="title-link" onclick="goDetail('${ans.creply_id}', '${item.secret}', '${item.user_id}','${item.vendor_id}')">
                                        문의하신 내용에 대한 담당자의 답변입니다.
                                    </a>
                                </div>
                            </td>
                            <td><span style="color: #666; font-weight: bold;">담당자</span></td>
                            <td style="color: #bbb; font-size: 13px;">
                                <fmt:parseDate value="${ans.created_at}" var="ansDate" pattern="yyyy-MM-dd HH:mm:ss"/>
                                <fmt:formatDate value="${ansDate}" pattern="yyyy-MM-dd"/>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
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
            
            <%-- 페이지네이션: inquiryPageInfo 라는 이름으로 내려온다고 가정 --%>
<c:if test="${not empty inquiryPageInfo and inquiryPageInfo.totalPage > 1}">
  <div class="pagination" style="display:flex;justify-content:center;gap:8px;padding:18px 0 0;">
    
    <c:if test="${inquiryPageInfo.prev}">
      <c:url var="prevUrl" value="/detail/${content_id}">
        <c:param name="tab" value="inquiry"/>
        <c:param name="inquiryPage" value="${inquiryPageInfo.startPage - 1}"/>
      </c:url>
<button type="button" class="inquiry-page" data-page="${inquiryPageInfo.startPage - 1}">이전</button>
    </c:if>

    <c:forEach var="p" begin="${inquiryPageInfo.startPage}" end="${inquiryPageInfo.endPage}">
      <c:url var="pUrl" value="/detail/${content_id}">
        <c:param name="tab" value="inquiry"/>
        <c:param name="inquiryPage" value="${p}"/>
      </c:url>

      <c:choose>
        <c:when test="${p == inquiryPageInfo.page}">
          <button type="button" disabled>${p}</button>
        </c:when>
        <c:otherwise>
  <button type="button"
          class="inquiry-page"
          data-page="${p}">
    ${p}
  </button>        </c:otherwise>
      </c:choose>
    </c:forEach>

    <c:if test="${inquiryPageInfo.next}">
      <c:url var="nextUrl" value="/detail/${content_id}">
        <c:param name="tab" value="inquiry"/>
        <c:param name="inquiryPage" value="${inquiryPageInfo.endPage + 1}"/>
      </c:url>
<button type="button" class="inquiry-page" data-page="${inquiryPageInfo.endPage + 1}">다음</button>
    </c:if>

  </div>
</c:if>
            
        </div>
    </div>

    <script>
    var currentUserId = '${loginSess.user_id}';
    var userRole = '${loginSess.role}';
    const urlParams = new URLSearchParams(window.location.search);

  	const inquiryPage = urlParams.get("inquiryPage") || 1;
        // 글쓰기 페이지 이동
        function goWriteForm() {
            
    	var content_id= $("#content_id").val();
    	if(!content_id) {
            // 부모창에 id="content_id"가 없을 경우를 대비한 2차 시도
            content_id = "${inquiryList[0].content_id}"; 
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
            	location.href = "${pageContext.request.contextPath}/inquiry/detail/" + creply_id;           } else {
                // 권한 없으면 차단
                alert("비밀글은 작성자 및 담당자만 확인할 수 있습니다.");
            }
        }
        
        $(document).on("click", ".inquiry-page", function (e) {
            e.preventDefault();

            const $container = $(this).closest(".inquiry-container");
            const page = $(this).data("page");

            const contentId = $container.data("content-id");
            const url = $container.data("ajax-url");

            if (!contentId || !url) {
                console.error("content_id 또는 ajax url 없음");
                return;
            }

            $.ajax({
                url: url,
                type: "GET",
                data: {
                    content_id: contentId,
                    inquiryPage: page
                },
                success: function (html) {
                    // 현재 inquiry 영역만 다시 그림
                    $container.replaceWith(html);
                },
                error: function () {
                    alert("문의사항을 불러오지 못했습니다.");
                }
            });
        });
        
       
    </script>
</body>
</html>