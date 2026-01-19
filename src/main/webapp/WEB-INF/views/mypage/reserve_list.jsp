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

        <c:forEach var="r" items="${reservationList}">
			<div class="reserve-item">
			
			  <!-- D-Day / END / CANCEL -->
			  <div class="badge ${r.dDay}">
			    ${r.dDay}
			  </div>
			
			  <!-- 날짜 + 상태 -->
			  <div class="datetime">
			    ${r.reserved_for_at} ${r.time_zone}
			    <span class="state">${r.reservation_status}</span>
			  </div>
			
			  <!-- 버튼 -->
			  <button>예약정보</button>
			
			  <c:if test="${r.dDay eq 'END'}">
			    <button>리뷰쓰기</button>
			  </c:if>
			
			</div>
			
			</c:forEach>
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