<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>ExhibiReserve - 사용자 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    <style>
    /* 1. 기본 초기화 */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Pretendard', sans-serif; background-color: #f3f5f9; color: #333; }

        .admin-container { display: flex; min-height: 100vh; }

        /* 2. 사이드바 */
        .sidebar { width: 260px; background-color: #1a1f33; color: white; display: flex; flex-direction: column; position: fixed; height: 100vh; z-index: 100; }
        .sidebar-header { padding: 40px 25px; }
        .logo { font-size: 20px; font-weight: 800; color: #5d5dff; }
        .logo-sub { font-size: 10px; opacity: 0.6; letter-spacing: 1px; margin-top: 5px; }
        .sidebar-nav { flex: 1; padding: 0 15px; }
        .sidebar-nav a { display: flex; align-items: center; padding: 12px 15px; color: #8a94ad; text-decoration: none; border-radius: 8px; transition: 0.3s; font-size: 15px; }
        .sidebar-nav li.active a { background-color: #4d4dff; color: white; }
        .sidebar-nav ul { list-style: none; }
        .sidebar-nav a:hover:not(.active) { background-color: rgba(255,255,255,0.05); color: white; }
        .material-symbols-outlined { margin-right: 12px; font-size: 20px; }
        .sidebar-footer { padding: 20px; }
        .user-box { background: rgba(255,255,255,0.05); padding: 15px; border-radius: 12px; }
        .user-role { display: block; font-size: 11px; color: #8a94ad; margin-bottom: 3px; }
        .user-name { font-size: 13px; font-weight: 600; }

        /* 3. 메인 레이아웃 */
        .main-content { flex: 1; margin-left: 260px; padding: 40px 50px; }
        .content-header { margin-bottom: 30px; }
        .title-group h2 { font-size: 26px; font-weight: 700; }
        .title-group p { color: #888; font-size: 14px; margin-top: 5px; }
        .content-card { background: white; border-radius: 16px; padding: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); }

        /* 4. 툴바 */
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .search-box { display: flex; align-items: center; background: #f5f6f8; padding: 8px 15px; border-radius: 10px; width: 320px; }
        .search-box input { border: none; background: transparent; outline: none; margin-left: 10px; width: 100%; font-size: 14px; }
        .filter-tabs { display: flex; gap: 8px; }
        .filter-tabs button { border: 1px solid #eee; background: white; padding: 8px 16px; border-radius: 20px; font-size: 13px; color: #888; cursor: pointer; }
        .filter-tabs button.active { background: #1a1f33; color: white; border-color: #1a1f33; }

        /* 5. 테이블 (요청하신 grid 간격 적용) */
        .table-header, .table-row {
            display: grid;
            /* 요청하신 간격: 상태(90px) 이메일(1fr) 이름(1fr) 핸드폰(160px) 생년월일(180px) */
            grid-template-columns: 90px 1fr 0.7fr 1fr 200px;
            align-items: center;
            gap: 0; 
        }

        .table-header { 
            padding: 0 15px 15px 15px; 
            border-bottom: 1px solid #eee; 
            color: #aaa; 
            font-size: 13px; 
            font-weight: 600;
        }

        .table-row { 
            padding: 22px 15px; /* 위아래 간격 소폭 증가 */
            border-bottom: 1px solid #f8f8f8; 
            font-size: 14px; 
            transition: 0.2s;
        }
        .table-row:hover { background-color: #f9faff; }

        /* [핵심] 컨텐츠 리스트 정렬 클래스를 헤더에도 동일하게 적용 */
        .col-status { text-align: center; }
        .col-email { text-align: left; padding-left: 40px; } /* 상태와 간격 벌림 */
        .col-name { text-align: left; padding-left: 5px; }   /* 이메일과 밀착 */
        .col-phone { text-align: left; padding-left: 10px; }  /* 이름과 밀착 */
        .col-birth { text-align: left; padding-left: 10px; }  /* 번호와 밀착 및 왼쪽 정렬 */

        /* 텍스트 스타일 */
        .table-row .email { font-weight: 500; color: #222; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .table-row .name { color: #555; }
        .table-row .phone, .table-row .birth { color: #888; font-size: 13px; font-family: 'Consolas', monospace; }

        /* 6. 배지 */
        .badge {
            display: inline-flex; align-items: center; justify-content: center;
            width: 62px; padding: 4px 0; border-radius: 20px;
            font-size: 11px; font-weight: 700;
        }
        .badge.vendor { background: #eef2ff; color: #4d4dff; }
        .badge.user { background: #fef2f2; color: #ef4444; }

        /* 8. 페이지네이션 */
        .pagination { display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 30px; }
        .pagination button { width: 35px; height: 35px; border: none; background: transparent; border-radius: 8px; cursor: pointer; color: #888; font-weight: 600; }
        .pagination button.active { background: #1a1f33; color: white; }
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
				<li><a href="${ctx}/admin/content_request"><span class="material-symbols-outlined">dashboard</span> 승인 요청</a></li>
                <li><a href="${ctx}/admin/content_manage"><span class="material-symbols-outlined">description</span> 전시 관리</a></li>
                <li class="active"><a href="#"><span class="material-symbols-outlined">person</span> 사용자 관리</a></li>
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
                <h2>사용자 관리</h2>
                <p>등록된 사용자의 상태를 확인하고 관리하세요.</p>
            </div>
        </header>

        <div class="content-card">
            <div class="toolbar">
                <div class="search-box">
                    <span class="material-symbols-outlined">search</span>
                    <input type="text"  class="searchInput" id="searchInput" placeholder="사용자 이름으로 검색..."  />
                </div>
                <div class="filter-tabs">
                    <button class="filter-btn active" data-status="">전체</button>
                    <button class="filter-btn" data-status="0">사용자</button>
                    <button class="filter-btn" data-status="1">업체</button>
                </div>
            </div>

            <section class="table-section">
                <div class="table-header">
                    <span class="col-status">상태</span>
                    <span class="col-email">이메일</span>
                    <span class="col-name">이름</span>
                    <span class="col-phone">핸드폰 번호</span>
                    <span class="col-birth">생년월일</span>
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

const USER_MAP = {
		  1:  { text: '업체', className: 'vendor' },
		  0: { text: '사용자', className: 'user' }
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
        keyword: keyword
    };
    
    // status가 빈 문자열("")이 아닐 때만 파라미터에 추가 (전체 선택 시 제외)
    if (status !== "" && status !== undefined) {
        searchData.role = status;
    }

    $.ajax({
        url: ctx + '/admin/user_manage/list',
        type: 'get',
        data: searchData,
        success(res) {
            renderList(res.userList);
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
	loadContentList();
});

//검색 서치 시
$('#searchInput').on('keyup', function(e){
	if(e.key ==='Enter'){
		loadContentList();
	}
});

function formatPhone(phone) {
    if (!phone) return 'null';
    if (phone==='') return 'null';
    
    phone = phone.replace(/\D/g,'');
    
    if(phone.length === 11){
    	return phone.replace(/(\d{3})(\d{4})(\d{4})/, '$1 - $2 - $3');
    }
    if(phone.length === 10){
    	return phone.replace(/(\d{3})(\d{3})(\d{4})/, '$1 - $2 - $3');
    }
    
    return phone; // yyyy-MM-dd
}
function formatBirth(birth) {
    if (!birth) return 'null';
    if (birth==='') return 'null';
    
    birth = birth.replace(/\D/g,'');
    
    if(birth.length === 8){
    	return birth.replace(/(\d{4})(\d{2})(\d{2})/, '$1 - $2 - $3');
    }
    
    return birth; // yyyy-MM-dd
}

function renderList(list) {
    const $list = $('#contentList');
    $list.empty();

    if (list.length === 0) {
        $list.append('<div class="empty" style="padding:40px; text-align:center; color:#999;">검색 결과가 없습니다.</div>');
        return;
    }

    list.forEach(item => {
    	
    	const vendor = (item.role === 1 || item.role === "1");
        const statusVal = vendor ? 1 : 0;
        const userInfo = USER_MAP[statusVal] || { text: '알수없음', className: 'user' };

        $list.append(
        		'<li class="table-row">' +
	                '<div class="col-status"><span class="badge ' + userInfo.className + '">' + userInfo.text + '</span></div>' + 
	                '<span class="email col-email">' + item.email + '</span>' +
	                '<span class="name col-name">' + item.name + '</span>' +
	                '<span class="phone col-phone">' + formatPhone(item.phone_number) + '</span>' +
	                '<span class="birth col-birth">' + formatBirth(item.birthday) + '</span>' +
            '</li>'
        );
    });
}


</script>
</html>






