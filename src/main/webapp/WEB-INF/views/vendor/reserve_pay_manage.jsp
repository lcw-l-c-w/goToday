<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>예약 및 결제 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    <style>
        /* 기본 초기화 및 레이아웃 (기존 스타일 유지) */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Pretendard', sans-serif; background-color: #f3f5f9; color: #333; }

        .admin-layout { display: flex; min-height: 100vh; }

        /* 사이드바 전체 컨테이너 */
.sidebar {
    width: 260px;
    background-color: #1a1f33; /* 다크 네이비 */
    color: #ffffff;
    display: flex;
    flex-direction: column;
    height: 100vh;
    position: sticky;
    top: 0;
}

/* 로고 영역 */
.sidebar-top {
     padding: 40px 25px; 
}

.logo {
     font-size: 20px; font-weight: 800; color: #5d5dff; 
}

.subtitle {
    font-size: 10px; opacity: 0.6; letter-spacing: 1px; margin-top: 5px;
}

/* 메뉴 영역 */
.sidebar-menu {
     flex: 1; padding: 0 15px; 
}

.sidebar-menu ul {
    list-style: none;
}

.sidebar-menu li {
     margin-bottom: 5px; 
}

.sidebar-menu li a {
    display: flex;
	    align-items: center;
	    padding: 12px 15px;
	    color: #8a94ad;
	    text-decoration: none;
	    border-radius: 8px;
	    transition: 0.3s;
	    font-size: 15px;
}

/* 마우스 올렸을 때 */
.sidebar-menu li a:hover {
    background-color: rgba(255, 255, 255, 0.1);
}
.title-link {
    color: inherit;
    text-decoration: none;
}

.title-link:hover .title {
    text-decoration: underline;
}

/* 활성화된 메뉴 (콘텐츠 관리) */
.sidebar-menu li.active a {
     background-color: #4d4dff; color: white; 
}

.sidebar-menu .icon {
    margin-right: 12px;
    font-size: 18px;
}
.material-symbols-outlined { margin-right: 12px; font-size: 20px; }

/* 하단 관리자 정보 */
.sidebar-bottom {
    padding: 20px;
}

.admin-info {
    background: rgba(255,255,255,0.05); padding: 15px; border-radius: 12px; 
}

.admin-info .role {
    font-size: 11px;
    color: #8a94ad;
    margin-bottom: 4px;
}

.admin-info .name {
     display: block; font-size: 13px; color: #fff; margin-bottom: 3px; 
}
        /* 메인 콘텐츠 */
        .main-content { flex: 1; padding: 40px; background-color: #f8f9fa; }
        .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 30px; }
        .page-title h2 { font-size: 24px; font-weight: 700; margin-bottom: 8px; }

        /* 필터 바 개선 */
.filter-bar { 
    background: white; 
    padding: 20px; 
    border-radius: 12px; 
    display: flex; 
    gap: 12px;           /* 요소 사이 간격 살짝 넓힘 */
    margin-bottom: 25px; 
    align-items: center; 
    box-shadow: 0 2px 8px rgba(0,0,0,0.02); 
}

/* 모든 입력 필드의 길이를 동일하게 설정 */
.filter-bar input, 
.filter-bar select { 
    flex: 1;            /* 모든 요소가 동일한 비율로 가로 길이를 나눠 가짐 */
    min-width: 0;       /* flex 박스 내에서 깨짐 방지 */
    padding: 10px 15px; 
    border: 1px solid #eee; 
    border-radius: 8px; 
    font-size: 14px; 
    outline: none; 
    height: 42px;       /* 높이 통일 */
}

/* 검색창만 다른 필드보다 조금 더 길게 하고 싶다면 (선택 사항) */
.filter-bar .searchInput { 
    flex: 2;            /* 검색창은 다른 필터의 2배 길이를 가짐 */
}

/* 날짜 입력 필드 폰트 보정 */
input[type="date"] {
    font-family: inherit;
    }

        /* 테이블 영역 */
        .table-wrap { background: white; border-radius: 16px; padding: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); }
        .user-table { width: 100%; border-collapse: collapse; }
        .user-table th { text-align: left; padding: 15px; border-bottom: 1px solid #eee; color: #aaa; font-size: 13px; font-weight: 600; }
        .user-table td { padding: 20px 15px; border-bottom: 1px solid #f8f8f8; font-size: 14px; vertical-align: middle; }

        /* 뱃지 스타일 (이미지 기반 정의) */
        .badge { display: inline-flex; align-items: center; justify-content: center; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; }
        
       /* --- 예약 상태 뱃지 (RESERVE_MAP) --- */
		/* 예약 확정: 청록색 계열 */
		.res-confirm { background: #e6fffa; color: #00b5ad; border: 1px solid #b2f5ea; }
		/* 예약 취소: 붉은색 계열 */
		.res-cancel { background: #fff1f0; color: #ff4d4f; border: 1px solid #ffccc7; }
		/* 예약 보류: 주황색 계열 */
		.res-pending { background: #fff8e6; color: #ffa000; border: 1px solid #ffeeba; }
		/* 이용 완료: 차분한 회색/네이비 계열 */
		.res-visited { background: #f0f5ff; color: #597ef7; border: 1px solid #adc6ff; }
		
		/* --- 결제 상태 뱃지 (PAY_MAP) --- */
		/* 결제 완료: 메인 블루 계열 */
		.pay-complete { background: #eef2ff; color: #4d4dff; border: 1px solid #dadaff; }
		/* 입금 대기: 베이지/황토색 계열 */
		.pay-waiting { background: #fafafa; color: #8c8c8c; border: 1px solid #d9d9d9; }
		/* 결제 실패: 어두운 빨강 계열 */
		.pay-failed { background: #fff2f0; color: #cf1322; border: 1px solid #ffa39e; }
		/* 환불 처리: 보라색 계열 */
		.pay-refund { background: #f9f0ff; color: #722ed1; border: 1px solid #d3adf7; }

        .btn-sm { padding: 6px 12px; border: 1px solid #eee; background: white; border-radius: 6px; cursor: pointer; font-size: 13px; transition: 0.2s; }
        .btn-sm:hover { background: #f5f5f5; }

        /* 모달 전체 컨테이너 */
.modal-overlay { 
    position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
    background: rgba(0,0,0,0.6); display: flex; align-items: center; justify-content: center; 
    z-index: 2000; visibility: hidden; opacity: 0; transition: 0.3s; 
}
.modal-overlay.active { visibility: visible; opacity: 1; }

/* 모달 본체 */
.modal { 
    background: white; width: 640px; border-radius: 24px; overflow: hidden; 
    display: flex; flex-direction: column; max-height: 90vh; 
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
}

/* 모달 헤더 */
.modal-header { 
    padding: 24px 30px; border-bottom: 1px solid #f0f0f0; 
    display: flex; justify-content: space-between; align-items: center; 
}
.modal-header h3 { font-size: 18px; font-weight: 800; color: #111; }
.modal-header h3 span { color: #5d5dff; margin-left: 8px; font-size: 15px; }

/* 모달 바디 */
.modal-body { padding: 30px; overflow-y: auto; background-color: #fff; }

/* 섹션 타이틀 스타일 */
.detail-group { margin-bottom: 28px; }
.group-title { 
    display: flex; align-items: center; gap: 8px; 
    font-size: 14px; font-weight: 600; margin-bottom: 14px; 
}
.icon-blue { color: #5d5dff; }
.icon-green { color: #059669; }
.icon-purple { color: #a55eea; }

/* 정보 카드 (회색 박스) */
.info-card { 
    background-color: #f8f9fc; border-radius: 16px; padding: 20px; 
    display: flex; flex-direction: column; gap: 18px;
}
.info-row-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
.info-item label { display: block; font-size: 11px; color: #999; margin-bottom: 6px; font-weight: 600; text-transform: uppercase; }
.info-item .val { font-size: 14px; color: #333; font-weight: 500; display: flex; align-items: center; gap: 5px; }
.info-item .val-bold { font-size: 15px; font-weight: 700; color: #111; }
.info-item .val-price { font-size: 18px; font-weight: 600; color: #059669; }

/* 하단 버튼 영역 */
.modal-footer { 
    padding: 20px 30px; background: #fff; border-top: 1px solid #f0f0f0; 
    display: flex; justify-content: space-between; align-items: center; 
}
.footer-btns { display: flex; gap: 10px; }

.btn-action { 
    background: #4d4dff; color: white; border: none; padding: 12px 20px; 
    border-radius: 12px; font-weight: 600; cursor: pointer; 
    display: flex; align-items: center; gap: 8px; font-size: 14px; transition: 0.2s;
}
.btn-action:hover { background: #3535ff; transform: translateY(-1px); }

.btn-close { 
    background: #fff; border: 1px solid #e0e0e0; color: #666; 
    padding: 12px 20px; border-radius: 12px; cursor: pointer; font-size: 14px; transition: 0.2s;
}
.btn-close:hover { background: #f9f9f9; color: #333; }
        .empty { padding: 50px; text-align: center; color: #bbb; }
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
                <li><a href="${ctx}/reply/index"><span class="material-symbols-outlined">support_agent</span> 관리자 문의하기</a></li>
            </ul>
        </nav>
        <div class="sidebar-bottom">
            <div class="admin-info">
                <p class="role">Signed in as</p>
                <strong class="name">${loginSess.name}</strong>
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
    'REFUNDED': { text: '환불 처리', className: 'pay-refund' }
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
        	    <td>\${item.reserve_id}</td>
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
                            <div class="val">신용카드</div>
                        </div>
                        <div class="info-item">
                            <label>결제 금액</label>
                            <div class="val-price">₩\${Number(data.total_price || 44000).toLocaleString()}</div>
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