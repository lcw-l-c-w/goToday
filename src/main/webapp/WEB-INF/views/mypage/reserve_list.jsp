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

body {
    background: #f5f5f5;
    font-family: 'Pretendard', -apple-system, sans-serif;
}

.container {
    max-width: 900px;
    margin: 40px auto;
}

.page-title {
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 30px;
}

/* 카드 */
.reserve-item {
    background: #fff;
    border-radius: 16px;
    padding: 18px;
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    gap: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

/* 왼쪽 정보 */
.reserve-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.reserve-code {
    font-size: 13px;
    color: #888;
}

/* 제목 줄 */
.title-line {
    display: flex;
    align-items: center;
    gap: 8px;
}

.badge {
    padding: 4px 10px;
    border-radius: 14px;
    font-size: 12px;
    font-weight: 700;
    background: #e1f5fe;
    color: #03a9f4;
}

.title {
    font-size: 17px;
    font-weight: 700;
}

.datetime {
    font-size: 13px;
    color: #555;
}

/* 상태 */
.state-line {
    display: flex;
    gap: 10px;
    font-size: 14px;
}

.state.done { color: #4dc3ff; font-weight: 700; }
.state.canceled { color: #ff4444; font-weight: 700; }
.state.visited { color: #28a745; font-weight: 700; }

.payment.waiting {
    color: #ff9800;
    font-weight: 700;
}

/* 버튼 */
.btn-group {
    display: flex;
    gap: 8px;
    margin-top: auto;
}

.btn-group button {
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
}

.info-btn {
    background: #fff;
    border: 1px solid #ddd;
}

.ticket-btn {
    background: #333;
    color: #fff;
    border: none;
}

.review-btn {
    background: #4dc3ff;
    color: #fff;
    border: none;
}

/* 포스터 */
.poster img {
    width: 100px;
    height: 140px;
    border-radius: 12px;
    object-fit: cover;
}

/* 페이징 */
.paging {
    margin-top: 30px;
    text-align: center;
}

.paging a {
    display: inline-block;
    margin: 0 4px;
    padding: 6px 12px;
    border-radius: 6px;
    font-size: 14px;
    text-decoration: none;
    color: #333;
    border: 1px solid #ddd;
}

.paging a.active {
    background: #4dc3ff;
    color: #fff;
    border-color: #4dc3ff;
}

.cancel-btn {
	padding: 10px 24px;
	border: 1px solid #ff4444; /* 빨간 테두리 */
	background: white;
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
								<span class="badge">${r.dday}</span>
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
								<button class="info-btn" data-id="${r.reservation_id}">예약정보</button>

								<c:if test="${r.receive_type eq 'MOBILE'}">
									<button class="ticket-btn" data-id="${r.reservation_id}">모바일 티켓</button>
								</c:if>

								<c:if test="${r.reservation_status eq 'VISITED'}">
									<button class="review-btn"
											data-id="${r.reservation_id}"
											data-content="${r.content_id}">
										리뷰쓰기
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

	</div>
	<script>
		$(function() {
			$(".info-btn").click(
					function() {
						const reservation_id = $(this).data("reservation-id");
						window.location.href = "/gotoday/mypage/reservations/"
								+ reservation_id;
					});

			$(".review-btn")
					.click(
							function() {
								const reservation_id = $(this).data(
										"reservation-id");
								const content_id = $(this).data("content-id");
								window.location.href = "/gotoday/review/write?reservation_id="
										+ reservation_id
										+ "&content_id="
										+ content_id;
							});

			$(".ticket-btn").click(function() {
				const reservation_id = $(this).data("reservation-id");
				window.location.href = "/gotoday/ticket/" + reservation_id;
			});

			// [추가] 예약 취소 버튼 클릭 이벤트
			$(".cancel-btn").click(function() {
				// 1. 숨겨둔 orderId 가져오기
				const orderId = $(this).data("order-id");

				// orderId가 없는 경우 (결제 정보가 없는 예약 등)
				if (!orderId) {
					alert("결제 정보를 찾을 수 없습니다.");
					return;
				}

				// 2. 취소 사유 입력받기
				const reason = prompt("취소 사유를 입력해주세요 (예: 단순 변심)", "단순 변심");

				// 취소 버튼을 눌렀거나 내용이 없으면 중단
				if (reason === null)
					return;
				if (reason.trim() === "") {
					alert("취소 사유를 입력해야 합니다.");
					return;
				}

				if (!confirm("정말로 예약을 취소하시겠습니까?"))
					return;

				// 3. 서버로 전송 (포스트맨과 동일한 설정)
				$.ajax({
					url : "/gotoday/payment/cancel.do", // 포스트맨 URL
					type : "POST",
					contentType : "application/json", // JSON 전송
					data : JSON.stringify({
						orderId : orderId, // 결제 키
						reason : reason
					// 취소 사유
					}),
					success : function(res) {
						if (res.success) {
							alert(res.msg); // "결제가 정상적으로 취소되었습니다."
							location.reload(); // 새로고침하여 상태 변경 반영
						} else {
							alert("취소 실패: " + res.msg);
						}
					},
					error : function(xhr, status, error) {
						console.error(error);
						alert("서버 통신 중 오류가 발생했습니다.");
					}
				});
			});
		});
	</script>
</body>
</html>
