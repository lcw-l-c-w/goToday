<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="reservation-detail">

  <!-- 예약 코드 -->
  <h2>예약 상세</h2>
  <p class="reserve-code">
    예약번호: ${reservationDetailDTO.reservation_code}
  </p>

  <!-- 날짜 / 시간 -->
  <div class="datetime">
    <span class="date">
      ${reservationDetailDTO.reserved_for_at}
    </span>
    <span class="time">
      ${reservationDetailDTO.time_zone}
    </span>
  </div>

  <!-- 예약 상태 -->
  <c:choose>
    <c:when test="${reservationDetailDTO.reservation_status eq 'DONE'}">
      <p class="state done">예약 완료</p>
    </c:when>
    <c:when test="${reservationDetailDTO.reservation_status eq 'CANCELED'}">
      <p class="state canceled">예약 취소</p>
    </c:when>
    <c:otherwise>
      <p class="state">
        ${reservationDetailDTO.reservation_status}
      </p>
    </c:otherwise>
  </c:choose>

  <!-- 결제 상태 -->
  <c:if test="${reservationDetailDTO.payment_status eq 'WAITING_FOR_DEPOSIT'}">
    <p class="payment waiting">입금 대기</p>
  </c:if>

  <!-- 콘텐츠 정보 -->
  <div class="content-info">
    <img src="${pageContext.request.contextPath}${reservationDetailDTO.main_image_path}"
         alt="${reservationDetailDTO.title}"
         class="poster"/>

    <h3>${reservationDetailDTO.title}</h3>
    <p class="location">${reservationDetailDTO.location}</p>
  </div>

  <!-- 수령 방식 -->
  <p class="receive-type">
    수령 방식:
    <c:choose>
      <c:when test="${reservationDetailDTO.receive_type eq 'MOBILE'}">
        모바일 티켓
      </c:when>
      <c:when test="${reservationDetailDTO.receive_type eq 'ONSITE'}">
        현장 수령
      </c:when>
      <c:otherwise>
        ${reservationDetailDTO.receive_type}
      </c:otherwise>
    </c:choose>
  </p>

  <!-- 수령인 정보 -->
  <div class="receiver-info">
    <h4>수령인 정보</h4>
    <p>이름: ${reservationDetailDTO.receiver_name}</p>
    <p>생년월일: ${reservationDetailDTO.receiver_birth}</p>
    <p>전화번호: ${reservationDetailDTO.receiver_phone}</p>
  </div>

  <!-- 인원 수 -->
  <div class="qty-info">
    <h4>예약 인원</h4>
    <c:if test="${reservationDetailDTO.adult_qty ne 0}">
      <p>성인: ${reservationDetailDTO.adult_qty}명</p>
    </c:if>
    <c:if test="${reservationDetailDTO.teen_qty ne 0}">
      <p>청소년: ${reservationDetailDTO.teen_qty}명</p>
    </c:if>
    <c:if test="${reservationDetailDTO.child_qty ne 0}">
      <p>아동: ${reservationDetailDTO.child_qty}명</p>
    </c:if>
  </div>

  <!-- 결제 정보 -->
  <div class="payment-info">
    <h4>결제 정보</h4>
    <p>결제 수단: ${reservationDetailDTO.payment_method}</p>
    <p>결제 금액:
      <fmt:formatNumber value="${reservationDetailDTO.amount_price}" pattern="#,###"/>원
    </p>
    <p>결제 일시:
      ${reservationDetailDTO.paid_at}
    </p>
  </div>

</div>
</body>
</html>