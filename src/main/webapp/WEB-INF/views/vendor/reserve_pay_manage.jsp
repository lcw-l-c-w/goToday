<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<!-- ================= 예약/결제 관리 페이지 ================= -->
<div class="admin-layout">

  <!-- 사이드바 -->
  <aside class="sidebar">
  <!-- 생략 -->
  </aside>

  <!-- 메인 -->
  <main class="main-content">

    <!-- 페이지 타이틀 -->
    <header class="page-header">
      <h2>예약 및 결제 관리</h2>
      <button class="btn-outline">엑셀 다운로드</button>
    </header>

    <!-- 검색 / 필터 -->
    <section class="filter-bar">
      <input type="text" placeholder="예약번호, 예약자명 검색" />
      <select><option>모든 콘텐츠</option></select>
      <input type="date" />
      <select><option>모든 결제수단</option></select>
      <select><option>전체 예약상태</option></select>
    </section>

    <!-- 예약 리스트 -->
    <section class="table-wrap">
      <table class="reservation-table">
        <thead>
          <tr>
            <th>예약번호</th>
            <th>콘텐츠명</th>
            <th>예약자</th>
            <th>방문일시</th>
            <th>인원</th>
            <th>예약 상태</th>
            <th>결제 상태</th>
            <th>관리</th>
          </tr>
        </thead>

        <tbody>
          <tr>
            <td>R20240501-001</td>
            <td>반 고흐 몰입형 전시</td>
            <td>김*수</td>
            <td>2026-01-12<br>10:00 ~ 12:00</td>
            <td>2명</td>
            <td><span class="badge success">예약 확정</span></td>
            <td><span class="badge paid">결제 완료</span></td>
            <td>
              <!-- 클릭 시 상세 모달 오픈 -->
              <button class="btn-sm">상세보기</button>
            </td>
          </tr>
        </tbody>
      </table>
    </section>

  </main>
</div>

<!-- ================= 예약 상세 모달 ================= -->
<div class="modal-overlay">

  <div class="modal reservation-detail">

    <!-- 헤더 -->
    <header class="modal-header">
      <h3>예약 상세 내역 <span>#R20240501-001</span></h3>
      <button class="btn-close">✕</button>
    </header>

    <!-- 본문 -->
    <div class="modal-body">

      <!-- 예약 정보 -->
      <section class="detail-section">
        <h4>예약 정보</h4>
        <ul class="info-grid">
          <li><strong>콘텐츠명</strong> 반 고흐 몰입형 전시</li>
          <li><strong>방문일</strong> 2026-01-12</li>
          <li><strong>시간대</strong> 10:00 ~ 12:00</li>
          <li><strong>예약 인원</strong> 2명</li>
          <li><strong>예약 상태</strong> <span class="badge success">예약 확정</span></li>
          <li><strong>이용 상태</strong> <span class="badge info">이용 전</span></li>
        </ul>
      </section>

      <!-- 결제 정보 -->
      <section class="detail-section">
        <h4>결제 정보</h4>
        <ul class="info-grid">
          <li><strong>결제 수단</strong> 카드</li>
          <li><strong>결제 상태</strong> <span class="badge paid">결제 완료</span></li>
          <li><strong>결제 금액</strong> <strong class="price">₩44,000</strong></li>
          <li><strong>결제 일시</strong> 2024-05-01 09:30:12</li>
        </ul>
      </section>

      <!-- 수령인 정보 -->
      <section class="detail-section">
        <h4>수령인 정보</h4>
        <ul class="info-grid">
          <li><strong>이름</strong> 김*수</li>
          <li><strong>생년월일</strong> 2000.05.12</li>
          <li><strong>이메일</strong> kim***@gmail.com</li>
          <li><strong>연락처</strong> 010-3671-4401</li>
        </ul>
      </section>

    </div>

    <!-- 하단 액션 -->
    <footer class="modal-footer">
      <!-- 관리자 액션 (상태에 따라 노출) -->
      <button class="btn-primary">이용 완료 처리</button>
      <button class="btn-secondary">닫기</button>
    </footer>

  </div>
</div>

</body>
</html>
