<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />

<style>
    :root {
        --main-color: #4dc3ff;
    }
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    body {
        font-family: "Pretendard", sans-serif;
        overflow-x: hidden;
    }
    a {
        text-decoration: none;
        color: inherit;
    }

    .header {
        width: 100%;
        border-bottom: 1px solid #eee;
        background: #fff;
        position: sticky;
        top: 0;
        z-index: 1000;
    }
    .nav-container {
        max-width: 1100px;
        margin: 0 auto;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 20px;
        height: 70px;
    }
    .logo img {
        height: 28px;
        cursor: pointer;
        display: block;
    }

    .nav-menu {
        display: flex;
        gap: 35px;
        height: 100%;
        list-style: none;
        align-items: center;
    }
    .nav-menu li {
        position: relative;
        height: 100%;
        display: flex;
        align-items: center;
    }
    .nav-menu a {
        font-weight: 600;
        font-size: 15px;
        color: #333;
        transition: color 0.3s ease;
        height: 100%;
        display: flex;
        align-items: center;
        padding: 0 5px;
    }
    .nav-menu li:hover a {
        color: var(--main-color);
    }
    .nav-menu li::after {
        content: "";
        position: absolute;
        bottom: -1px;
        left: 0;
        width: 0;
        height: 3px;
        background-color: var(--main-color);
        transition: width 0.3s ease;
        z-index: 5;
    }
    .nav-menu li:hover::after {
        width: 100%;
    }

    .nav-icons {
        display: flex;
        gap: 20px;
        align-items: center;
    }

    /* header search */
    .search-bar {
        border-bottom: 1px solid #333;
        display: flex;
        align-items: center;
        padding: 2px 5px;
    }
    .search-bar input {
        border: none;
        outline: none;
        width: 150px;
        font-size: 14px;
        background: transparent;
    }
    .search-btn {
        border: none;
        background: transparent;
        cursor: pointer;
        font-size: 16px;
        line-height: 1;
    }
    
    .search-btn .material-symbols-outlined {
	    font-size: 23px; /* 아이콘 크기 */
	    font-variation-settings: 'FILL' 0, 'wght' 350, 'GRAD' 0, 'opsz' 24;
	}

    .user-icon {
        font-size: 30px;
       display: flex;
	    align-items: center;
	    justify-content: center;
	    background: none;
	    border: none;
	    color: #333; /* 아이콘 색상 (원하는 색으로 변경 가능) */
	    cursor: pointer;
	    padding: 8px;
	    transition: color 0.2s;
    }
    .user-icon:hover {
        color: var(--main-color);
    }
    
    .user-icon .material-symbols-outlined {
	    font-size: 32px; /* 아이콘 크기 */
	    font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
	}

    .search-wrap {
        position: relative;
    }
    .search-panel {
        display: none;
        position: absolute;
        top: calc(100% + 10px);
        right: 0;
        width: 260px;
        background: #fff;
        border: 1px solid #eee;
        padding: 10px;
        z-index: 2000;
    }
    .search-wrap:hover .search-panel,
    .search-panel:hover {
        display: block;
    }
    .search-panel::before {
        content: "";
        position: absolute;
        top: -10px;
        left: 0;
        right: 0;
        height: 10px;
    }

    .panel-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
        font-size: 13px;
    }
    .clear-btn {
        border: none;
        background: transparent;
        cursor: pointer;
        color: #666;
        font-size: 12px;
    }
    .clear-btn:hover {
        color: var(--main-color);
    }

    .recent-list {
        list-style: none;
        display: flex;
        flex-direction: column;
        gap: 6px;
    }
    .recent-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 8px;
    }
    .recent-keyword {
        font-size: 13px;
        color: #333;
        cursor: pointer;
    }
    .recent-keyword:hover {
        color: var(--main-color);
    }
    .recent-del {
        border: none;
        background: transparent;
        cursor: pointer;
        color: #999;
        font-size: 12px;
    }
    .recent-del:hover {
        color: #333;
    }
    .empty-recent {
        display: none;
        color: #888;
        font-size: 12px;
        margin-top: 6px;
    }
</style>

<header class="header">
    <div class="nav-container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/main">
                <img src="<c:url value='/img/logo.png'/>" alt="Logo" />
            </a>
        </div>

        <ul class="nav-menu">
            <li>
                <a href="${pageContext.request.contextPath}/reply/index.do"
                    >Q&A</a
                >
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/popup">PopUp</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/exhibition"
                    >Exhibition</a
                >
            </li>
        </ul>

        <div class="nav-icons">
            <div class="search-wrap" id="searchWrap">
                <form
                    id="headerSearchForm"
                    method="get"
                    action="${pageContext.request.contextPath}/search"
                >
                    <div class="search-bar">
                        <input
                            id="headerSearchInput"
                            type="text"
                            name="q"
                            placeholder="검색"
                            autocomplete="off"
                        />
                        <button
                            type="submit"
                            class="search-btn"
                            aria-label="search"
                        >
                            <span class="material-symbols-outlined">search</span>
                        </button>
                    </div>
                </form>

                <div class="search-panel" id="searchPanel">
                    <div class="panel-header">
                        <strong>최근 검색어</strong>
                        <button
                            type="button"
                            id="clearRecentBtn"
                            class="clear-btn"
                        >
                            전체삭제
                        </button>
                    </div>
                    <ul id="recentList" class="recent-list"></ul>
                    <div id="emptyRecent" class="empty-recent">
                        최근 검색어가 없습니다.
                    </div>
                </div>
            </div>

            <span class="user-icon" id="myPageBtn">
            	<c:choose>
				    <c:when test="${empty loginSess}">
				        <span class="material-symbols-outlined">login</span>
				    </c:when>
				    <c:otherwise>
				    	<c:choose>
						    <c:when test="${not empty loginSess and loginSess.role == 0}">
						        <span class="material-symbols-outlined">person</span>
						    </c:when>
						    <c:otherwise>
						        <span class="material-symbols-outlined">passkey</span>
						    </c:otherwise>
						</c:choose>
				    </c:otherwise>
				</c:choose>
            	
            </span>
        </div>
    </div>
</header>

<script>
    (function () {
      const STORAGE_KEY = "gotoday_recent_keywords";
      const MAX_RECENT = 5;

      const form = document.getElementById("headerSearchForm");
      const input = document.getElementById("headerSearchInput");
      const recentList = document.getElementById("recentList");
      const emptyRecent = document.getElementById("emptyRecent");
      const clearBtn = document.getElementById("clearRecentBtn");

      function loadKeywords() {
        try {
          const raw = localStorage.getItem(STORAGE_KEY);
          const arr = raw ? JSON.parse(raw) : [];
          return Array.isArray(arr) ? arr : [];
        } catch (e) { return []; }
      }
      function saveKeywords(arr) { localStorage.setItem(STORAGE_KEY, JSON.stringify(arr)); }
      function normalize(q) { return (q || "").trim(); }

      function addKeyword(q) {
        q = normalize(q);
        if (!q) return;
        if (q.length > 50) q = q.substring(0, 50);
        let arr = loadKeywords().filter(item => item !== q);
        arr.unshift(q);
        if (arr.length > MAX_RECENT) arr = arr.slice(0, MAX_RECENT);
        saveKeywords(arr);
      }
      function removeKeyword(q) { saveKeywords(loadKeywords().filter(item => item !== q)); }
      function clearKeywords() { localStorage.removeItem(STORAGE_KEY); }

      function renderRecent() {
        const arr = loadKeywords();
        recentList.innerHTML = "";
        if (arr.length === 0) { emptyRecent.style.display = "block"; return; }
        emptyRecent.style.display = "none";

        arr.forEach(q => {
          const li = document.createElement("li");
          li.className = "recent-item";

          const span = document.createElement("span");
          span.className = "recent-keyword";
          span.textContent = q;
          span.addEventListener("click", function () {
            input.value = q;
            form.requestSubmit();
          });

          const del = document.createElement("button");
          del.type = "button";
          del.className = "recent-del";
          del.textContent = "X";
          del.addEventListener("click", function () {
            removeKeyword(q);
            renderRecent();
          });

          li.appendChild(span);
          li.appendChild(del);
          recentList.appendChild(li);
        });
      }

      form.addEventListener("submit", function (e) {
        const q = normalize(input.value);
        if (!q) {
        	e.preventDefault();
        	window.location.href = form.action;   // /search 로 이동
        	return;
        }
        addKeyword(q);
      });

      clearBtn.addEventListener("click", function () {
        clearKeywords();
        renderRecent();
      });

      document.getElementById("searchWrap").addEventListener("mouseenter", renderRecent);
      renderRecent();
    })();

    (function () {
    	  const btn = document.getElementById("myPageBtn");
    	  if (!btn) return; // 페이지에 버튼 없으면 아무것도 안 함

    	  const CTX = "${pageContext.request.contextPath}";
    	  const isLoggedIn = ${not empty loginSess}; // true/false

    	  // role이 숫자라고 가정하면 아래처럼 (안전하게 숫자로 변환)
    	  const userRole = Number("${not empty loginSess ? loginSess.role : -1}");

    	  btn.addEventListener("click", function () {
    		  if(!isLoggedIn) {
    			  alert("로그인이 필요합니다.");
    			  location.href="${pageContext.request.contextPath}/member/login";
    		  }
    		  else location.href="${pageContext.request.contextPath}/login/process";
    	  });
    	})();
</script>
