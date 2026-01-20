<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>정보입력 | GoToday</title>
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
    :root {
        --color-background: #f5f5f5;
        --color-primary: #41b6e6;
        --color-text: #000000;
        --color-white: #ffffff;
        --color-input-bg: #d9d9d9;
        --color-border: #e0e0e0;
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Roboto', sans-serif; background-color: var(--color-background); color: var(--color-text); min-height: 100vh; }

    /* 공통 컨테이너 및 탭 */
    .main-container { max-width: 900px; margin: 60px auto; padding: 0 20px; }
    .tab-nav { display: flex; background: var(--color-white); border: 2px solid var(--color-border); border-radius: 8px; margin-bottom: 50px; overflow: hidden; }
    .tab-item { flex: 1; padding: 20px; text-align: center; font-size: 20px; font-weight: 700; color: #999; border-right: 2px solid var(--color-border); }
    .tab-item:last-child { border-right: none; }
    .tab-item.active { color: var(--color-primary); background-color: #f0f9ff; }
    .form-container { background: var(--color-white); border-radius: 12px; padding: 60px 80px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }

    /* 폼 스타일 */
    .role-section { margin-bottom: 40px; padding-bottom: 30px; border-bottom: 2px solid var(--color-border); }
    .role-title { font-size: 18px; font-weight: 700; margin-bottom: 20px; }
    .role-group, .radio-group { display: flex; gap: 30px; }
    .role-label, .radio-label { display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 16px; }
    .form-row { display: flex; align-items: center; margin-bottom: 30px; }
    .form-label { width: 140px; font-size: 16px; font-weight: 700; flex-shrink: 0; }
    .form-input-group { display: flex; align-items: stretch; gap: 15px; flex: 1; }
    .form-input { flex: 1; height: 50px; background-color: var(--color-input-bg); border: none; border-radius: 8px; padding: 0 20px; font-size: 16px; }
    .email-at { font-size: 18px; font-weight: 700; align-self: center; }

    /* 버튼류 */
    .btn-black { height: 50px; padding: 0 25px; border-radius: 10px; background-color: #000; color: #fff; border: none; cursor: pointer; font-weight: 700; font-size: 15px; }
    .check-message { color: var(--color-primary); font-size: 14px; margin-top: -20px; margin-bottom: 20px; margin-left: 140px; }
    
    .bottom-buttons { display: flex; justify-content: center; gap: 20px; margin-top: 40px; }
    .btn-bottom { width: 180px; height: 55px; border-radius: 27.5px; font-size: 18px; font-weight: 700; cursor: pointer; transition: all 0.3s ease; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
    .btn-outline { background-color: var(--color-white); color: #000; border: 3px solid #000; }
    .btn-outline:hover { background-color: #000; color: var(--color-white); }

    /* 소셜 섹션 복구 */
    .social-section { margin-top: 40px; padding-top: 30px; border-top: 1px solid var(--color-border); }
    .social-title { text-align: center; font-size: 14px; color: #666; margin-bottom: 15px; }
    .social-login-group { display: flex; gap: 12px; }
    .btn-social { flex: 1; padding: 12px; border-radius: 4px; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 8px; font-weight: 600; font-size: 14px; height: 45px; }
    .btn-kakao { background-color: #FEE500; color: #3c1e1e; }
    .btn-naver { background-color: #03C75A; color: #fff; }
</style>
<script>
    $(function () {
        function ChangeForm() {
            let role = $("input[name='role']:checked").val();
            $("#vendorNo").css('display', role === "1" ? 'flex' : 'none');
            $("#nameLabel").text(role === "1" ? "등록자명" : "이름");
            if(role === "1") { $("#socialSection").hide(); } else { $("#socialSection").show(); }
            $("#vendor_no, #name, #email_prefix, #email_domain, #password, #password_confirm, #birthday_date, #phone_number").val('');
            $("input[name='gender']").prop("checked", false);
            emailChecked = false; $("#emailCheckMsg").text('');
        }
        $("input[name='role']").on("change", ChangeForm);
        ChangeForm(); 
    });

    let emailChecked = false;
    function goSave() {
        let emailPrefix = $("#email_prefix").val();
        let emailDomain = $("#email_domain").val();
        let email = emailPrefix + "@" + emailDomain;

        if(!$("input[name='role']:checked").val()) { alert("회원유형을 선택해주세요."); return; }
        if (emailPrefix === '' || emailDomain === '') { alert("이메일을 입력해주세요"); return; }
        if (!emailChecked) { alert("이메일 중복확인을 해주세요"); return; }
        $("#email").val(email);
        if ($("#password").val() == '' || $("#password").val() !== $("#password_confirm").val()) { alert("비밀번호를 확인해주세요."); return; }
        let birthdayDate = $("#birthday_date").val();
        if (birthdayDate === '') { alert("생년월일을 입력해주세요."); return; }
        $("#birthday").val(birthdayDate.replaceAll("-", ""));
        if($("#phone_number").val() == '') { alert("전화번호를 입력해주세요."); return; }
        $("#frm").submit();
    }

    function emailCheck() {
        let email = $("#email_prefix").val() + "@" + $("#email_domain").val();
        if ($("#email_prefix").val() === '' || $("#email_domain").val() === '') {
            $("#emailCheckMsg").text("이메일을 입력해주세요");
            return;
        }
        $.ajax({
            url: "/gotoday/member/emailCheck",
            data: { email: email },
            success: function(res) {
                if (res == 0) { $("#emailCheckMsg").text("사용 가능한 이메일입니다."); emailChecked = true; }
                else { $("#emailCheckMsg").text("이미 사용 중인 이메일입니다."); emailChecked = false; }
            }
        });
    }
</script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <div class="main-container">
        <div class="tab-nav">
            <div class="tab-item active">정보입력</div>
            <div class="tab-item">관심사 입력</div>
            <div class="tab-item">가입완료</div>
        </div>
        <div class="form-container">
            <form id="frm" action="/gotoday/member/register1" method="POST">
                <input type="hidden" name="email" id="email">
                <input type="hidden" id="birthday" name="birthday">

                <div class="role-section">
                    <div class="role-title">회원유형 선택</div>
                    <div class="role-group">
                        <label class="role-label"><input type="radio" name="role" value="0" checked><span>개인 회원</span></label>
                        <label class="role-label"><input type="radio" name="role" value="1"><span>기업 회원</span></label>
                    </div>
                </div>

                <div class="form-row">
                    <label class="form-label">이메일</label>
                    <div class="form-input-group">
                        <input type="text" id="email_prefix" class="form-input">
                        <span class="email-at">@</span>
                        <input type="text" id="email_domain" class="form-input">
                        <button type="button" class="btn-black" onclick="emailCheck()">중복확인</button>
                    </div>
                </div>
                <div class="check-message" id="emailCheckMsg"></div>

                <div class="form-row">
                    <label class="form-label">비밀번호</label>
                    <div class="form-input-group"><input type="password" id="password" name="password" class="form-input" placeholder="비밀번호 입력"></div>
                </div>
                <div class="form-row">
                    <label class="form-label">비밀번호 확인</label>
                    <div class="form-input-group"><input type="password" id="password_confirm" class="form-input" placeholder="비밀번호 재입력"></div>
                </div>
                <div class="form-row" id="vendorNo" style="display: none;">
                    <label class="form-label">사업자등록번호</label>
                    <div class="form-input-group"><input type="text" id="vendor_no" name="vendor_no" class="form-input"></div>
                </div>
                <div class="form-row">
                    <label class="form-label" id="nameLabel">이름</label>
                    <div class="form-input-group"><input type="text" id="name" name="name" class="form-input"></div>
                </div>
                <div class="form-row">
                    <label class="form-label">생년월일</label>
                    <div class="form-input-group"><input type="date" id="birthday_date" class="form-input"></div>
                </div>
                <div class="form-row">
                    <label class="form-label">성별</label>
                    <div class="radio-group">
                        <label class="radio-label"><input type="radio" name="gender" value="M"><span>남자</span></label>
                        <label class="radio-label"><input type="radio" name="gender" value="F"><span>여자</span></label>
                    </div>
                </div>
                <div class="form-row">
                    <label class="form-label">휴대전화</label>
                    <div class="form-input-group"><input type="tel" id="phone_number" name="phone_number" class="form-input" placeholder="숫자만 입력"></div>
                </div>

                <div class="bottom-buttons">
                    <button type="button" class="btn-bottom btn-outline" onclick="history.back()">이전단계</button>
                    <button type="button" class="btn-bottom btn-outline" onclick="goSave()">다음단계</button>
                </div>

                <div class="social-section" id="socialSection">
                    <div class="social-title">또는 소셜 계정으로 회원가입</div>
                    <div class="social-login-group">
                        <a href="#" class="btn-social btn-kakao">카카오 회원가입</a>
                        <a href="#" class="btn-social btn-naver">네이버 회원가입</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</body>
</html>