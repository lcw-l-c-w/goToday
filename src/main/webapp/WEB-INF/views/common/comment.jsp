<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<p><span><strong>총 ${comment.totalCount}개</strong>  |  ${commentVO.page}/${comment.totalPage}페이지</span></p>
                <table class="list">
                    <colgroup>
                        <col width="80px" />
                        <col width="*" />
                        <col width="100px" />
                        <col width="200px" />
                    </colgroup>
                    <tbody>
                    <c:if test="${empty comment.list}">
                        <tr>
                            <td class="first" colspan="8">등록된 글이 없습니다.</td>
                        </tr>
                    </c:if>
                    <c:if test="${!empty comment.list }">
                    <c:forEach var="vo" items="${comment.list}">
                        <tr>
                            <td>${vo.no}</td>
                            <td class="txt_l" style="text-align:left;">
                            	<!-- 댓글 삭제 // 세션의 no와 CommentVO 객체의 user_no와 일치하는 경우에만(댓글 작성자만) 삭제할 수 있도록 -->
                            	${vo.content} <c:if test="${loginSess.no == vo.writer}"><a href="javascript:commentDel(${vo.no});">[삭제]</a></c:if>
                            </td>
                            <td class="writer">
                                ${vo.writer_name}
                            </td>
                            <td class="date">
                            <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${vo.regdate}" />
                            </td>
                        </tr>
                    </c:forEach>
                    </c:if>
                    </tbody>
                </table>
                <!-- 페이지 처리 -->
                    <div class="pagenate clear">
                        <ul class='paging'>
                        <!-- prev 버튼 있는 경우 -->
                        <c:if test="${comment.prev == true}">
                        		<!-- prev 버튼 클릭시 stype, sword 값을 그대로 가지고 이전 페이지로 이동 -->
                        		<li><a href="javascript:getComment(${comment.startPage-1})"><-</a>
                        	</c:if>
                        	<c:forEach var="p" begin="${comment.startPage}" end="${comment.endPage}">
	                            <li><a href='javascript:getComment(${p});'
	                            <c:if test="${commentVO.page == p}">class='current'</c:if>>${p}</a></li>
	                        </c:forEach>
	                        <c:if test="${comment.next == true}">
                        		<li><a href="javascript:getComment(${comment.endPage+1})">-></a>
                        	</c:if>
                        </ul>
                    </div>