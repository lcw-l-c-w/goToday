<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined"
	rel="stylesheet" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin_content_manage.css">

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="icon" href="${pageContext.request.contextPath}/favicon.ico">

<header class="content-header">
	<div class="title-group">
		<h2>전시 관리</h2>
		<p>등록된 게시글의 상태를 확인하고 관리하세요.</p>
	</div>
</header>

<div class="content-card">
	<div class="toolbar">
		<div class="search-box">
			<span class="material-symbols-outlined">search</span> <input
				type="text" class="searchInput" id="searchInput"
				placeholder="전시회 명으로 검색..." />
		</div>
		<div class="filter-tabs">
			<button class="filter-btn active" data-status="">전체</button>
			<button class="filter-btn" data-status="1">활성화</button>
			<button class="filter-btn" data-status="0">비활성화</button>
		</div>
	</div>

	<section class="table-section">
		<div class="table-header">
			<span>상태</span> <span>전시명</span> <span>전시기간</span> <span>장소</span> <span>작성자</span>
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
<script>
const ctx = '${pageContext.request.contextPath}';

function confirmLogout() {
    if (confirm("로그아웃 하시겠습니까?")) {
        return true; 
    } else {
        return false;
    }
}

const ACTIVATE_MAP = {
		  1:  { text: '활성화', className: 'active' },
		  0: { text: '비활성화', className: 'inactive' }
		};

$(function () {
	loadContentList();
})	

let currentPage = 1;

function loadContentList(page = 1) {
	currentPage = page;
	
    const keyword = $('#searchInput').val();
    // active 클래스가 붙은 버튼의 data-status를 가져옴
    let status = $('.filter-btn.active').data('status');
    
    // 데이터 전송 객체 구성
    const searchData = { 
    		keyword : keyword,
    		page : page
    	};
    
    // status가 빈 문자열("")이 아닐 때만 파라미터에 추가 (전체 선택 시 제외)
    if (status !== "" && status !== undefined) {
        searchData.is_active = status;
    }

    $.ajax({
        url: ctx + '/admin/content_manage/list',
        type: 'get',
        data: searchData,
        success(res) {
            renderList(res.list);
            if(res.pageInfo) {
            renderPagination(res.pageInfo);
            }else{
            	console.error('pafeInfo 없음', res);
            	$('.pagination').empty();
            }
        },
        error() {
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

$(document).on('click', '.btn-act', function () {
    const contentId = $(this).data('id');

    $.ajax({
        url: ctx + '/admin/content_manage/act',
        type: 'get',
        data: { content_id: contentId },
        success() {
            loadContentList(); // 다시 로드
        },
        error() {
            alert('상태 변경 실패');
        }
    });
});

$(document).on('click', '.btn-delete', function () {
    const contentId = $(this).data('id');
    
    if (!confirm('삭제하시겠습니까?')) {
        return; // 취소 누르면 아무것도 안 함
    }

    $.ajax({
        url: ctx + '/admin/content_manage/delete',
        type: 'get',
        data: { content_id: contentId },
        success() {
            loadContentList(); // 다시 로드
        },
        error() {
            alert('삭제 실패');
        }
    });
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
        $list.append('<div class="empty" style="padding:40px; text-align:center; color:#999;">검색 결과가 없습니다.</div>');
        return;
    }

    list.forEach(item => {
    	
    	const isActive = (item.is_active === true || item.is_active === 1 || item.is_active === "1");
        const statusVal = isActive ? 1 : 0;
        const activateInfo = ACTIVATE_MAP[statusVal] || { text: '알수없음', className: 'inactive' };

        // 상태에 따른 아이콘 및 타이틀 설정
        // 활성 상태면 '비가시성(눈가림)' 아이콘, 비활성 상태면 '가시성(눈뜸)' 아이콘
        const actIcon = isActive ? 'visibility' : 'visibility_off';
        const actTitle = isActive ? '비활성화 하기' : '활성화 하기';
        
        $list.append(
        		'<li class="table-row">' +
	                '<div><span class="badge ' + activateInfo.className + '">' + activateInfo.text + '</span></div>' + 
	                '<a href="' + ctx + '/detail/' + item.content_id + '" class="title-link">' +
		                '<span class="title" style="font-weight:600;">' + item.title + '</span>' +
		            '</a>' +
	                '<span class="date" style="color:#666;">' + formatDate(item.start_at) + ' ~ ' + formatDate(item.end_at) + '</span>' +
	                '<span class="location" style="color:#666;">' + item.location + '</span>' +
	                '<span class="user_id">' + item.user_id + '</span>' +
	                '<div class="actions">' +
		             // Material Symbols를 사용하여 아이콘 처리
	                    '<button class="btn-icon btn-act" data-id="' + item.content_id + '" title="' + actTitle + '">' +
	                        '<span class="material-symbols-outlined" style="font-size:18px;">' + actIcon + '</span>' +
	                    '</button>' +
	                    '<button class="btn-icon btn-delete" data-id="' + item.content_id + '" title="삭제">' +
	                        '<span class="material-symbols-outlined" style="font-size:18px;">delete</span>' +
	                    '</button>' +
	                '</div>' +
            '</li>'
        );
    });
}
</script>
</html>






