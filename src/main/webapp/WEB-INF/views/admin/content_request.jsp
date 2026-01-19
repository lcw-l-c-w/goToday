<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>ExhibiReserve - 승인 요청</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    <style>
    /* 1. 기본 초기화 및 폰트 */
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Pretendard', sans-serif; background-color: #f3f5f9; color: #333; }

.admin-container { display: flex; min-height: 100vh; }

/* 2. 사이드바 (Sidebar) */
.sidebar {
    width: 260px;
    background-color: #1a1f33;
    color: white;
    display: flex;
    flex-direction: column;
    position: fixed;
    height: 100vh;
}
.sidebar-header { padding: 40px 25px; }
.logo { font-size: 20px; font-weight: 800; color: #5d5dff; }
.logo-sub { font-size: 10px; opacity: 0.6; letter-spacing: 1px; margin-top: 5px; }
.sidebar-nav { flex: 1; padding: 0 15px; }
.sidebar-nav ul { list-style: none; }
.sidebar-nav a {
    display: flex;
    align-items: center;
    padding: 12px 15px;
    color: #8a94ad;
    text-decoration: none;
    border-radius: 8px;
    transition: 0.3s;
    font-size: 15px;
}
.sidebar-nav li.active a { background-color: #4d4dff; color: white; }
.sidebar-nav a:hover:not(.active) { background-color: rgba(255,255,255,0.05); color: white; }
.material-symbols-outlined { margin-right: 12px; font-size: 20px; }
.sidebar-footer { padding: 20px; }
.user-box { background: rgba(255,255,255,0.05); padding: 15px; border-radius: 12px; }
.user-role { display: block; font-size: 11px; color: #8a94ad; margin-bottom: 3px; }
.user-name { font-size: 13px; font-weight: 600; }

/* 3. 메인 레이아웃 및 상단 헤더 */
.main-content { flex: 1; margin-left: 260px; padding: 40px 50px; }
.content-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
.title-group h2 { font-size: 26px; font-weight: 700; }
.title-group p { color: #888; font-size: 14px; margin-top: 5px; }
.content-card { background: white; border-radius: 16px; padding: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); }

/* 4. 툴바 (검색 및 필터) */
.toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
.search-box { display: flex; align-items: center; background: #f5f6f8; padding: 8px 15px; border-radius: 10px; width: 320px; }
.search-box input { border: none; background: transparent; outline: none; margin-left: 10px; width: 100%; font-size: 14px; }
.filter-tabs { display: flex; gap: 8px; }
.filter-tabs button { border: 1px solid #eee; background: white; padding: 8px 16px; border-radius: 20px; font-size: 13px; color: #888; cursor: pointer; }
.filter-tabs button.active { background: #1a1f33; color: white; border-color: #1a1f33; }

/* 5. 테이블 (Grid Layout) */
.table-header, .table-row {
    display: grid;
    /* 요청하신대로 전시기간을 왼쪽으로 당긴 비율 설정 */
    grid-template-columns: 80px 1fr 180px 1fr 70px 100px;
    padding: 18px 15px;
    align-items: center;
    gap: 12px;
}
.table-header { border-bottom: 1px solid #eee; color: #aaa; font-size: 12px; font-weight: 600; }
.table-row { border-bottom: 1px solid #f8f8f8; font-size: 14px; }
.table-row .title { font-weight: 600; color: #222; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.table-row .date, .table-row .location { font-size: 13px; color: #666; line-height: 1.4; }
.text-right { text-align: right; }
.title-link {
    color: inherit;
    text-decoration: none;
}

.title-link:hover .title {
    text-decoration: underline;
}
/* 6. 뱃지 (Status Badge) */
.badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 65px;
    padding: 4px 0;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 700;
    white-space: nowrap;
}
.STATUS_REJECTED { 
    background: #fff1f0; 
    color: #ff4d4f; 
    border: 1px solid #ffccc7;
}

.STATUS_REQUESTED { 
    background: #fff8e6; 
    color: #ffa000; 
    border: 1px solid #ffeeba;
}

/* 7. 관리 버튼 (Action Buttons) */
.actions { display: flex; gap: 8px; justify-content: flex-end; }
.btn-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 34px;
    height: 34px;
    border-radius: 8px;
    border: 1px solid #edf0f5;
    background-color: white;
    cursor: pointer;
    transition: 0.2s;
    font-size: 16px;
}
.btn-icon:hover { background-color: #f8f9fa; }
.btn-stop { color: #ffa000; }
.btn-stop:hover { background-color: #fff8e6; border-color: #ffa000; }
.btn-delete { color: #ff4d4d; }
.btn-delete:hover { background-color: #fff5f5; border-color: #ff4d4d; }

/* 8. 페이지네이션 */
.pagination { display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 30px; }
.pagination button { width: 35px; height: 35px; border: none; background: transparent; border-radius: 8px; cursor: pointer; color: #888; font-weight: 600; }
.pagination button.active { background: #1a1f33; color: white; }
.pagination button.arrow { font-size: 10px; color: #ccc; }
    </style>
</head>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="icon" href="${pageContext.request.contextPath}/favicon.ico">

<body>

<div class="admin-container">
    <aside class="sidebar">
        <div class="sidebar-header">
            <h1 class="logo">ExhibiReserve</h1>
            <p class="logo-sub">ADMIN MANAGEMENT</p>
        </div>

        <nav class="sidebar-nav">
            <ul>
                <li class="active"><a href="#"><span class="material-symbols-outlined">dashboard</span> 승인 요청</a></li>
                <li><a href="${ctx}/admin/content_manage"><span class="material-symbols-outlined">description</span> 전시 관리</a></li>
                <li><a href="${ctx}/admin/user_manage"><span class="material-symbols-outlined">person</span> 사용자 관리</a></li>
                <li><a href="${ctx}/reply/index"><span class="material-symbols-outlined">support_agent</span> 관리자 문의하기</a></li>
            </ul>
        </nav>

        <div class="sidebar-footer">
            <div class="user-box">
                <span class="user-role">Signed in as</span>
                <strong class="user-name">${loginSess.name}</strong>
            </div>
        </div>
    </aside>

    <main class="main-content">
        <header class="content-header">
            <div class="title-group">
                <h2>승인 요청</h2>
                <p>승인 요청된 게시글을 확인해보세요.</p>
            </div>
        </header>

        <div class="content-card">
            <div class="toolbar">
                <div class="search-box">
                    <span class="material-symbols-outlined">search</span>
                    <input type="text"  class="searchInput" id="searchInput" placeholder="전시회 명으로 검색..."  />
                </div>
                <div class="filter-tabs">
				    <button class="filter-btn active" data-status="STATUS_REQUESTED">승인요청</button>
				    <button class="filter-btn" data-status="STATUS_REJECTED">거절</button>
				</div>
                
            </div>

            <section class="table-section">
                <div class="table-header">
                    <span>상태</span>
                    <span>전시명</span>
                    <span>전시기간</span>
                    <span>장소</span>
                    <span>작성자</span>
                    <span class="text-right">관리</span>
                </div>
                
     			 <ul class="table-body" id="contentList">
				    <li class="loading">데이터를 불러오는 중입니다...</li>
				</ul>

            </section>

            <div class="pagination">
                <button class="arrow">◀</button>
                <button>1</button>
                <button class="active">2</button>
                <button>3</button>
                <button class="arrow">▶</button>
            </div>
        </div>
    </main>
</div>

</body>
<script>
const ctx = '${pageContext.request.contextPath}';

const STATUS_MAP = {
	    STATUS_REQUESTED: { text: '승인요청', className: 'STATUS_REQUESTED' },
	    STATUS_REJECTED:  { text: '거절',     className: 'STATUS_REJECTED' },
	};

$(function () {
	loadContentList();
})	

function loadContentList() {
	
    const keyword = $('#searchInput').val();
    // active 클래스가 붙은 버튼의 data-status를 가져옴
    let status = $('.filter-btn.active').data('status');
    
    // 데이터 전송 객체 구성
    const searchData = {
        keyword: keyword,
        content_status: status
    };
    
    // status가 빈 문자열("")이 아닐 때만 파라미터에 추가 (전체 선택 시 제외)
    if (status !== "" && status !== undefined) {
        searchData.content_status = status;
    }

    $.ajax({
        url: ctx + '/admin/content_request/list',
        type: 'get',
        data: searchData,
        success(res) {
            renderList(res.list);
        },
        error() {
            alert('목록을 불러오지 못했습니다.');
        }
    });
}

//검색 서치 시
$('#searchInput').on('keyup', function(e){
	if(e.key ==='Enter'){
		loadContentList();
	}
});

$('.filter-btn').on('click', function () {
    $('.filter-btn').removeClass('active');
    $(this).addClass('active');
    loadContentList();
});

$(document).on('click', '.btn-approve', function () {
    $.post(ctx + '/admin/content_request/approve', {
        content_id: $(this).data('id')
    }, loadContentList);
});

$(document).on('click', '.btn-reject', function () {
    $.post(ctx + '/admin/content_request/reject', {
        content_id: $(this).data('id')
    }, loadContentList);
});



function formatDate(dateStr) {
    if (!dateStr) return '';
    return dateStr.split(' ')[0]; // yyyy-MM-dd
}

function renderList(list) {
    const $list = $('#contentList');
    $list.empty();

    if (list.length === 0) {
        $list.append('<div class="empty" style="padding:40px; text-align:center; color:#999;">검색 결과가 없습니다.</div>');
        return;
    }

    list.forEach(item => {
    	const statusInfo = STATUS_MAP[item.content_status] 
        || { text: item.content_status, className: '' };
    	
        let actionHtml = '';
        if (item.content_status === 'STATUS_REQUESTED') {
            actionHtml =
                '<div class="actions">' +
                    '<button class="btn-icon btn-approve" data-id="' + item.content_id + '" title="승인">' +
                        '<span class="material-symbols-outlined">check</span>' +
                    '</button>' +
                    '<button class="btn-icon btn-reject" data-id="' + item.content_id + '" title="거절">' +
                        '<span class="material-symbols-outlined">close</span>' +
                    '</button>' +
                '</div>';
        }

        $list.append(
            '<li class="table-row">' +
                '<div><span class="badge ' + statusInfo.className + '">' + statusInfo.text + '</span></div>' +
                '<a href="' + ctx + '/detail/' + item.content_id + '" class="title-link">' +
	                '<span class="title" style="font-weight:600;">' + item.title + '</span>' +
	            '</a>' +
                '<span class="date">' + formatDate(item.start_at) + ' ~ ' + formatDate(item.end_at) + '</span>' +
                '<span class="location">' + item.location + '</span>' +
                '<span class="user_id">' + item.user_id + '</span>' +
                actionHtml +
            '</li>'
        );
    });
}


</script>
</html>






