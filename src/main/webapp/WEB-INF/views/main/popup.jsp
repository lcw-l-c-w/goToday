<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>POPUP</title>
<!-- ✅ popup 전용 CSS -->
<link rel="stylesheet" href="<c:url value='/css/popup.css'/>">
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<%@ include file="/WEB-INF/views/common/recentViewed.jspf" %>

	<main class="main-wrapper">
		<section class="exhibit-banner-section">
			<div class="banner-container">
				<button class="slide-btn btn-l" id="exPrev">〈</button>
				<ul class="banner-track" id="exTrack">
					<c:forEach var="item" items="${random}">
						<li class="exhibit-banner-card"
							onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
							<img src="<c:url value='${item.main_image_path}'/>">
							<div class="banner-overlay">
								<h3>${item.title}</h3>
								<p>운영 기간 | ${item.start_at.substring(0,10)} ~ ${item.end_at.substring(0,10)}</p>
								<p>${item.location}</p>
							</div>
						</li>
					</c:forEach>
				</ul>
				<button class="slide-btn btn-r" id="exNext">〉</button>
			</div>
			<div class="indicator-dots" id="exDots"></div>
		</section>

		<h2 class="section-title">추천 전시</h2>
		<section class="recommend-section">
			<%-- 컨트롤러 세션명 loginSess와 일치시킴 --%>
			<%-- 1. 로그인 여부 확인 (세션 이름 확인 필수) --%>
			<c:set var="isLoggedIn" value="${not empty loginSess}" />

			<%-- 2. 추천 리스트가 비어있는지 확인 --%>
			<%-- 기존의 recommand[0].blur 조건이 까다로워서 오작동할 확률이 높으므로 단순화합니다 --%>
			<c:set var="isTagEmpty" value="${ not empty recommend and recommend[0].blur}" />

			<%-- 3. 블러 처리 여부 결정: 로그인을 안 했거나, 추천 데이터가 아예 없을 때 --%>
			<c:set var="isBlur" value="${!isLoggedIn or isTagEmpty}" />
			<c:if test="${isBlur}">
				<div class="cta-overlay">
					<c:choose>
						<c:when test="${!isLoggedIn}">
							<h3>로그인이 필요한 서비스입니다</h3>
							<p>
								로그인하시면 당신의 취향에 딱 맞는<br>멋진 전시들을 추천해드려요!
							</p>
							<a href="${pageContext.request.contextPath}/member/login"
								class="cta-btn">로그인하러 가기</a>
						</c:when>
						<c:when test="${isTagEmpty}">
							<h3>관심사 등록 전이신가요?</h3>
							<p>
								관심사를 설정하면 당신만을 위한<br>특별한 맞춤 전시를 추천해드려요!
							</p>
							<a href="${pageContext.request.contextPath}/mypage/user_like_edit"
								class="cta-btn">관심사 설정하기</a>
						</c:when>
					</c:choose>
				</div>
			</c:if>

			<div class="recommend-container">
				
				<div class="recommend-view">
					<div id="recList"
						class="content-list horizontal ${isBlur ? 'blur-container' : ''}">
						<c:forEach var="item" items="${recommend}">
							<article class="content-card"
								onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
								<div class="card-img-wrap">
									<img src="<c:url value='${item.main_image_path}'/>">
								</div>
								<div class="content-body">
									<h4 style="margin-bottom: 5px; font-size: 15px;">${item.title}</h4>
									<p style="font-size: 13px; color: #888;">${item.location}</p>
								</div>
							</article>
						</c:forEach>
						<c:if test="${empty recommend}">
							<div style="height: 280px; width: 100%;"></div>
						</c:if>
					</div>
				</div>
			</div>
		</section>

		<h2 class="section-title">HOT 콘텐츠</h2>
		<section>
			<div class="hot-grid-container">
				<c:if test="${not empty popularList}">
					<div class="hot-main"
						onclick="location.href='${pageContext.request.contextPath}/detail/${popularList[0].content_id}'">
						<img src="<c:url value='${popularList[0].main_image_path}'/>">
						<div
							style="position: absolute; bottom: 0; left: 0; width: 100%; padding: 25px; background: linear-gradient(transparent, rgba(0, 0, 0, 0.7)); color: white;">
							<h3 style="font-size: 22px;">${popularList[0].title}</h3>
						</div>
					</div>
					<div class="hot-sub-grid">
						<c:forEach var="item" items="${popularList}" begin="1" end="6">
							<div class="sub-card"
								onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
								<img src="<c:url value='${item.main_image_path}'/>">
							</div>
						</c:forEach>
					</div>
				</c:if>
			</div>
		</section>

<h2 class="section-title">오픈 예정 콘텐츠</h2>
<section class="upcoming-section" style="padding-bottom: 100px;">
  <div class="upcoming-container">
    <button class="recommend-btn rec-prev" id="upPrev">&lt;</button>

    <div class="upcoming-view" id="upView">
      <div class="content-list horizontal" id="upList">
        <c:forEach var="item" items="${upcomingList}">
          <article class="content-card"
              onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
            <div class="card-img-wrap">
              <c:if test="${not empty item.dday}">
                <span class="d-day">D-${item.dday}</span>
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
            // --- 1. 입체 캐러셀 배너 로직 ---
            const track = document.getElementById('exTrack');
            const cards = track ? track.querySelectorAll('.exhibit-banner-card') : [];
            const dotContainer = document.getElementById('exDots');
            let currentIdx = 0;

            if (cards.length > 0) {
                cards.forEach((_, i) => {
                    const dot = document.createElement('div');
                    dot.classList.add('dot');
                    if(i === 0) dot.classList.add('active');
                    dot.onclick = () => { currentIdx = i; updateCards(); };
                    dotContainer.appendChild(dot);
                });

                function updateCards() {
                    const len = cards.length;
                    cards.forEach((card, i) => {
                        card.classList.remove('active', 'prev', 'next');
                        const prevIdx = (currentIdx - 1 + len) % len;
                        const nextIdx = (currentIdx + 1) % len;
                        if (i === currentIdx) card.classList.add('active');
                        else if (i === prevIdx) card.classList.add('prev');
                        else if (i === nextIdx) card.classList.add('next');
                    });
                    const dots = dotContainer.querySelectorAll('.dot');
                    dots.forEach((dot, i) => dot.classList.toggle('active', i === currentIdx));
                }
                document.getElementById('exPrev').onclick = () => { currentIdx = (currentIdx - 1 + cards.length) % cards.length; updateCards(); };
                document.getElementById('exNext').onclick = () => { currentIdx = (currentIdx + 1) % cards.length; updateCards(); };
                updateCards();

                // 자동 슬라이드 기능 (선택사항)
                setInterval(() => {
                    currentIdx = (currentIdx + 1) % cards.length;
                    updateCards();
                }, 5000);
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