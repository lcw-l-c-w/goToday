<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 예약 관리 | GoToday</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<h1 class="page-title">예약 관리</h1>
	<div class="list-wrapper">
	    <c:choose>
	      <c:when test="${empty reservationList}">
	        <div class="empty-box">
	          	예약 내역이 없습니다.
	        </div>
	      </c:when>
   		<c:otherwise>
   		
   		

        <c:forEach var="r" items="${reservationList}">
        	<p>${r}</p>
			
			<div class="reserve-item">
				<!-- badge: D-Day / END / CANCEL -->
				<div class="badge">
					${r.dday}
				</div>
				
				<!-- 예약 정보 + 날짜 + 상태 -->
				<div class="datetime">
				    <p class="reserve-code">${r.reservation_code}</p>
				
				    <span class="date">${r.reserved_for_at}</span>
				    <span class="time">${r.time_zone}</span>
				
				    <!-- 예약 상태 -->
				    <c:choose>
				        <c:when test="${r.reservation_status eq  'DONE'}">
				            <p class="state done">예약 완료</p>
				        </c:when>
				        <c:when test="${r.reservation_status eq  'CANCELED'}">
				            <p class="state canceled">예약 취소</p>
				        </c:when>
				        <c:when test="${r.reservation_status eq  'VISITED'}">
				            <p class="state visited">이용 완료</p>
				        </c:when>
				        <c:otherwise>
				            <p class="state">${r.reservation_status}</p>
				        </c:otherwise>
				    </c:choose>
				
				    <!-- 결제 상태: 입금 대기만 노출 -->
				    <c:if test="${r.payment_status eq 'WAITING_FOR_DEPOSIT'}">
				        <p class="payment-type waiting">입금 대기</p>
				    </c:if>
				
				    <!-- 수령 방식: MOBILE일 때만 버튼 -->
				    <c:if test="${r.receive_type eq  'MOBILE'}">
				        <button class="ticket-btn"
				                data-reservation-id="${r.reservation_id}">
				            모바일 티켓
				        </button>
				    </c:if>
				
				    <input type="hidden" name="reservation_id" value="${r.reservation_id}">
				</div>
				
				<!-- 콘텐츠 정보 -->
				<div class="reserve-content">
					<p>${r.title}</p>
					<img src="${r.main_image_path }">
				</div>
				
				<!-- 버튼 -->
				<button class="info-btn" data-reservation-id="${r.reservation_id}">예약정보</button>
				
				<c:if test="${r.reservation_status eq 'VISITED'}">
				    <button class="review-btn" 
				    	data-reservation-id="${r.reservation_id}"
				    	data-content-id = "${r.content_id }" >
				    	리뷰쓰기</button>
				</c:if>
			</div>
			
		</c:forEach>
        <!-- 우측 포스터 -->
        <div class="poster">
          <img src="/upload/poster/${r.main_image_path}" alt="포스터">
        </div>
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
        
        $(".info-btn").click(function () {
        	const reservation_id = $(this).data("reservation-id");
            window.location.href = "/gotoday/mypage/reservations/" + reservation_id;
		});
		
		$(".review-btn").click(function () {
			const reservation_id = $(this).data("reservation-id");
			const content_id = $(this).data("content-id");
			window.location.href = "/gotoday/review/write?reservation_id="+reservation_id+"&content_id="+content_id;
		});
    });
</script>

</body>
</html>