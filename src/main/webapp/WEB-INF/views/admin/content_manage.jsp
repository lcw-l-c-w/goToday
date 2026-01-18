<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>ExhibiReserve - 전시 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    <style>
    /* 기본 초기화 */
	* { margin: 0; padding: 0; box-sizing: border-box; }
	body { font-family: 'Pretendard', sans-serif; background-color: #f3f5f9; color: #333; }
	
	.admin-container {
	    display: flex;
	    min-height: 100vh;
	}
	
	/* ================= 사이드바 ================= */
	.sidebar {
	    width: 260px;
	    background-color: #1a1f33; /* 다크 네이비 */
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
	.sidebar-nav li { margin-bottom: 5px; }
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
	
	/* ================= 메인 콘텐츠 ================= */
	.main-content {
	    flex: 1;
	    margin-left: 260px; /* 사이드바 너비만큼 띄움 */
	    padding: 40px 50px;
	}
	
	.content-header {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-bottom: 30px;
	}
	.title-group h2 { font-size: 26px; font-weight: 700; }
	.title-group p { color: #888; font-size: 14px; margin-top: 5px; }
	
	.btn-register {
	    background-color: #4d4dff; /* 이미지 블루 버튼 */
	    color: white; border: none; padding: 12px 24px;
	    border-radius: 10px; font-weight: 600; cursor: pointer;
	}
	
	/* 카드 섹션 */
	.content-card {
	    background: white;
	    border-radius: 16px; /* 이미지처럼 큰 곡률 */
	    padding: 25px;
	    box-shadow: 0 4px 15px rgba(0,0,0,0.03);
	}
	
	.toolbar {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-bottom: 25px;
	}
	
	.search-box {
	    display: flex; align-items: center; background: #f5f6f8;
	    padding: 8px 15px; border-radius: 10px; width: 320px;
	}
	.search-box input {
	    border: none; background: transparent; outline: none;
	    margin-left: 10px; width: 100%; font-size: 14px;
	}
	
	.filter-tabs { display: flex; gap: 8px; }
	.filter-tabs button {
	    border: 1px solid #eee; background: white; padding: 8px 16px;
	    border-radius: 20px; font-size: 13px; color: #888; cursor: pointer;
	}
	.filter-tabs button.active { background: #1a1f33; color: white; border-color: #1a1f33; }
	
	/* 테이블 스타일 */
	.table-header {
	    display: grid;
	    grid-template-columns: 80px 2.5fr 1.5fr 2fr 1fr 120px;
	    padding: 15px 10px;
	    border-bottom: 1px solid #eee;
	    color: #aaa; font-size: 12px; font-weight: 600;
	}
	
	.table-row {
	    display: grid;
	    grid-template-columns: 80px 2.5fr 1.5fr 2fr 1fr 120px;
	    padding: 20px 10px;
	    border-bottom: 1px solid #f8f8f8;
	    align-items: center;
	    font-size: 14px;
	}
	
	.col-actions { display: flex; gap: 5px; justify-content: flex-end; }
	.action-btn {
	    border: 1px solid #eee; background: white; padding: 5px;
	    border-radius: 6px; cursor: pointer; font-size: 12px; transition: 0.2s;
	}
	.action-btn:hover { background: #f0f0f0; }
	
	/* 뱃지 */
	.badge {
	    padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 700;
	}
	.badge.active { background: #eef2ff; color: #4d4dff; }
	.badge.inactive { background: #f5f5f5; color: #999; }
	.badge.pending { background: #fff8e6; color: #ffa000; }
	
	/* 페이지네이션 */
	.pagination {
	    display: flex; justify-content: center; align-items: center;
	    gap: 10px; margin-top: 30px;
	}
	.pagination button {
	    width: 35px; height: 35px; border: none; background: transparent;
	    border-radius: 8px; cursor: pointer; color: #888; font-weight: 600;
	}
	.pagination button.active { background: #1a1f33; color: white; }
	.pagination button.arrow { font-size: 10px; color: #ccc; }
    </style>
</head>
<body>

<div class="admin-container">
    <aside class="sidebar">
        <div class="sidebar-header">
            <h1 class="logo">ExhibiReserve</h1>
            <p class="logo-sub">VENDOR MANAGEMENT</p>
        </div>

        <nav class="sidebar-nav">
            <ul>
                <li><a href="#"><span class="material-symbols-outlined">dashboard</span> 승인 요청</a></li>
                <li class="active"><a href="#"><span class="material-symbols-outlined">description</span> 전시 관리</a></li>
                <li><a href="#"><span class="material-symbols-outlined">person</span> 사용자 관리</a></li>
                <li><a href="#"><span class="material-symbols-outlined">support_agent</span> 관리자 문의하기</a></li>
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
                <h2>전시 관리</h2>
                <p>등록하신 전시회의 상태를 확인하고 관리하세요.</p>
            </div>
        </header>

        <div class="content-card">
            <div class="toolbar">
                <div class="search-box">
                    <span class="material-symbols-outlined">search</span>
                    <input type="text"  class="searchInput" id="searchInput" placeholder="전시회 명으로 검색..."  />
                </div>
                <div class="filter-tabs">
                    <button class="filter-btn active">전체</button>
                    <button class="filter-btn" data-status="activate">활성화</button>
                    <button class="filter-btn" data-status="deactivate">비활성화</button>
                </div>
            </div>

            <section class="table-section">
                <div class="table-header">
                    <span>상태</span>
                    <span>전시명</span>
                    <span>전시기간</span>
                    <span>장소</span>
                    <span>가격</span>
                    <span class="text-right">관리</span>
                </div>
				<div class="contentList" id="contentList">
					 <div class="loading">데이터를 불러오는 중입니다...</li>
				</div>	
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
const ACTIVATE_MAP = {
		activate: { text: '활성화', className: 'activate' },
		deactivate:  { text: '비활성화',     className: 'deactivate' }
	};
</script>
</html>






