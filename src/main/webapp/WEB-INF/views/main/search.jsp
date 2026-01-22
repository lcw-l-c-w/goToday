<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search</title>

<!-- ✅ search 전용 CSS -->
<link rel="stylesheet" href="<c:url value='/css/search.css'/>">
</head>
<body>

<!-- ✅ 공통 네비바 -->
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<%@ include file="/WEB-INF/views/common/recentViewed.jspf" %>
	
<div class="search-page">
  <div class="search-container">

    <!-- 상단 검색바 -->
    <form id="searchForm" class="search-top" action="${pageContext.request.contextPath}/search" method="get">
      <div class="search-input-wrap">
        <input class="search-input" type="search" name="q" value="${search.q}" placeholder="검색어를 입력하세요" autocomplete="off">
        <button type="button" class="clear-btn" id="clearQBtn" aria-label="clear">×</button>
        <button type="submit" class="submit-btn" aria-label="search">🔍</button>
      </div>

      <div class="search-top-right">
        <label class="chk">
          <input type="checkbox" name="onlyFree" value="true" <c:if test="${search.onlyFree}">checked</c:if>>
          무료만
        </label>
        <label class="chk">
          <input type="checkbox" name="hideEnded" value="true" <c:if test="${search.hideEnded}">checked</c:if>>
          종료된 거 숨기기
        </label>
      </div>

      <!-- 페이지(페이지네이션용) -->
      <input type="hidden" id="page" name="page" value="${empty search.page ? 1 : search.page}">
    </form>

    <!-- 필터 영역(스크린샷 같은 줄 형태) -->
    <div class="filter-box">
      <div class="filter-row">
        <div class="filter-label">카테고리</div>
        <div class="filter-options">
          <label class="opt"><input type="radio" name="content_kind" value="" form="searchForm"
            <c:if test="${empty search.content_kind}">checked</c:if>> 전체</label>
          <label class="opt"><input type="radio" name="content_kind" value="popup" form="searchForm"
            <c:if test="${search.content_kind=='popup'}">checked</c:if>> 팝업</label>
          <label class="opt"><input type="radio" name="content_kind" value="exhibition" form="searchForm"
            <c:if test="${search.content_kind=='exhibition'}">checked</c:if>> 전시회</label>
        </div>
      </div>

      <div class="filter-row">
        <div class="filter-label">지역</div>
        <div class="filter-options">
          <label class="opt"><input type="checkbox" name="place_tag" value="성수" form="searchForm"
            <c:if test="${search.place_tag != null && search.place_tag.contains('성수')}">checked</c:if>> 성수</label>
          <label class="opt"><input type="checkbox" name="place_tag" value="홍대" form="searchForm"
            <c:if test="${search.place_tag != null && search.place_tag.contains('홍대')}">checked</c:if>> 홍대</label>
          <label class="opt"><input type="checkbox" name="place_tag" value="여의도" form="searchForm"
            <c:if test="${search.place_tag != null && search.place_tag.contains('여의도')}">checked</c:if>> 여의도</label>
          <label class="opt"><input type="checkbox" name="place_tag" value="강남" form="searchForm"
            <c:if test="${search.place_tag != null && search.place_tag.contains('강남')}">checked</c:if>> 강남</label>
          <label class="opt"><input type="checkbox" name="place_tag" value="혜화" form="searchForm"
            <c:if test="${search.place_tag != null && search.place_tag.contains('혜화')}">checked</c:if>> 혜화</label>
          <label class="opt"><input type="checkbox" name="place_tag" value="한남" form="searchForm"
            <c:if test="${search.place_tag != null && search.place_tag.contains('한남')}">checked</c:if>> 한남</label>
          <label class="opt"><input type="checkbox" name="place_tag" value="etc" form="searchForm"
            <c:if test="${search.place_tag != null && search.place_tag.contains('etc')}">checked</c:if>> etc</label>
        </div>
      </div>

      <div class="filter-row">
        <div class="filter-label">분야</div>
        <div class="filter-options">
          <label class="opt"><input type="checkbox" name="category" value="식품" form="searchForm"
            <c:if test="${search.category != null && search.category.contains('식품')}">checked</c:if>> 식품</label>
          <label class="opt"><input type="checkbox" name="category" value="캐릭터" form="searchForm"
            <c:if test="${search.category != null && search.category.contains('캐릭터')}">checked</c:if>> 캐릭터</label>
          <label class="opt"><input type="checkbox" name="category" value="화장품" form="searchForm"
            <c:if test="${search.category != null && search.category.contains('화장품')}">checked</c:if>> 화장품</label>
          <label class="opt"><input type="checkbox" name="category" value="미디어" form="searchForm"
            <c:if test="${search.category != null && search.category.contains('미디어')}">checked</c:if>> 미디어</label>
          <label class="opt"><input type="checkbox" name="category" value="미술" form="searchForm"
            <c:if test="${search.category != null && search.category.contains('미술')}">checked</c:if>> 미술</label>
          <label class="opt"><input type="checkbox" name="category" value="패션" form="searchForm"
            <c:if test="${search.category != null && search.category.contains('패션')}">checked</c:if>> 패션</label>
          <label class="opt"><input type="checkbox" name="category" value="디지털/테크" form="searchForm"
            <c:if test="${search.category != null && search.category.contains('디지털/테크')}">checked</c:if>> 디지털/테크</label>
          <label class="opt"><input type="checkbox" name="category" value="키즈/반려동물" form="searchForm"
            <c:if test="${search.category != null && search.category.contains('키즈/반려동물')}">checked</c:if>> 키즈/반려동물</label>
          <label class="opt"><input type="checkbox" name="category" value="etc" form="searchForm"
            <c:if test="${search.category != null && search.category.contains('etc')}">checked</c:if>> etc</label>
        </div>
      </div>

      <div class="filter-row">
        <div class="filter-label">예약 여부</div>
        <div class="filter-options">
          <label class="opt"><input type="radio" name="reservation_type" value="" form="searchForm"
            <c:if test="${empty search.reservation_type}">checked</c:if>> 전체</label>
          <label class="opt"><input type="radio" name="reservation_type" value="false" form="searchForm"
            <c:if test="${search.reservation_type == 'false'}">checked</c:if>> 현장 입장</label>
          <label class="opt"><input type="radio" name="reservation_type" value="true" form="searchForm"
            <c:if test="${search.reservation_type == 'true'}">checked</c:if>> 예매 필수</label>
        </div>
      </div>

      <div class="filter-row">
        <div class="filter-label">정렬</div>
        <div class="filter-options">
          <select name="sort" form="searchForm" class="sort-select">
            <option value="relevance" <c:if test="${empty search.sort || search.sort=='relevance'}">selected</c:if>>관련도</option>
            <option value="newest" <c:if test="${search.sort=='newest'}">selected</c:if>>최신순</option>
            <option value="popular" <c:if test="${search.sort=='popular'}">selected</c:if>>인기순</option>
          </select>

          <button type="submit" form="searchForm" class="apply-btn">조건 적용</button>
        </div>
      </div>
    </div>

    <!-- 결과 리스트 -->
    <div class="result-box">
      <c:forEach var="item" items="${searchList}">
        <div class="result-row">

          <div class="col-poster">
            <div class="poster-box">
                <a class="poster-link"
       				href="${pageContext.request.contextPath}/detail/${item.content_id}">
              		<img class="poster-img" src="<c:url value='${item.main_image_path}'/>" alt="poster">

              <!-- ✅ 오픈예정 D-day: dday > 0 일 때만 -->
              <c:if test="${item.dday != null && item.dday > 0}">
                <span class="dday">D-${item.dday}</span>
              </c:if>
            </a>
          </div>
        </div>

          <div class="col-title">
            <!-- 예약태그 -->
            <div class="mini-tag">
              <c:choose>
                <c:when test="${item.reservation_type == 'true'}">예매 필수</c:when>
                <c:otherwise>현장 입장</c:otherwise>
              </c:choose>
            </div>

            <a class="title-link" href="${pageContext.request.contextPath}/detail/${item.content_id}">
              ${item.title}
            </a>
          </div>

          <div class="col-period">
            <!-- Service에서 만든 periodText 사용 -->
            ${item.periodText}
          </div>

          <div class="col-place">
            ${item.location}
          </div>

        </div>
      </c:forEach>
    </div>

    <!-- 페이지네이션 -->
    <c:if test="${pageInfo.totalPage > 1}">
      <div class="pagination">

        <c:if test="${pageInfo.prev}">
          <button type="button" class="page-btn"
            onclick="goPage(${pageInfo.startPage - 1});">이전</button>
        </c:if>

        <c:forEach var="p" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
          <c:choose>
            <c:when test="${p == pageInfo.page}">
              <button type="button" class="page-btn active" disabled>${p}</button>
            </c:when>
            <c:otherwise>
              <button type="button" class="page-btn" onclick="goPage(${p});">${p}</button>
            </c:otherwise>
          </c:choose>
        </c:forEach>

        <c:if test="${pageInfo.next}">
          <button type="button" class="page-btn"
            onclick="goPage(${pageInfo.endPage + 1});">다음</button>
        </c:if>

      </div>
    </c:if>

  </div>
</div>

<script>
(function () {
  const form = document.getElementById("searchForm");
  const page = document.getElementById("page");
  const clearBtn = document.getElementById("clearQBtn");
  const qInput = form.querySelector("input[name='q']");

  // ✅ 새 검색(조건 적용/검색)하면 1페이지부터
  form.addEventListener("submit", function () {
    if (form.dataset.goPage === "1") return; // 페이지네이션 이동이면 유지
    page.value = "1";
  });

  // 검색어 X 버튼
  clearBtn.addEventListener("click", function(){
    qInput.value = "";
    qInput.focus();
  });

  // 페이지네이션 함수
  window.goPage = function (p) {
    page.value = String(p);
    form.dataset.goPage = "1";
    form.submit();
    form.dataset.goPage = "";
  };
})();
</script>

</body>
</html>
