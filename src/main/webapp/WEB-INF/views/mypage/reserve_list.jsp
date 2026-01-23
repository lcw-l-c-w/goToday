<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 관리 | GoToday</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { background: #f5f5f5; font-family: 'Pretendard', -apple-system, sans-serif; }
.container { max-width: 900px; margin: 40px auto; }
.page-title { font-size: 28px; font-weight: 700; margin-bottom: 30px; }

.reserve-item {
    background: #ffffff;
    border-radius: 20px;
    padding: 22px 26px;
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    gap: 20px;

    border: 1px solid #eee;
    box-shadow: 0 4px 15px rgba(0,0,0,0.06);

    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.reserve-item:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 22px rgba(77,195,255,0.18);
}

.reserve-info { flex: 1; display: flex; flex-direction: column; gap: 8px; }
.reserve-code { font-size: 13px; color: #888; }

.title-line { display: flex; align-items: center; gap: 8px; }
.badge {
	padding: 4px 10px;
	border-radius: 14px;
	font-size: 12px;
	font-weight: 700;
	background: #e1f5fe;
	color: #03a9f4;
}

/*  badge 색상 조건별 분기 */
.badge.dday {
	background: #fff9c4;
	color: #f57f17;
}
.badge.canceled {
	background: #ffebee;
	color: #ff4444;
}
.badge.end {
	background: #f5f5f5;
	color: #666;
}

.title { font-size: 17px; font-weight: 700; }
.datetime { font-size: 13px; color: #555; }

.state-line { display: flex; gap: 10px; font-size: 14px; }
.state.done { color: #4dc3ff; font-weight: 700; }
.state.canceled { color: #ff4444; font-weight: 700; }
.state.visited { color: #28a745; font-weight: 700; }
.payment.waiting { color: #ff9800; font-weight: 700; }

.btn-group { display: flex; gap: 8px; margin-top: auto; }
.btn-group button {
	padding: 8px 16px;
	border-radius: 8px;
	font-size: 13px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s ease;
}

.info-btn {
    background: white;
    border: 1px solid #4dc3ff;
    color: #4dc3ff;
}
.info-btn:hover {
    background: #4dc3ff;
    color: white;
}
.ticket-btn, .review-check-btn {
    background: white;
    border: 1px solid #333;
    color: #333;
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
}

.ticket-btn:hover, .review-check-btn:hover {
    background: #333;
    color: white;
}

.review-btn {
    background: white;
    border: 1px solid #4dc3ff;
    color: #4dc3ff;
}

.review-btn:hover {
    background: #4dc3ff;
    color: white;
}
.cancel-btn {
    background: white;
    border: 1px solid #ff4444;
    color: #ff4444;
    border-radius: 8px;
	font-size: 14px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s;
}
.cancel-btn:hover {
    background: #ff4444;
    color: white;
}

.poster img {
	width: 100px;
	height: 140px;
	border-radius: 12px;
	object-fit: cover;
}
</style>
</head>

<body>
<div class="container">
	<h1 class="page-title">예약 관리</h1>

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
					window.location.href = "/gotoday/mypage/reservations/"
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
					alert(res.msg);
					location.reload();
				},
				error: function () {
					alert("서버 오류");
				}
			});
		});
	});
</script>
</body>
</html>
