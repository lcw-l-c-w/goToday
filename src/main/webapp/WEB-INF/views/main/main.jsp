<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GoToday Main</title>
    <style>
        /* 1. 기본 스타일 */
        :root { --main-color: #4dc3ff; } 
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Pretendard', sans-serif; overflow-x: hidden; background-color: #fff; }
        a { text-decoration: none; color: inherit; }
        
     <%--  .header { width: 100%; border-bottom: 1px solid #eee; background: #fff; position: sticky; top: 0; z-index: 1000; }
        .nav-container { max-width: 1100px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; padding: 0 20px; height: 70px; }
        .logo img { height: 32px; cursor: pointer; display: block; }
        .nav-menu { display: flex; gap: 35px; height: 100%; list-style: none; align-items: center; }
        .nav-menu li { position: relative; height: 100%; display: flex; align-items: center; }
        .nav-menu a { font-weight: 600; font-size: 15px; color: #333; transition: color 0.3s ease; height: 100%; display: flex; align-items: center; padding: 0 5px; }
        .nav-menu li:hover a { color: var(--main-color); }
        .nav-menu li::after { content: ""; position: absolute; bottom: -1px; left: 0; width: 0; height: 3px; background-color: var(--main-color); transition: width 0.3s ease; z-index: 5; }
        .nav-menu li:hover::after { width: 100%; }
        .nav-icons { display: flex; gap: 20px; align-items: center; }
        .search-bar { border-bottom: 1px solid #333; display: flex; align-items: center; padding: 2px 5px; }
        .search-bar input { border: none; outline: none; width: 150px; font-size: 14px; }
        .user-icon { font-size: 22px; cursor: pointer; transition: color 0.2s; }
        .user-icon:hover { color: var(--main-color); } --%>

        /* 2. 메인 배너 */
        .main-wrapper { max-width: 1100px; margin: 0 auto; padding: 0 20px; }
        .main-banner { position: relative; width: 100%; height: 500px; margin: 20px 0 60px; border-radius: 20px; overflow: hidden; background: #000; }
        #slideList { display: flex !important; flex-wrap: nowrap !important; width: auto; height: 100%; transition: transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94); margin: 0; padding: 0; list-style: none; }
        .banner-card { flex: 0 0 100% !important; width: 100%; height: 100%; position: relative; cursor: pointer; }
        .banner-card img { width: 100%; height: 100%; object-fit: cover; pointer-events: none; }
        .banner-info { position: absolute; bottom: 0; left: 0; width: 100%; padding: 60px 40px; background: linear-gradient(transparent, rgba(0,0,0,0.8)); color: white; }
        .banner-info h3 { font-size: 32px; margin-bottom: 10px; }
        .banner-btn { position: absolute; top: 50%; transform: translateY(-50%); background: rgba(255,255,255,0.3); border: none; color: white; font-size: 24px; width: 50px; height: 50px; border-radius: 50%; cursor: pointer; z-index: 100; transition: 0.3s; }
        .btn-prev { left: 20px; }
        .btn-next { right: 20px; }

        /* 3. 추천 컨텐츠 슬라이드 및 잘림 방지 */
        .recommend-section { position: relative; width: 100%; margin-bottom: 60px; }
        .recommend-container { position: relative; width: 100%; padding: 0 10px; }
        .recommend-view { width: 100%; overflow: hidden; }
        .content-list.horizontal { display: flex; gap: 20px; transition: transform 0.5s ease; padding: 10px 0; list-style: none; }
        .content-card { flex: 0 0 210px; cursor: pointer; transition: 0.3s; }
        .content-card:hover { transform: translateY(-5px); }
        .card-img-wrap { width: 100%; height: 280px; border-radius: 15px; overflow: hidden; position: relative; margin-bottom: 15px; border: 1px solid #eee; }
        .card-img-wrap img { width: 100%; height: 100%; object-fit: cover; }
        .recommend-btn { position: absolute; top: 50%; transform: translateY(-50%); background: #fff; border: 1px solid #eee; width: 44px; height: 44px; border-radius: 50%; cursor: pointer; z-index: 110; box-shadow: 0 4px 12px rgba(0,0,0,0.1); display: flex; align-items: center; justify-content: center; font-size: 18px; transition: 0.2s; }
        .recommend-btn:hover { background: #f8f8f8; color: var(--main-color); }
        .rec-prev { left: -22px; }
        .rec-next { right: -22px; }

        /* 블러 및 CTA */
        .blur-container { filter: blur(8px); pointer-events: none; user-select: none; }
        .cta-overlay { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 100; background: rgba(255, 255, 255, 0.95); padding: 40px 60px; border-radius: 25px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); text-align: center; width: 90%; max-width: 480px; }
        .cta-overlay h3 { font-size: 24px; font-weight: bold; margin-bottom: 15px; color: #111; }
        .cta-overlay p { font-size: 16px; color: #666; margin-bottom: 25px; line-height: 1.6; }
        .cta-btn { display: inline-block; background-color: var(--main-color); color: white; padding: 14px 35px; border-radius: 12px; font-weight: bold; }

        /* 4. 기타 스타일 */
        .section-title { font-size: 24px; font-weight: bold; margin: 60px 0 25px; text-align: center; }
        .hot-grid-container { display: grid; grid-template-columns: 1.3fr 2fr; gap: 15px; height: 550px; }
        .hot-main { border-radius: 18px; overflow: hidden; position: relative; cursor: pointer; }
        .hot-main img { width: 100%; height: 100%; object-fit: cover; }
        .hot-sub-grid { display: grid; grid-template-columns: repeat(3, 1fr); grid-template-rows: repeat(2, 1fr); gap: 12px; }
        .sub-card { border-radius: 12px; overflow: hidden; cursor: pointer; }
        .sub-card img { width: 100%; height: 100%; object-fit: cover; }
    </style>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<%@ include file="/WEB-INF/views/common/recentViewed.jspf" %>
	
   <%--  <header class="header">
        <div class="nav-container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/main">
                    <img src="<c:url value='/resources/images/logo.png'/>" alt="Logo">
                </a>
            </div>
            <ul class="nav-menu">
                <li><a href="#">Q&A</a></li>
                <li><a href="${pageContext.request.contextPath}/popup">PopUp</a></li>
                <li><a href="${pageContext.request.contextPath}/exhibition">Exhibition</a></li>
            </ul>
            <div class="nav-icons">
                <div class="search-bar">
                    <input type="text" placeholder="검색">
                    <span>🔍</span>
                </div>
                <span class="user-icon" id="myPageBtn">👤</span>
            </div>
        </div>
    </header> --%>

    <main class="main-wrapper">
        <section class="main-banner">
            <button class="banner-btn btn-prev" id="slidePrev">&lt;</button>
            <ul id="slideList">
                <c:forEach var="item" items="${random}">
                    <li class="banner-card" onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
                        <img src="<c:url value='${item.main_image_path}'/>">
                        <div class="banner-info">
                            <h3>${item.title}</h3>
                            <p>운영 기간 | ${item.start_at} ~ ${item.end_at}</p>
                        </div>
                    </li>
                </c:forEach>
            </ul>
            <button class="banner-btn btn-next" id="slideNext">&gt;</button>
        </section>

        <section class="recommend-section">
            <h2 class="section-title">추천 컨텐츠</h2>
            
            <%-- 수정: random이 아닌 recommand 리스트의 속성을 참조하여 블러 처리 판단 --%>
            <c:set var="isBlur" value="${not empty recommand and recommand[0].blur and empty loginSess}" />

            <c:if test="${isBlur}">
                <div class="cta-overlay">
                    <h3>${recommand[0].ctaMessage}</h3>
                    <p>취향을 등록하면 당신만을 위한<br>특별한 팝업과 전시를 추천해드려요!</p>
                    <a href="${pageContext.request.contextPath}${recommand[0].ctaUrl}" class="cta-btn">지금 설정하러 가기</a>
                </div>
            </c:if>

            <div class="recommend-container">
                <button class="recommend-btn rec-prev" id="recPrev">&lt;</button>
                
                <div class="recommend-view">
                    <%-- 수정: items를 random에서 recommand로 변경 --%>
                    <div id="recList" class="content-list horizontal ${isBlur ? 'blur-container' : ''}">
                        <c:forEach var="item" items="${recommand}">
                            <article class="content-card" onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
                                <div class="card-img-wrap"><img src="<c:url value='${item.main_image_path}'/>"></div>
                                <div class="content-body">
                                    <h4 style="margin-bottom: 5px; font-size: 15px;">${item.title}</h4>
                                    <p style="font-size: 13px; color: #888;">${item.location}</p>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </div>

                <button class="recommend-btn rec-next" id="recNext">&gt;</button>
            </div>
        </section>

        <section>
            <h2 class="section-title">HOT 컨텐츠</h2>
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

        <section style="padding-bottom: 100px;">
            <h2 class="section-title">오픈 예정 컨텐츠</h2>
            <div class="content-list horizontal" style="overflow-x: auto; scrollbar-width: none;">
                <c:forEach var="item" items="${upcomingList}">
                    <article class="content-card" onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
                        <div class="card-img-wrap">
                            <c:if test="${not empty item.dday}"><span style="position: absolute; top: 12px; left: 12px; background: #00d2ff; color: white; padding: 5px 12px; border-radius: 8px; font-weight: bold; font-size: 12px;">D-${item.dday}</span></c:if>
                            <img src="<c:url value='${item.main_image_path}'/>">
                        </div>
                        <h4 style="margin: 8px 0 4px; font-size: 15px;">${item.title}</h4>
                        <p style="font-size: 13px; color: #999;">${item.periodText}</p>
                    </article>
                </c:forEach>
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

            // 2. 추천 컨텐츠 슬라이드 로직
            const recList = document.getElementById('recList');
            const recCards = recList ? recList.querySelectorAll('.content-card') : [];
            let recPosition = 0;
            const cardWidth = 210 + 20; 
            const containerWidth = document.querySelector('.recommend-view').offsetWidth;
            const visibleCount = Math.floor(containerWidth / cardWidth);

            if (recCards.length > visibleCount) {
                document.getElementById('recPrev').onclick = () => {
                    recPosition = Math.min(recPosition + cardWidth, 0);
                    recList.style.transform = `translateX(\${recPosition}px)`;
                };
                document.getElementById('recNext').onclick = () => {
                    recPosition = Math.max(recPosition - cardWidth, -(cardWidth * recCards.length - containerWidth + 10));
                    recList.style.transform = `translateX(\${recPosition}px)`;
                };
            } else {
                if(document.getElementById('recPrev')) document.getElementById('recPrev').style.display = 'none';
                if(document.getElementById('recNext')) document.getElementById('recNext').style.display = 'none';
            }

            // 3. 로그인 체크
            document.getElementById('myPageBtn').onclick = () => {
                const isLoggedIn = ${not empty loginSess};
                if (!isLoggedIn) {
                    alert("로그인이 필요한 서비스입니다.");
                    location.href = "${pageContext.request.contextPath}/member/login";
                } else {
                    location.href = "${pageContext.request.contextPath}/member/mypage";
                }
            };
        });
    </script>
</body>
</html>