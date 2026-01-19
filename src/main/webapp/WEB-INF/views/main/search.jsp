<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>search</title>
</head>
<body>

    <h2>검색 테스트</h2>

    <form id="searchForm"
        action="${pageContext.request.contextPath}/search" method="get">

        <!-- 검색어 -->
        <div>
            <label>검색어(q):</label>
            <input type="search" name="q"
                value="${search.q}" placeholder="검색어를 입력하세요">
            <button type="submit">검색</button>
        </div>

        <hr>

        <!-- 정렬 -->
        <div>
            <label>정렬(sort):</label>
            <select name="sort">
                <option value="relevance" <c:if test="${empty search.sort}">selected</c:if>>관련도(기본)</option>
                <option value="newest" <c:if test="${search.sort=='newest'}">selected</c:if>>최신순(start_at DESC)</option>
                <option value="popular" <c:if test="${search.sort=='popular'}">selected</c:if>>인기순(좋아요)</option>
            </select>
        </div>

        <hr>

        <!-- 무료만 보기 -->
        <label>
            <input type="checkbox" name="onlyFree" value="true"
                <c:if test="${search.onlyFree}">checked</c:if>>
            무료만 보기
        </label>

        <hr>

        <!-- 콘텐츠 종류(content_kind) : 단일 -->
        <div>
            <label>종류(content_kind):</label>

            <label>
                <input type="radio" name="content_kind" value=""
                    <c:if test="${empty search.content_kind}">checked</c:if>>
                전체
            </label>

            <label>
                <input type="radio" name="content_kind" value="popup"
                    <c:if test="${search.content_kind=='popup'}">checked</c:if>>
                팝업
            </label>

            <label>
                <input type="radio" name="content_kind" value="exhibition"
                    <c:if test="${search.content_kind=='exhibition'}">checked</c:if>>
                전시
            </label>
        </div>

        <hr>

        <!-- 분야(category) : 다중 -->
        <div>
            <label>분야(category, 다중):</label><br>

            <label><input type="checkbox" name="category" value="식품"
                <c:if test="${search.category != null && search.category.contains('식품')}">checked</c:if>>식품</label>

            <label><input type="checkbox" name="category" value="캐릭터"
                <c:if test="${search.category != null && search.category.contains('캐릭터')}">checked</c:if>>캐릭터</label>

            <label><input type="checkbox" name="category" value="화장품"
                <c:if test="${search.category != null && search.category.contains('화장품')}">checked</c:if>>화장품</label>

            <label><input type="checkbox" name="category" value="미디어"
                <c:if test="${search.category != null && search.category.contains('미디어')}">checked</c:if>>미디어</label>

            <label><input type="checkbox" name="category" value="미술"
                <c:if test="${search.category != null && search.category.contains('미술')}">checked</c:if>>미술</label>

            <label><input type="checkbox" name="category" value="패션"
                <c:if test="${search.category != null && search.category.contains('패션')}">checked</c:if>>패션</label>

            <label><input type="checkbox" name="category" value="디지털/테크"
                <c:if test="${search.category != null && search.category.contains('디지털/테크')}">checked</c:if>>디지털/테크</label>

            <label><input type="checkbox" name="category" value="키즈/반려동물"
                <c:if test="${search.category != null && search.category.contains('키즈/반려동물')}">checked</c:if>>키즈/반려동물</label>

            <label><input type="checkbox" name="category" value="etc"
                <c:if test="${search.category != null && search.category.contains('etc')}">checked</c:if>>etc</label>
        </div>

        <hr>

        <!-- 핫플레이스(place_tag) : 다중 -->
        <div>
            <label>핫플(place_tag, 다중):</label><br>

            <label><input type="checkbox" name="place_tag" value="성수"
                <c:if test="${search.place_tag != null && search.place_tag.contains('성수')}">checked</c:if>>성수</label>

            <label><input type="checkbox" name="place_tag" value="홍대"
                <c:if test="${search.place_tag != null && search.place_tag.contains('홍대')}">checked</c:if>>홍대</label>

            <label><input type="checkbox" name="place_tag" value="강남"
                <c:if test="${search.place_tag != null && search.place_tag.contains('강남')}">checked</c:if>>강남</label>

            <label><input type="checkbox" name="place_tag" value="혜화"
                <c:if test="${search.place_tag != null && search.place_tag.contains('혜화')}">checked</c:if>>혜화</label>

            <label><input type="checkbox" name="place_tag" value="여의도"
                <c:if test="${search.place_tag != null && search.place_tag.contains('여의도')}">checked</c:if>>여의도</label>

            <label><input type="checkbox" name="place_tag" value="한남"
                <c:if test="${search.place_tag != null && search.place_tag.contains('한남')}">checked</c:if>>한남</label>

            <label><input type="checkbox" name="place_tag" value="etc"
                <c:if test="${search.place_tag != null && search.place_tag.contains('etc')}">checked</c:if>>etc</label>
        </div>

        <hr>

        <!-- 종료된거 안보기 -->
        <div>
            <label>
                <input type="checkbox" name="hideEnded" value="true"
                    <c:if test="${search.hideEnded}">checked</c:if>>
                종료된 콘텐츠 안보기 (end_at >= NOW)
            </label>
        </div>

        <hr>

        <!-- 예약 여부(reservation_type) : 단일 -->
        <div>
            <label>예약 여부(reservation_type):</label>

            <label>
                <input type="radio" name="reservation_type" value=""
                    <c:if test="${empty search.reservation_type}">checked</c:if>>
                전체
            </label>

            <label>
                <input type="radio" name="reservation_type" value="false"
                    <c:if test="${search.reservation_type == 'false'}">checked</c:if>>
                현장 입장
            </label>

            <label>
                <input type="radio" name="reservation_type" value="true"
                    <c:if test="${search.reservation_type == 'true'}">checked</c:if>>
                예매 필수
            </label>
        </div>

        <!-- 페이지 -->
        <input type="hidden" id="page" name="page"
            value="${empty search.page ? 1 : search.page}">

        <hr>
        <button type="submit">조건 적용해서 검색</button>
    </form>

    <hr>

    <h3>검색 결과</h3>

    <c:if test="${pageInfo.totalPage > 1}">
        <div class="pagination">

            <c:if test="${pageInfo.prev}">
                <button type="button"
                    onclick="document.getElementById('page').value='${pageInfo.startPage - 1}'; document.getElementById('searchForm').submit();">
                    이전</button>
            </c:if>

            <c:forEach var="p" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
                <c:choose>
                    <c:when test="${p == pageInfo.page}">
                        <strong>${p}</strong>
                    </c:when>
                    <c:otherwise>
                        <button type="button"
                            onclick="document.getElementById('page').value='${p}'; document.getElementById('searchForm').submit();">
                            ${p}</button>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${pageInfo.next}">
                <button type="button"
                    onclick="document.getElementById('page').value='${pageInfo.endPage + 1}'; document.getElementById('searchForm').submit();">
                    다음</button>
            </c:if>

        </div>
    </c:if>

    <c:forEach var="item" items="${searchList}">
        <div style="border: 1px solid #ddd; padding: 10px; margin: 10px 0;">
            <div><b>${item.title}</b> (id: ${item.contentId})</div>
            <div>종류: ${item.content_kind} / 카테고리: ${item.category}</div>
            <div>기간: ${item.start_at} ~ ${item.end_at}</div>
            <div>장소: ${item.location}</div>

            <a href="${pageContext.request.contextPath}/content/detail?content_id=${item.contentId}">
                상세 보기
            </a>
        </div>
    </c:forEach>

</body>
</html>
