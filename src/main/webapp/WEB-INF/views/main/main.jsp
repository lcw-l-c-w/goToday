<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GoToday Main</title>
    <!-- ✅ main 전용 CSS -->
<link rel="stylesheet" href="<c:url value='/css/main.css'/>">
 
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<%@ include file="/WEB-INF/views/common/recentViewed.jspf" %>
	
   <main class="main-wrapper">
        <section class="main-banner">
            <button class="banner-btn btn-prev" id="slidePrev">&lt;</button>
            <ul id="slideList">
                <c:forEach var="item" items="${random}">
                    <li class="banner-card" onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
                        <img src="<c:url value='${item.main_image_path}'/>">
                        <div class="banner-info">
                            <h3>${item.title}</h3>
                            <p>운영 기간 | ${item.start_at.substring(0,10)} ~ ${item.end_at.substring(0,10)}</p>
                        </div>
                    </li>
                </c:forEach>
            </ul>
            <button class="banner-btn btn-next" id="slideNext">&gt;</button>
        </section>

        <section class="recommend-section">
            <h2 class="section-title">추천 컨텐츠</h2>
            
            <%-- 통합 로직: 로그인 여부 및 추천 리스트 비어있음 확인 --%>
            <c:set var="isLoggedIn" value="${not empty loginSess}" />
            <c:set var="isTagEmpty" value="${empty recommend}" />
            <c:set var="isBlur" value="${!isLoggedIn or isTagEmpty}" />

            <%-- 블러 조건 충족 시 안내 오버레이 표시 --%>
            <c:if test="${isBlur}">
                <div class="cta-overlay">
                    <c:choose>
                        <%-- 로그인 전일 때 --%>
                        <c:when test="${!isLoggedIn}">
                            <h3>로그인이 필요한 서비스입니다</h3>
                            <p>로그인하시면 당신의 취향에 딱 맞는<br>멋진 전시들을 추천해드려요!</p>
                            <a href="${pageContext.request.contextPath}/member/login" class="cta-btn">로그인하러 가기</a>
                        </c:when>
                        <%-- 로그인 했으나 추천 데이터(관심사)가 없을 때 --%>
                        <c:when test="${isTagEmpty}">
                            <h3>관심사 등록 전이신가요?</h3>
                            <p>관심사를 설정하면 당신만을 위한<br>특별한 맞춤 전시를 추천해드려요!</p>
                            <a href="${pageContext.request.contextPath}/mypage/interest" class="cta-btn">관심사 설정하기</a>
                        </c:when>
                    </c:choose>
                </div>
            </c:if>

            <div class="recommend-container">
                <button class="recommend-btn rec-prev" id="recPrev">&lt;</button>
                <div class="recommend-view">
                    <%-- 조건에 따라 blur-container 클래스 동적 부여 --%>
                    <div id="recList" class="content-list horizontal ${isBlur ? 'blur-container' : ''}">
                        <c:forEach var="item" items="${recommend}">
                            <article class="content-card" onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
                                <div class="card-img-wrap">
                                    <img src="<c:url value='${item.main_image_path}'/>">
                                </div>
                                <div class="content-body">
                                    <h4 style="margin-bottom: 5px; font-size: 15px;">${item.title}</h4>
                                    <p style="font-size: 13px; color: #888;">${item.location}</p>
                                </div>
                            </article>
                        </c:forEach>
                        
                        <%-- 데이터가 없을 때 레이아웃 무너짐 방지 --%>
                        <c:if test="${empty recommend}">
                            <div style="height:280px; width:100%;"></div>
                        </c:if>
                    </div>
                </div>

                <button class="recommend-btn rec-next" id="recNext">&gt;</button>
            </div>
        </section>

        <section>
            <h2 class="section-title">HOT 콘텐츠</h2>
            <div class="hot-grid-container">
                <c:if test="${not empty popularList}">
                    <div class="hot-main" onclick="location.href='${pageContext.request.contextPath}/detail/${popularList[0].content_id}'">
                        <img src="<c:url value='${popularList[0].main_image_path}'/>">
                        <div class="banner-info" style="padding: 20px;"><h3>${popularList[0].title}</h3></div>
                    </div>
                    <div class="hot-sub-grid">
                        <c:forEach var="item" items="${popularList}" begin="1" end="6">
                            <div class="sub-card" onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
                                <img src="<c:url value='${item.main_image_path}'/>">
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </section>

<section class="upcoming-section" style="padding-bottom: 100px;">
  <h2 class="section-title">오픈 예정 콘텐츠</h2>

  <div class="upcoming-container">
    <button class="recommend-btn rec-prev" id="upPrev">&lt;</button>

    <div class="upcoming-view" id="upView">
      <div class="content-list horizontal" id="upList">
        <c:forEach var="item" items="${upcomingList}">
          <article class="content-card"
              onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
            <div class="card-img-wrap">
              <c:if test="${not empty item.dday}">
                <span class="d-day-badge">D-${item.dday}</span>
              </c:if>
              <img src="<c:url value='${item.main_image_path}'/>">
            </div>
            <h4 style="margin: 8px 0 4px; font-size: 15px;">${item.title}</h4>
            <p style="font-size: 13px; color: #999;">${item.periodText}</p>
          </article>
        </c:forEach>
      </div>
    </div>

    <button class="recommend-btn rec-next" id="upNext">&gt;</button>
  </div>
</section>

    </main>

    <script>
        window.addEventListener("load", function() {
            // 1. 메인 배너
            const slideList = document.getElementById('slideList');
            const bannerSlides = slideList ? slideList.querySelectorAll('.banner-card') : [];
            let bannerIdx = 0;
            if (bannerSlides.length > 1) {
                document.getElementById('slidePrev').onclick = () => {
                    bannerIdx = (bannerIdx - 1 + bannerSlides.length) % bannerSlides.length;
                    slideList.style.transform = `translateX(-\${bannerIdx * 100}%)`;
                };
                document.getElementById('slideNext').onclick = () => {
                    bannerIdx = (bannerIdx + 1) % bannerSlides.length;
                    slideList.style.transform = `translateX(-\${bannerIdx * 100}%)`;
                };
            }

         // 2. 추천 컨텐츠 슬라이드 로직 (scroll 방식: 1개씩 이동)
            const view = document.querySelector('.recommend-view');
            const recPrev = document.getElementById('recPrev');
            const recNext = document.getElementById('recNext');
            const firstCard = document.querySelector('#recList .content-card');

            if (view && firstCard && recPrev && recNext) {
              const listStyle = getComputedStyle(document.getElementById('recList'));
              const gap = parseFloat(listStyle.gap || listStyle.columnGap || 0);
              const step = firstCard.offsetWidth + gap;

              recPrev.onclick = () => view.scrollBy({ left: -step, behavior: 'smooth' });
              recNext.onclick = () => view.scrollBy({ left: step, behavior: 'smooth' });

              // “5개 이하이면 버튼 숨김” (원하면 유지)
              const recCards = document.querySelectorAll('#recList .content-card');
              if (recCards.length <= 5) {
                recPrev.style.display = 'none';
                recNext.style.display = 'none';
              }
            } else {
              if (recPrev) recPrev.style.display = 'none';
              if (recNext) recNext.style.display = 'none';
            }

         // 3. 오픈 예정 컨텐츠: 버튼으로 1개씩 이동
            const upView = document.getElementById('upView');
            const upPrev = document.getElementById('upPrev');
            const upNext = document.getElementById('upNext');
            const upFirstCard = document.querySelector('#upList .content-card');

            if (upView && upPrev && upNext && upFirstCard) {
              const upListStyle = getComputedStyle(document.getElementById('upList'));
              const upGap = parseFloat(upListStyle.gap || upListStyle.columnGap || 0);
              const upStep = upFirstCard.offsetWidth + upGap;

              upPrev.onclick = () => upView.scrollBy({ left: -upStep, behavior: 'smooth' });
              upNext.onclick = () => upView.scrollBy({ left: upStep, behavior: 'smooth' });

              // 카드가 5개 이하이면 버튼 숨김(원하면)
              const upCards = document.querySelectorAll('#upList .content-card');
              if (upCards.length <= 5) {
                upPrev.style.display = 'none';
                upNext.style.display = 'none';
              }
            } else {
              if (upPrev) upPrev.style.display = 'none';
              if (upNext) upNext.style.display = 'none';
            }


      
        });
    </script>
</body>
</html>