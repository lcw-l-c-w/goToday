<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>전시 게시물 관리</title>
</head>
<body>

<div class="admin-layout">

  <!-- ================= 사이드바 ================= -->
  <aside class="sidebar">
    <div class="sidebar-top">
      <h1 class="logo">ExhibiReserve</h1>
      <p class="subtitle">VENDOR MANAGEMENT</p>
    </div>

    <nav class="sidebar-menu">
      <ul>
        <li>
          <a href="#">대시보드</a>
        </li>
        <li class="active">
          <a href="#">콘텐츠 관리</a>
        </li>
        <li>
          <a href="#">정산 내역</a>
        </li>
      </ul>
    </nav>

    <div class="sidebar-bottom">
      <div class="admin-info">
        <span class="role">Signed in as</span>
        <strong class="name">상수전시관 관리자</strong>
      </div>
    </div>
  </aside>


  <!-- ================= 메인 콘텐츠 ================= -->
  <main class="main-content">

    <!-- 상단 헤더 -->
    <div class="page-header">
      <div class="page-title">
        <h2>전시 게시물 관리</h2>
        <p>등록하신 전시의 상태를 확인하고 관리하세요.</p>
      </div>

      <div class="page-actions">
        <button class="btn-primary">+ 게시글 등록하기</button>
      </div>
    </div>

    <!-- 필터 & 검색 -->
    <div class="filter-bar">

      <div class="search-box">
        <input type="text" placeholder="전시 명으로 검색..." />
      </div>

      <div class="filter-buttons">
        <button class="active">전체</button>
        <button>승인대기</button>
        <button>승인</button>
        <button>거절</button>
        <button>오픈예정</button>
        <button>현재진행중</button>
        <button>종료</button>
        <button>활성화</button>
        <button>비활성화</button>
      </div>

    </div>

    <!-- ================= 전시 리스트 ================= -->
    <section class="exhibit-list">

      <!-- 리스트 헤더 -->
      <div class="list-header">
        <span class="col-info">전시 정보</span>
        <span class="col-period">기간</span>
        <span class="col-status">상태</span>
        <span class="col-manage">관리</span>
      </div>

      <!-- 리스트 아이템 -->
      <ul class="list-body">

        <!-- item 1: 현재진행중 -->
        <li class="list-item">
          <div class="exhibit-info">
            <img src="#" alt="전시 이미지" class="thumb" />
            <div class="text">
              <strong class="title">서울 미디어아트 판타지아</strong>
              <p class="place">서울숲 갤러리 1관</p>
            </div>
          </div>

          <div class="exhibit-period">
            2024-05-01 ~ 2024-08-31
          </div>

          <div class="exhibit-status">
            <span class="status ongoing">현재진행중</span>
          </div>

          <div class="exhibit-manage">
            <!-- 현재진행중 상태는 관리하기 버튼 없음 -->
          </div>
        </li>

        <!-- item 2: 승인대기 -->
        <li class="list-item">
          <div class="exhibit-info">
            <img src="#" alt="전시 이미지" class="thumb" />
            <div class="text">
              <strong class="title">근현대 미술의 발자취</strong>
              <p class="place">동대문 디자인 플라자(DDP)</p>
            </div>
          </div>

          <div class="exhibit-period">
            2024-06-15 ~ 2024-07-15
          </div>

          <div class="exhibit-status">
            <span class="status pending">승인대기</span>
          </div>

          <div class="exhibit-manage">
            <!-- 승인대기 상태는 관리하기 버튼 없음 -->
          </div>
        </li>

        <!-- item 3: 거절 (관리하기 버튼 표시) -->
        <li class="list-item">
          <div class="exhibit-info">
            <img src="#" alt="전시 이미지" class="thumb" />
            <div class="text">
              <strong class="title">디지털 네이처: 숨쉬는 숲</strong>
              <p class="place">제주 누아 아트홀</p>
            </div>
          </div>

          <div class="exhibit-period">
            2024-03-01 ~ 2024-04-30
          </div>

          <div class="exhibit-status">
            <span class="status reject">거절</span>
          </div>

          <div class="exhibit-manage">
            <a href="content/edit?id=3">수정하기</a>
          </div>
        </li>

        <!-- item 4: 오픈예정 -->
        <li class="list-item">
          <div class="exhibit-info">
            <img src="#" alt="전시 이미지" class="thumb" />
            <div class="text">
              <strong class="title">빛의 예술: 이머시브 전시</strong>
              <p class="place">코엑스 전시홀</p>
            </div>
          </div>

          <div class="exhibit-period">
            2024-09-01 ~ 2024-12-31
          </div>

          <div class="exhibit-status">
            <span class="status upcoming">오픈예정</span>
          </div>

          <div class="exhibit-manage">
            <!-- 오픈예정 상태는 관리하기 버튼 없음 -->
          </div>
        </li>

        <!-- item 5: 종료 -->
        <li class="list-item">
          <div class="exhibit-info">
            <img src="#" alt="전시 이미지" class="thumb" />
            <div class="text">
              <strong class="title">봄의 정원 특별전</strong>
              <p class="place">국립현대미술관</p>
            </div>
          </div>

          <div class="exhibit-period">
            2024-01-01 ~ 2024-02-28
          </div>

          <div class="exhibit-status">
            <span class="status ended">종료</span>
          </div>

          <div class="exhibit-manage">
            <!-- 종료 상태는 관리하기 버튼 없음 -->
          </div>
        </li>

      </ul>
      
    </section>
  </main>
</div>

</body>
</html>