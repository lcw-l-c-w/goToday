<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>GoToday | ${content.title}</title>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>

<style>
/* 1. 기본 스타일 정의 */
:root {
	--main-color: #4dc3ff;
	--border-color: #eee;
	--text-gray: #666;
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body {
	font-family: 'Pretendard', sans-serif;
	color: #333;
	background-color: #fff;
	overflow-x: hidden;
	line-height: 1.5;
}

a { text-decoration: none; color: inherit; }

/* 2. 네비게이션 바 스타일 */
.header {
	width: 100%;
	border-bottom: 1px solid var(--border-color);
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

.logo img { height: 32px; cursor: pointer; display: block; }

.nav-menu {
	display: flex;
	gap: 35px;
	list-style: none;
	align-items: center;
	height: 100%;
}

.nav-menu li { position: relative; height: 100%; display: flex; align-items: center; }
.nav-menu a { font-weight: 600; font-size: 15px; transition: color 0.3s ease; }
.nav-menu li:hover a { color: var(--main-color); }

.nav-icons { display: flex; gap: 20px; align-items: center; }

.search-bar {
	border-bottom: 1px solid #333;
	display: flex;
	align-items: center;
	padding: 2px 5px;
}
.search-bar input { border: none; outline: none; width: 150px; font-size: 14px; }

.user-icon { font-size: 22px; cursor: pointer; transition: color 0.2s; }
.user-icon:hover { color: var(--main-color); }

/* 3. 레이아웃 및 본문 */
.container { max-width: 1100px; margin: 40px auto; padding: 0 20px; }

.content-title-area {
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
	border-bottom: 2px solid #333;
	padding-bottom: 15px;
	margin-bottom: 30px;
}

.content-title-area h1 { margin: 0; font-size: 28px; letter-spacing: -1px; }

.sns-group { display: flex; gap: 10px; }
.sns-group img { width: 22px; cursor: pointer; opacity: 0.7; transition: 0.2s; }

.main-box { display: flex; gap: 50px; align-items: flex-start; margin-bottom: 60px; }

/* 4. 포스터 사이드 */
.poster-side { flex: 0 0 350px; display: flex; flex-direction: column; align-items: center; }

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
	padding: 8px 25px;
	background: #fff;
	border: 1.5px solid #eee;
	border-radius: 50px;
	cursor: pointer;
	transition: all 0.3s;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.poster-like-btn:hover { transform: translateY(-2px); border-color: var(--main-color); }
.poster-like-btn.active-liked { background: #f0faff; border-color: var(--main-color); }

/* 5. 정보 및 예매 섹션 */
.info-side { flex: 1; }

.info-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
.info-table th { text-align: left; width: 100px; padding: 12px 0; color: #333; border-bottom: 1px solid #f5f5f5; }
.info-table td { padding: 12px 0; font-size: 15px; color: #555; border-bottom: 1px solid #f5f5f5; }

.reserve-section { display: flex; gap: 20px; border-top: 1px solid var(--border-color); padding-top: 30px; }
#calendar { flex: 1.2; border: 1px solid var(--border-color); border-radius: 10px; padding: 10px; font-size: 12px; }
.time-selector { flex: 1; border: 1px solid var(--border-color); border-radius: 10px; padding: 15px; background: #fafafa; }

.time-option { display: flex; align-items: center; padding: 10px; background: #fff; border: 1px solid var(--border-color); border-radius: 6px; margin-bottom: 8px; cursor: pointer; }

.action-btns { display: flex; gap: 10px; margin-top: 25px; }

.btn-reserve {
	flex: 2;
	background-color: var(--main-color);
	color: #fff;
	border: none;
	padding: 16px;
	border-radius: 6px;
	font-weight: bold;
	cursor: pointer;
	font-size: 16px;
	transition: background 0.2s;
}
.btn-reserve:hover { background-color: #37b0f0; }
.btn-save-cal { flex: 1; background: #f8f9fa; border: 1px solid #ddd; padding: 16px; border-radius: 6px; cursor: pointer; }

/* 6. 탭 메뉴 */
.tab-wrapper { margin-top: 50px; }
.tab-menu { display: flex; list-style: none; border-bottom: 2px solid var(--border-color); margin-bottom: 30px; }
.tab-item { flex: 1; padding: 18px 0; cursor: pointer; font-weight: bold; color: #999; text-align: center; }
.tab-item.active { color: #333; border-bottom: 3px solid var(--main-color); }
.tab-panel { display: none; padding: 20px 0; }
.tab-panel.active { display: block; }
.detail-img { width: 100%; border-radius: 8px; margin-top: 20px; }
</style>

<script>
$(function() {
    let selectedDate = null;
    let selectedTime = null;
    let scheduleId = null;

    // 탭 전환
    $(".tab-item").click(function() {
        $(".tab-item").removeClass("active");
        $(this).addClass("active");
        $(".tab-panel").hide().eq($(this).index()).show();
    });

    // 달력 로드
    const calendarEl = document.getElementById('calendar');
    if (calendarEl) {
        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'ko',
            height: 'auto',
            headerToolbar: { left: 'prev', center: 'title', right: 'next' },
            dateClick: function(info) {
                $(".fc-daygrid-day").css("background", "");
                $(info.dayEl).css("background", "rgba(77, 195, 255, 0.1)");
                selectedDate = info.dateStr;
                fetchTimes(selectedDate);
            }
        });
        calendar.render();
    }

    // 시간 조회
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
                selectedTime = null;
                scheduleId = null;
            }
        });
    }

    $(document).on("change", "input[name='sch_radio']", function() {
        selectedTime = $(this).data("time");
        scheduleId = $(this).data("id");
    });

    // 예매하기
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

    // 좋아요 토글 - 깨짐 방지를 위해 코드로 변경
    $("#likeBtn").click(function() {
        const heart = $(this).find(".heart-icon");
        const count = $(this).find(".like-count-num");
        const content_id = heart.data("content-id");

        $.ajax({
            url: "${pageContext.request.contextPath}/heart",
            type: "POST",
            contentType: 'application/json',
            data: JSON.stringify({ content_id: content_id }),
            success: function(res) {
                if (!res) {
                    alert("로그인이 필요한 서비스입니다.");
                    location.href = "${pageContext.request.contextPath}/member/login";
                    return;
                }
                // JavaScript에서도 코드로 변경
                if (res.liked == 1) {
                    heart.html("&#x1F499;"); // 파란 하트
                    $("#likeBtn").addClass("active-liked");
                } else {
                    heart.html("&#x1F90D;"); // 흰 하트
                    $("#likeBtn").removeClass("active-liked");
                }
                count.text(res.count_num);
            },
            error: function() { alert("오류가 발생했습니다."); }
        });
    });

    // 마이페이지 로그인 체크
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
				<a href="${pageContext.request.contextPath}/main"> 
                    <img src="<c:url value='/resources/images/logo.png'/>" alt="Logo">
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
		<div class="breadcrumb">콘텐츠 > ${content.contentKindName} > <span>#${content.category}</span></div>

		<div class="content-title-area">
			<div>
				<h1>${content.title}</h1>
				<p style="margin-top: 8px; color: var(--text-gray);">${content.start_at} ~ ${content.end_at} | ${content.location} 📍</p>
			</div>
			<div class="sns-group">
				<img src="https://cdn-icons-png.flaticon.com/512/733/733579.png" alt="X" style="width:22px; margin-left:10px;"> 
                <img src="https://cdn-icons-png.flaticon.com/512/2111/2111463.png" alt="IG" style="width:22px; margin-left:10px;"> 
                <img src="https://cdn-icons-png.flaticon.com/512/1358/1358023.png" alt="Link" style="width:22px; margin-left:10px;">
			</div>
		</div>

		<div class="main-box">
			<section class="poster-side">
				<img class="poster-img" src="${pageContext.request.contextPath}${content.main_image_path}" alt="포스터">
				<button type="button" class="poster-like-btn ${content.liked == 1 ? 'active-liked' : ''}" id="likeBtn">
					<span class="heart-icon" data-content-id="${content.content_id}">
                        <c:choose>
							<c:when test="${content.liked == 1}">&#x1F499;</c:when>
							<c:otherwise>&#x1F90D;</c:otherwise>
						</c:choose>
					</span>
					<span class="like-count-num">${content.like_count}</span>
				</button>
			</section>

			<section class="info-side">
				<table class="info-table">
					<tr><th>소개</th><td>${content.description}</td></tr>
					<tr><th>관람료</th><td>성인 ${content.adult_price}원 / 청소년 ${content.teen_price}원</td></tr>
					<tr><th>운영시간</th><td>${content.content_time}</td></tr>
					<tr><th>수령방법</th><td>${content.reservationTypeLabel}</td></tr>
				</table>

				<div class="reserve-section">
					<div id="calendar"></div>
					<div class="time-selector">
						<div class="reservation_timezone">
							<span class="time-title">시간대 선택</span>
							<p style="font-size: 12px; color: #999; margin-top: 20px;">먼저 달력에서 날짜를 선택해주세요.</p>
						</div>
					</div>
				</div>

				<div class="action-btns">
					<input type="hidden" id="content_id" value="${content.content_id}">
					<button class="btn-reserve">예매하기</button>
					<button class="btn-save-cal">캘린더 저장</button>
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
					<img src="${pageContext.request.contextPath}${content.main_image_path}" class="detail-img">
				</section>
                <section class="tab-panel">리뷰 목록이 여기에 표시됩니다.</section>
                <section class="tab-panel">문의사항 목록이 여기에 표시됩니다.</section>
			</div>
		</div>
	</div>
</body>
</html>