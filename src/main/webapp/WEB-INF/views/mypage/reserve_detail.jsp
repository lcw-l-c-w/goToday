<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 상세 | GoToday</title>
<style>
    :root { --main-color: #4dc3ff; --color-button-inactive: #d9d9d9; }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body { 
        font-family: 'Pretendard', sans-serif; 
        background-color: #f5f5f5; 
        padding: 40px 20px; 
    }
    
    /* 상단 레이아웃: 제목과 버튼을 양끝으로 배치 */
    .top-area {
        max-width: 900px;
        margin: 0 auto 30px auto;
        display: flex;
        justify-content: space-between; /* 양끝 정렬 */
        align-items: center; /* 세로 중앙 정렬 */
    }

    .page-title { 
        font-size: 32px; 
        font-weight: 700; 
        color: #111;
    }

    /* 우측 끝 동그란 < 버튼 */
    .btn-back {
        width: 36px;
        height: 36px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 50%;
        cursor: pointer;
        transition: 0.2s;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        color: #333;
        font-weight: 700;
        font-size: 18px;
        line-height: 1;
        padding-right: 2px; /* < 모양 중앙 보정 */
    }
    .btn-back:hover {
        background-color: #eee;
        transform: scale(1.1); /* 우측에 있으므로 크기가 살짝 커지는 효과 */
    }

    /* 공통 흰색 박스 스타일 */
    .reservation-wrapper { 
        width: 100%; 
        max-width: 900px; 
        background: #fff; 
        padding: 40px; 
        border-radius: 20px; 
        box-shadow: 0 4px 20px rgba(0,0,0,0.05); 
        margin: 0 auto; 
    }

    /* 내부 레이아웃 생략 (기존과 동일) */
    .header-section { display: flex; justify-content: space-between; gap: 40px; padding-bottom: 30px; border-bottom: 1px solid #eee; }
    .info-summary { flex: 1; }
    .content-title { font-size: 24px; font-weight: 700; color: #333; margin-bottom: 20px; }
    .summary-table { width: 100%; border-collapse: collapse; }
    .summary-table th { text-align: left; padding: 10px 0; color: #888; font-weight: 500; width: 100px; font-size: 15px; }
    .summary-table td { padding: 10px 0; font-weight: 600; font-size: 15px; color: #333; }
    .poster-wrapper { width: 220px; }
    .poster { width: 100%; border-radius: 12px; box-shadow: 0 8px 15px rgba(0,0,0,0.1); object-fit: cover; }
    .section-title { font-size: 18px; font-weight: 700; margin-top: 40px; margin-bottom: 20px; color: #111; }
    .data-table { width: 100%; border-collapse: collapse; border-top: 1px solid #ddd; }
    .data-table th { background-color: var(--main-color); color: #fff; text-align: left; padding: 12px 20px; width: 180px; border-bottom: 1px solid #eee; font-size: 14px; }
    .data-table td { padding: 12px 20px; border-bottom: 1px solid #eee; font-size: 14px; }
    .notice-box { background-color: #f9f9f9; padding: 20px; border-radius: 12px; font-size: 14px; color: #666; line-height: 1.6; }
</style>
</head>
<body>

    <div class="top-area">
        <h1 class="page-title">예약 상세</h1>
        
        <button type="button" class="btn-back" onclick="history.back();" title="목록으로">
            &lt;
        </button>
    </div>

    <div class="reservation-wrapper">
        <div class="header-section">
            <div class="info-summary">
                <div class="content-title">${reservationDetailDTO.title}</div>
                <table class="summary-table">
                    <tr><th>예약번호</th><td>${reservationDetailDTO.reservation_code}</td></tr>
                    <tr><th>일정</th><td>${reservationDetailDTO.reserved_for_at} ${reservationDetailDTO.time_zone}</td></tr>
                    <tr><th>장소</th><td>${reservationDetailDTO.location}</td></tr>
                    <tr>
                        <th>상태</th>
                        <td>
                            <c:choose>
                                <c:when test="${reservationDetailDTO.reservation_status eq 'DONE'}">예약 완료</c:when>
                                <c:when test="${reservationDetailDTO.reservation_status eq 'CANCELED'}">예약 취소</c:when>
                                <c:otherwise>${reservationDetailDTO.reservation_status}</c:otherwise>
                            </c:choose>
                            <c:if test="${reservationDetailDTO.payment_status eq 'WAITING_FOR_DEPOSIT'}">(입금 대기)</c:if>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="poster-wrapper">
                <img src="${pageContext.request.contextPath}${reservationDetailDTO.main_image_path}" class="poster"/>
            </div>
        </div>

        <div class="section-title">수령인 정보</div>
        <table class="data-table">
            <tr><th>이름</th><td>${reservationDetailDTO.receiver_name}</td></tr>
            <tr><th>생년월일</th><td>${reservationDetailDTO.receiver_birth}</td></tr>
            <tr><th>전화번호</th><td>${reservationDetailDTO.receiver_phone}</td></tr>
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
            <tr><th>결제 수단</th><td>${reservationDetailDTO.payment_method}</td></tr>
            <tr><th>결제 금액</th><td style="font-weight: 700;"><fmt:formatNumber value="${reservationDetailDTO.amount_price}" pattern="#,###"/>원</td></tr>
            <tr><th>결제 일시</th><td>${reservationDetailDTO.paid_at}</td></tr>
        </table>

        <br><br>
        <div class="notice-box">
            <span style="font-weight: 700; color: #004680; display: block; margin-bottom: 10px;">예약취소 유의사항</span>
            <p>• 관람일 전날까지만 무료 취소가 가능합니다.</p>
            <p>• 관람일 당일에 취소가 불가능합니다.</p>
        </div>
    </div>
</body>
</html>