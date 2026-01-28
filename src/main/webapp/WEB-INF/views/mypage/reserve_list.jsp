<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 관리 | GoToday</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage_reserve_list.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
<h1 class="page-title">예약 관리</h1>
<div class="container">
	<div class="page-header">
	    <div class="filter-bar">
	        <a class="filter-btn ticket-btn ${currentFilter eq 'ALL' ? 'active' : ''}"
	           href="${pageContext.request.contextPath}/mypage/reservation?filter=ALL">
	            전체
	        </a>
	
	        <a class="filter-btn ticket-btn ${currentFilter eq 'UPCOMING' ? 'active' : ''}"
	           href="${pageContext.request.contextPath}/mypage/reservation?filter=UPCOMING">
	            이용 예정
	        </a>
	
	        <a class="filter-btn ticket-btn ${currentFilter eq 'END' ? 'active' : ''}"
	           href="${pageContext.request.contextPath}/mypage/reservation?filter=END">
	            종료된 내역
	        </a>
	
	        <a class="filter-btn ticket-btn ${currentFilter eq 'CANCELED' ? 'active' : ''}"
	           href="${pageContext.request.contextPath}/mypage/reservation?filter=CANCELED">
	            예약 취소
	        </a>
	    </div>
	</div>

	<div class="list-wrapper">
		<c:choose>
			<c:when test="${empty reservationList}">
				<div class="empty-box">예약 내역이 없습니다.</div>
			</c:when>

			<c:otherwise>
				<c:forEach var="r" items="${reservationList}">
					<div class="reserve-item">
						<div class="reserve-info">
							<div class="reserve-code">${r.reservation_code}</div>
						<div class="title-line">
							<c:choose>
								<c:when test='${r.dday eq "D-Day"}'>
									<span class="badge dday">${r.dday}</span>
								</c:when>
								<c:when test='${r.dday eq "CANCELED"}'>
									<span class="badge canceled">${r.dday}</span>
								</c:when>
								<c:when test='${r.dday eq "END"}'>
									<span class="badge end">${r.dday}</span>
								</c:when>
								<c:otherwise>
									<span class="badge">${r.dday}</span>
								</c:otherwise>
							</c:choose>
							<span class="title">${r.title}</span>
						</div>

							<div class="state-line">
								<c:choose>
									<c:when test="${r.reservation_status eq 'DONE'}">
										<span class="state done">예약 완료</span>
									</c:when>
									<c:when test="${r.reservation_status eq 'CANCELED'}">
										<span class="state canceled">예약 취소</span>
									</c:when>
									<c:when test="${r.reservation_status eq 'VISITED'}">
										<span class="state visited">이용 완료</span>
									</c:when>
								</c:choose>

								<c:if test="${r.payment_status eq 'WAITING_FOR_DEPOSIT'}">
									<span class="payment waiting">입금대기</span>
								</c:if>

								<span class="datetime">| ${r.reserved_for_at} ${r.time_zone}</span>
							</div>

							<div class="btn-group">
								<button class="info-btn"
									data-reservation-id="${r.reservation_id}">
									예약정보
								</button>

								<c:if test="${r.receive_type eq 'MOBILE' and r.payment_status eq 'DONE'}">
									<button class="ticket-btn"
										data-reservation-id="${r.reservation_id}">
										모바일 티켓
									</button>
								</c:if>

								<c:if test="${r.reservation_status eq 'VISITED'}">
									<c:choose>
										<c:when test = "${r.review_exists eq 1 }">
											<button class = "review-check-btn"
											data-reservation-id = "${r.reservation_id }">
												리뷰 확인하기
											</button>
										</c:when>
										<c:otherwise>
											<button class="review-btn" 
												data-reservation-id = "${r.reservation_id }">
												리뷰쓰기
											</button>
										</c:otherwise>
									</c:choose>
								</c:if>

								<c:if test="${r.reservation_status eq 'DONE' and r.dday ne 'END' and not empty r.order_id}">
									<button class="cancel-btn"
										data-order-id="${r.order_id}"
										data-reservation-id="${r.reservation_id}">
										예약 취소
									</button>
								</c:if>
							</div>
						</div>

						<div class="poster">
							<a href="${pageContext.request.contextPath}/detail/${r.content_id}" target="_top">
								<img src="${pageContext.request.contextPath}${r.main_image_path}" alt="포스터">
							</a>
						</div>

					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
</div>
<jsp:include page="/WEB-INF/views/review/write.jsp" />

<script src="/gotoday/resources/js/review/write.js"></script>
<script>
	$(function() {
		$(".info-btn").click(
				function() {
					const reservation_id = $(this).data("reservation-id");
					window.location.href = "/gotoday/mypage/reservation/"
							+ reservation_id;
				});
		$(".review-btn, .review-check-btn").click(function(e) {
            e.preventDefault(); // 페이지 이동 방지 -> 모달로 띄울 거
            
            const resId = $(this).data("reservation-id");

            // 서버에서 전시명, 위치, 시간대 가져옴
            $.ajax({
                url: "/gotoday/review/getData", 
                type: "GET",
                data: { reservation_id: resId},
                success: function(data) {
                    // 데이터 로드 성공 시 모달에 데이터 세팅 후 오픈
                    openReviewModal(data);
                },
                error: function() {
                    alert("데이터를 불러오는데 실패했습니다.");
                }
            });
		}); 
		
		$(".ticket-btn").not(".review-check-btn").click(function () {
			const reservationId = $(this).data("reservation-id");
			location.href = "/gotoday/ticket/" + reservationId;
		});
	
		$(".cancel-btn").click(function () {
			const orderId = $(this).data("order-id");
			if (!orderId) {
				alert("결제 정보를 찾을 수 없습니다.");
				return;
			}
	
			const reason = prompt("취소 사유를 입력해주세요", "단순 변심");
			if (!reason) return;
	
			if (!confirm("정말 예약을 취소하시겠습니까?")) return;
	
			$.ajax({
			    url: "/gotoday/payment/cancel.do",
			    type: "POST",
			    contentType: "application/json",
			    data: JSON.stringify({ orderId: orderId, reason: reason }),
			    success: function (res) {
			        // [수정] 성공 여부에 따라 분기 처리
			        if (res.success) {
			            // 진짜 취소 성공 시
			            alert(res.msg); // "결제가 정상적으로 취소되었습니다."
			            location.reload();
			        } else {
			            // 로직상 실패 (당일 취소 불가, 이미 취소됨 등)
			            // 서버에서 보낸 e.getMessage()가 res.msg에 들어있음
			            alert(res.msg); // "관람일 당일 및 지난 일정은 취소/환불이 불가합니다." 출력됨
			        }
			    },
			    error: function () {
			        // 이건 진짜 네트워크 에러나 404, 서버 다운일 때만 뜸
			        alert("시스템 오류가 발생했습니다. 관리자에게 문의하세요.");
			    }
			});
		});
	});
</script>
</body>
</html>
