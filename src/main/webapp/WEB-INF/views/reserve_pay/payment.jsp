<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>GoToday - 결제하기</title>
    <script src="https://js.tosspayments.com/v1/payment"></script>
    <style>
        /* [공통 스타일] */
        :root { --main-color: #4dc3ff; --text-color: #333; --border-color: #eee; --bg-gray: #f9f9f9; }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Pretendard', sans-serif; background-color: var(--bg-gray); color: var(--text-color); }
        a { text-decoration: none; color: inherit; }

        /* [헤더] */
        .header { width: 100%; border-bottom: 1px solid #eee; background: #fff; position: sticky; top: 0; z-index: 1000; }
        .nav-container { max-width: 1100px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; padding: 0 20px; height: 70px; }
        .logo img { height: 32px; cursor: pointer; display: block; }
        .nav-menu { display: flex; gap: 35px; height: 100%; list-style: none; align-items: center; }
        .nav-menu a { font-weight: 600; font-size: 15px; color: #333; transition: color 0.3s ease; }
        .nav-menu a:hover { color: var(--main-color); }
        .nav-icons { display: flex; gap: 20px; align-items: center; }
        .user-icon { font-size: 22px; cursor: pointer; transition: color 0.2s; }
        .user-icon:hover { color: var(--main-color); }

        /* [메인 컨테이너] */
        .main-wrapper { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        .section-title { font-size: 20px; font-weight: 700; margin-bottom: 15px; color: #222; display: flex; align-items: center; gap: 8px;}
        .section-title::before { content: ''; display: block; width: 4px; height: 20px; background: var(--main-color); border-radius: 2px; }

        /* [카드 박스 공통] */
        .card-box {
            background: #fff; border-radius: 15px; padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03); border: 1px solid var(--border-color);
            margin-bottom: 25px;
        }

        /* 주문 정보 (영수증 스타일) */
        .receipt-list { list-style: none; }
        .receipt-item { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 15px; color: #555; }
        .receipt-item.total { border-top: 1px dashed #ddd; padding-top: 15px; margin-top: 15px; font-weight: 700; font-size: 18px; color: #333; }
        .receipt-item.total span:last-child { color: var(--main-color); font-size: 22px; }

        /* 입력 폼 */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .form-group { margin-bottom: 15px; }
        .form-group.full { grid-column: span 2; }
        .form-label { display: block; font-size: 14px; margin-bottom: 8px; font-weight: 600; color: #555; }
        .form-input { 
            width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 10px; 
            font-size: 15px; outline: none; transition: 0.2s; 
        }
        .form-input:focus { border-color: var(--main-color); box-shadow: 0 0 0 3px rgba(77, 195, 255, 0.1); }
        .info-text { font-size: 13px; color: #888; margin-top: 5px; }

        /* 라디오 선택 카드 */
        .radio-group { display: flex; gap: 10px; }
        .radio-option { flex: 1; position: relative; }
        .radio-option input {
		    position: absolute;
		    opacity: 0;
		    width: 0;
		    height: 0;
		}
        .radio-option input:checked + .radio-box {
			border-color: var(--main-color);
			background: #eef9ff;
			color: var(--main-color);
			box-shadow: 0 0 0 3px rgba(77, 195, 255, 0.15);
		}
        .radio-box { 
            display: block; padding: 15px; text-align: center; 
            border: 1px solid #ddd; border-radius: 10px; cursor: pointer; 
            font-weight: 600; color: #666; transition: 0.2s;
        }
        .radio-option input:checked + .radio-box { 
            border-color: var(--main-color); background: #eef9ff; color: var(--main-color); 
        }

        /* 약관 동의 */
        .agreement-box { background: #f8f9fa; border-radius: 10px; padding: 15px; }
        .agree-item { display: flex; align-items: center; padding: 8px 0; font-size: 14px; }
        .agree-item input { margin-right: 10px; accent-color: var(--main-color); width: 18px; height: 18px; }
        .all-agree { border-bottom: 1px solid #ddd; padding-bottom: 10px; margin-bottom: 10px; font-weight: 700; }

        /* 하단 결제 버튼 */
        .payment-btn {
            width: 100%; padding: 20px; background: var(--main-color); color: #fff;
            border: none; border-radius: 15px; font-size: 20px; font-weight: 800;
            cursor: pointer; transition: 0.3s; box-shadow: 0 10px 25px rgba(77, 195, 255, 0.3);
            margin-top: 10px;
        }
        .payment-btn:hover { background: #38b2f0; transform: translateY(-3px); }
        
        .refund-content {
		    border: 1px solid var(--border-color);
		    border-radius: 12px;
		    overflow: hidden;
		    background: #fff;
		    margin-bottom: 20px;
		}
		
		/* 상단 토글 헤더 */
		.refund-toggle {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    padding: 16px 18px;
		    cursor: pointer;
		    background: #f8fbfd;
		    font-size: 15px;
		    font-weight: 700;
		    color: #333;
		    transition: background 0.25s ease;
		}
		
		.refund-toggle:hover {
		    background: #eef9ff;
		}
		
		.refund-arrow {
		    font-size: 14px;
		    color: #666;
		    transition: transform 0.3s ease;
		}
		
		/* 열렸을 때 화살표 회전 */
		.refund-content.open .refund-arrow {
		    transform: rotate(180deg);
		}
		
		/* 상세 영역 */
		.refund-detail {
		    display: none;
		    padding: 20px 22px;
		    background: #ffffff;
		    border-top: 1px solid #eee;
		}
		
		/* 섹션 단위 */
		.refund-section {
		    margin-bottom: 20px;
		}
		
		.refund-section:last-child {
		    margin-bottom: 0;
		}
		
		/* 소제목 */
		.refund-section h4 {
		    font-size: 14px;
		    font-weight: 700;
		    color: #222;
		    margin-bottom: 8px;
		    display: flex;
		    align-items: center;
		    gap: 6px;
		}
		
		.refund-section h4::before {
		    content: '';
		    width: 4px;
		    height: 14px;
		    background: var(--main-color);
		    border-radius: 2px;
		}
		
		/* 리스트 */
		.refund-section ul {
		    padding-left: 18px;
		    list-style-type: none;
		}
		
		.refund-section li {
		    font-size: 14px;
		    color: #555;
		    line-height: 1.6;
		    margin-bottom: 6px;
		}
		
		/* 강조 텍스트 */
		.refund-section strong {
		    color: #222;
		    font-weight: 700;
		}
		
		/* 하단 환불 안내 박스 */
		.refund-notice {
		    background: #f9f9f9;
		    border-radius: 10px;
		    padding: 14px 16px;
		    font-size: 13px;
		    color: #666;
		    line-height: 1.5;
		}
		
		/* 모바일 대응 */
		@media (max-width: 600px) {
		    .refund-toggle {
		        font-size: 14px;
		        padding: 14px 16px;
		    }
		
		    .refund-detail {
		        padding: 16px;
		    }
		
		    .refund-section h4 {
		        font-size: 13px;
		    }
		
		    .refund-section li {
		        font-size: 13px;
		    }
		}
		        
    </style>
</head>
<body>
    <header class="header">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
    </header>

    <main class="main-wrapper">
        <div style="text-align: center; margin-bottom: 30px;">
            <h1 style="font-size: 24px; font-weight: 700;">주문 및 결제</h1>
        </div>

        <form id="paymentForm">
            <h2 class="section-title">주문 정보</h2>
            <div class="card-box">
                <ul class="receipt-list">
                    <li class="receipt-item"><span>상품명</span> <strong>${contentVo.title}</strong></li>
                    <li class="receipt-item"><span>예약 일정</span>${reservation.reserved_for_at} | ${reservation.time_zone} 타임</li>
                    <li class="receipt-item"><span>장소</span>${contentVo.location}</li>
                    <hr style="border:0; border-top:1px solid #eee; margin:15px 0;">
                    <li class="receipt-item">
                        <span>선택 수량</span> 
                        <span>성인 ${reservation.adult_qty} / 청소년 ${reservation.teen_qty} / 어린이 ${reservation.child_qty}</span>
                    </li>
                    <li class="receipt-item total">
                        <span>총 결제금액</span>
                        <span>${reservation.total_price}원</span>
                    </li>
                </ul>
            </div>
            
			<h2 class="section-title">예약자 정보</h2>
            <div class="card-box">
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">이름</label>
                        <input type="text" name="reserver_name" class="form-input" value="${receiver_info.name}" readonly>
                    </div>
                    <div class="form-group">
                        <label class="form-label">생년월일</label>
                        <input type="text" name="receiver_birth" class="form-input" value="${receiver_info.birthday}" readonly>
                    </div>
                    <div class="form-group full">
                        <label class="form-label">이메일</label>
                        <input type="text" name="receiver_email" class="form-input" value="${receiver_info.email}" placeholder="example@email.com">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">휴대폰 번호</label>
                        <input type="text" name="receiver_phone" class="form-input" value="${receiver_info.phone_number}" placeholder="010-0000-0000">
                    </div>
                </div>
                <p class="info-text">
               		※ 입력하신 정보로 예약 내역을 조회합니다. 정확하게 기입해 주세요.<br>
                </p>
            </div>
            <h2 class="section-title">수령인 정보</h2>
            <div class="card-box">
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">이름</label>
                        <input type="text" name="receiver_name" class="form-input" value="${receiver_info.name}" placeholder="이름을 입력하세요">
                    </div>
                    <div class="form-group">
                        <label class="form-label">생년월일</label>
                        <input type="text" name="receiver_birth" class="form-input" value="${receiver_info.birthday}" placeholder="YYYY-MM-DD">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">이메일</label>
                        <input type="text" name="receiver_email" class="form-input" value="${receiver_info.email}" placeholder="example@email.com">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">휴대폰 번호</label>
                        <input type="text" name="receiver_phone" class="form-input" value="${receiver_info.phone_number}" placeholder="010-0000-0000">
                    </div>
                </div>
                <p class="info-text">
               		※ 기본적으로 회원 정보로 입력됩니다.<br>
               		※ 입장 시, 입력하신 정보로 조회됩니다. 정확하게 기입해 주세요.<br>
                </p>
            </div>

            <h2 class="section-title">수령 및 결제 선택</h2>
            <div class="card-box">
                <label class="form-label" style="margin-bottom:10px;">티켓 수령 방법</label>
					<div class="radio-group" style="margin-bottom: 20px;">
					  <label class="radio-option">
					    <input type="radio" name="receive_type" value="ONSITE" checked>
					    <span class="radio-box">현장 수령</span>
					  </label>
					  <label class="radio-option">
					    <input type="radio" name="receive_type" value="MOBILE">
					    <span class="radio-box">모바일 티켓</span>
					  </label>
					</div>
					
					<div id="payment-method-section">
					  <label class="form-label" style="margin-bottom:10px;">결제 수단</label>
					  <div class="radio-group">
					    <label class="radio-option">
					      <input type="radio" name="payMethod" value="CARD" checked>
					      <span class="radio-box">신용/체크카드 및 간편결제</span>
					    </label>
					    <label class="radio-option">
					      <input type="radio" name="payMethod" value="VIRTUAL_ACCOUNT">
					      <span class="radio-box">가상계좌</span>
					    </label>
					  </div>
					</div>
            </div>
            
            <div class="refund-content">

		    <!-- 토글 헤더 -->
		    <div class="refund-toggle">
		      <span>결제 · 취소 · 환불 정책 안내</span>
		      <span class="refund-arrow">▼</span>
		    </div>
		 	
			  <!-- 토글 본문 -->
			  <div class="refund-detail">
			
			    <div class="refund-section">
			      <h4>예매 정책</h4>
			      <ul>
			        <li>1인당 최대 <strong>10매</strong>까지 예매 가능합니다.</li>
			        <li>
			          관람일 당일 00:00 이후 예약 건은
			          <strong>취소 및 환불이 불가</strong>합니다.
			        </li>
			      </ul>
			    </div>
			
			    <div class="refund-section">
			      <h4>취소 및 환불 정책</h4>
			      <ul>
			        <li>
			          취소 및 환불은
			          <strong>관람일 전일 23:59:59까지</strong> 가능합니다.
			        </li>
			        <li>
			          관람일 당일 관람 시작 시간 이후 미입장(No-Show) 시
			          <strong>환불이 불가</strong>합니다.
			        </li>
			      </ul>
			    </div>
			
			    <div class="refund-section">
			      <h4>취소 수수료 안내</h4>
			      <ul>
			        <li>관람일 7일 전까지: 티켓 금액의 <strong>10%</strong></li>
			        <li>관람일 3일 전까지: 티켓 금액의 <strong>30%</strong></li>
			        <li>관람일 1일 전까지: 티켓 금액의 <strong>50%</strong></li>
			      </ul>
			    </div>
			
			    <div class="refund-section">
			      <h4>예매 변경 안내</h4>
			      <ul>
			        <li>
			          동일 상품에 대해 날짜, 시간, 수량, 결제수단 등의 변경을 원하는 경우,
			          <strong>기존 예매 건을 취소한 후 재예매</strong>해야 합니다.
			        </li>
			        <li>
			          단,취소 시점에 따라
			          <strong>취소 수수료가 부과</strong>될 수 있습니다.
			        </li>
			      </ul>
			    </div>
			
			    <div class="refund-section refund-notice">
			      <p>
			        환불 완료 후 실제 환불 시점은 결제수단에 따라 상이하며<br>
			        <strong>영업일 기준 3~7일</strong> 정도 소요될 수 있습니다.<br>
			        ※ 취소 및 환불 가능 여부는 당사 시스템 시간을 기준으로 판단됩니다.
			      </p>
			    </div>
			
			  </div>
			</div>

            <h2 class="section-title">약관 동의</h2>
            <div class="card-box">
                <div class="agreement-box">
                    <div class="agree-item all-agree">
                        <label><input type="checkbox" name="agreeAll"> 주문 내용 및 약관 전체 동의</label>
                    </div>
                    <div class="agree-item">
                        <label><input type="checkbox" name="agreeCancelPolicy" value="Y"> [필수] 취소 및 환불 규정 안내</label>
                    </div>
                    <div class="agree-item">
                        <label><input type="checkbox" name="agreePrivacy" value="Y"> [필수] 개인정보 수집 및 이용 동의</label>
                    </div>
                </div>
            </div>

            <button type="button" id="payment-button" class="payment-btn">
                ${reservation.total_price}원 결제하기
            </button>
        </form>
    </main>

    <script>
        const button = document.getElementById("payment-button");
        const totalPrice = Number("${reservation.total_price}");
	
	    const paymentMethodSection = document.getElementById("payment-method-section");

	    if (totalPrice === 0) {
	        if (paymentMethodSection) {
	            paymentMethodSection.style.display = "none";
	        }
	        button.textContent = "무료 전시 예약하기";
	    }
      
        //클라이언트 키
        const clientKey = "test_ck_mBZ1gQ4YVXgBY9gRN47j3l2KPoqN"; 
        const tossPayments = TossPayments(clientKey);

        // 전체 동의 스크립트 추가 (UX 개선)
        const agreeAll = document.querySelector('input[name="agreeAll"]');
        const agrees = document.querySelectorAll('input[name^="agree"]:not([name="agreeAll"])');
        
        agreeAll.addEventListener('change', (e) => {
            agrees.forEach(cb => cb.checked = e.target.checked);
        });
        
        agrees.forEach(cb => {
            cb.addEventListener('change', () => {
                const allChecked = Array.from(agrees).every(c => c.checked);
                agreeAll.checked = allChecked;
            });
        });

        // 결제 버튼 클릭 이벤트
        button.addEventListener("click", async function () {
        	var method = null;
        	const payMethodEl = document.querySelector('input[name="payMethod"]:checked');
        	if (payMethodEl) {
        	    method = payMethodEl.value;
        	}
            const receiverName = document.querySelector('input[name="receiver_name"]').value;
            const receiverBirth = document.querySelector('input[name="receiver_birth"]').value;
            const receiverPhone = document.querySelector('input[name="receiver_phone"]').value;
            const receiverEmail = document.querySelector('input[name="receiver_email"]').value;
            const receiveType = document.querySelector('input[name="receive_type"]:checked').value;

            // 유효성 검사
            if(!receiverName || !receiverPhone || !receiverBirth) {
                alert("예약자 정보를 모두 입력해주세요.");
                return;
            }
            if(!document.querySelector('input[name="agreeCancelPolicy"]').checked || 
               !document.querySelector('input[name="agreePrivacy"]').checked) {
                alert("필수 약관에 동의해주세요.");
                return;
            }

            try {
                // 1. 서버에 예약 정보 저장
                const response = await fetch("${pageContext.request.contextPath}/reserve/payment.do", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: new URLSearchParams({
                        receiver_name: receiverName,
                        receiver_birth: receiverBirth,
                        receiver_phone: receiverPhone,
                        receive_type: receiveType
                    })
                });

                const result = await response.json();             

                // 서버 응답이 성공이면 토스 결제창 호출 (일반 결제창 방식)
                if (!result.success) {
                    alert("예약 처리 실패: " + result.msg);
                    button.disabled = false;
                    button.textContent = "총 ${reservation.total_price}원 결제하기";
                    return;
                }

				if(result.free) {
					alert("예약 및 결제가 완료되었습니다.");
					location.href = "${pageContext.request.contextPath}/reserve/success.do"
					      + "?reservation_code=" + result.reservationCode;
					return;
				}                
                
                console.log("예약 정보 저장 성공, 토스 결제창 호출")
                
                //공통옵션
                const commonOptions = {
                    amount: result.amount,
                    orderId: result.orderId,
                    orderName: result.orderName,
                    customerName: result.customerName,
                    customerEmail: receiverEmail,
                    successUrl: window.location.origin + "${pageContext.request.contextPath}/reserve/success.do",
                    failUrl: window.location.origin + "${pageContext.request.contextPath}/reserve/fail.do",
                };

                if (method === "CARD") {
                    tossPayments.requestPayment("카드", commonOptions);
                } else if (method === "VIRTUAL_ACCOUNT") {
                    commonOptions.validHours = 24;
                    tossPayments.requestPayment("가상계좌", commonOptions);
                }
                
            } catch (error) {
                console.error("오류 발생:", error);
                alert("결제 처리 중 오류가 발생했습니다.");
            }
        });

        document.querySelector(".refund-toggle").addEventListener("click", function () {
            const container = document.querySelector(".refund-content");
            const detail = document.querySelector(".refund-detail");

            container.classList.toggle("open");

            if (detail.style.display === "block") {
              detail.style.display = "none";
            } else {
              detail.style.display = "block";
            }
        });
        
    </script>
</body>
</html>