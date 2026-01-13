<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>전시 관리</title>
</head>
<body>

<div class="admin-layout">
  <!-- ================= 메인 ================= -->
  <main class="admin-content">

    <!-- 탭 -->
    <div class="tab-menu">
      <button class="active">전시 관리</button>
      <button>사용자 관리</button>
      <button>문의 사항</button>
    </div>

    <!-- 타이틀 -->
    <h2 class="page-title">전시 관리</h2>

    <!-- 검색-->
    <div class="toolbar">
      <input type="text" placeholder="전시명 검색" />
    </div>

    <!-- ================= 전시 리스트 ================= -->
    <section class="table-wrap">

      <!-- 헤더 -->
      <div class="table-header">
        <span>상태</span>
        <span>전시명</span>
        <span>전시기간</span>
        <span>장소</span>
        <span>가격</span>
        <span>관리</span>
      </div>

      <!-- 바디 -->
      <ul class="table-body">

        <!-- item -->
        <li class="table-row">
          <span><span class="badge active">활성</span></span>
          <span>모던 아트 익스피리언스 2026</span>
          <span>2026.01.15 ~ 2026.03.30</span>
          <span>서울 시립미술관 본관 2층</span>
          <span>15,000원</span>
          <span class="actions">
            <button title="승인">✅</button>
            <button title="거절">❌</button>
            <button title="비활성화">⛔</button>
            <button title="삭제">🗑</button>
          </span>
        </li>

        <!-- item (비활성화 예시) -->
        <li class="table-row">
          <span><span class="badge inactive">비활성</span></span>
          <span>모던 아트 익스피리언스 2026</span>
          <span>2026.01.15 ~ 2026.03.30</span>
          <span>서울 시립미술관 본관 2층</span>
          <span>15,000원</span>
          <span class="actions">
            <button title="승인">✅</button>
            <button title="거절">❌</button>
            <button title="비활성화">⛔</button>
            <button title="삭제">🗑</button>
          </span>
        </li>

        <!-- item (승인 대기) -->
        <li class="table-row">
          <span><span class="badge pending">승인 대기</span></span>
          <span>미디어 아트: 빛과 공간</span>
          <span>2026.02.01 ~ 2026.04.01</span>
          <span>DDP 전시관</span>
          <span>18,000원</span>
          <span class="actions">
            <button title="승인">✅</button>
            <button title="거절">❌</button>
            <button title="비활성화">⛔</button>
            <button title="삭제">🗑</button>
          </span>
        </li>

      </ul>

    </section>
    <!-- ================= 전시 리스트 END ================= -->

    <!-- 페이지네이션 -->
    <div class="pagination">
      <button>1</button>
      <button class="active">2</button>
      <button>3</button>
    </div>

  </main>
</div>

</body>
</html>
