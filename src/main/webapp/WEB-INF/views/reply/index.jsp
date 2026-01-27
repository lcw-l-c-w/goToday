<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isIframe" value="${param.isIframe}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>Q&A</title>
<META name="viewport"
	content="width=device-width, height=device-height, initial-scale=1.0, user-scalable=no">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />
<link rel="stylesheet" href="${ctx}/css/reset.css" />
<link rel="stylesheet" href="${ctx}/css/contents.css" />
<script>
	
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
					<h3 class="sub_title">고객 문의사항</h3>
					<div class="bbs">
						<div class="list-wrap">
							<table class="list">
								<p>
									<span><strong>총 ${map.count }개</strong> | ${replyVO.page }/${map.totalPage }페이지</span>
								</p>
								<p class="btnSet" style="text-align: right; margin-top: -30px;">
									<c:if test="${!empty loginSess}">
										<a class="btn" href="write?isIframe=${isIframe}">문의사항 남기기</a>
									</c:if>
									<c:if test="${empty loginSess}">
										<br>
									</c:if>
								</p>
								<caption>게시판 목록</caption>
								<colgroup>
									<col width="10%" />
									<col width="50%" />
									<col width="15%" />
									<col width="25%" />
								</colgroup>
								<thead>
									<tr>
										<th>번호</th>
										<th>제목</th>
										<th>작성자</th>
										<th>작성일</th>
									</tr>
								</thead>
								<tbody>
									<c:if test="${empty map.list }">
										<tr>
											<td class="first" colspan="8">등록된 글이 없습니다.</td>
										</tr>
									</c:if>
									<c:forEach var="vo" items="${map.list }">
										<tr>
											<td>${vo.reply_id }</td>
											<td style="text-align: left;"><a
												href="view?reply_id=${vo.reply_id}&isIframe=${isIframe}">
													${vo.title } <c:if test="${vo.answer_count > 0}">
														<span class="reply-count">[${vo.answer_count}]</span>
													</c:if>
											</a></td>
											<td class="writer"><c:choose>
													<c:when test="${empty vo.writer_name}">
									        관리자
									    </c:when>
													<c:otherwise>
									        ${vo.writer_name}
									    </c:otherwise>
												</c:choose></td>
											<td class="date"><fmt:formatDate
													value="${vo.created_at }" pattern="YYYY-MM-dd" /></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="pagenate">
							<div class="pagenate clear">
								<ul class='paging'>
									<c:if test="${map.isPrev }">
										<li><a
											href="index?page=${map.startPage-1 }&searchType=${replyVO.searchType}&searchWord=${replyVO.searchWord}&isIframe=${isIframe}">
												<< </a></li>
									</c:if>
									<c:forEach var="p" begin="${map.startPage}"
										end="${map.endPage}">
										<c:if test="${p == replyVO.page}">
											<li><a href='#;' class='current'>${p}</a></li>
										</c:if>
										<c:if test="${p != replyVO.page}">
											<li><a
												href='index?page=${p}&searchType=${replyVO.searchType}&searchWord=${replyVO.searchWord}&isIframe=${isIframe}'>${p}</a></li>
										</c:if>
									</c:forEach>
									<c:if test="${map.isNext }">
										<li><a
											href="index?page=${map.endPage+1 }&searchType=${replyVO.searchType}&searchWord=${replyVO.searchWord}&isIframe=${isIframe}">
												>> </a></li>
									</c:if>
								</ul>
							</div>
						</div>
						<!-- 페이지처리 -->
						<div class="bbsSearch">
							<form method="get" name="searchForm" id="searchForm"
								action="index">
								<input type="hidden" name="isIframe" value="${isIframe}">
								<span class="srchSelect"> <select id="stype"
									name="searchType" class="dSelect" title="검색분류 선택">
										<option value="all">전체</option>
										<option value="title"
											<c:if test="${replyVO.searchType == 'title'}">selected</c:if>>제목</option>
										<option value="body"
											<c:if test="${replyVO.searchType == 'body'}">selected</c:if>>내용</option>
								</select>
								</span> <span class="searchWord"> <input type="text" id="sval"
									name="searchWord" value="${replyVO.searchWord}" title="검색어 입력">
									<input type="button" id="" value="검색" title="검색"
									onclick="document.getElementById('searchForm').submit();">
								</span>
							</form>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>