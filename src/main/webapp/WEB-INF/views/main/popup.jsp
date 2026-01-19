<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>popup</title>

<link rel="stylesheet" href="/resources/css/main.css">

<style>
/* ================= 카드 기본 ================= */
.content-card {
  width: 9rem;
  height: 12rem;
  overflow: hidden;
}

.content-card img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.content-body {
  padding: 4px;
  font-size: 0.85rem;
}

/* ================= 추천 영역 블러 ================= */
.content-list.is-blur {
  position: relative;
}

.content-list.is-blur .content-card {
  filter: blur(8px);
  pointer-events: none;
}

/* ================= 오버레이 ================= */
.content-overlay {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.85);

  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  text-align: center;
  z-index: 10;
}

.overlay-title {
  font-weight: bold;
  margin-bottom: 8px;
}

.overlay-desc {
  font-size: 0.85rem;
  margin-bottom: 12px;
}

.overlay-btn {
  padding: 6px 14px;
  border-radius: 20px;
  background: #7b61ff;
  color: #fff;
  text-decoration: none;
  font-size: 0.85rem;
}
</style>
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

    <!-- 🔥 블러 대상은 content-list -->
    <div class="content-list horizontal ${needBlur ? 'is-blur' : ''}">

      <c:forEach var="item" items="${recommand}">
        <article class="content-card">
          <img src="${item.main_image_path}" alt="">
          <div class="content-body">
            <div class="title">${item.title}</div>
          </div>
        </article>
      </c:forEach>

      <!-- 🔥 오버레이는 딱 1개 -->
      <c:if test="${needBlur}">
        <div class="content-overlay">
          <p class="overlay-title">관심사 등록 전이신가요?</p>
          <p class="overlay-desc">
            관심사를 설정하면 맞춤 콘텐츠를 추천해드려요
          </p>
          <a href="/mypage/interest" class="overlay-btn">
            관심사 설정하기
          </a>
        </div>
      </c:if>

    </div>
  </section>

  <!-- ================= HOT 콘텐츠 ================= -->
  <section class="content-section hot">
    <h2>HOT 콘텐츠</h2>

    <div class="content-list grid">
      <c:forEach var="item" items="${random}">
        <article class="content-hot">
          <img src="${item.main_image_path}" alt="">
          <div class="content-body">
            <div class="title">${item.title}</div>
          </div>
        </article>
      </c:forEach>
    </div>
  </section>

  <!-- ================= 오픈 예정 콘텐츠 ================= -->
  <section class="content-section upcoming">
    <h2>오픈 예정 콘텐츠</h2>

    <button class="slide-prev">&lt;</button>

    <div class="content-list horizontal">
      <c:forEach var="item" items="${upcoming}">
        <article class="content-card">
          <img src="${item.main_image_path}" alt="">
          <h4>${item.title}</h4>
          <p>D-${item.dday}</p>
        </article>
      </c:forEach>
    </div>

    <button class="slide-next">&gt;</button>
  </section>

</main>

</body>
</html>
