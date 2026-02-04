<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GoToday Main</title>
    <!--  main 전용 CSS -->
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
            <c:set var="isTagEmpty" value="${not empty recommend and recommend[0].blur}" />
            <c:set var="isBlur" value="${!isLoggedIn or recommend[0].blur}" />

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
                            <a href="${pageContext.request.contextPath}/mypage/main?page=user_like_edit" class="cta-btn">관심사 설정하기</a>
                        </c:when>
                    </c:choose>
                </div>
            </c:if>

            <div class="recommend-container">
               
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
        
        <div class="ad-wrap" onclick="location.href='${pageContext.request.contextPath}/detail/20'">
		    <img class="ad" src="${pageContext.request.contextPath}/img/전지적독자시점.png">
		</div>

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
	<jsp:include page="/WEB-INF/views/common/footer.jsp" />
    <script>
    window.addEventListener("load", function() {
        // 1. 메인 배너 로직
        const slideList = document.getElementById('slideList');
        const bannerSlides = slideList ? slideList.querySelectorAll('.banner-card') : [];
        let bannerIdx = 0;
        let slideTimer;

        if (bannerSlides.length > 1) {
            // [수정] 슬라이드 이동 핵심 함수
            function moveSlide(index) {
                bannerIdx = index;
                if (bannerIdx >= bannerSlides.length) bannerIdx = 0;
                if (bannerIdx < 0) bannerIdx = bannerSlides.length - 1;
                
                // JSP 환경이므로 \${} 형태로 작성하여 간섭 방지
                slideList.style.transform = `translateX(-\${bannerIdx * 100}%)`;
                resetTimer(); 
            }

       
            // 5초 자동 재생
            function startTimer() {
                slideTimer = setInterval(() => {
                    moveSlide(bannerIdx + 1);
                }, 5000);
            }

            function resetTimer() {
                clearInterval(slideTimer);
                startTimer();
            }

            // [수정] 버튼 클릭 시에도 moveSlide 함수를 호출해야 함
            document.getElementById('slidePrev').onclick = () => {
                moveSlide(bannerIdx - 1);
            };
            
            document.getElementById('slideNext').onclick = () => {
                moveSlide(bannerIdx + 1);
            };

            // 배너에 마우스 올리면 정지, 떼면 다시 시작 (편의기능)
            const bannerArea = document.querySelector('.main-banner');
            bannerArea.onmouseenter = () => clearInterval(slideTimer);
            bannerArea.onmouseleave = () => startTimer();

            startTimer(); // 최초 시작
        }

     // --- 2. 오픈 예정 콘텐츠 슬라이드 (수정본) ---
        const upView = document.getElementById('upView');
        const upPrev = document.getElementById('upPrev');
        const upNext = document.getElementById('upNext');
        const upFirstCard = document.querySelector('#upList .content-card');

        if (upView && upPrev && upNext && upFirstCard) {
            // gap 값을 가져오되, 실패할 경우 기본값 15를 사용
            const upListStyle = getComputedStyle(document.getElementById('upList'));
            const gapValue = parseFloat(upListStyle.gap || upListStyle.columnGap);
            const upGap = isNaN(gapValue) ? 15 : gapValue; 
            
            // 이동할 한 칸의 거리 계산
            const upStep = upFirstCard.offsetWidth + upGap;

            // 다음 버튼 클릭
            upNext.onclick = () => {
                upView.scrollBy({ left: upStep, behavior: 'smooth' });
            };

            // 이전 버튼 클릭
            upPrev.onclick = () => {
                upView.scrollBy({ left: -upStep, behavior: 'smooth' });
            };

            // 데이터가 화면(보통 5개)보다 적으면 버튼을 숨기되, 테스트를 위해 숫자를 확인하세요.
            const upCards = document.querySelectorAll('#upList .content-card');
            if (upCards.length > 5) {
                upPrev.style.display = 'flex';
                upNext.style.display = 'flex';
            } else {
                // 항목이 적을 때는 버튼 숨김
                upPrev.style.display = 'none';
                upNext.style.display = 'none';
            }
        }

    });
    </script>
</body>
</html>