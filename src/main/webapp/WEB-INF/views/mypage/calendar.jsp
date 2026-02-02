<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang='ko'>

<head>
<meta charset='utf-8' />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<link
	href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css'
	rel='stylesheet' />
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>

<style>
body {
	margin: 0px;
	font-family: 'Malgun Gothic', sans-serif;
	
}

/* 캘린더 스타일 미세 조정 */
#calendar {
	max-width: 100%;
}

.fc .fc-daygrid-day-top {
    flex-direction: row; /* 기존 column(위아래)에서 row(좌우)로 변경 */
    justify-content: flex-start; /* 요소를 왼쪽으로 정렬 */
    padding: 2px; /* 여백 조정 */
}

.fc-toolbar-title {
	font-size: 20px !important;
}

.fc-scroller fc-scroller-liquid-absolute{
	
}

/* 오른쪽 리스트 스타일 */
#event-container {
	padding: 20px;
	background: #fff;
	border-left: 1px solid #ddd;
	height: 61vh;
	overflow-y: auto;
}

#event-container h2 {
	font-size: 20px;
	font-weight: 700;
	color: #111;
}

#event-container hr {
	border: none;
	border-top: 1px solid #eee;
	margin: 15px 0;
}

.event-item {
	padding: 10px 0;
	border-bottom: 1px solid #eee;
	font-size: 14px;
	display: flex;
	align-items: center;
}

.event-item .color-dot {
	margin-right: 8px;
}

.event-item .color-dot.reservation {
	color: #4dc3ff;
}

.event-item .color-dot.pick {
	color: #ff9f89;
}

.event-title {
	color: black;
	font-size: 14px;
	display: -webkit-box;
	-webkit-line-clamp: 2;
	-webkit-box-orient: vertical;
	overflow: hidden;
	text-overflow: ellipsis;
	flex: 1;
}

.delete-btn {
	background: transparent;
	border: none;
	color: #999;
	cursor: pointer;
	padding: 5px 8px;
	font-size: 14px;
	font-weight: 600;
	transition: all 0.2s;
	margin-left: 10px;
}

.delete-btn:hover {
	color: #ff4444;
}

.event-item a {
	text-decoration: none;
	color: black;
	cursor: pointer;
	display: -webkit-box;
	-webkit-line-clamp: 2;
	-webkit-box-orient: vertical;
	overflow: hidden;
	text-overflow: ellipsis;
	flex: 1;
}

.event-item a:hover {
	color: orange;
	font-weight: bold;
}

/* FullCalendar 더보기 버튼 스타일 */
.fc-daygrid-more-link {
	color: #4dc3ff !important;
	font-weight: 600;
	font-size: 12px;
}

/* FullCalendar 팝오버 스타일 */
.fc-popover {
	border-radius: 12px !important;
	border: 2px solid #eee !important;
	box-shadow: 0 4px 15px rgba(0,0,0,0.1) !important;
}

.fc-popover-header {
	background: #f9f9f9 !important;
	border-radius: 10px 10px 0 0 !important;
	padding: 10px 12px !important;
	font-weight: 600 !important;
}

.fc-popover-body {
	padding: 8px !important;
}

.fc-popover-body .fc-daygrid-event-harness {
	margin-bottom: 6px !important;
}

.fc-popover-body .fc-daygrid-event-harness:last-child {
	margin-bottom: 0 !important;
}
</style>

<script>
    // 1. [중요] JSP의 ContextPath를 자바스크립트 변수로 미리 빼둡니다. (충돌 방지)
    var contextPath = "${pageContext.request.contextPath}";
    var myEvents = [];

    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');

        // 2. 캘린더 설정
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView : 'dayGridMonth',
            locale : 'ko',
            selectable : true,
            height: 700,
            dayMaxEvents: 2, // 일정이 2개 초과시 "더보기" 표시
            moreLinkClick: 'popover', // 더보기 클릭 시 팝오버로 전체 일정 표시 

            // [중요] 날짜 클릭 시 실행
            dateClick : function(info) {
                // (1) 날짜 가져오기
                var clickedDate = info.dateStr;

                // (2) 제목 변경
                document.getElementById('selected-date-title').innerText = clickedDate;

                // (3) 해당 날짜 일정 찾기
                var filteredEvents = myEvents.filter(function(event) {
                    return event.start === clickedDate;
                });

                // (4) 리스트 초기화 후 다시 그리기
                var listDiv = document.getElementById('event-list-box');
                listDiv.innerHTML = ""; 

                if (filteredEvents.length > 0) {
                    filteredEvents.forEach(function(event) {
                        if (event.color === '#4dc3ff') {
                            // [CASE 1] 파란색(예약) -> 상세 페이지 이동
                            var html = "<div class='event-item'>";
                            html += "<span class='color-dot reservation'>●</span>";
                            html += "<a href='" + contextPath + "/mypage/reservation/" + event.reservation_id + "' title='" + event.title + "'>" + event.title + "</a>";
                            html += "</div>";

                            listDiv.innerHTML += html;

                        } else if (event.color === '#ff9f89') {
                            // [CASE 2] 주황색(찜) -> 콘텐츠 상세 페이지 이동
                            var html = "<div class='event-item'>";
                            html += "<span class='color-dot pick'>●</span>";
                            html += "<a href='javascript:void(0);' onclick='goToDetail(" + event.content_id + ")' title='" + event.title + "'>" + event.title + "</a>";
                            html += "<button class='delete-btn' onclick='deletePick(" + event.reservation_id + ")'>X</button>";
                            html += "</div>";

                            listDiv.innerHTML += html;
                        }
                    });
                } else {
                    // 일정이 없으면
                    listDiv.innerHTML = "<div style='color:#999; text-align:center;'>일정이 없습니다.</div>";
                }
            },
            
            events : [] 
        });

        calendar.render();

        // 3. 서버에서 데이터 가져오기
        $.ajax({
            url: contextPath + "/mypage/calendar-data", 
            type: "GET",
            dataType: "json",
            success: function(data) {
                myEvents = data;
                calendar.addEventSource(myEvents);
            },
            error: function(err) {
                console.log("데이터 로드 실패:", err);
            }
        });
    });

    // 4. 콘텐츠 상세 페이지 이동 (iframe 탈출)
    function goToDetail(contentId) {
        window.top.location.href = contextPath + "/detail/" + contentId;
    }

    // 5. 캘린더 삭제 함수
    function deletePick(id) { 
        if(!confirm("캘린더 목록에서 삭제하시겠습니까?")) return;

        $.ajax({
            url: contextPath + "/calendar/remove",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify({ "calendarId": id }), 
            success: function(res) {
                if(res.success) {
                    alert("삭제되었습니다.");
                    location.reload(); 
                } else {
                    alert(res.msg);
                }
            },
            error: function(err) {
                console.log(err);
                alert("삭제 중 오류가 발생했습니다.");
            }
        });
    }
</script>
</head>

<body>

	<table width="100%" height="800" border="0" cellspacing="0"
		cellpadding="0">
		<tr valign="top">
			<td width="70%" style="padding-right: 20px;">
				<div id='calendar'></div>
			</td>

			<td width="30%">
				<div id="event-container">
					<h2 id="selected-date-title" style="margin-top: 0;">날짜를 선택하세요</h2>
					<hr>
					<br>

					<div id="event-list-box">
						<div style="color: #999; text-align: center; line-height: 1.8;">
							달력의 날짜를 클릭하면<br>예약/찜 내역이<br>여기에 표시됩니다.
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>

</body>
</html>