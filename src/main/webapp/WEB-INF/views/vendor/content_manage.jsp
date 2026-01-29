<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined"
	rel="stylesheet" />
<link rel="stylesheet" href="${ctx}/css/vendor_content_manage.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<main class="main-content">
	<div class="page-header">
		<div class="page-title">
			<h2>전시 게시물 관리</h2>
			<p>등록하신 전시의 상태를 확인하고 관리하세요.</p>
		</div>
		<button class="btn-primary"
			onclick="location.href='${ctx}/vendor/content_create'">+ 게시글
			등록하기</button>
	</div>

	<div class="filter-bar">
		<div class="search-box">
			<input type="text" class="searchInput" id="searchInput"
				placeholder="전시명으로 검색..." />
		</div>
		<div class="filter-button" id="filterGroup">
			<button class="filter-btn active" data-status="">전체</button>
			<button class="filter-btn" data-status="STATUS_REQUESTED">승인요청</button>
			<button class="filter-btn" data-status="STATUS_REJECTED">거절</button>
			<button class="filter-btn" data-status="STATUS_SCHEDULED">오픈예정</button>
			<button class="filter-btn" data-status="STATUS_OPEN">진행중</button>
			<button class="filter-btn" data-status="STATUS_CLOSED">종료</button>
		</div>
	</div>

	<section class="content-list">
		<div class="list-header">
			<span class="col-info">전시 정보</span> <span class="col-period">기간</span>
			<span class="col-status">상태</span> <span class="col-manage">관리</span>
		</div>
		<div class="contentList" id="contentList">
			<div class="loading">데이터를 불러오는 중입니다...</div>
		</div>

		<div class="pagination">
			<button class="arrow">◀</button>
			<button>1</button>
			<button class="active">2</button>
			<button>3</button>
			<button class="arrow">▶</button>
		</div>
	</section>
</main>


<script>
const ctx = '${pageContext.request.contextPath}';

function confirmLogout() {
    if (confirm("로그아웃 하시겠습니까?")) {
        return true; 
    } else {
        return false;
    }
}

const STATUS_MAP = {
	    STATUS_REQUESTED: { text: '승인요청', className: 'STATUS_REQUESTED' },
	    STATUS_REJECTED:  { text: '거절',     className: 'STATUS_REJECTED' },
	    STATUS_SCHEDULED: { text: '오픈예정', className: 'STATUS_SCHEDULED' },
	    STATUS_OPEN:      { text: '진행중',   className: 'STATUS_OPEN' },
	    STATUS_CLOSED:    { text: '종료',     className: 'STATUS_CLOSED' }
	};


$(function () {
    loadContentList(); 
});

let currentPage = 1;

function loadContentList(page = 1) {
	const keyword = $('#searchInput').val();
	const status = $('.filter-btn.active').data('status');
	
	$.ajax({
		url: ctx +'/vendor/content_manage/list',
		type:'get',
		data: {
			keyword: keyword,
			status: status,
			page : page
		},
		success: function(res){
			renderList(res.list);
			if(res.pageInfo) {
	            renderPagination(res.pageInfo);
	        }else{
	            console.error('pafeInfo 없음', res);
	            $('.pagination').empty();
	        }
		},
        error: function () {
            alert('목록을 불러오지 못했습니다.');
        }
	});
}
//필터 클릭 시
$('.filter-btn').on('click', function() {
	$('.filter-btn').removeClass('active');
	$(this).addClass('active');
	loadContentList(1);
});

//검색 서치 시
$('#searchInput').on('keyup', function(e){
	if(e.key ==='Enter'){
		loadContentList(1);
	}
});

function renderPagination(p){
	const $pagination = $('.pagination');
	$pagination.empty();
	
	if(p.prev){
		$pagination.append(
				'<button class="arrow" onclick="loadContentList(' +(p.startPage -1)+ ')">◀</button>'
				);
	}
	
	for(let i=p.startPage; i<=p.endPage; i++){
		const activeClass = (i === p.page) ? 'active' : '';
		$pagination.append(
				 '<button class="' + activeClass + '" onclick="loadContentList(' + i + ')">' + i + '</button>'
		);
	}
	if(p.next) {
		$pagination.append(
				'<button class="arrow" onclick="loadContentList('+(p.endPage +1) + ')">▶</button>'
				);
	}
}

function formatDate(dateStr) {
    if (!dateStr) return '';
    return dateStr.split(' ')[0]; // yyyy-MM-dd
}

function renderList(list) {
    const $list = $('#contentList');
    
    $list.empty();

    if (list.length === 0) {
        $list.append('<div class="empty">검색 결과가 없습니다.</div>');
        return;
    }

    list.forEach(item => {
        const statusInfo = STATUS_MAP[item.content_status] 
            || { text: item.content_status, className: '' };

        $list.append(
            '<div class="content-row">' +

                '<div class="col-info">' +
                    '<img src="' + ctx + item.main_image_path + '" class="thumb">' +
                    '<div class="text">' +
                    '<a href="' + ctx + '/detail/' + item.content_id + '" class="title-link">' +
		                '<span class="title" style="font-weight:600;">' + item.title + '</span>' +
		            '</a>' +
                        '<div class="location">' + item.location + '</div>' +
                    '</div>' +
                '</div>' +

                '<div class="col-period">' +
                    formatDate(item.start_at) + ' ~ ' + formatDate(item.end_at) +
                '</div>' +

                '<div class="col-status">' +
                    '<span class="' + statusInfo.className + '">' +
                        statusInfo.text +
                    '</span>' +
                '</div>' +

                '<div class="col-manage">' +
                    '<a href="' + ctx + '/vendor/content_create?content_id=' + item.content_id + '">' +
                        '관리하기' +
                    '</a>' +
                '</div>' +

            '</div>'
        );
    });
}


</script>
</html>