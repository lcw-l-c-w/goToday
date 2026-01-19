<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>GoToday - PopUp</title>
    <style>
        /* 1. 기본 스타일 및 네비게이션 강조선 */
        :root { --main-color: #4dc3ff; } 
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Pretendard', sans-serif; overflow-x: hidden; background-color: #fff; line-height: 1.5; }
        a { text-decoration: none; color: inherit; }
        
        .header { width: 100%; border-bottom: 1px solid #eee; background: #fff; position: sticky; top: 0; z-index: 1000; }
        .nav-container { max-width: 1100px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; padding: 0 20px; height: 70px; }
        .logo img { height: 32px; cursor: pointer; display: block; }
        
        .nav-menu { display: flex; gap: 35px; height: 100%; list-style: none; align-items: center; }
        .nav-menu li { position: relative; height: 100%; display: flex; align-items: center; }
        .nav-menu a { font-weight: 600; font-size: 15px; color: #333; transition: color 0.3s ease; height: 100%; display: flex; align-items: center; padding: 0 5px; }

        /* 네비게이션 호버 및 활성 페이지 강조선 */
        .nav-menu li:hover a, .nav-menu li.active-page a { color: var(--main-color); }
        .nav-menu li::after { 
            content: ""; position: absolute; bottom: -1px; left: 0; width: 0; height: 3px; 
            background-color: var(--main-color); transition: width 0.3s ease; z-index: 5; 
        }
        .nav-menu li:hover::after, .nav-menu li.active-page::after { width: 100%; }

        .nav-icons { display: flex; gap: 20px; align-items: center; }
        .search-bar { border-bottom: 1px solid #333; display: flex; align-items: center; padding: 2px 5px; }
        .search-bar input { border: none; outline: none; width: 150px; font-size: 14px; }
        .user-icon { font-size: 22px; cursor: pointer; transition: color 0.2s; }

        .main-wrapper { max-width: 1100px; margin: 0 auto; padding: 0 20px; }

        /* 2. 입체 캐러셀 배너 */
        .exhibit-banner-section { 
            position: relative; width: 100%; height: 500px; 
            margin: 40px 0 80px; display: flex; flex-direction: column; align-items: center; justify-content: center;
        }
        .banner-container {
            position: relative; width: 100%; height: 100%;
            display: flex; align-items: center; justify-content: center; perspective: 1200px;
        }
        .banner-track {
            position: relative; width: 420px; height: 450px; transform-style: preserve-3d; margin: 0 auto; list-style: none;
        }
        .exhibit-banner-card {
            position: absolute; width: 100%; height: 100%; border-radius: 20px; overflow: hidden;
            transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.6s;
            opacity: 0; z-index: 0; pointer-events: none; box-shadow: 0 15px 35px rgba(0,0,0,0.15); background: #f4f4f4;
        }
        .exhibit-banner-card img { width: 100%; height: 100%; object-fit: cover; }
        .exhibit-banner-card.active { opacity: 1; z-index: 10; transform: translateX(0) scale(1.1); pointer-events: auto; }
        .exhibit-banner-card.prev { opacity: 0.5; z-index: 5; transform: translateX(-105%) scale(0.85) rotateY(15deg); }
        .exhibit-banner-card.next { opacity: 0.5; z-index: 5; transform: translateX(105%) scale(0.85) rotateY(-15deg); }
        
        .banner-overlay {
            position: absolute; bottom: 0; left: 0; width: 100%; padding: 40px 30px;
            background: linear-gradient(transparent, rgba(0,0,0,0.85)); color: white; opacity: 0; transition: opacity 0.4s;
        }
        .exhibit-banner-card.active .banner-overlay { opacity: 1; }
        .banner-overlay h3 { font-size: 24px; margin-bottom: 5px; }
        .banner-overlay p { font-size: 14px; opacity: 0.8; }
        
        .slide-btn { position: absolute; top: 50%; transform: translateY(-50%); background: none; border: none; font-size: 40px; cursor: pointer; z-index: 100; transition: 0.3s; color: #333; opacity: 0.5; }
        .slide-btn:hover { opacity: 1; color: var(--main-color); }
        .btn-l { left: -20px; } .btn-r { right: -20px; }
        .indicator-dots { display: flex; gap: 8px; margin-top: 20px; }
        .dot { width: 8px; height: 8px; border-radius: 50%; background: #ddd; cursor: pointer; transition: 0.3s; }
        .dot.active { background: var(--main-color); width: 22px; border-radius: 10px; }

        /* 3. 추천 콘텐츠 블러 및 CTA */
        .recommend-section { 
            position: relative; width: 100%; margin-bottom: 80px; 
            min-height: 480px; background: #fafafa; border-radius: 25px; padding: 40px 0;
        }
        .recommend-container { position: relative; width: 100%; padding: 0 30px; }
        .recommend-view { width: 100%; overflow: hidden; min-height: 340px; }
        .content-list.horizontal { display: flex; gap: 20px; transition: transform 0.5s ease; padding: 10px 0; list-style: none; }
        .content-card { flex: 0 0 210px; cursor: pointer; transition: 0.3s; }
        .content-card:hover { transform: translateY(-5px); }
        .card-img-wrap { width: 100%; height: 280px; border-radius: 15px; overflow: hidden; margin-bottom: 15px; border: 1px solid #eee; background:#fff; position: relative; }
        .card-img-wrap img { width: 100%; height: 100%; object-fit: cover; }
        
        .recommend-btn { position: absolute; top: 50%; transform: translateY(-50%); background: #fff; border: 1px solid #eee; width: 44px; height: 44px; border-radius: 50%; cursor: pointer; z-index: 110; box-shadow: 0 4px 12px rgba(0,0,0,0.1); display: flex; align-items: center; justify-content: center; font-size: 18px; transition: 0.2s; }
        .recommend-btn:hover { background: var(--main-color); color: white; border-color: var(--main-color); }
        .rec-prev { left: -5px; } .rec-next { right: -5px; }

        .blur-container { filter: blur(15px); pointer-events: none; user-select: none; opacity: 0.5; }
        .cta-overlay {
            position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 120;
            background: rgba(255, 255, 255, 0.95); padding: 50px 60px; border-radius: 30px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.1); text-align: center; width: 90%; max-width: 480px;
        }
        .cta-overlay h3 { font-size: 24px; font-weight: bold; margin-bottom: 15px; color: #111; }
        .cta-overlay p { font-size: 15px; color: #666; margin-bottom: 25px; line-height: 1.6; }
        .cta-btn { display: inline-block; background-color: var(--main-color); color: white; padding: 14px 35px; border-radius: 12px; font-weight: bold; font-size: 16px; transition: 0.3s; }
        .cta-btn:hover { background-color: #38b2f0; transform: scale(1.05); }

        /* 4. HOT & 오픈 예정 콘텐츠 스타일 */
        .section-title { font-size: 26px; font-weight: bold; margin: 60px 0 30px; text-align: center; }
        .hot-grid-container { display: grid; grid-template-columns: 1.3fr 2fr; gap: 15px; height: 550px; margin-bottom: 80px; }
        .hot-main { border-radius: 18px; overflow: hidden; position: relative; cursor: pointer; background: #eee; }
        .hot-main img { width: 100%; height: 100%; object-fit: cover; transition: 0.5s; }
        .hot-main:hover img { transform: scale(1.05); }
        .hot-sub-grid { display: grid; grid-template-columns: repeat(3, 1fr); grid-template-rows: repeat(2, 1fr); gap: 12px; }
        .sub-card { border-radius: 12px; overflow: hidden; cursor: pointer; transition: 0.3s; background: #eee; }
        .sub-card:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .sub-card img { width: 100%; height: 100%; object-fit: cover; }
        .d-day { position: absolute; top: 12px; left: 12px; background: #ff4d4d; color: white; padding: 5px 12px; border-radius: 8px; font-weight: bold; font-size: 12px; z-index: 10; }
    </style>
</head>
<body>

    <header class="header">
        <div class="nav-container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/main"><img src="<c:url value='/resources/images/logo.png'/>" alt="Logo"></a>
            </div>
            <ul class="nav-menu">
                <li><a href="#">Q&A</a></li>
                <li class="active-page"><a href="${pageContext.request.contextPath}/popup">PopUp</a></li>
                <li><a href="${pageContext.request.contextPath}/exhibition">Exhibition</a></li>
            </ul>
            <div class="nav-icons">
                <div class="search-bar"><input type="text" placeholder="검색"><span>🔍</span></div>
                <span class="user-icon" id="myPageBtn">👤</span>
            </div>
        </div>
    </header>

    <main class="main-wrapper">
        <section class="exhibit-banner-section">
            <div class="banner-container">
                <button class="slide-btn btn-l" id="exPrev">〈</button>
                <ul class="banner-track" id="exTrack">
                    <c:forEach var="item" items="${random}">
                        <li class="exhibit-banner-card" onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
                            <img src="<c:url value='${item.main_image_path}'/>" alt="${item.title}">
                            <div class="banner-overlay">
                                <h3>${item.title}</h3>
                                <p>운영 기간 | ${item.start_at} ~ ${item.end_at}</p>
                                <p>${item.location}</p>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
                <button class="slide-btn btn-r" id="exNext">〉</button>
            </div>
            <div class="indicator-dots" id="exDots"></div>
        </section>

        <h2 class="section-title">추천 콘텐츠</h2>
        <section class="recommend-section">     
            <c:set var="isLoggedIn" value="${not empty loginSess}" />
            <c:set var="isTagEmpty" value="${empty recommand or (not empty recommand and recommand[0].blur)}" />
            <c:set var="isBlur" value="${!isLoggedIn or isTagEmpty}" />

            <c:if test="${isBlur}">
                <div class="cta-overlay">
                    <c:choose>
                        <c:when test="${!isLoggedIn}">
                            <h3>로그인이 필요한 서비스입니다</h3>
                            <p>로그인하시면 당신의 취향에 딱 맞는<br>다양한 팝업을 추천해드려요!</p>
                            <a href="${pageContext.request.contextPath}/member/login" class="cta-btn">로그인하러 가기</a>
                        </c:when>
                        <c:otherwise>
                            <h3>관심사 등록 전이신가요?</h3>
                            <p>관심사를 설정하면 당신만을 위한<br>특별한 맞춤 콘텐츠를 추천해드려요!</p>
                            <a href="${pageContext.request.contextPath}/mypage/interest" class="cta-btn">관심사 설정하기</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <div class="recommend-container">
                <button class="recommend-btn rec-prev" id="recPrev">&lt;</button>
                <div class="recommend-view">
                    <div id="recList" class="content-list horizontal ${isBlur ? 'blur-container' : ''}">
                        <c:forEach var="item" items="${recommand}">
                            <article class="content-card" onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
                                <div class="card-img-wrap"><img src="<c:url value='${item.main_image_path}'/>" alt="${item.title}"></div>
                                <div class="content-body">
                                    <h4 style="margin-bottom: 5px; font-size: 15px;">${item.title}</h4>
                                    <p style="font-size: 13px; color: #888;">${item.location}</p>
                                </div>
                            </article>
                        </c:forEach>
                        <c:if test="${empty recommand}">
                            <div style="height:280px; width:100%;"></div>
                        </c:if>
                    </div>
                </div>
                <button class="recommend-btn rec-next" id="recNext">&gt;</button>
            </div>
        </section>

        <h2 class="section-title">지금 가장 HOT한 팝업</h2>
        <section>
            <div class="hot-grid-container">
                <c:if test="${not empty popularList}">
                    <div class="hot-main" onclick="location.href='${pageContext.request.contextPath}/detail/${popularList[0].content_id}'">
                        <img src="<c:url value='${popularList[0].main_image_path}'/>">
                        <div style="position:absolute; bottom:0; left:0; width:100%; padding: 25px; background: linear-gradient(transparent, rgba(0,0,0,0.7)); color:white;">
                            <h3 style="font-size:22px;">${popularList[0].title}</h3>
                        </div>
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

        <h2 class="section-title">오픈 예정 콘텐츠</h2>
        <section style="padding-bottom: 100px;">
            <div class="content-list horizontal" style="overflow-x: auto; scrollbar-width: none; -ms-overflow-style: none;">
                <c:forEach var="item" items="${upcomingList}">
                    <article class="content-card" onclick="location.href='${pageContext.request.contextPath}/detail/${item.content_id}'">
                        <div class="card-img-wrap">
                            <c:if test="${not empty item.dday}"><span class="d-day">D-${item.dday}</span></c:if>
                            <img src="<c:url value='${item.main_image_path}'/>">
                        </div>
                        <h4 style="margin: 8px 0 4px; font-size: 15px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${item.title}</h4>
                        <p style="font-size: 13px; color: #999;">${item.periodText}</p>
                    </article>
                </c:forEach>
            </div>
        </section>
    </main>

    <script>
        window.addEventListener("load", function() {
            // --- 1. 입체 캐러셀 배너 로직 ---
            const track = document.getElementById('exTrack');
            const cards = track ? track.querySelectorAll('.exhibit-banner-card') : [];
            const dotContainer = document.getElementById('exDots');
            let currentIdx = 0;
            let autoSlide;

            if (cards.length > 0) {
                cards.forEach((_, i) => {
                    const dot = document.createElement('div');
                    dot.classList.add('dot');
                    if(i === 0) dot.classList.add('active');
                    dot.onclick = () => { currentIdx = i; updateCards(); resetTimer(); };
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

                function nextSlide() { currentIdx = (currentIdx + 1) % cards.length; updateCards(); }
                function resetTimer() { clearInterval(autoSlide); autoSlide = setInterval(nextSlide, 5000); }

                document.getElementById('exPrev').onclick = () => { currentIdx = (currentIdx - 1 + cards.length) % cards.length; updateCards(); resetTimer(); };
                document.getElementById('exNext').onclick = () => { nextSlide(); resetTimer(); };
                
                updateCards();
                autoSlide = setInterval(nextSlide, 5000);
            }

            // --- 2. 추천 콘텐츠 슬라이더 로직 ---
            const recList = document.getElementById('recList');
            const recCards = recList ? recList.querySelectorAll('.content-card') : [];
            let recPosition = 0;
            const cardWidth = 210 + 20; 
            const view = document.querySelector('.recommend-view');
            if (recCards.length > 0 && view) {
                const containerWidth = view.offsetWidth;
                const visibleCount = Math.floor(containerWidth / cardWidth);
                document.getElementById('recPrev').onclick = () => { recPosition = Math.min(recPosition + cardWidth, 0); recList.style.transform = `translateX(${recPosition}px)`; };
                document.getElementById('recNext').onclick = () => { recPosition = Math.max(recPosition - cardWidth, -(cardWidth * recCards.length - containerWidth + 10)); recList.style.transform = `translateX(${recPosition}px)`; };
                if (recCards.length <= visibleCount) {
                    document.getElementById('recPrev').style.display = 'none';
                    document.getElementById('recNext').style.display = 'none';
                }
            }

            // --- 3. 마이페이지 이동 ---
            const myBtn = document.getElementById('myPageBtn');
            if(myBtn) {
                myBtn.onclick = () => {
                    const isLoggedIn = ${not empty loginSess};
                    location.href = isLoggedIn ? "${pageContext.request.contextPath}/member/mypage" : "${pageContext.request.contextPath}/member/login";
                };
            }
        });
    </script>
</body>
</html>