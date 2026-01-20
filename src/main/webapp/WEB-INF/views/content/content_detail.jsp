<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>GoToday | ${content.title}</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>

<style>
/* 1. 기본 및 네비게이션 스타일 (메인과 100% 일치) */
:root { -
	-main-color: #4dc3ff; -
	-border-color: #eee; -
	-text-gray: #666;
}

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Pretendard', sans-serif;
	color: #333;
	background-color: #fff;
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
	height: 32px;
	cursor: pointer;
	display: block;
}

.nav-menu {
	display: flex;
	gap: 35px;
	list-style: none;
	align-items: center;
	height: 100%;
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
	transition: color 0.3s ease;
	height: 100%;
	display: flex;
	align-items: center;
	padding: 0 5px;
}

.nav-menu li:hover a {
	color: var(- -main-color);
}

.nav-menu li::after {
	content: "";
	position: absolute;
	bottom: -1px;
	left: 0;
	width: 0;
	height: 3px;
	background-color: var(- -main-color);
	transition: width 0.3s ease;
}

.nav-menu li:hover::after {
	width: 100%;
}

/* 우측 아이콘 섹션 (검색창 복구) */
.nav-icons {
	display: flex;
	gap: 20px;
	align-items: center;
}

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
}

.user-icon {
	font-size: 22px;
	cursor: pointer;
	transition: color 0.2s;
}

.user-icon:hover {
	color: var(- -main-color);
}

/* 2. 상단 레이아웃 */
.container {
	max-width: 1100px;
	margin: 40px auto;
	padding: 0 20px;
}

.breadcrumb {
	font-size: 13px;
	color: var(- -text-gray);
	margin-bottom: 10px;
}

.content-title-area {
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
	border-bottom: 2px solid #333;
	padding-bottom: 15px;
	margin-bottom: 30px;
}

.content-title-area h1 {
	margin: 0;
	font-size: 28px;
	letter-spacing: -1px;
}

.sns-group {
	display: flex;
	gap: 10px;
}

.sns-group img {
	width: 22px;
	cursor: pointer;
	opacity: 0.7;
}

.main-box {
	display: flex;
	gap: 50px;
	align-items: flex-start;
	margin-bottom: 60px;
}

.poster-side {
	flex: 0 0 350px;
}

.poster-img {
	width: 100%;
	height: 480px;
	object-fit: cover;
	border-radius: 8px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.poster-like-btn {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-top: 15px;
	font-weight: bold;
	color: #444;
	background: none;
	border: none;
	cursor: pointer;
	font-size: 18px;
}

.poster-like-btn .heart-icon {
	color: var(- -main-color);
	font-size: 20px;
}

.info-side {
	flex: 1;
}

.info-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 30px;
}

.info-table th {
	text-align: left;
	width: 100px;
	padding: 12px 0;
	color: #333;
	font-size: 15px;
	vertical-align: top;
}

.info-table td {
	padding: 12px 0;
	font-size: 15px;
	color: #555;
	line-height: 1.6;
}

.reserve-section {
	display: flex;
	gap: 20px;
	border-top: 1px solid #eee;
	padding-top: 30px;
}

#calendar {
	flex: 1.2;
	border: 1px solid #eee;
	border-radius: 10px;
	padding: 10px;
	font-size: 12px;
}

.time-selector {
	flex: 1;
	border: 1px solid #eee;
	border-radius: 10px;
	padding: 15px;
	background: #fafafa;
}

.time-title {
	font-weight: bold;
	font-size: 14px;
	margin-bottom: 15px;
	display: block;
}

.time-option {
	display: flex;
	align-items: center;
	padding: 10px;
	background: #fff;
	border: 1px solid #eee;
	border-radius: 6px;
	margin-bottom: 8px;
	cursor: pointer;
}

.action-btns {
	display: flex;
	gap: 10px;
	margin-top: 25px;
	align-items: stretch;
}

.btn-reserve {
	flex: 2;
	background: var(- -main-color);
	color: #fff;
	border: none;
	padding: 16px;
	border-radius: 6px;
	font-weight: bold;
	cursor: pointer;
}

.btn-save-cal {
	flex: 1;
	background: #f8f9fa;
	border: 1px solid #ddd;
	color: #444;
	padding: 16px;
	border-radius: 6px;
	font-weight: 600;
	cursor: pointer;
}

/* 3단계 탭 메뉴 비율 조정 */
.tab-wrapper {
	margin-top: 50px;
}

.tab-menu {
	display: flex;
	list-style: none;
	border-bottom: 2px solid #eee;
	margin-bottom: 30px;
}

.tab-item {
	flex: 1;
	padding: 18px 0;
	cursor: pointer;
	font-weight: bold;
	color: #999;
	text-align: center;
	transition: 0.3s;
}

.tab-item.active {
	color: #333;
	border-bottom: 3px solid var(- -main-color);
}

.tab-panel {
	display: none;
	padding: 20px 0;
}

.tab-panel.active {
	display: block;
}

.detail-content {
	line-height: 1.8;
	color: #444;
	font-size: 16px;
	margin-bottom: 20px;
}

.detail-img {
	width: 100%;
	border-radius: 8px;
}

/* 리뷰 및 문의사항 스타일 */
.review-summary {
	display: flex;
	gap: 40px;
	background: #fcfcfc;
	padding: 30px;
	border-radius: 12px;
	margin-bottom: 40px;
}

.rating-bars {
	list-style: none;
	flex: 1;
}

.rating-bars li {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 5px;
	font-size: 13px;
}

.bar {
	flex: 1;
	height: 8px;
	background: #eee;
	border-radius: 4px;
	overflow: hidden;
}

.fill {
	height: 100%;
	background: var(- -main-color);
}

.review-list, .qna-list {
	list-style: none;
}

.review-item, .qna-item {
	padding: 20px 0;
	border-bottom: 1px solid #eee;
}
</style>

<script>
  $(function() {
	    // 선택된 데이터를 저장할 변수 (추가됨)
	    let selectedDate = null;
	    let selectedTime = null;
	    let scheduleId = null;

	    // 1. 3단계 탭 전환
	    $(".tab-item").click(function() {
	        $(".tab-item").removeClass("active");
	        $(this).addClass("active");
	        $(".tab-panel").removeClass("active").eq($(this).index()).addClass("active");
	    });

	    // 2. 달력 및 AJAX
	    const calendarEl = document.getElementById('calendar');
	    if (calendarEl) {
	        const calendar = new FullCalendar.Calendar(calendarEl, {
	            initialView: 'dayGridMonth', 
	            locale: 'ko', 
	            height: 'auto',
	            headerToolbar: { left: 'prev', center: 'title', right: 'next' }, // 헤더 복구
	            dateClick: function(info) {
	                $(".fc-daygrid-day").css("background", ""); 
	                $(info.dayEl).css("background", "rgba(77, 195, 255, 0.1)");
	                selectedDate = info.dateStr; // 선택 날짜 저장
	                fetchTimes(selectedDate);
	            }
	        });
	        calendar.render();
	    }

	    function fetchTimes(date) {
	        $.ajax({
	            url: "${pageContext.request.contextPath}/schedule/time",
	            data: { content_id: $("#content_id").val(), scheduled_at: date },
	            success: function(res) {
	                let html = `<span class="time-title">\${date} 시간 선택</span>`;
	                if(!res || res.length === 0) {
	                    html += "<p style='font-size:12px; color:#999; margin-top:20px;'>예정된 회차가 없습니다.</p>";
	                } else {
	                    res.forEach(sch => {
	                        html += `
	                            <label class="time-option">
	                                <input type="radio" name="sch_radio" data-id="\${sch.schedule_id}" data-time="\${sch.time_zone}">
	                                <span style="flex:1; margin-left:10px;">\${sch.time_zone}</span>
	                                <span style="font-size:12px;">\${sch.current_ticket}석</span>
	                            </label>`;
	                    });
	                }
	                $(".reservation_timezone").html(html);
	                // 날짜가 바뀌면 선택 정보 초기화
	                selectedTime = null;
	                scheduleId = null;
	            }
	        });
	    }

	    // 3. 시간 선택 시 변수 저장 (누락되었던 부분)
	    $(document).on("change", "input[name='sch_radio']", function() {
	        selectedTime = $(this).data("time");
	        scheduleId = $(this).data("id");
	    });

	    // 4. 예매하기 버튼 클릭 로직 (누락되었던 부분)
	    $(".btn-reserve").click(function() {
	        if(!selectedDate || !selectedTime || !scheduleId) {
	            alert("날짜와 시간을 선택해주세요.");
	            return;
	        }
	        
	        $.post("${pageContext.request.contextPath}/reserve/schedule.do", {
	            content_id: $("#content_id").val(),
	            reserved_for_at: selectedDate,
	            time_zone: selectedTime,
	            schedule_id: scheduleId
	        }).done(function(){
	            location.href = "${pageContext.request.contextPath}/reserve/quantity.do";
	        }).fail(function(){
	            alert("예약 요청 중 오류가 발생했습니다.");
	        });
	    });
	    
	    //추가-의선 캘박 
    $(".btn-save-cal").click(function() {
        // 1. 변수에 값이 있는지 확인
        if(!selectedDate || !selectedTime) {
            alert("관람하실 날짜와 시간을 먼저 선택해주세요.");
            return;
        }

        const contentId = $("#content_id").val();
        
        // 2. 캘린더 패키지로 데이터 전송 (AJAX)
        $.ajax({
            url: "${pageContext.request.contextPath}/calendar/add", // 새로 만들 컨트롤러 주소
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                "contentId": contentId,
                "date": selectedDate,  // 변수에 저장된 날짜 (예: 2026-01-20)
                "time": selectedTime   // 변수에 저장된 시간 (예: 14:00)
            }),
            success: function(res) {
                if (res.success) {
                    alert("📅 " + res.msg); // "나의 캘린더에 저장되었습니다!"
                } else {
                    alert(res.msg); // "로그인이 필요합니다." 등
                    if (res.msg.includes("로그인")) {
                        location.href = "${pageContext.request.contextPath}/member/login";
                    }
                }
            },
            error: function() {
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
    });
	    

	    // 5. 좋아요 토글
	    $("#likeBtn").click(function() {
	        const heart = $(this).find(".heart-icon");
	        const count = $(this).find(".like-count-num");
	        let num = parseInt(count.text());
	        if(heart.text() === "🤍") { heart.text("💙"); count.text(num + 1); } 
	        else { heart.text("🤍"); count.text(num - 1); }
	    });

	    // 6. 마이페이지 로그인 체크
	    $("#myPageBtn").click(function() {
	        const isLoggedIn = ${not empty loginSess};
	        if (!isLoggedIn) {
	            alert("로그인이 필요한 서비스입니다.");
	            location.href = "${pageContext.request.contextPath}/member/login";
	        } else {
	            location.href = "${pageContext.request.contextPath}/member/mypage";
	        }
	    });
	});
  </script>
</head>
<body>

	<header class="header">
		<div class="nav-container">
			<div class="logo">
				<a href="${pageContext.request.contextPath}/main"> <img
					src="<c:url value='/resources/images/logo.png'/>" alt="Logo">
				</a>
			</div>

			<ul class="nav-menu">
				<li><a href="#">Q&A</a></li>
				<li><a href="${pageContext.request.contextPath}/popup">PopUp</a></li>
				<li><a href="${pageContext.request.contextPath}/exhibition">Exhibition</a></li>
			</ul>

			<div class="nav-icons">
				<div class="search-bar">
					<input type="text" placeholder="검색"> <span>🔍</span>
				</div>
				<span class="user-icon" id="myPageBtn">👤</span>
			</div>
		</div>
	</header>

	<div class="container">
		<div class="breadcrumb">
			콘텐츠 > ${content.contentKindName} > <span>#${content.category}</span>
		</div>

		<div class="content-title-area">
			<div>
				<h1>${content.title}</h1>
				<p style="margin-top: 8px; color: var(- -text-gray);">${content.start_at}
					~ ${content.end_at} &nbsp;|&nbsp; ${content.location} 📍</p>
			</div>
			<div class="sns-group">
				<img src="https://cdn-icons-png.flaticon.com/512/733/733579.png"
					alt="X"> <img
					src="https://cdn-icons-png.flaticon.com/512/2111/2111463.png"
					alt="IG"> <img
					src="https://cdn-icons-png.flaticon.com/512/1358/1358023.png"
					alt="Link">
			</div>
		</div>

		<div class="main-box">
			<section class="poster-side">
				<img class="poster-img"
					src="${pageContext.request.contextPath}${content.main_image_path}">
				<button type="button" class="poster-like-btn" id="likeBtn">
					<span class="heart-icon">🤍</span> <span class="like-count-num">${content.like_count}</span>
				</button>
			</section>

			<section class="info-side">
				<table class="info-table">
					<tr>
						<th>소개</th>
						<td>${content.description}</td>
					</tr>
					<tr>
						<th>관람료</th>
						<td>성인 ${content.adult_price}원 / 청소년 ${content.teen_price}원</td>
					</tr>
					<tr>
						<th>운영시간</th>
						<td>${content.content_time}</td>
					</tr>
					<tr>
						<th>수령방법</th>
						<td>${content.reservationTypeLabel}</td>
					</tr>
				</table>

				<div class="reserve-section">
					<div id="calendar"></div>
					<div class="time-selector">
						<div class="reservation_timezone">
							<span class="time-title">시간대 선택</span>
							<p style="font-size: 12px; color: #999; margin-top: 20px;">먼저
								달력에서 날짜를 선택해주세요.</p>
						</div>
					</div>
				</div>

				<div class="action-btns">
					<input type="hidden" id="content_id" value="${content.content_id}">
					<button class="btn-reserve">예매하기</button>
					<button class="btn-save-cal">캘린더 저장하기</button>
				</div>
			</section>
		</div>

		<div class="tab-wrapper">
			<ul class="tab-menu">
				<li class="tab-item active">상세정보</li>
				<li class="tab-item">리뷰</li>
				<li class="tab-item">문의사항</li>
			</ul>

			<div class="tab-content">
				<section class="tab-panel active">
					<div class="detail-content">${content.detail_description}</div>
					<c:if test="${not empty content.main_image_path}">
						<img
							src="${pageContext.request.contextPath}${content.main_image_path}"
							class="detail-img">
					</c:if>
				</section>

				<section class="tab-panel">
					<div class="review-summary">
						<div
							style="flex: 0.4; text-align: center; border-right: 1px solid #eee;">
							<h3 style="font-size: 45px; color: var(- -main-color);">4.7</h3>
							<p style="color: #ffd700; font-size: 18px;">★★★★★</p>
							<p style="font-size: 13px; color: #999; margin-top: 5px;">총
								34개 리뷰</p>
						</div>
						<ul class="rating-bars" style="margin-left: 40px;">
							<li>5점
								<div class="bar">
									<div class="fill" style="width: 80%;"></div>
								</div> 24
							</li>
							<li>4점
								<div class="bar">
									<div class="fill" style="width: 15%;"></div>
								</div> 7
							</li>
							<li>3점
								<div class="bar">
									<div class="fill" style="width: 5%;"></div>
								</div> 3
							</li>
						</ul>
					</div>
					<ul class="review-list">
						<li class="review-item"><strong>김*님</strong> <span
							style="float: right; color: #ccc;">2026.01.13</span>
							<p style="margin-top: 10px;">전시가 너무 예쁘네요!</p></li>
					</ul>
				</section>

				<section class="tab-panel">
					<div
						style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
						<p style="color: var(- -text-gray);">컨텐츠에 대해 궁금한 점을 문의해 주세요.</p>
						<button
							style="padding: 8px 16px; background: #333; color: #fff; border: none; border-radius: 4px; cursor: pointer;">문의하기</button>
					</div>
					<ul class="qna-list">
						<li class="qna-item"><span
							style="background: #eee; padding: 2px 6px; font-size: 12px; border-radius: 3px;">답변대기</span>
							<span style="margin-left: 10px;">재입장이 가능한가요?</span> <span
							style="float: right; color: #ccc;">이*님 | 2026.01.19</span></li>
					</ul>
				</section>
			</div>
		</div>
	</div>
</body>
</html>