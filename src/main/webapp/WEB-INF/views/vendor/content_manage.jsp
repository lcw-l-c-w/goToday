<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>전시 게시물 관리</title>
<style>
/* 기본 초기화 */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
    background-color: #f8f9fa;
    color: #333;
}

/* 레이아웃 구성 */
.admin-layout {
    display: flex;
    min-height: 100vh;
}

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
    padding: 30px 25px;
}

.logo {
    font-size: 20px;
    font-weight: 800;
    color: #ffffff;
    letter-spacing: -0.5px;
}

.subtitle {
    font-size: 10px;
    color: #8a94ad;
    text-transform: uppercase;
    margin-top: 4px;
    font-weight: 600;
}

/* 메뉴 영역 */
.sidebar-menu {
    flex: 1;
    padding: 10px 15px;
}

.sidebar-menu ul {
    list-style: none;
}

.sidebar-menu li {
    margin-bottom: 8px;
}

.sidebar-menu li a {
    display: flex;
    align-items: center;
    padding: 12px 15px;
    color: #ffffff; /* 글자색 강제 지정 */
    text-decoration: none;
    font-size: 15px;
    font-weight: 500;
    border-radius: 8px;
    transition: all 0.2s ease;
}

/* 마우스 올렸을 때 */
.sidebar-menu li a:hover {
    background-color: rgba(255, 255, 255, 0.1);
}

/* 활성화된 메뉴 (콘텐츠 관리) */
.sidebar-menu li.active a {
    background-color: #5d5dff; /* 보라빛 도는 블루 */
    color: #ffffff;
}

.sidebar-menu .icon {
    margin-right: 12px;
    font-size: 18px;
}

/* 하단 관리자 정보 */
.sidebar-bottom {
    padding: 20px;
    background-color: rgba(0, 0, 0, 0.2);
}

.admin-info {
    padding: 15px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 10px;
}

.admin-info .role {
    font-size: 11px;
    color: #8a94ad;
    margin-bottom: 4px;
}

.admin-info .name {
    font-size: 13px;
    display: block;
    color: #ffffff;
}

/* 메인 콘텐츠 영역 */
.main-content {
    flex: 1;
    padding: 40px;
    background-color: #f8f9fa;
}

/* 헤더 영역 */
.page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 30px;
}

.page-title h2 {
    font-size: 24px;
    font-weight: 700;
    margin-bottom: 8px;
}

.page-title p {
    color: #888;
    font-size: 14px;
}

.btn-primary {
    background-color: #4d4dff;
    color: #fff;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s;
}

.btn-primary:hover {
    background-color: #3b3bff;
}

/* 필터 & 검색바 */
.filter-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #fff;
    padding: 15px 25px;
    border-radius: 12px 12px 0 0;
    border: 1px solid #eee;
    border-bottom: none;
}

.search-box input {
    width: 300px;
    padding: 10px 15px;
    border: 1px solid #eee;
    border-radius: 8px;
    background-color: #fcfcfc;
    outline: none;
}

.filter-btn {
    background: none;
    border: none;
    padding: 8px 16px;
    margin-left: 5px;
    color: #888;
    cursor: pointer;
    border-radius: 6px;
    font-size: 14px;
}

.filter-btn.active {
    background-color: #1a1f33;
    color: #fff;
}

/* 리스트 섹션 */
.content-list {
    background: #fff;
    border: 1px solid #eee;
    border-radius: 0 0 12px 12px;
    overflow: hidden;
}

/* 리스트 헤더 */
.list-header {
    display: flex;
    padding: 15px 25px;
    background-color: #fafafa;
    border-bottom: 1px solid #eee;
    color: #888;
    font-size: 13px;
    font-weight: 600;
}

/* 리스트 로우(Row) */
.content-row {
    display: flex;
    align-items: center;
    padding: 20px 25px;
    border-bottom: 1px solid #f1f1f1;
    transition: background 0.2s;
}

.content-row:hover {
    background-color: #fcfcfc;
}

/* 컬럼 너비 설정 (flex 비율) */
.col-info { flex: 4; display: flex; align-items: center; }
.col-period { flex: 3; color: #666; font-size: 14px; }
.col-status { flex: 2; text-align: center; }
.col-manage { flex: 1; text-align: right; }

/* 전시 정보 셀 내부 */
.thumb {
    width: 60px;
    height: 60px;
    border-radius: 8px;
    object-fit: cover;
    margin-right: 15px;
    background-color: #eee;
}

.text .title {
    font-weight: 700;
    font-size: 16px;
    margin-bottom: 4px;
}

.text .location {
    color: #888;
    font-size: 13px;
}

/* 상태 뱃지 스타일 */
.col-status span, /* 직접 텍스트인 경우 */
.status-badge {
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    display: inline-block;
}

.STATUS_OPEN { 
    background: #eef2ff; 
    color: #4d4dff; 
    border: 1px solid #dadaff;
}

.STATUS_REQUESTED { 
    background: #fff8e6; 
    color: #ffa000; 
    border: 1px solid #ffeeba;
}

.STATUS_REJECTED { 
    background: #fff1f0; 
    color: #ff4d4f; 
    border: 1px solid #ffccc7;
}

.STATUS_SCHEDULED { 
    background: #e6fffa; 
    color: #00b5ad; 
    border: 1px solid #b2f5ea;
}

.STATUS_CLOSED { 
    background: #f5f5f5; 
    color: #8c8c8c; 
    border: 1px solid #d9d9d9;
}

/* 관리하기 링크 버튼 */
.col-manage a {
    color: #888;
    text-decoration: none;
    font-size: 14px;
    border: 1px solid #eee;
    padding: 6px 12px;
    border-radius: 6px;
    transition: all 0.2s;
}

.col-manage a:hover {
    background-color: #f0f0f0;
    color: #333;
}

/* 데이터 없음/로딩중 */
.empty, .loading {
    padding: 50px;
    text-align: center;
    color: #bbb;
}
</style>    
</head>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<body>

<div class="admin-layout">
    <aside class="sidebar">
    <div class="sidebar-top">
        <h1 class="logo">ExhibiReserve</h1>
        <p class="subtitle">VENDOR MANAGEMENT</p>
    </div>

    <nav class="sidebar-menu">
        <ul>
            <li class="active"><a href="#"><span class="icon">📋</span> 콘텐츠 관리</a></li>
            <li><a href="${ctx}/vendor/reserve_pay_manage"><span class="icon">📊</span> 예약 관리</a></li>
            <li><a href="${ctx}/reply/index.jsp"><span class="icon">💬</span> 관리자 문의하기</a></li>
        </ul>
    </nav>

    <div class="sidebar-bottom">
    <div class="admin-info">
        <p class="role">Signed in as</p>

        <strong class="name">
            <c:choose>
                <c:when test="${not empty loginSess}">
                    ${loginSess.name}
                </c:when>
                <c:otherwise>
                    잘못된 접근입니다.
                </c:otherwise>
            </c:choose>
        </strong>
    </div>
</div>
</aside>

    <main class="main-content">
        <div class="page-header">
            <div class="page-title">
                <h2>전시 게시물 관리</h2>
                <p>등록하신 전시의 상태를 확인하고 관리하세요.</p>
            </div>
            <button class="btn-primary" onclick="location.href='${ctx}/vendor/content_create'">+ 게시글 등록하기</button>
        </div>

        <div class="filter-bar">
            <div class="search-box">
                <input type="text" class="searchInput" id="searchInput" placeholder="전시명으로 검색..."  />
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
                <span class="col-info">전시 정보</span>
                <span class="col-period">기간</span>
                <span class="col-status">상태</span>
                <span class="col-manage">관리</span>
            </div>
            <div class="contentList" id="contentList">
                <div class="loading">데이터를 불러오는 중입니다...</li>
            </div>
        </section>
    </main>
</div>

</body>

<script>
const ctx = '${pageContext.request.contextPath}';

const STATUS_MAP = {
	    STATUS_REQUESTED: { text: '승인요청', className: 'STATUS_REQUESTED' },
	    STATUS_REJECTED:  { text: '거절',     className: 'STATUS_REJECTED' },
	    STATUS_SCHEDULED: { text: '오픈예정', className: 'STATUS_SCHEDULED' },
	    STATUS_OPEN:      { text: '진행중',   className: 'STATUS_OPEN' },
	    STATUS_CLOSED:    { text: '종료',     className: 'STATUS_CLOSED' }
	};


$(function () {
    loadContentList(); // 최초 전체 목록
});

function loadContentList() {
	const keyword = $('#searchInput').val();
	const status = $('.filter-btn.active').data('status');
	
	$.ajax({
		url: ctx +'/vendor/content_manage/list',
		type:'get',
		data: {
			keyword: keyword,
			status: status
		},
		success: function(res){
			console.log(res);
		    console.log(res.list);
			renderList(res.list);
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
	loadContentList();
});

//검색 서치 시
$('#searchInput').on('keyup', function(e){
	if(e.key ==='Enter'){
		loadContentList();
	}
});

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
                        '<div class="title">' + item.title + '</div>' +
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