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
    <link rel="stylesheet" href="${ctx}/css/admin_content_request.css">
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






