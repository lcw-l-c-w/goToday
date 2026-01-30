<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 상세 | GoToday</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage_reserve_detail.css">
</head>
<body>
<h1 class="page-title">예약 상세</h1>
	<div class="top-area">
		<button type="button" class="btn-back" onclick="history.back();" title="목록으로">&lt;</button>
	</div>

	<div class="reservation-wrapper">
		<div class="header-section">
			<div class="info-summary">
				<div class="content-title">${reservationDetailDTO.title}</div>
				<table class="summary-table">
					<tr>
						<th>예약번호</th>
						<td>${reservationDetailDTO.reservation_code}</td>
					</tr>
					<tr>
						<th>일정</th>
						<td>${reservationDetailDTO.reserved_for_at} ${reservationDetailDTO.time_zone}</td>
					</tr>
					<tr>
						<th>장소</th>
						<td>${reservationDetailDTO.location}</td>
					</tr>
					<tr>
						<th>상태</th>
						<td>
							<c:choose>
								<c:when test="${reservationDetailDTO.reservation_status eq 'DONE'}">예약 완료</c:when>
								<c:when test="${reservationDetailDTO.reservation_status eq 'CANCELED'}">예약 취소</c:when>
								<c:when test="${reservationDetailDTO.reservation_status eq 'VISITED'}">이용 완료</c:when>
								<c:otherwise>${reservationDetailDTO.reservation_status}</c:otherwise>
							</c:choose> 
							<c:if test="${reservationDetailDTO.payment_status eq 'WAITING_FOR_DEPOSIT'}">(입금 대기)</c:if>
						</td>
					</tr>
				</table>
			</div>
			<div class="poster-wrapper">
				<img src="${pageContext.request.contextPath}${reservationDetailDTO.main_image_path}" class="poster" />
			</div>
		</div>

		<div class="section-title">수령인 정보</div>
		<table class="data-table">
			<tr>
				<th>이름</th>
				<td>${reservationDetailDTO.receiver_name}</td>
			</tr>
			<tr>
				<th>생년월일</th>
				<td>${reservationDetailDTO.receiver_birth}</td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td>${reservationDetailDTO.receiver_phone}</td>
			</tr>
			<tr>
				<th>수령 방식</th>
				<td>
					<c:choose>
						<c:when test="${reservationDetailDTO.receive_type eq 'MOBILE'}">모바일 티켓</c:when>
						<c:when test="${reservationDetailDTO.receive_type eq 'ONSITE'}">현장 수령</c:when>
						<c:otherwise>${reservationDetailDTO.receive_type}</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</table>

		<div class="section-title">예약 인원</div>
		<table class="data-table">
			<tr>
				<th>인원 상세</th>
				<td>
					<c:if test="${reservationDetailDTO.adult_qty ne 0}">성인: ${reservationDetailDTO.adult_qty}명 </c:if>
					<c:if test="${reservationDetailDTO.teen_qty ne 0}">청소년: ${reservationDetailDTO.teen_qty}명 </c:if>
					<c:if test="${reservationDetailDTO.child_qty ne 0}">아동: ${reservationDetailDTO.child_qty}명 </c:if>
				</td>
			</tr>
		</table>

		<div class="section-title">결제 정보</div>
		<table class="data-table">
			<tr>
				<th>결제 수단</th>
				<td>${reservationDetailDTO.payment_method}</td>
			</tr>

			<%-- 환불/결제 금액 분기 --%>
			<c:choose>
				<%-- 취소 상태일 때 (CANCEL 또는 CANCELED) --%>
				<c:when test="${reservationDetailDTO.payment_status eq 'CANCEL' or reservationDetailDTO.payment_status eq 'CANCELED'}">
					<tr>
						<th>환불 금액</th>
						<td style="font-weight: 700; color: #ff4d4f;">
							<fmt:formatNumber value="${reservationDetailDTO.cancel_amount}" pattern="#,###" />원
						</td>
					</tr>
				</c:when>

				<%-- 정상 결제일 때 --%>
				<c:otherwise>
					<tr>
						<th>결제 금액</th>
						<td style="font-weight: 700;">
							<fmt:formatNumber value="${reservationDetailDTO.amount_price}" pattern="#,###" />원
						</td>
					</tr>
				</c:otherwise>
			</c:choose>

			<tr>
				<th>결제 일시</th>
				<td>${reservationDetailDTO.paid_at}</td>
			</tr>
		</table>

		<br><br>
		<div class="notice-box">
			<span style="font-weight: 700; color: #004680; display: block; margin-bottom: 10px;">예약취소 유의사항</span>
			<p>• 관람일 7일 전까지만 무료 취소가 가능합니다.</p>
			<p>• 관람일 당일에 취소가 불가능합니다.</p>
		</div>
	</div>
</body>
</html>