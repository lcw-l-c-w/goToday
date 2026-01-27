<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보 입력 | GoToday</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member_register.css">
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

        
        if(!$("input[name='gender']:checked").val()) {
            alert("성별을 선택해주세요.");
            return;
        }
        
        if($("#phone_number").val() == '') {
            alert("전화번호를 입력해주세요.");
            return;
        }
        
        // 전화번호 숫자만 추출해서 hidden에 넣기
        let phoneNumber = $("#phone_number").val().replace(/-/g, ""); // 하이픈 제거
        $("#phone_number").val(phoneNumber); // 폼 전송 시 숫자만
        
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
    
    // 전화번호 하이픈(-) 추가
    $(document).ready(function() {
        $("#phone_number").on("input", function() {
            let number = $(this).val().replace(/[^0-9]/g, ""); // 숫자만 추출
            let formatted = "";

            if(number.length < 4) {
                formatted = number;
            } else if(number.length < 7) {
                formatted = number.substr(0, 3) + "-" + number.substr(3);
            } else if(number.length <= 11) {
                formatted = number.substr(0, 3) + "-" + number.substr(3, 4) + "-" + number.substr(7);
            } else {
                formatted = number.substr(0, 3) + "-" + number.substr(3, 4) + "-" + number.substr(7, 4);
            }

            $(this).val(formatted);
        });
    });
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="container">
	    <div class="tab-nav">
	        <div class="tab-item active">정보 입력</div>
	        <div class="tab-item">관심사 입력</div>
	        <div class="tab-item">가입 완료</div>
	    </div>
    	
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

</body>
</html>