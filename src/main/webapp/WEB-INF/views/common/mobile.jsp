<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>이용 완료 처리</title>

<style>
* { box-sizing: border-box; }
body {
  margin: 0;
  font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, sans-serif;
  background: #f5f6f8;
  color: #222;
}

.mobile-wrap {
  max-width: 480px;
  margin: 30px auto;
  padding: 16px;
  
}

.card {
  background: #fff;
  border-radius: 14px;
  padding: 18px;
  box-shadow: 0 4px 16px rgba(0,0,0,0.06);
}

.page-title {
  font-size: 20px;
  font-weight: 700;
  margin-bottom: 20px;
  text-align: center;
}

/* 기본 정보 */
.info-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
  margin : 20px 10px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.info-label {
  font-size: 14px;
  color: #777;
}

.info-value {
  font-size: 15px;
  font-weight: 600;
  text-align: right;
  max-width: 65%;
  word-break: break-word;
}

.highlight {
  color: #2b7cff;
}

/* 수량 박스 */
.qty-box {
  background: #f8f9fb;
  border-radius: 10px;
  padding: 14px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-bottom: 22px;
}

.qty-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.qty-label {
  font-size: 14px;
  color: #555;
}

.qty-value {
  font-size: 16px;
  font-weight: 700;
}

/* 버튼 */
.btn-complete {
  width: 100%;
  padding: 16px 0;
  font-size: 16px;
  font-weight: 700;
  border: none;
  border-radius: 10px;
  background: #2b7cff;
  color: #fff;
  cursor: pointer;
}

.btn-complete:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.notice {
  margin-top: 14px;
  font-size: 13px;
  color: #999;
  text-align: center;
}
</style>
</head>

<body>

<div class="mobile-wrap">
  <div class="card">

    <div class="page-title">이용 완료 처리</div>

    <!-- 기본 정보 -->
    <div class="info-list">
      <div class="info-row">
        <div class="info-label">예약 번호</div>
        <div class="info-value">${reservation.reservation_code}</div>
      </div>

      <div class="info-row">
        <div class="info-label">컨텐츠명</div>
        <div class="info-value highlight">${reservation.content_title}</div>
      </div>

      <div class="info-row">
        <div class="info-label">방문일</div>
        <div class="info-value">${reservation.visit_date} ${reservation.visit_time}</div>
      </div>
      
      <div class="info-row">
        <div class="info-label">예약자 이름</div>
        <div class="info-value">${reservation.receiver_name}</div>
      </div>

    </div>

    <!-- 수량 정보 -->
    <div class="qty-box">
      <div class="qty-row">
        <div class="qty-label">성인</div>
        <div class="qty-value">${reservation.adult_qty} 명</div>
      </div>
      <div class="qty-row">
        <div class="qty-label">청소년</div>
        <div class="qty-value">${reservation.teen_qty} 명</div>
      </div>
      <div class="qty-row">
        <div class="qty-label">유아</div>
        <div class="qty-value">${reservation.child_qty} 명</div>
      </div>
    </div>

    <!-- 완료 처리 -->
    <div>
      <input type="hidden" name="reserve_id" id="reserve_id" value="${reservation.reserve_id}">
      <button type="button" id="completeBtn" class="btn-complete">
        이용 완료 처리
      </button>
	</div>

    <div class="notice">
      이용 완료 처리 후에는<br>
      상태를 되돌릴 수 없습니다.
    </div>
  </div>
</div>

<script>
(function () {
  const ctx = '${pageContext.request.contextPath}';
  const btn = document.getElementById('completeBtn');
  const reserveInput = document.getElementById('reserve_id');

  if (!btn || !reserveInput) return;

  const reserveId = reserveInput.value;

  btn.addEventListener('click', function () {
    if (btn.disabled) return;

    if (!confirm('해당 예약을 [이용 완료] 처리하시겠습니까?')) {
      return;
    }

    btn.disabled = true;
    btn.innerText = '처리 중...';

    fetch(ctx + '/vendor/reserve_pay_manage/update_status', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: new URLSearchParams({
        reserve_id: reserveId,
        status: 'VISITED'
      })
    })
    .then(res => res.json())
    .then(res => {
      if (!res.success) {
        if (res.code === 'NO_AUTH') {
          alert('로그인이 필요합니다.');
          location.href = ctx + '/member/login';
          return;
        }

        alert(res.message || '처리에 실패했습니다.');
        btn.disabled = false;
        btn.innerText = '이용 완료 처리';
        return;
      }

      // 성공
      btn.innerText = '처리 완료';
      btn.style.background = '#ccc';
      alert('이용 완료 처리되었습니다.');
    })
    .catch(err => {
      console.error(err);
      alert('서버 통신 중 오류가 발생했습니다.');
      btn.disabled = false;
      btn.innerText = '이용 완료 처리';
    });
  });
})();
</script>


</body>
</html>
