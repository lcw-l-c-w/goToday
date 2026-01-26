<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>예약 및 결제 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    <link rel="stylesheet" href="${ctx}/css/reserve_pay_manage.css">
    <style>
        
    </style>
</head>
<body>

<div class="admin-layout">
    <aside class="sidebar">
        <div class="sidebar-top">
            <h1 class="logo">ExhibiReserve</h1>
            <p class="subtitle">VENDOR MANAGEMENT</p>
        </div>
        <nav class="sidebar-menu">
            <ul>
                <li><a href="${ctx}/vendor/content_manage"><span class="material-symbols-outlined">description</span> 콘텐츠 관리</a></li>
                <li class="active"><a href="#"><span class="material-symbols-outlined">person</span> 예약 관리</a></li>
                <li><a href="${ctx}/reply/index.do"><span class="material-symbols-outlined">support_agent</span> 관리자 문의하기</a></li>
                <li><a href="${ctx}/mypage/logout" onclick="return confirmLogout();"><span class="material-symbols-outlined">logout</span> 로그아웃</a></li>
            </ul>
        </nav>
        <div class="sidebar-bottom">
	    <div class="admin-info">
	        <p class="role">Signed in as</p>
	        <div class="name-wrapper"> <strong class="name">
	                <c:choose>
	                    <c:when test="${not empty loginSess}">
	                        ${loginSess.name}
	                    </c:when>
	                    <c:otherwise>
	                        잘못된 접근입니다.
	                    </c:otherwise>
	                </c:choose>
	            </strong>
	            <a href="${ctx}/main" class="home-icon-btn" title="메인으로 이동">
	                <span class="material-symbols-outlined">home</span>
	            </a>
	        </div>
	    </div>
	</div>
    </aside>

    <main class="main-content">
        <div class="page-header">
            <div class="page-title">
                <h2>예약 및 결제 관리</h2>
                <p>실시간 예약 현황을 확인하고 관리하세요.</p>
            </div>
        </div>

        <section class="filter-bar">
            <input type="text" class="searchInput" id="searchInput" placeholder="예약번호, 수령인 검색" />
            <select id="contentFilter"><option value="">모든 콘텐츠</option></select>
            <input type="date" id="dateFilter" />
            <select id="statusFilter">
                <option value="">전체 예약상태</option>
                <option value="DONE">예약 확정</option>
				<option value="CANCELLED">예약 취소</option>
				<option value="PENDING">예약 보류</option>
				<option value="VISITED">이용 완료</option>
            </select>
        </section>

        <section class="table-wrap">
            <table class="user-table">
                <thead>
                    <tr>
                        <th>예약번호</th>
                        <th>콘텐츠명</th>
                        <th>수령인</th>
                        <th>방문일시</th>
                        <th>인원</th>
                        <th>예약상태</th>
                        <th>결제상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="reserveList">
                    </tbody>
            </table>
        </section>
    </main>
</div>

<div class="modal-overlay" id="userModal">
    <div class="modal">
        <header class="modal-header">
            <h3>예약 상세 정보 <span id="modalReserveId"></span></h3>
            <button style="border:none; background:none; font-size:20px; cursor:pointer; color:#999;" onclick="closeModal()">✕</button>
        </header>
        <div class="modal-body" id="modalBody">
            </div>
        <footer class="modal-footer">
            <span style="font-size: 12px; color: #bbb; font-weight:500;">ADMIN ACTION</span>
            <div class="footer-btns">
                <button class="btn-action" id="btnAction">
                    <span class="material-symbols-outlined" style="margin:0; font-size:18px;">check_circle</span>
                    이용 완료 처리
                </button>
                <button class="btn-close" onclick="closeModal()">닫기</button>
            </div>
        </footer>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
const ctx = '${pageContext.request.contextPath}';

function confirmLogout() {
    if (confirm("로그아웃 하시겠습니까?")) {
        return true; 
    } else {
        return false;
    }
}

//1. 상태 맵핑
const RESERVE_MAP = {
    'DONE': { text: '예약 확정', className: 'res-confirm' },
    'CANCELED': { text: '예약 취소', className: 'res-cancel' },
    'PENDING': { text: '예약 보류', className: 'res-pending' },
    'VISITED': { text: '이용 완료', className: 'res-visited' }
};

const PAY_MAP = {
    'DONE': { text: '결제 완료', className: 'pay-complete' },
    'WAITING_FOR_DEPOSIT': { text: '입금 대기', className: 'pay-waiting' },
    'FAILED': { text: '결제 실패', className: 'pay-failed' },
    'REFUNDED': { text: '환불 처리', className: 'pay-refund' },
    'CANCELED' : { text: '결제 취소', className: 'pay-cancel'}
};

function loadContentFilter() {
	$.ajax({
		url : ctx + '/vendor/content_manage/list',
		type : 'get',
		success : function(res) {
			const $select = $('#contentFilter');
			
			$select.empty();
			$select.append('<option value="">모든 콘텐츠</option>');
			
			if(!res.list || res.list.length === 0) return;
			
			res.list.forEach(item => {
				$select.append(
						`<option value="\${item.content_id}">
							\${item.title}
						</option>`
						);
			});
		},
		error: function() {
			console.log('콘텐츠 목록 로드 실패')
		}
	})
}

$(function () {
	loadContentFilter();
    loadReserveList();
    
	$('#contentFilter, #statusFilter, #dateFilter').on('change', function() {
	    loadReserveList();
	});
});

$('#searchInput').on('keypress', function(e) {
    if (e.key === 'Enter') {
        loadReserveList();
    }
});

function loadReserveList() {
    const $list = $('#reserveList');
    $list.html('<tr><td colspan="8" class="loading">데이터를 불러오는 중입니다...</td></tr>');

    const data = {};

    const keyword = $('#searchInput').val();
    const contentId = $('#contentFilter').val();
    const status = $('#statusFilter').val();
    const date = $('#dateFilter').val();
    
    if (keyword) data.keyword = keyword;
    if (contentId) data.content_id = contentId;
    if (status) data.reservation_status = status;
    if (date) data.reserved_for_at = date;
    
    $.ajax({
        url: ctx + '/vendor/reserve_pay_manage/list', // 실제 컨트롤러 URL에 맞게 수정
        type: 'get',
        data: data,
        success: function(res) {
        	console.log('res =', res);
            console.log('res.list =', res.list);
            console.log('Array?', Array.isArray(res.list));
            console.log('length =', res.list?.length);

            reserveCache = res.list;
            renderList(res.list);
        },
        error: function() {
            $list.html('<tr><td colspan="8" class="empty">데이터 로드 실패</td></tr>');
        }
    });
}

function formatPhone(phone) {
    if (!phone) return 'null';
    if (phone==='') return 'null';
    
    phone = phone.replace(/\D/g,'');
    
    if(phone.length === 11){
    	return phone.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
    }
    if(phone.length === 10){
    	return phone.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
    }
    
    return phone; // yyyy-MM-dd
}

function renderList(list) {
    const $list = $('#reserveList');
    $list.empty();

    if (!list || list.length === 0) {
        $list.append('<tr><td colspan="8" class="empty">예약 내역이 없습니다.</td></tr>');
        return;
    }
    
    list.forEach(item => {
    	console.log('renderList item =', item);
    	// 데이터가 없을 경우를 대비한 기본값 처리 (Optional Chaining 방식)
        const resKey = item.reserve_status || '';
        const payKey = item.pay_status || '';
        const resInfo = RESERVE_MAP[item.reserve_status] || { text: item.reserve_status, className: '' };
        const payInfo = PAY_MAP[item.pay_status] || { text: item.pay_status, className: '' };
        const isVisited = item.reserve_status === 'VISITED';
        const rowStyle = isVisited ? 'style="background-color: #fafafa; color: #bbb;"' : '';
        
        const html = `
        	<tr>
        	    <td>\${item.reservation_code}</td>
        	    <td style="font-weight:600;">\${item.content_title}</td>
        	    <td>\${item.receiver_name}<br>
        	    <small style="color:#888;">\${formatPhone(item.receiver_phone)}</small>
        	    </td>
        	    <td>\${item.visit_date}<br><small>\${item.visit_time}</small></td>
        	    <td>\${item.person_count}명</td>
        	    <td><span class="badge \${resInfo.className}">\${resInfo.text}</span></td>
        	    <td><span class="badge \${payInfo.className}">\${payInfo.text}</span></td>
        	    <td>
        	    <button class="btn-sm" onclick="openModal('\${item.reserve_id}')">
	                \${isVisited ? '기록 보기' : '상세보기'}
	            </button>
        	    </td>
        	</tr>
        	`;


        $list.append(html);
    });
}

function openModal(id) {
    const data = reserveCache.find(item => item.reserve_id == id);
    if (!data) return;

    $('#modalReserveId').text('#' + data.reserve_id);

    const resInfo = RESERVE_MAP[data.reserve_status] || { text: data.reserve_status, className: '' };
    
    const modalHtml = `
        <div class="modal-content-wrapper">
            <section class="detail-group">
                <div class="group-title icon-blue">
                    <span class="material-symbols-outlined">calendar_month</span>예약 정보
                </div>
                <div class="info-card">
                    <div class="info-item">
                        <label>콘텐츠명</label>
                        <div class="val-bold">\${data.content_title}</div>
                    </div>
                    <div class="info-row-grid">
                        <div class="info-item">
                            <label>방문일</label>
                            <div class="val">\${data.visit_date}</div>
                        </div>
                        <div class="info-item">
                            <label>시간대</label>
                            <div class="val"><span class="material-symbols-outlined" style="font-size:16px;">schedule</span> \${data.visit_time}</div>
                        </div>
                    </div>
                    <div class="info-row-grid">
                        <div class="info-item">
                            <label>예약 인원</label>
                            <div class="val"><span class="material-symbols-outlined" style="font-size:16px;">group</span> \${data.person_count}명</div>
                        </div>
                        <div class="info-item">
                            <label>예약 상태</label>
                            <div><span class="badge \${resInfo.className}">\${resInfo.text}</span></div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="detail-group">
                <div class="group-title icon-green">
                    <span class="material-symbols-outlined">payments</span>결제 정보
                </div>
                <div class="info-card">
                    <div class="info-row-grid">
                        <div class="info-item">
                            <label>결제 수단</label>
                            <div class="val">\${data.payment_method}</div>
                        </div>
                        <div class="info-item">
                            <label>결제 금액</label>
                            <div class="val-price">₩\${Number(data.amount_price || 0).toLocaleString()}</div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="detail-group" style="margin-bottom:0;">
                <div class="group-title icon-purple">
                    <span class="material-symbols-outlined">person</span>예약자 정보
                </div>
                <div class="info-card">
                    <div class="info-row-grid">
                        <div class="info-item">
                            <label>예약자명</label>
                            <div class="val">\${data.receiver_name}</div>
                        </div>
                        <div class="info-item">
                            <label>연락처</label>
                            <div class="val">\${formatPhone(data.receiver_phone)}</div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    `;

    $('#modalBody').html(modalHtml);
    
	 // 하단 버튼(btnAction) 제어 및 이벤트 바인딩
    const $actionBtn = $('#btnAction');
    
    if (data.reserve_status === 'VISITED') {
        $actionBtn.prop('disabled', true)
                  .css({'background': '#ccc', 'cursor': 'not-allowed'})
                  .html('<span class="material-symbols-outlined" style="margin:0;">task_alt</span> 처리 완료');
        $actionBtn.off('click'); // 이벤트 해제
    } else {
        $actionBtn.prop('disabled', false)
                  .css({'background': '#4d4dff', 'cursor': 'pointer'})
                  .html('<span class="material-symbols-outlined" style="margin:0;">check_circle</span> 이용 완료 처리');
        
        // 기존 이벤트 제거 후 새로 등록
        $actionBtn.off('click').on('click', function() {
            if (!confirm('해당 예약을 [이용 완료] 상태로 변경하시겠습니까?')) return;

            $.ajax({
                url: ctx + '/vendor/reserve_pay_manage/update_status',
                type: 'post',
                data: { reserve_id: data.reserve_id, status: 'VISITED' },
                success: function(res) {
                    if (res.success) {
                        alert('이용 완료 처리가 정상적으로 완료되었습니다.');
                        closeModal();
                        loadReserveList();
                    } else {
                        alert('처리에 실패했습니다: ' + (res.message || '오류 발생'));
                    }
                },
                error: function() { alert('서버 통신 중 오류가 발생했습니다.'); }
            });
        });
    }

    $('#userModal').addClass('active');
}

function closeModal() {
    $('#userModal').removeClass('active');
}
</script>

</body>
</html>