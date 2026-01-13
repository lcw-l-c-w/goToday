<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<div class="admin-layout">

  <!-- ================= 메인 콘텐츠 ================= -->
  <main class="admin-content">

    <!-- 탭 -->
    <div class="tab-menu">
      <button>전시 관리</button>
      <button class="active">사용자 관리</button>
      <button>문의 사항</button>
    </div>

    <!-- 페이지 타이틀 -->
    <h2 class="page-title">사용자 관리</h2>

    <!-- 검색 -->
    <div class="toolbar">
      <input type="text" placeholder="이메일 또는 이름 검색" />
      <button class="btn-primary">검색</button>
    </div>

    <!-- ================= 사용자 리스트 ================= -->
    <section class="table-wrap">

      <!-- 테이블 헤더 -->
      <div class="table-header">
        <span>상태</span>
        <span>이메일</span>
        <span>이름</span>
        <span>핸드폰 번호</span>
        <span>생년월일</span>
        <span>관리</span>
      </div>

      <!-- 테이블 바디 -->
      <ul class="table-body">

        <!-- 사용자 row -->
        <li class="table-row">
          <span><span class="badge user">사용자</span></span>
          <span>honggildong@gmail.com</span>
          <span>홍길동</span>
          <span>010-1234-1234</span>
          <span>1990-03-19</span>
          <span class="actions">
            <!-- 회원 탈퇴 -->
            <button class="btn-danger">회원탈퇴</button>
          </span>
        </li>

        <!-- 업체 row -->
        <li class="table-row">
          <span><span class="badge vendor">업체</span></span>
          <span>vendor01@company.com</span>
          <span>전시업체A</span>
          <span>010-5678-9999</span>
          <span>1985-07-11</span>
          <span class="actions">
            <button class="btn-danger">회원탈퇴</button>
          </span>
        </li>

        <!-- 비활성 사용자 -->
        <li class="table-row">
          <span><span class="badge inactive">탈퇴</span></span>
          <span>leaveuser@gmail.com</span>
          <span>이탈퇴</span>
          <span>010-0000-0000</span>
          <span>1995-01-01</span>
          <span class="actions">
            <!-- 이미 탈퇴된 경우 비활성화 -->
            <button class="btn-disabled" disabled>탈퇴완료</button>
          </span>
        </li>

      </ul>

    </section>
    <!-- ================= 사용자 리스트 END ================= -->

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