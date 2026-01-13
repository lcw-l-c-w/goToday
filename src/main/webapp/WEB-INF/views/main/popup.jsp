<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POP UP</title>
</head>
<style>
    .card{
    width: 9rem;
    height: 12rem;
    background-color: orange;
    margin: 10px;
  }

    /* 리스트 공통 */
    .content-list {
    width: 100%;
    display: flex;
    }

    /* 가로 정렬 */
    .content-list.horizontal {
    flex-direction: row;
    gap: 16px;
    overflow-x: auto;
    padding: 10px 0;
    }

  .content-card{
    width: 9rem;
    height: 12rem;
    background-color: orange;
    margin: 10px;
  }
  .content-card.large{
    width: 18rem;
    height: 24rem;
    background-color: red;
  }
    /* 그리드 정렬 */
    .content-list.grid {
    flex-wrap: wrap;
    gap: 16px;
    justify-content: center;
    }


</style>

<body>

<!-- ================= HEADER ================= -->
<header class="header">
  <div class="header-inner">
    <a href="#" class="logo">LOGO</h1>

    <nav class="gnb">
      <ul>
        <li><a href="reply/index">Q & A</a></li>
        <li><a href="exhibition">전시</a></li>
        <li><a href="popup">팝업</a></li>
      </ul>
    </nav>

    <div class="header-util">
      <input name="search-word" type="text" placeholder="검색어를 입력하세요">  
      <button type="submit">검색</button>
      <!-- 로그인 여부에 따라  -->
      <a href="mypage/main" class="login">마이페이지</a>
      <a href="member/login" class="login">로그인</a>
    </div>
  </div>
</header>

<!-- ================= MAIN ================= -->
<main class="main">

  <!-- ===== 메인 배너 ===== -->
  <div class="carousel">

  <!-- 이전 버튼 -->
  <button class="nav prev">‹</button>

  <!-- 슬라이드 영역 -->
  <div class="carousel-track-wrapper">
    <ul class="carousel-track">

      <li class="card">
        <p class="content-title">컨텐츠명</p>
        <p class="content-time">전시기간</p>
      </li>

      <li class="card active">
        <h3 class="content-title">콘텐츠 타이틀</h3>
        <p class="content-time">전시기간</p>
      </li>

      <li class="card">
        <p class="content-title">컨텐츠명</p>
        <p class="content-time">전시기간</p>
      </li>

    </ul> 
  </div>

  <!-- 다음 버튼 -->
  <button class="nav next">›</button>

</div>

<!-- 인디케이터 -->
<div class="dots">
  <span class="dot"></span>
  <span class="dot active"></span>
  <span class="dot"></span>
</div>

  <!-- ===== HOT 컨텐츠 ===== -->
  <section class="content-hot-section">
    <h3 class="section-title">HOT 컨텐츠</h3>

    <div class="content-list grid">
      <article class="content-card large">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
        <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>

    </div>
  </section>

  <!-- ===== 오픈 예정 컨텐츠 ===== -->
  <section class="content-upcoming-section">
    <h3 class="section-title">오픈 예정 컨텐츠</h3>

    <button class="upcoming-list-prev">&lt;</button>

    <div class="content-list horizontal">
      <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
        <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
    </div>

    <button class="upcoming-list-next">&gt;</button>

    <div class="upcoming-list-pagination">
      <span></span><span></span><span></span><span></span>
    </div>
  </section>
  
  <!-- ===== 추천 컨텐츠 ===== -->
  <section class="content-recommend-section">
    <h3 class="section-title">추천 컨텐츠</h3>

    <div class="content-list horizontal">
      <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
        <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>
       <article class="content-card">
        <img src="" alt="">
        <div>태그</div>
        <div>컨텐츠타이틀</div>
        <hr>
        <div>장소</div>
        <div>시간</div> 
      </article>

     
    </div>
  </section>

</main>


<!-- ================= FLOATING BUTTONS ================= -->
<div class="floating-buttons">
  <button class="floating-btn top">↑</button>
</div>

<!-- ================= FOOTER ================= -->
<footer class="footer">
  <div class="footer-inner">
    <p>© Popup Exhibition</p>
  </div>
</footer>

</body>
</html>