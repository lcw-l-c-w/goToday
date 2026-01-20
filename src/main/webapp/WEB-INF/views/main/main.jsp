<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Main</title>
    <link rel="stylesheet" href="/resources/css/main.css">
</head>

<body>

<main class="main">

    <!-- ================= 메인 배너 ================= -->
    <section class="main-banner">
        <button class="banner-prev">&lt;</button>

        <ul class="banner-list">
            <c:forEach var="item" items="${random}">
                <li class="banner-card">
                    <img src="${item.main_image_path}" alt="">
                    <div class="banner-info">
                        <h3>${item.title}</h3>
                        <p>${item.start_at} ~ ${item.end_at}</p>
                    </div>
                </li>
            </c:forEach>
        </ul>

        <button class="banner-next">&gt;</button>
    </section>


    <!-- ================= 추천 콘텐츠 ================= -->
    <section class="content-section recommend">
        <h2>추천 콘텐츠</h2>

        <div class="content-list horizontal">
            <c:forEach var="item" items="${random}">
                <article class="content-card ${item.blur ? 'blur' : ''}">
                    <img src="${item.main_image_path}" alt="">

                    <div class="content-body">
                        <div class="category">${item.category}</div>
                        <h4>${item.title}</h4>
                        <div class="location">${item.location}</div>
                    </div>

                    <c:if test="${item.blur}">
                        <div class="content-overlay">
                            <p>${item.ctaMessage}</p>
                            <a href="${item.ctaUrl}" class="cta-btn">확인하기</a>
                        </div>
                    </c:if>
                </article>
            </c:forEach>
        </div>
    </section>



<!-- ================= HOT 콘텐츠 ================= -->
<section class="content-section hot">
    <h2>HOT 콘텐츠</h2>

    <div class="content-list grid">
        <c:if test="${empty popularList}">
            <div>popularList 비어있음</div>
        </c:if>

        <c:forEach var="item" items="${popularList}">
            <article class="content-card ${item.blur ? 'blur' : ''}">
                <!-- 이미지 -->
                <img src="${item.main_image_path}" alt="">

                <!-- 기본 정보 -->
                <div class="content-body">
                    <div class="category">${item.category}</div>
                    <h4>${item.title}</h4>

                    <!-- ✅ 운영기간 표시 추가 -->
                    <div class="period">${item.periodText}</div>

                    <div class="location">${item.location}</div>
                </div>

                <!-- 블러일 때 오버레이 -->
                <c:if test="${item.blur}">
                    <div class="content-overlay">
                        <p>${item.ctaMessage}</p>
                        <a href="${item.ctaUrl}" class="cta-btn">확인하기</a>
                    </div>
                </c:if>

                <!-- ✅ 상세 페이지 이동(테스트용) -->
                <div class="detail-link">
                    <a href="${pageContext.request.contextPath}/detail/${item.content_id}">
                        상세보기
                    </a>
                </div>
            </article>
        </c:forEach>
    </div>
</section>


<!-- ================= 오픈 예정 콘텐츠 ================= -->
<section class="content-section upcoming">
    <h2>오픈 예정 콘텐츠</h2>

    <!-- 버튼은 아직 동작 안해도 됨(테스트용) -->
    <button class="slide-prev">&lt;</button>

    <div class="content-list horizontal">
        <c:if test="${empty upcomingList}">
            <div>upcomingList 비어있음</div>
        </c:if>

        <c:forEach var="item" items="${upcomingList}">
            <article class="content-card">
                <img src="${item.main_image_path}" alt="">
                <h4>${item.title}</h4>

                <!-- ✅ D-day 표시 (서비스에서 계산된 item.dday 사용) -->
                <c:if test="${item.dday != null}">
                    <p>D-${item.dday}</p>
                </c:if>

                <!-- ✅ 운영기간도 같이 보고 싶으면 (선택) -->
                <div class="period">${item.periodText}</div>

                <!-- ✅ 상세 페이지 이동(테스트용) -->
                <div class="detail-link">
                    <a href="${pageContext.request.contextPath}/detail/${item.content_id}">
                        상세보기
                    </a>
                </div>
            </article>
        </c:forEach>
    </div>

    <button class="slide-next">&gt;</button>
</section>
</main>

</body>
</html>
