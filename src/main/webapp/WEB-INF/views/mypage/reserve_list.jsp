<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GoToday | My Page</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
<div class="mypage-wrap">
	<!-- 좌측 사이드바 -->
  	<section class="sidebar">
    	<h3>주문관리</h3>
	    <ul>
	      <li class="active">예약관리</li>
	      <li>나의리뷰</li>
	      <li>찜관리</li>
	    </ul>

	    <h3>문의내역</h3>
	    <ul>
	      <li>1:1문의</li>
	    </ul>

	    <h3>회원관리</h3>
	    <ul>
	      <li>내정보수정</li>
	      <li>관심사 설정</li>
	    </ul>
  	</section>

	<!-- 우측 컨텐츠 -->
	<section class="content">
	    <h2>예약관리</h2>
	
	    <c:choose>
	      <c:when test="${empty reservationList}">
	        <div class="empty-box">
	          	예약 내역이 없습니다.
	        </div>
	      </c:when>
      <c:otherwise>

        <c:forEach var="VO" items="${reservationList}">
          <div class="reserve-item ${vo.reservation_status}">
            <!-- 상단 상태 바 (CANCEL 전용) -->
            <c:if test="${vo.reservation_status eq 'CANCELED'}">
              <div class="cancel-bar">CANCELED</div>
            </c:if>

            <!-- 좌측 정보 -->
            <div class="info">

            <!-- D-Day / END 배지 -->
            <div class="badge ${r.statusBadge}">
              ${r.statusBadge}
            </div>

            <!-- 제목 -->
            <div class="title">
              ${r.contentTitle}
            </div>

            <!-- 날짜 + 상태 -->
            <div class="datetime">
              ${r.displayDate}
              <span class="state">${r.statusLabel}</span>
            </div>

            <!-- 취소 카드 상세 영역 -->
            <c:if test="${r.statusBadge eq 'CANCELED'}">
              <div class="cancel-info">
                <div>예약번호 <span>${r.reservationCode}</span></div>
                <div>전시회 이름 <span>${r.contentTitle}</span></div>
                <div>날짜 <span>${r.displayDate}</span></div>
              </div>
            </c:if>

            <!-- 버튼 영역 -->
            <div class="btn-group">
				<button onclick="location.href='/mypage/reservation/${r.reservationId}'">
               		예약정보
              	</button>

              	<c:if test="${r.statusBadge eq 'END'}">
                	<button onclick="location.href='/review/write?reservationId=${r.reservationId}'">
                  		리뷰쓰기
                	</button>
              	</c:if>

              	<c:if test="${r.statusBadge eq 'CANCELED'}">
                	<button>모바일 티켓</button>
                	<button>상세내역</button>
              	</c:if>
           	</div>
        </div>

            <!-- 우측 포스터 -->
            <div class="poster">
              <img src="/upload/poster/${r.posterImg}" alt="포스터">
            </div>

          </div>

        </c:forEach>

      </c:otherwise>
    </c:choose>

    <!-- 페이징 -->
    <div class="paging">
      &lt;&lt; 1 2 3 4 5 &gt;&gt;
    </div>

  </section>

</div>

<script>
    $(function() {
        // 탭 전환 이벤트
        $(".tab-item").click(function() {
            $(".tab-item").removeClass("active");
            $(this).addClass("active");
            // 탭 클릭시 AJAX로 데이터를 다시 불러오거나 섹션을 숨길 수 있습니다.
        });
    });
</script>

</body>
</html>