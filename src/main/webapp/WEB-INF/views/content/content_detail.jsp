<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>GoToday | ${content.title}</title>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>

<style>
/* 1. 기본 스타일 정의 */
:root { 
	--main-color: #4dc3ff; 
	--border-color: #eee; 
	--text-gray: #666;
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
	line-height: 1.5;
}

a {
	text-decoration: none;
	color: inherit;
}

img {
  max-width: 100%;
  height: auto;
  object-fit: contain;
}
/* 3. 레이아웃 및 본문 */
.container {
	max-width: 1100px;
	margin: 40px auto;
	padding: 0 20px;
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
	transition: 0.2s;
}

.main-box {
	display: flex;
	gap: 50px;
	align-items: flex-start;
	margin-bottom: 60px;
}

/* 4. 포스터 사이드 */
.poster-side {
	flex: 0 0 350px;
	display: flex;
	flex-direction: column;
	align-items: center;
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
	padding: 8px 25px;
	background: #fff;
	border: 1.5px solid #eee;
	border-radius: 50px;
	cursor: pointer;
	transition: all 0.3s;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.poster-like-btn:hover {
	transform: translateY(-2px);
	border-color: var(- -main-color);
}

.poster-like-btn.active-liked {
	background: #f0faff;
	border-color: var(- -main-color);
}

/* 5. 정보 및 예매 섹션 */
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
	border-bottom: 1px solid #f5f5f5;
}

.info-table td {
	padding: 12px 0;
	font-size: 15px;
	color: #555;
	border-bottom: 1px solid #f5f5f5;
}

.reserve-section {
	display: flex;
	gap: 20px;
	border-top: 1px solid var(- -border-color);
	padding-top: 30px;
}

#calendar {
	flex: 1.2;
	border: 1px solid var(- -border-color);
	border-radius: 10px;
	padding: 10px;
	font-size: 12px;
}

.time-selector {
	flex: 1;
	border: 1px solid var(- -border-color);
	border-radius: 10px;
	padding: 15px;
	background: #fafafa;
}

.time-option {
	display: flex;
	align-items: center;
	padding: 10px;
	background: #fff;
	border: 1px solid var(- -border-color);
	border-radius: 6px;
	margin-bottom: 8px;
	cursor: pointer;
}

.action-btns {
	display: flex;
	gap: 10px;
	margin-top: 25px;
}

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

.btn-reserve:hover {
	background-color: #37b0f0;
}

.btn-save-cal {
	flex: 1;
	background: #f8f9fa;
	border: 1px solid #ddd;
	padding: 16px;
	border-radius: 6px;
	cursor: pointer;
}
.btn-reserve.is-disabled,
.btn-reserve:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 6. 탭 메뉴 */
.tab-wrapper {
	margin-top: 50px;
}

.tab-menu {
	display: flex;
	list-style: none;
	border-bottom: 2px solid var(- -border-color);
	margin-bottom: 30px;
}

.tab-item {
	flex: 1;
	padding: 18px 0;
	cursor: pointer;
	font-weight: bold;
	color: #999;
	text-align: center;
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

.detail-img {
width: 100%;           /* 1. 상자 너비에 딱 맞게! */
    max-width: 600px;      /* 2. 너무 커지는 건 방지 (원하는 숫자로 조절해!) */
    height: auto;          /* 3. 높이는 비율에 맞게 알아서! */
    display: block;        /* 4. 덩어리로 만들어서 */
    margin: 20px auto;     /* 5. 가운데로 모으기! */
    border-radius: 8px;
    object-fit: contain;   /* 6. 이미지가 잘리지 않고 상자 안에 다 보이게! */
}
#btn-reservation-detail {
  margin-top: 12px;
  padding: 14px 16px;
  background: #eaf7ff;        /* 하늘색 배경 */
  color: #2b7fc2;             /* 진한 하늘색 글자 */
  border: 1px solid #bfe6ff;  /* 테두리 */
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  text-align: center;
}
</style>

<script>
$(function() {
    let selectedDate = null;
    let selectedTime = null;
    let scheduleId = null;

    if("${content.content_id}"=='' ) {
    	$(".container").hide();
    	setTimeout(function() {
            alert("해당 콘텐츠를 찾을 수 없습니다.");
        }, 10);
        return;
    }
      const isReservable= "${content.contentReservation}" === "1" ? 1:0;
      if(isReservable==0) {$(".btn-reserve").prop("disabled", true)
   							 			  .addClass("is-disabled")
  							    $("#btn-reservation-detail").html("이 컨텐츠는 현장 대기만 가능하므로, 예매가 불가합니다.");
      }
      else{
    	  $("#btn-reservation-detail").hide();
}
    // 탭 전환
    $(".tab-item").click(function() {
        $(".tab-item").removeClass("active");
        $(this).addClass("active");
        $(".tab-panel").hide().eq($(this).index()).show();
    });
	
    // 달력 로드
    const calendarEl = document.getElementById('calendar');
    if (calendarEl) {
    	
    	// 1. JSP 변수에서 시작일과 종료일 가져오기 (문자열 자르기 포함)
        const startDate = "${content.start_at}".substring(0, 10);
        const endDate = "${content.end_at}".substring(0, 10);
        const today = new Date().toISOString().slice(0,10);
     // 2. 종료일 포함(inclusive)을 위해 하루 더하기
        // JS의 Date 객체는 현재 지역 시간을 기준으로 하므로 시간 오차를 방지하기 위해 
        // 단순 날짜 더하기 로직을 사용합니다.
        let endDateObj = new Date(endDate);
        endDateObj.setDate(endDateObj.getDate() + 1);
        
        
     // yyyy-mm-dd 형식으로 변환
        let finalEndDate = endDateObj.toISOString().substring(0, 10);
     
        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'local',
            height: 'auto',
            headerToolbar: { left: 'prev', center: 'title', right: 'next' },
      
         // 3. 전시 기간 배경색 입히기 (핑크색)
            events: [
                {
                    start: startDate,
                    end: finalEndDate,
                    display: 'background',
                    backgroundColor: '#ffe3ee', // 연한 핑크색
                    allDay: true
                }
            ],
            dateClick: function(info) {
            	// 모든 날짜 클릭 가능
                $(".fc-daygrid-day").css("background", ""); // 이전 선택 초기화
                $(info.dayEl).css("background", "rgba(77, 195, 255, 0.3)"); // 클릭한 날짜 강조
               const todayDate= new Date();
               todayDate.setHours(0, 0, 0, 0);  
                if(info.date<todayDate){
            		alert("지난 날짜는 불가합니다. 다른 날짜를 선택해주세요.");
            		return;
            	}
                
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
                    	const isSoldOut = sch.current_ticket === 0;
                        const disabledAttr = isSoldOut ? 'disabled' : '';
                        const soldOutClass = isSoldOut ? 'sold-out' : '';
                        const ticketText = isSoldOut ? '매진' : `\${sch.current_ticket}석`;
                        
                    	
                        html += `
                            <label class="time-option \${soldOutClass}">
                                <input type="radio" name="sch_radio" data-id="\${sch.schedule_id}" data-time="\${sch.time_zone}">
                                <span style="flex:1; margin-left:10px;">\${sch.time_zone}</span>
                                <span style="font-size:12px; \${isSoldOut ? 'color:#e74c3c; font-weight:bold;' : ''}">\${ticketText}</span>
                            </label>`;
                    });
                }
                $(".reservation_timezone").html(html);
                selectedTime = null;
                scheduleId = null;
                
                $(".time-option.sold-out").on("click", function(e) {
                    e.preventDefault();
                    alert("해당 시간대는 매진되었습니다.");
                    return false;
                });
            }
        });
    }

    $(document).on("change", "input[name='sch_radio']", function() {
        selectedTime = $(this).data("time");
        scheduleId = $(this).data("id");
    });
    

 
	
    //추가-의선 캘박 
    $(".btn-save-cal").click(function() {
        // 1. 변수에 값이 있는지 확인
        if(!selectedDate) {
            alert("관람하실 날짜를 먼저 선택해주세요.");
            return;
        }

        const contentId = $("#content_id").val();
        
        // 2. 캘린더 패키지로 데이터 전송 (AJAX)
        $.ajax({
            url: "${pageContext.request.contextPath}/calendar/add", 
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({
                "contentId": contentId,
                "date": selectedDate,  // 변수에 저장된 날짜 (예: 2026-01-20)
                "time": selectedTime   
            }),
            success: function(res) {
                if (res.success) {
                    alert("📅 " + res.msg); // "나의 캘린더에 저장되었습니다!"
                } else {
                    alert(res.msg); // "로그인이 필요합니다." 
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
            schedule_id: scheduleId,
            content_time: "${content.content_time}"        
        	}).done(function(res){
        	if (res === "OK") {
	       		location.href = "${pageContext.request.contextPath}/reserve/quantity.do";
            } else {
                alert(res);
            }
        }).fail(function(){
        	const msg = res.responseText;
            alert(msg || "예약 요청 중 오류가 발생했습니다.");
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
    //트위터 클릭시 해당 프로필로 이동 . 근데 만약 트위터 주소가 없으면 버튼 블락 처리해야하지 않을까? 클릭을 못하도록 . 
    	if("${content.x_url}"=="")$("#x").hide();
    	if("${content.instagram_url}"=="") $("#ig").hide();
    	$("#x").click(function(){
    		window.location.href= "${content.x_url}";
    	})
    	$("#ig").click(function(){
    		window.location.href= "${content.instagram_url}";
    	})
    	

  // url 공유 하는 마법
$("#link").click(async function() { // async 사용 해야하는 이유
    const shareData = {
        title: "GoToday ! " + "${content.title}", 
        text: "멋진 전시/팝업 정보를 확인해보세요!", 
        url: window.location.href 
    };

    try {
        if (navigator.share) {
            await navigator.share(shareData);
        } else {
            
            const tempInput = document.createElement("input");
            document.body.appendChild(tempInput);
            tempInput.value = window.location.href;
            tempInput.select();
            document.execCommand("copy");
            document.body.removeChild(tempInput);
            alert("주소가 복사되었습니다.");
        }
    } catch(err) {
        console.log("공유하기 에러 발생:", err);
    }
});
    	
    	
    	
    //예약 처리 여부 -> 만약 상태가 종료이면 reservation-div를 hidden처리
   $(document).ready(function() {
    // 1. data-status 값을 가져옴
    const contentStatus = $("#confirmStatus").data("status");
    
    
    if(contentStatus === "STATUS_CLOSED" || contentStatus === "종료") {
    	$(".reservation-div").html(`
    	        <div style="background: #f8f9fa; padding: 40px; text-align: center; border-radius: 10px; border: 1px dashed #ccc;">
    	            <p style="font-size: 18px; font-weight: bold; color: #999;">🔒 관람이 종료된 콘텐츠입니다.</p>
    	            <p style="font-size: 14px; color: #bbb; margin-top: 10px;">다음에 더 좋은 전시로 찾아뵙겠습니다.</p>
    	        </div>
    	    `);
    }
});
    

});

    //  상세 페이지 들어갔을 때 최근본페이지 기능에 넣으려고 만든 부분
	document.addEventListener("DOMContentLoaded", function () {
  		if (window.GoTodayRecentViewed) {
    		GoTodayRecentViewed.add({
      		id: "${content.content_id}",
      		title: "${content.title}",
            image: "<c:url value='${content.main_image_path}'/>",
      		url: "${pageContext.request.contextPath}/detail/${content.content_id}",
      		location: "${content.location}"
    		});
  		}
	});


</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>
	<%@ include file="/WEB-INF/views/common/recentViewed.jspf" %>


	<div class="container">
		<div class="breadcrumb">
			콘텐츠 > ${content.contentKindName} > <span>#${content.category}</span>
		</div>

		<div class="content-title-area">
			<div>
				<h1>${content.title}</h1>
				<p style="margin-top: 8px; color: var(- -text-gray);">${content.start_at.substring(0,10)}
					~ ${content.end_at.substring(0,10)}  |  ${content.location} 📍</p>
			</div>
			<div class="sns-group">
				<img src="https://cdn-icons-png.flaticon.com/512/5968/5968958.png"
					alt="X" style="width: 22px; margin-left: 10px;" id="x"> <img
					src="https://cdn-icons-png.flaticon.com/512/1384/1384031.png"
					alt="IG" style="width: 22px; margin-left: 10px;" id="ig"> <img
					src="https://cdn-icons-png.flaticon.com/512/1358/1358023.png"
					alt="Link" style="width: 22px; margin-left: 10px;"id="link">
			</div>
		</div>

		<div class="main-box">
			<section class="poster-side">
				<img class="poster-img"
					src="${pageContext.request.contextPath}${content.main_image_path}"
					alt="포스터">
				<button type="button"
					class="poster-like-btn ${content.liked == 1 ? 'active-liked' : ''}"
					id="likeBtn">
					<span class="heart-icon" data-content-id="${content.content_id}">
						<c:choose>
							<c:when test="${content.liked == 1}">&#x1F499;</c:when>
							<c:otherwise>&#x1F90D;</c:otherwise>
						</c:choose>
					</span> <span class="like-count-num">${content.like_count}</span>
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
					<tr>
						<th>상태</th>
						<td id="confirmStatus" data-status="${content.contentStatusCurrent}">${content.contentStatusCurrent}</td>
					</tr>
				</table>
				<div class="reservation-div">
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
					<button class="btn-save-cal">캘린더 저장</button>
				</div>
				</div>
				<div id="btn-reservation-detail">
				
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
					<img
						src="${pageContext.request.contextPath}${content.main_image_path}"
						class="detail-img">
				</section>
				<section class="tab-panel">
					<jsp:include page="/WEB-INF/views/review/review_list_by_content.jsp" />
				</section>
				<section class="tab-panel">문의사항 목록이 여기에 표시됩니다.</section>
			</div>
		</div>
	</div>
</body>
</html>
