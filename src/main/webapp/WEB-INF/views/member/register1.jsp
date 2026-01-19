<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 정보입력 | GoToday</title>
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
            --color-white: #ffffff;
            --color-input-bg: #d9d9d9;
            --color-border: #e0e0e0;
            --color-kakao: #FEE500;
            --color-naver: #03C75A;
            
            --font-family: 'Roboto', sans-serif;
            --font-size-nav: 24px;
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
        .main-container {
            max-width: 800px;
            margin: 60px auto;
            padding: 0 20px;
        }

        /* Tab Navigation */
        .tab-nav {
            display: flex;
            background: var(--color-white);
            border: 2px solid var(--color-border);
            border-radius: 8px;
            margin-bottom: 50px;
            overflow: hidden;
        }

        .tab-item {
            flex: 1;
            padding: 20px;
            text-align: center;
            font-size: 20px;
            font-weight: 700;
            cursor: pointer;
            color: #999;
            border-right: 2px solid var(--color-border);
            transition: all 0.3s ease;
        }

        .tab-item:last-child {
            border-right: none;
        }

        .tab-item.active {
            color: var(--color-primary);
            background-color: #f0f9ff;
        }

        /* Form Container */
        .form-container {
            background: var(--color-white);
		    border-radius: 12px;
		    padding: 80px 100px;  /* 기존 60px 80px → 여백 증가 */
		    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
		    max-width: 900px;
        }

        /* Role Selection */
        .role-section {
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 2px solid var(--color-border);
        }

        .role-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .role-group {
            display: flex;
            gap: 30px;
        }

        .role-label {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            font-size: 16px;
        }

        /* Form Row */
        .form-row {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }

        .form-label {
            width: 140px;
            font-size: 16px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .form-input-group {
            display: flex;
		    align-items: stretch;  /* input과 버튼 높이 맞춤 */
		    gap: 15px;
        }

        .form-input {
            flex: 1;
            height: 50px;
            background-color: var(--color-input-bg);
            border: none;
            border-radius: 8px;
            padding: 0 20px;
            font-size: 16px;
            font-family: var(--font-family);
        }

        .form-input.small {
            flex: 1;  /* 버튼과 같은 flex 안에서 늘어나도록 */
    		min-width: 0; /* flex-basis 문제 방지 */
        }

        .form-input:focus {
            outline: 2px solid var(--color-primary);
            background-color: var(--color-white);
        }

        .email-at {
            font-size: 18px;
            font-weight: 700;
            padding: 0 5px;
        }

        /* Buttons */
        .btn {
            height: 50px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-check {
            flex: 0 0 auto;   /* 고정폭 */
		    height: 50px;     /* input 높이와 동일 */
		    padding: 0 25px;  /* 버튼 안쪽 좌우 여백 증가 */
		    border-radius: 10px; /* 둥근 모서리 */
		    background-color: #000;
		    color: #fff;
		    cursor: pointer;
		    font-weight: 700;
		    font-size: 16px;
		    transition: background-color 0.3s ease;
        }

        .btn-check:hover {
            background-color: #333;
        }

        .btn-search {
            width: 50px;
            height: 50px;
            background-color: var(--color-primary);
            color: var(--color-white);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 700;
        }

        .btn-search:hover {
            background-color: #3399cc;
        }

        /* Check Message */
        .check-message {
            color: var(--color-primary);
            font-size: 14px;
            margin-top: 5px;
            margin-left: 150px;
        }

        /* Radio Buttons */
        .radio-group {
            display: flex;
            gap: 30px;
        }

        .radio-label {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            font-size: 16px;
        }

        input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        /* 소셜 가입 섹션 스타일 (로그인 페이지 스타일 적용) */
		.social-section {
		    margin-top: 40px;
		    padding-top: 30px;
		    border-top: 1px solid var(--color-border);
		}
		
		.social-title {
		    text-align: center;
		    font-size: 14px;
		    color: #666;
		    margin-bottom: 15px;
		}
		
		.social-login-group {
		    display: flex;
		    gap: 12px;
		}
		
		.btn-social {
		    flex: 1;
		    padding: 12px;
		    border-radius: 4px;
		    text-decoration: none;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    gap: 8px;
		    font-weight: 600;
		    font-size: 14px;
		    transition: transform 0.1s;
		}
		
		.btn-social:active {
		    transform: scale(0.96);
		}
		
		.btn-kakao { background-color: #FEE500; color: #000; }
		.btn-naver { background-color: #03C75A; color: #fff; }
		
		/* SVG 아이콘 설정 */
		.kakao-icon { 
		    width: 18px; height: 18px; 
		    background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath d='M12 3c-4.97 0-9 3.185-9 7.115 0 2.558 1.712 4.8 4.348 6.148l-.845 3.097c-.102.373.121.754.495.845.132.032.27.022.395-.028l3.633-2.422c.322.033.65.055.974.055 4.97 0 9-3.185 9-7.115S16.97 3 12 3z'/%3E%3C/svg%3E") no-repeat center/contain; 
		}
		.naver-icon { 
		    width: 14px; height: 14px; 
		    background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='white'%3E%3Cpath d='M16.273 12.845L7.376 0H0v24h7.727V11.155L16.624 24H24V0h-7.727v12.845z'/%3E%3C/svg%3E") no-repeat center/contain; 
		}

        /* Bottom Buttons */
        .bottom-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 40px;
        }

        .btn-bottom {
            width: 180px;
            height: 55px;
            border-radius: 27.5px;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-prev {
            background-color: var(--color-white);
            color: #000;
            border: 3px solid #000;
        }

        .btn-prev:hover {
            background-color: #000;
            color: var(--color-white);
        }

        .btn-submit {
            background-color: var(--color-white);
            color: #000;
            border: 3px solid #000;
        }

        .btn-submit:hover {
            background-color: #000;
            color: var(--color-white);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .form-container {
                padding: 40px 30px;
            }
            
            .form-row {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .form-label {
                margin-bottom: 10px;
            }
            
            .check-message {
                margin-left: 0;
            }
            
            .nav {
                display: none;
            }

            .form-input.small {
                flex: 1;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <img src="${pageContext.request.contextPath}/img/logo.svg" alt="GoToday Logo" class="logo" onclick="location.href='/gotoday/main'">
        
        <nav class="nav">
            <a href="#" class="nav-item">Q&A</a>
            <a href="#" class="nav-item">PopUp</a>
            <a href="#" class="nav-item">Exhibition</a>
        </nav>
        
        <div class="header-actions">
            <input type="text" class="search-input" placeholder="검색...">
            <img src="${pageContext.request.contextPath}/img/user-icon.svg" alt="User" class="user-icon">
        </div>
    </header>

    <div class="main-container">
        <!-- Tab Navigation -->
        <div class="tab-nav">
            <div class="tab-item active">정보입력</div>
            <div class="tab-item">관심사 입력</div>
            <div class="tab-item">가입완료</div>
        </div>

        <!-- Form Container -->
        <div class="form-container">
            <form id="frm" action="/gotoday/member/register1" method="POST">
                <!-- Hidden Fields -->
                <input type="hidden" name="email" id="email">
                <input type="hidden" id="birthday" name="birthday">

                <!-- Role Selection -->
                <div class="role-section">
                    <div class="role-title">회원유형 선택</div>
                    <div class="role-group">
                        <label class="role-label">
                            <input type="radio" id="user" name="role" value="0" ${role == 0 ? 'checked' : ''}>
                            <span>개인 회원</span>
                        </label>
                        <label class="role-label">
                            <input type="radio" id="vendor" name="role" value="1" ${role == 1 ? 'checked' : ''}>
                            <span>기업 회원</span>
                        </label>
                    </div>
                </div>

                <!-- 이메일 -->
                <div class="form-row">
                    <label class="form-label">이메일</label>
                    <div class="form-input-group">
                        <input type="text" id="email_prefix" name="email_prefix" class="form-input small" placeholder="이메일">
                        <span class="email-at">@</span>
                        <input type="text" id="email_domain" name="email_domain" class="form-input small" placeholder="직접입력">
                        <button type="button" class="btn btn-check" onclick="emailCheck()">중복확인</button>
                    </div>
                </div>
                <div class="check-message" id="emailCheckMsg"></div>

                <!-- 비밀번호 -->
                <div class="form-row">
                    <label class="form-label">비밀번호</label>
                    <div class="form-input-group">
                        <input type="password" id="password" name="password" class="form-input" placeholder="비밀번호를 입력하세요">
                    </div>
                </div>

                <!-- 비밀번호 확인 -->
                <div class="form-row">
                    <label class="form-label">비밀번호 확인</label>
                    <div class="form-input-group">
                        <input type="password" id="password_confirm" name="password_confirm" class="form-input" placeholder="비밀번호를 다시 입력하세요">
                    </div>
                </div>

                <!-- 사업자등록번호 (기업회원만) -->
                <div class="form-row" id="vendorNo" style="display: ${role == 1 ? 'flex' : 'none'};">
                    <label class="form-label">사업자등록번호</label>
                    <div class="form-input-group">
                        <input type="text" id="vendor_no" name="vendor_no" class="form-input" placeholder="사업자등록번호를 입력하세요">
                    </div>
                </div>

                <!-- 이름 -->
                <div class="form-row">
                    <label class="form-label" id="nameLabel">${role == 1 ? '등록자명' : '이름'}</label>
                    <div class="form-input-group">
                        <input type="text" id="name" name="name" class="form-input" placeholder="이름을 입력하세요">
                    </div>
                </div>

                <!-- 생년월일 -->
                <div class="form-row">
                    <label class="form-label">생년월일</label>
                    <div class="form-input-group">
                        <input type="date" id="birthday_date" class="form-input">
                    </div>
                </div>

                <!-- 성별 -->
                <div class="form-row">
                    <label class="form-label">성별</label>
                    <div class="form-input-group">
                        <div class="radio-group">
                            <label class="radio-label">
                                <input type="radio" id="genderM" name="gender" value="M">
                                <span>남자</span>
                            </label>
                            <label class="radio-label">
                                <input type="radio" id="genderF" name="gender" value="F">
                                <span>여자</span>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- 휴대전화 -->
                <div class="form-row">
                    <label class="form-label">휴대전화</label>
                    <div class="form-input-group">
                        <input type="tel" id="phone_number" name="phone_number" class="form-input" placeholder="숫자만 입력하세요">
                    </div>
                </div>

                <!-- Bottom Buttons -->
                <div class="bottom-buttons">
                    <button type="button" class="btn-bottom btn-prev" onclick="history.back()">이전단계</button>
                    <button type="button" class="btn-bottom btn-submit" onclick="goSave()">회원가입</button>
                </div>
                
                <!-- Social Login Section -->
				<div class="social-section" id="socialSection">
				    <div class="social-title">또는 소셜 계정으로 회원가입</div>
				    <div class="social-login-group">
				        <a href="https://kauth.kakao.com/oauth/authorize?client_id=${REST_API_KEY}&redirect_uri=${REDIRECT_URI}&response_type=code&scope=account_email,profile_nickname" class="btn-social btn-kakao">
				            <span class="kakao-icon"></span> 카카오 회원가입
				        </a>
				        <a href="/naver" class="btn-social btn-naver">
				            <span class="naver-icon"></span> 네이버 회원가입
				        </a>
				    </div>
				</div>
            </form>
        </div>
    </div>

    <script>
        $(function () {
            function ChangeForm() {
                let role = $("input[name='role']:checked").val();
                $("#vendorNo").css('display', role === "1" ? 'flex' : 'none');
                $("#nameLabel").text(role === "1" ? "등록자명" : "이름");

             	// 기업 회원은 소셜 가입을 숨김 (선택 사항)
                if(role === "1") {
                    $("#socialSection").hide();
                } else {
                    $("#socialSection").show();
                }
             
                // 선택 변경 시 필드 초기화
                $("#vendor_no").val('');
                $("#name").val('');
                $("#email_prefix").val('');
                $("#email_domain").val('');
                $("#password").val('');
                $("#password_confirm").val('');
                $("#birthday_date").val('');
                $("#phone_number").val('');
                $("input[name='gender']").prop("checked", false);

                emailChecked = false;
                $("#emailCheckMsg").text('');
            }

            $("input[name='role']").on("change", ChangeForm);
            ChangeForm(); 
        });

        let emailChecked = false;

        function goSave() {
            let emailPrefix = $("#email_prefix").val();
            let emailDomain = $("#email_domain").val();
            let email = emailPrefix + "@" + emailDomain;

            if(!$("input[name='role']:checked").val()) {
                alert("회원유형을 선택해주세요.");
                return;
            }
            
            if (emailPrefix === '' || emailDomain === '') {
                alert("이메일을 입력해주세요");
                return;
            }

            if (!emailChecked) {
                alert("이메일 중복확인을 해주세요");
                return;
            }
         
            $("#email").val(email);

            if ($("#password").val() == '') {
                alert("비밀번호를 입력해주세요.")
                return;
            }
            
            if ($("#password_confirm").val() == '') {
                alert("비밀번호 확인을 입력해주세요.")
                return;
            }
            
            if ($("#password").val() !== $("#password_confirm").val()) {
                alert("비밀번호가 일치하지 않습니다.");
                return;
            }
            
            if($("#name").val() == '') {
                alert("이름을 입력해주세요.");
                return;
            }
            
            let birthdayDate = $("#birthday_date").val();
            if (birthdayDate === '') {
                alert("생년월일을 입력해주세요.");
                return;
            }
            let birthday = birthdayDate.replaceAll("-", "");
            $("#birthday").val(birthday);
            
            let phoneRegex = /^[0-9]+$/;
            if(!phoneRegex.test($("#phone_number").val())) {
                alert("전화번호는 숫자만 입력해주세요.")
                return;
            }
            
            if(!$("input[name='gender']:checked").val()) {
                alert("성별을 선택해주세요.");
                return;
            }
            
            if($("#phone_number").val() == '') {
                alert("전화번호를 입력해주세요.");
                return;
            }
            
            $("#frm").submit();
        }

        function emailCheck() {
            let email = $("#email_prefix").val() + "@" + $("#email_domain").val();

            if ($("#email_prefix").val() === '' || $("#email_domain").val() === '') {
                $("#emailCheckMsg").text("이메일을 입력해주세요");
                return;
            }
            
            if (!$("#email_domain").val().endsWith(".com")
                    && !$("#email_domain").val().endsWith(".co.kr")) {
                $("#emailCheckMsg").text("도메인 형식을 다시 확인해주세요.")
                return;
            }

            $.ajax({
                url: "/gotoday/member/emailCheck",
                data: { email: email },
                success: function(res) {
                    if (res == 0) {
                        $("#emailCheckMsg").text("사용 가능한 이메일입니다.");
                        emailChecked = true;
                    } else {
                        $("#emailCheckMsg").text("이미 사용 중인 이메일입니다.");
                        emailChecked = false;
                    }
                }
            });
        }

        $(document).ready(function() {
            $("#email_prefix, #email_domain").on("input change", function() {
                emailChecked = false;
                $("#emailCheckMsg").text("");
            });
        });
    </script>
</body>
</html>