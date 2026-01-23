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
    <link rel="stylesheet" href="${ctx}/css/admin_user_manage.css">
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
                <li><a href="${ctx}/reply/index.do"><span class="material-symbols-outlined">support_agent</span> 관리자 문의하기</a></li>
                <li><a href="${ctx}/mypage/logout" onclick="return confirmLogout();"><span class="material-symbols-outlined">logout</span> 로그아웃</a></li>
            </ul>
        </nav>

        <div class="sidebar-footer">
		    <div class="user-box">
		        <p class="user-role">Signed in as</p>
		        <div class="name-wrapper"> <strong class="user-name">
		                <c:choose>
		                    <c:when test="${not empty loginSess}">
		                        관리자
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

function confirmLogout() {
    if (confirm("로그아웃 하시겠습니까?")) {
        return true; 
    } else {
        return false;
    }
}

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






