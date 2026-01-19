<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내정보 수정 | GoToday</title>
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
            --color-input-bg: #d9d9d9;
            --color-red: #ff4444;
            
            --font-family: 'Roboto', sans-serif;
            --font-size-nav: 24px;
            --font-size-title: 36px;
            --font-size-button: 24px;
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
            display: block;          /* a 태그 block화 */
		    text-decoration: none;   /* 밑줄 제거 */
		    color: inherit;          /* 기본 글자색 유지 */
        }

        /* hover 시 회색 */
		.sidebar-item:hover {
		    color: #999;           /* 원하는 회색 */
		    font-weight: 400;      /* 필요하면 유지 */
		}
		
		/* 현재 페이지(active) */
		.sidebar-item.active {
		    color: var(--color-primary);
		    font-weight: 700;
		}

        /* Content Area */
        .content {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .page-title {
            font-size: var(--font-size-title);
            font-weight: 700;
            margin-bottom: 50px;
            align-self: flex-start;
        }

        .form-wrapper {
            width: 100%;
            max-width: 700px;
        }

        /* Form Row */
        .form-row {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
        }

        .form-label {
            width: 180px;
            font-size: 18px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .form-input-wrapper {
            flex: 1;
        }

        .form-input {
            width: 100%;
            height: 50px;
            background-color: var(--color-input-bg);
            border: none;
            border-radius: 8px;
            padding: 0 20px;
            font-size: 16px;
            font-family: var(--font-family);
        }

        .form-input:focus {
            outline: 2px solid var(--color-primary);
            background-color: var(--color-white);
        }

        .form-input:read-only {
            cursor: not-allowed;
            opacity: 0.7;
        }

        .form-input::placeholder {
            color: #999;
        }

        /* Gender Radio Buttons */
        .gender-group {
            display: flex;
            gap: 30px;
        }

        .gender-label {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            font-size: 16px;
        }

        input[type="radio"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }

        /* Button Container */
        .button-container {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 60px;
            margin-bottom: 100px;
        }

        .btn {
            font-size: 20px;
            font-weight: 700;
            width: 150px;
            padding: 12px 0;
            border: 3px solid var(--color-border);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-submit {
            background-color: var(--color-white);
            color: var(--color-text);
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
            .nav { display: none; }
            .form-row { flex-direction: column; align-items: flex-start; }
            .form-label { margin-bottom: 10px; }
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
		        <a href="/gotoday/mypage/reservation" class="sidebar-item">예약관리</a>
		        <a href="/gotoday/mypage/review" class="sidebar-item">나의리뷰</a>
		        <a href="/gotoday/mypage/wishlist" class="sidebar-item">찜관리</a>
		    </div>
		    
		    <div class="sidebar-section">
		        <h2 class="sidebar-title">문의내역</h2>
		        <a href="/gotoday/mypage/qna" class="sidebar-item">1:1문의</a>
		    </div>
		    
		    <div class="sidebar-section">
		        <h2 class="sidebar-title">회원관리</h2>
		        <a href="/gotoday/mypage/user_like_edit" class="sidebar-item">관심사수정</a>
		        <a href="/gotoday/mypage/user_info"
		           class="sidebar-item active">내정보수정</a>
		    </div>
		</aside>

        <main class="content">
            <h1 class="page-title">내정보 수정</h1>
            
            <form id="frm" action="/gotoday/mypage/user_info" method="POST" class="form-wrapper" onsubmit="return beforeSubmit();">
                <!-- 이메일 -->
                <div class="form-row">
                    <label class="form-label">이메일</label>
                    <div class="form-input-wrapper">
                        <input type="text" name="email" value="${user.email}" class="form-input" readonly>
                    </div>
                </div>

                <!-- 역할과 로그인 타입에 따른 패스워드/이름 -->
                <c:choose>
                    <c:when test="${user.role == 0 && user.login_type == 'L'}">
                        <!-- 패스워드 -->
                        <div class="form-row">
                            <label class="form-label">반경한 비밀번호</label>
                            <div class="form-input-wrapper">
                                <input type="password" name="password" class="form-input" placeholder="미입력 시 기존 비밀번호가 유지됩니다.">
                            </div>
                        </div>

                        <!-- 패스워드 확인 -->
                        <div class="form-row">
                            <label class="form-label">비밀번호 확인</label>
                            <div class="form-input-wrapper">
                                <input type="password" name="confirmPassword" class="form-input" placeholder="미입력 시 기존 비밀번호가 유지됩니다.">
                            </div>
                        </div>

                        <!-- 이름 -->
                        <div class="form-row">
                            <label class="form-label">이름</label>
                            <div class="form-input-wrapper">
                                <input type="text" name="name" value="${user.name}" class="form-input">
                            </div>
                        </div>
                    </c:when>

                    <c:when test="${user.role == 0 && user.login_type != 'L'}">
                        <!-- 이름 (읽기 전용) -->
                        <div class="form-row">
                            <label class="form-label">이름</label>
                            <div class="form-input-wrapper">
                                <input type="text" name="name" value="${user.name}" class="form-input" readonly>
                            </div>
                        </div>
                    </c:when>

                    <c:when test="${user.role == 1}">
                        <!-- 패스워드 -->
                        <div class="form-row">
                            <label class="form-label">패스워드</label>
                            <div class="form-input-wrapper">
                                <input type="password" name="password" class="form-input" placeholder="미입력 시 기존 비밀번호가 유지됩니다.">
                            </div>
                        </div>

                        <!-- 패스워드 확인 -->
                        <div class="form-row">
                            <label class="form-label">패스워드 확인</label>
                            <div class="form-input-wrapper">
                                <input type="password" name="confirmPassword" class="form-input" placeholder="미입력 시 기존 비밀번호가 유지됩니다.">
                            </div>
                        </div>

                        <!-- 사업자등록번호 -->
                        <div class="form-row">
                            <label class="form-label">사업자등록번호</label>
                            <div class="form-input-wrapper">
                                <input type="text" name="bizNo" class="form-input" placeholder="미입력 시 기존 등록번호가 유지됩니다.">
                            </div>
                        </div>

                        <!-- 이름 -->
                        <div class="form-row">
                            <label class="form-label">이름</label>
                            <div class="form-input-wrapper">
                                <input type="text" name="name" value="${user.name}" class="form-input">
                            </div>
                        </div>
                    </c:when>
                </c:choose>

                <!-- 우편번호 -->
                <div class="form-row">
                    <label class="form-label">전화번호</label>
                    <div class="form-input-wrapper">
                        <input type="text" name="phone_number" value="${user.phone_number}" class="form-input">
                    </div>
                </div>

                <!-- 생년월일 -->
                <div class="form-row">
                    <label class="form-label">생년월일</label>
                    <div class="form-input-wrapper">
                        <input type="date" id="birthday_date" class="form-input">
                        <input type="hidden" id="birthday" name="birthday">
                    </div>
                </div>

                <!-- 성별 -->
                <div class="form-row">
                    <label class="form-label">성별</label>
                    <div class="form-input-wrapper">
                        <div class="gender-group">
                            <label class="gender-label">
                                <input type="radio" name="gender" value="M">
                                <span>남</span>
                            </label>
                            <label class="gender-label">
                                <input type="radio" name="gender" value="F">
                                <span>여</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- 버튼 -->
                <div class="button-container">
                    <button type="submit" class="btn btn-submit">확인</button>
                </div>
            </form>
        </main>
    </div>

    <script>
        $(function() {
            // 성별 라디오 체크
            var gender = '${user.gender}';
            if (gender === 'M') {
                $('input[name="gender"][value="M"]').prop('checked', true);
            } else if (gender === 'F') {
                $('input[name="gender"][value="F"]').prop('checked', true);
            }

            // 생년월일 표시 (yyyyMMdd → yyyy-MM-dd)
            var birthday = '${user.birthday}';
            if (birthday && birthday.length === 8) {
                $('#birthday_date').val(
                    birthday.substring(0,4) + '-' +
                    birthday.substring(4,6) + '-' +
                    birthday.substring(6,8)
                );
            }

            // 사이드바 아이템 클릭 시 페이지 이동
            $('.sidebar-item').on('click', function() {
                var text = $(this).text().trim();
                
                if (text === '관심사수정') {
                    location.href = '/gotoday/mypage/user_like_edit';
                } else if (text === '내정보수정') {
                    location.href = '/gotoday/mypage/user_info';
                }
                
                $('.sidebar-item').removeClass('active');
                $(this).addClass('active');
            });
        });

        // 수정 버튼 눌렀을 때
        function beforeSubmit() {
            let birthdayDate = $("#birthday_date").val();
            if (birthdayDate === '') {
                alert("생년월일을 입력해주세요.");
                return false;
            }

            let birthday = birthdayDate.replaceAll("-", "");
            $("#birthday").val(birthday);

            // 비밀번호 확인
            let password = $('input[name="password"]').val();
            let confirmPassword = $('input[name="confirmPassword"]').val();
            
            if (password !== '' || confirmPassword !== '') {
                if (password !== confirmPassword) {
                    alert("비밀번호가 일치하지 않습니다.");
                    return false;
                }
            }

            alert('정보가 성공적으로 수정되었습니다.');
            return true;
        }

    </script>
</body>
</html>