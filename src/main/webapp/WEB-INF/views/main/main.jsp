<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main</title>
<link rel="stylesheet" href="/resources/css/main.css">
<style>
.content-card {
  position: relative;
  width: 9rem;
  height: 12rem;
  overflow: hidden;
}

/* 카드 본문 블러 */
.content-card.is-blur img,
.content-card.is-blur .content-body {
  filter: blur(8px);
}

/* 🔥 오버레이 */
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

/* 오버레이 텍스트 */
.overlay-title {
  font-weight: bold;
  margin-bottom: 8px;
}

.overlay-desc {
  font-size: 0.85rem;
  margin-bottom: 12px;
}

/* 버튼 */
.overlay-btn {
  padding: 6px 12px;
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
					<img src="${item.main_image_path}"	alt="">
						<div class="banner-info">
							<h3>${item.title}</h3>
							<p>${item.start_at}~ ${item.end_at}</p>
						</div></li>
				</c:forEach>
			</ul>

			<button class="banner-next">&gt;</button>
		</section>


		<!-- ================= 추천 콘텐츠 ================= -->
		<section class="content-section recommend">
			<h2>추천 콘텐츠</h2>

			<div class="content-list horizontal">
				<c:forEach var="item" items="${recommand}">
<article class="content-card ${item.blur ? 'is-blur' : ''}">
  <img src="${item.main_image_path}" alt="">

  <div class="content-body">
    <div class="title">${item.title}</div>
  </div>

  <!-- 🔥 블러일 때만 뜨는 오버레이 -->
  <c:if test="${item.blur}">
    <div class="content-overlay">
      <p class="overlay-title">관심사 등록 전이신가요?</p>
      <p class="overlay-desc">
 			${item.ctaMessage}
      </p>
      <a href="${item.ctaUrl}" class="overlay-btn">관심사 설정하기</a>
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
