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
										data-reservation-id="${r.reservation_id}"
										data-payment-method="${r.payment_method}"
										data-payment-status="${r.payment_status}">
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

<!-- 예약 취소 모달 -->
<div id="cancelModal" class="cancel-modal-overlay">
	<div class="cancel-modal">
		<div class="cancel-modal-header">
			<h3>예약 취소</h3>
			<button type="button" class="cancel-modal-close">&times;</button>
		</div>
		<div class="cancel-modal-body">
			<div class="cancel-form-group">
				<label for="cancelReason">취소 사유</label>
				<input type="text" id="cancelReason" value="단순 변심" placeholder="취소 사유를 입력해주세요">
			</div>

			<!-- 가상계좌 환불 정보 (조건부 표시) -->
			<div id="refundAccountSection" style="display: none;">
				<hr style="margin: 20px 0; border: none; border-top: 1px solid #eee;">
				<p style="font-size: 14px; color: #666; margin-bottom: 15px;">
					가상계좌 결제 건은 환불받을 계좌 정보가 필요합니다.
				</p>

				<div class="cancel-form-group">
					<label for="refundAccountNumber">계좌번호</label>
					<input type="text" id="refundAccountNumber" placeholder="계좌번호를 입력해주세요 (예: 123-456-789012)">
				</div>

				<div class="cancel-form-group">
					<label>은행명</label>
					<div class="bank-input-toggle">
						<label class="radio-label">
							<input type="radio" name="bankInputType" value="select" checked> 선택하기
						</label>
						<label class="radio-label">
							<input type="radio" name="bankInputType" value="manual"> 직접 입력
						</label>
					</div>

					<select id="refundBankSelect" class="bank-select">
						<option value="">은행을 선택해주세요</option>
						<option value="경남은행">경남은행</option>
						<option value="광주은행">광주은행</option>
						<option value="국민은행">국민은행</option>
						<option value="기업은행">기업은행</option>
						<option value="농협은행">농협은행</option>
						<option value="대구은행">대구은행</option>
						<option value="부산은행">부산은행</option>
						<option value="산업은행">산업은행</option>
						<option value="새마을금고">새마을금고</option>
						<option value="수협은행">수협은행</option>
						<option value="신한은행">신한은행</option>
						<option value="신협은행">신협은행</option>
						<option value="우리은행">우리은행</option>
						<option value="우체국">우체국</option>
						<option value="전북은행">전북은행</option>
						<option value="제주은행">제주은행</option>
						<option value="카카오뱅크">카카오뱅크</option>
						<option value="케이뱅크">케이뱅크</option>
						<option value="토스뱅크">토스뱅크</option>
						<option value="하나은행">하나은행</option>
						<option value="SC제일은행">SC제일은행</option>
					</select>

					<input type="text" id="refundBankManual" class="bank-manual-input" placeholder="은행명을 입력해주세요" style="display: none;">
				</div>

				<div class="cancel-form-group">
					<label for="refundHolderName">예금주</label>
					<input type="text" id="refundHolderName" placeholder="예금주를 입력해주세요">
				</div>
			</div>
		</div>
		<div class="cancel-modal-footer">
			<button type="button" class="cancel-modal-btn cancel-modal-btn-secondary" id="cancelModalClose">취소</button>
			<button type="button" class="cancel-modal-btn cancel-modal-btn-primary" id="cancelModalConfirm">예약 취소</button>
		</div>
	</div>
</div>

<style>
/* 취소 모달 스타일 */
.cancel-modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	z-index: 9999;
	justify-content: center;
	align-items: center;
}

.cancel-modal-overlay.show {
	display: flex;
}

.cancel-modal {
	background: #fff;
	border-radius: 12px;
	width: 90%;
	max-width: 420px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
	overflow: hidden;
}

.cancel-modal-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 18px 20px;
	border-bottom: 1px solid #eee;
}

.cancel-modal-header h3 {
	margin: 0;
	font-size: 18px;
	font-weight: 600;
}

.cancel-modal-close {
	background: none;
	border: none;
	font-size: 24px;
	cursor: pointer;
	color: #999;
	padding: 0;
	line-height: 1;
}

.cancel-modal-close:hover {
	color: #333;
}

.cancel-modal-body {
	padding: 20px;
}

.cancel-form-group {
	margin-bottom: 16px;
}

.cancel-form-group label {
	display: block;
	margin-bottom: 6px;
	font-size: 14px;
	font-weight: 500;
	color: #333;
}

.cancel-form-group input[type="text"],
.cancel-form-group select {
	width: 100%;
	padding: 10px 12px;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-size: 14px;
	box-sizing: border-box;
}

.cancel-form-group input[type="text"]:focus,
.cancel-form-group select:focus {
	outline: none;
	border-color: #007bff;
}

.bank-input-toggle {
	display: flex;
	gap: 16px;
	margin-bottom: 10px;
}

.radio-label {
	display: flex;
	align-items: center;
	gap: 6px;
	font-size: 14px;
	cursor: pointer;
}

.radio-label input[type="radio"] {
	margin: 0;
}

.cancel-modal-footer {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	padding: 16px 20px;
	border-top: 1px solid #eee;
	background: #f9f9f9;
}

.cancel-modal-btn {
	padding: 10px 20px;
	border: none;
	border-radius: 6px;
	font-size: 14px;
	font-weight: 500;
	cursor: pointer;
	transition: background 0.2s;
}

.cancel-modal-btn-secondary {
	background: #e9e9e9;
	color: #333;
}

.cancel-modal-btn-secondary:hover {
	background: #ddd;
}

.cancel-modal-btn-primary {
	background: #dc3545;
	color: #fff;
}

.cancel-modal-btn-primary:hover {
	background: #c82333;
}
</style>

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

		// 취소 모달 관련 변수
		let currentOrderId = null;
		let currentPaymentMethod = null;
		let currentPaymentStatus = null;

		const $cancelModal = $("#cancelModal");
		const $refundSection = $("#refundAccountSection");
		const $bankSelect = $("#refundBankSelect");
		const $bankManual = $("#refundBankManual");

		// 은행 입력 방식 토글
		$("input[name='bankInputType']").change(function() {
			if ($(this).val() === "select") {
				$bankSelect.show();
				$bankManual.hide().val("");
			} else {
				$bankSelect.hide().val("");
				$bankManual.show();
			}
		});

		// 모달 열기
		$(".cancel-btn").click(function () {
			currentOrderId = $(this).data("order-id");
			if (!currentOrderId) {
				alert("결제 정보를 찾을 수 없습니다.");
				return;
			}

			currentPaymentMethod = $(this).data("payment-method");
			currentPaymentStatus = $(this).data("payment-status");

			// 폼 초기화
			$("#cancelReason").val("단순 변심");
			$("#refundAccountNumber").val("");
			$("#refundHolderName").val("");
			$bankSelect.val("");
			$bankManual.val("");
			$("input[name='bankInputType'][value='select']").prop("checked", true).trigger("change");

			// 가상계좌 + 결제완료 상태면 환불계좌 섹션 표시
			if (currentPaymentMethod === "가상계좌" && currentPaymentStatus === "DONE") {
				$refundSection.show();
			} else {
				$refundSection.hide();
			}

			$cancelModal.addClass("show");
		});

		// 모달 닫기
		$(".cancel-modal-close, #cancelModalClose").click(function() {
			$cancelModal.removeClass("show");
		});

		// 모달 외부 클릭 시 닫기
		$cancelModal.click(function(e) {
			if ($(e.target).hasClass("cancel-modal-overlay")) {
				$cancelModal.removeClass("show");
			}
		});

		// 예약 취소 확인
		$("#cancelModalConfirm").click(function() {
			const reason = $("#cancelReason").val().trim();
			if (!reason) {
				alert("취소 사유를 입력해주세요.");
				return;
			}

			let accountNumber = null;
			let bank = null;
			let holderName = null;

			// 가상계좌 + 결제완료 상태면 환불계좌 정보 필수
			if (currentPaymentMethod === "가상계좌" && currentPaymentStatus === "DONE") {
				accountNumber = $("#refundAccountNumber").val().trim();
				holderName = $("#refundHolderName").val().trim();

				// 은행명: select 또는 직접입력
				const bankInputType = $("input[name='bankInputType']:checked").val();
				if (bankInputType === "select") {
					bank = $bankSelect.val();
				} else {
					bank = $bankManual.val().trim();
				}

				if (!accountNumber || !bank || !holderName) {
					alert("환불 계좌 정보를 모두 입력해주세요.");
					return;
				}
			}

			if (!confirm("정말 예약을 취소하시겠습니까?")) return;

			$cancelModal.removeClass("show");

			if (currentPaymentMethod === "가상계좌" && currentPaymentStatus === "DONE") {
				$.ajax({
				    url: "/gotoday/payment/account/refund.do",
				    type: "POST",
				    contentType: "application/json",
				    data: JSON.stringify({
				    	orderId: currentOrderId,
				    	reason: reason,
				    	accountNumber: accountNumber,
				    	bank: bank,
				    	holderName: holderName
				    }),
				    success: function (res) {
				        if (res.success) {
				            alert(res.msg);
				            location.reload();
				        } else {
				            alert(res.msg);
				        }
				    },
				    error: function () {
				        alert("시스템 오류가 발생했습니다. 관리자에게 문의하세요.");
				    }
				});

			} else {
				$.ajax({
				    url: "/gotoday/payment/cancel.do",
				    type: "POST",
				    contentType: "application/json",
				    data: JSON.stringify({ orderId: currentOrderId, reason: reason}),
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
			}
		});
	});
</script>
</body>
</html>
