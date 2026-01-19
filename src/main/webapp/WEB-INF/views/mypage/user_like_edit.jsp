<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관심사 수정 | GoToday</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <style>
        /* Design Tokens */
        :root {
            --color-background: #f5f5f5;
            --color-primary: #41b6e6;
            --color-text: #000000;
            --color-sidebar-bg: rgba(217, 217, 217, 0.30);
            --color-white: #ffffff;
            --color-button-inactive: #d9d9d9;
            --color-border: #000000;
            
            --font-family: 'Roboto', sans-serif;
            --font-size-nav: 24px;
            --font-size-title: 36px;
            --font-size-button: 24px; /* 너무 커서 약간 조정 */
            --font-size-sidebar: 20px;
            
            --border-radius-sidebar: 30px;
            --border-radius-button: 50px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: var(--font-family);
            background-color: var(--color-background);
            color: var(--color-text);
            min-height: 100vh;
        }

        /* Header */
        .header {
            background-color: var(--color-white);
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 40px;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .logo {
            height: 40px;
            width: auto;
            cursor: pointer;
        }

        .nav {
            display: flex;
            align-items: center;
            gap: 40px;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        .nav-item {
            font-size: var(--font-size-nav);
            font-weight: 400;
            text-decoration: none;
            color: var(--color-text);
            position: relative;
        }

        .nav-item.active::after {
            content: '';
            position: absolute;
            bottom: -18px;
            left: 0;
            right: 0;
            height: 4px;
            background-color: var(--color-primary);
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .search-input {
            width: 300px;
            height: 40px;
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 0 15px;
            font-size: 16px;
            outline: none;
        }

        .user-icon {
            width: 36px;
            height: 36px;
            cursor: pointer;
        }

        /* Main Container */
        .container {
            display: flex;
            gap: 60px;
            padding: 60px 8%;
            max-width: 1600px;
            margin: 0 auto;
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background-color: var(--color-sidebar-bg);
            border-radius: var(--border-radius-sidebar);
            padding: 50px 30px;
            height: fit-content;
        }

        .sidebar-section {
            margin-bottom: 40px;
        }

        .sidebar-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .sidebar-item {
            font-size: var(--font-size-sidebar);
            font-weight: 400;
            line-height: 2.2;
            cursor: pointer;
            padding: 5px 0;
            transition: color 0.2s;
        }

        .sidebar-item:hover, .sidebar-item.active {
            color: var(--color-primary);
            font-weight: 700;
        }

        /* Content Area */
        .content {
            flex: 1;
        }

        .page-title {
            font-size: var(--font-size-title);
            font-weight: 700;
            margin-bottom: 50px;
        }

        .form-section {
            margin-bottom: 60px;
            background: var(--color-white);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
        }

        .section-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: left;
            color: var(--color-text-light);
        }

        /* Button Grid */
        .button-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: flex-start;
        }

        /* Custom Radio/Checkbox Buttons */
        input[type="radio"],
        input[type="checkbox"] {
            display: none;
        }

        .btn-option {
            display: inline-block;
            padding: 12px 30px;
            border-radius: var(--border-radius-button);
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            background-color: var(--color-button-inactive);
            color: #666;
            text-align: center;
            border: 2px solid transparent;
        }

        input[type="radio"]:checked + .btn-option,
        input[type="checkbox"]:checked + .btn-option {
            background-color: var(--color-primary);
            color: var(--color-white);
            border-color: var(--color-primary);
        }

        .btn-option:hover {
            opacity: 0.8;
            transform: translateY(-2px);
        }

        /* Submit Button */
        .submit-container {
            display: flex;
            justify-content: center;
            margin-top: 50px;
            margin-bottom: 100px;
        }

        .btn-submit {
            font-size: 24px;
            font-weight: 700;
            width: 250px;
            padding: 15px 0;
            background-color: var(--color-white);
            border: 3px solid var(--color-border);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            background-color: var(--color-border);
            color: var(--color-white);
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .container { flex-direction: column; padding: 20px; }
            .sidebar { width: 100%; display: flex; overflow-x: auto; gap: 20px; padding: 20px; }
            .sidebar-section { margin-bottom: 0; min-width: 150px; }
            .nav { display: none; } /* 모바일에서 네비 숨김 */
        }
    </style>
</head>
<body>
    <header class="header">
        <img src="${pageContext.request.contextPath}/img/logo.svg" alt="GoToday Logo" class="logo" onclick="location.href='/gotoday/main'">
        
        <nav class="nav">
            <a href="#" class="nav-item">Q&A</a>
            <a href="#" class="nav-item active">PopUp</a>
            <a href="#" class="nav-item">Exhibition</a>
        </nav>
        
        <div class="header-actions">
            <input type="text" class="search-input" placeholder="검색...">
            <img src="${pageContext.request.contextPath}/img/user-icon.svg" alt="User" class="user-icon">
        </div>
    </header>

    <div class="container">
        <aside class="sidebar">
            <div class="sidebar-section">
                <h2 class="sidebar-title">주문관리</h2>
                <div class="sidebar-item">예약관리</div>
                <div class="sidebar-item">나의리뷰</div>
                <div class="sidebar-item">찜관리</div>
            </div>
            
            <div class="sidebar-section">
                <h2 class="sidebar-title">문의내역</h2>
                <div class="sidebar-item">1:1문의</div>
            </div>
            
            <div class="sidebar-section">
                <h2 class="sidebar-title">회원관리</h2>
                <div class="sidebar-item active">관심사수정</div>
                <div class="sidebar-item">내정보수정</div>
            </div>
        </aside>

        <main class="content">
            <h1 class="page-title">관심사 수정</h1>
            
            <form id="frm" action="/gotoday/mypage/user_like_edit" method="POST">
                <div class="form-section">
                    <h2 class="section-title">전시 or 팝업</h2>
                    <div class="button-grid">
                        <label>
                            <input type="radio" name="event" value="exhibition" 
                                <c:if test="${userTags.contains('exhibition')}">checked</c:if>>
                            <span class="btn-option">전시</span>
                        </label>
                        <label>
                            <input type="radio" name="event" value="popup" 
                                <c:if test="${userTags.contains('popup')}">checked</c:if>>
                            <span class="btn-option">팝업</span>
                        </label>
                    </div>
                </div>

                <div class="form-section">
                    <h2 class="section-title">사람들이 많이 가는 핫 플레이스</h2>
                    <div class="button-grid">
                        <label>
                            <input type="checkbox" name="location" value="seongsu" 
                                <c:if test="${userTags.contains('seongsu')}">checked</c:if>>
                            <span class="btn-option">성수</span>
                        </label>
                        <label>
                            <input type="checkbox" name="location" value="hongdae" 
                                <c:if test="${userTags.contains('hongdae')}">checked</c:if>>
                            <span class="btn-option">홍대</span>
                        </label>
                        <label>
                            <input type="checkbox" name="location" value="yeouido" 
                                <c:if test="${userTags.contains('yeouido')}">checked</c:if>>
                            <span class="btn-option">여의도</span>
                        </label>
                        <label>
                            <input type="checkbox" name="location" value="gangnam" 
                                <c:if test="${userTags.contains('gangnam')}">checked</c:if>>
                            <span class="btn-option">강남</span>
                        </label>
                        <label>
                            <input type="checkbox" name="location" value="hyehwa" 
                                <c:if test="${userTags.contains('hyehwa')}">checked</c:if>>
                            <span class="btn-option">혜화</span>
                        </label>
                        <label>
                            <input type="checkbox" name="location" value="hannam" 
                                <c:if test="${userTags.contains('hannam')}">checked</c:if>>
                            <span class="btn-option">한남</span>
                        </label>
                    </div>
                </div>

                <div class="form-section">
                    <h2 class="section-title">관심있는 분야</h2>
                    <div class="button-grid">
                        <label>
                            <input type="checkbox" name="interest" value="food" 
                                <c:if test="${userTags.contains('food')}">checked</c:if>>
                            <span class="btn-option">식품</span>
                        </label>
                        <label>
                            <input type="checkbox" name="interest" value="character" 
                                <c:if test="${userTags.contains('character')}">checked</c:if>>
                            <span class="btn-option">캐릭터</span>
                        </label>
                        <label>
                            <input type="checkbox" name="interest" value="cosmetics" 
                                <c:if test="${userTags.contains('cosmetics')}">checked</c:if>>
                            <span class="btn-option">화장품</span>
                        </label>
                        <label>
                            <input type="checkbox" name="interest" value="media" 
                                <c:if test="${userTags.contains('media')}">checked</c:if>>
                            <span class="btn-option">미디어</span>
                        </label>
                        <label>
                            <input type="checkbox" name="interest" value="art" 
                                <c:if test="${userTags.contains('art')}">checked</c:if>>
                            <span class="btn-option">미술</span>
                        </label>
                        <label>
                            <input type="checkbox" name="interest" value="fashion" 
                                <c:if test="${userTags.contains('fashion')}">checked</c:if>>
                            <span class="btn-option">패션</span>
                        </label>
                        <label>
                            <input type="checkbox" name="interest" value="digitaltech" 
                                <c:if test="${userTags.contains('digitaltech')}">checked</c:if>>
                            <span class="btn-option">디지털/테크</span>
                        </label>
                        <label>
                            <input type="checkbox" name="interest" value="kidspets" 
                                <c:if test="${userTags.contains('kidspets')}">checked</c:if>>
                            <span class="btn-option">키즈/반려동물</span>
                        </label>
                        <label>
                            <input type="checkbox" name="interest" value="etc" 
                                <c:if test="${userTags.contains('etc')}">checked</c:if>>
                            <span class="btn-option">기타</span>
                        </label>
                    </div>
                </div>

                <div class="submit-container">
                    <button type="submit" class="btn-submit">확인</button>
                </div>
            </form>
        </main>
    </div>

    <script>
        $(document).ready(function() {
            // 폼 제출 시 간단한 유효성 검사 (선택 사항)
            $('#frm').on('submit', function(e) {
                const eventSelected = $('input[name="event"]:checked').length > 0;
                if(!eventSelected) {
                    alert('행사 형태(전시 또는 팝업)를 선택해주세요.');
                    e.preventDefault();
                    return;
                }
                
                alert('관심사가 성공적으로 수정되었습니다.');
            });

            // 사이드바 아이템 클릭 시 효과 (실제 이동은 링크 추가 필요)
            $('.sidebar-item').on('click', function() {
                $('.sidebar-item').removeClass('active');
                $(this).addClass('active');
            });
        });
    </script>
</body>
</html>