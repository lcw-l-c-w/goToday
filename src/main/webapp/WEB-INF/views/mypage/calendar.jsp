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

.fc-toolbar-title {
	font-size: 20px !important;
}

.fc-scroller fc-scroller-liquid-absolute{
	
}

/* 오른쪽 리스트 스타일 */
#event-container {
	padding: 20px;
	border-left: 1px solid #ddd;
	height: 100%;
}

.event-item {
	padding: 10px 0;
	border-bottom: 1px solid #eee;
	font-size: 14px;
	display: flex; /* 색상 점과 텍스트 정렬용 */
	align-items: center;
}

.event-item a {
	text-decoration: none; /* 밑줄 없애기 */
	color: black; /* 글자색 검정으로 고정 (보라색 방지) */
	cursor: pointer; /* 마우스 올리면 손가락 모양 */
}

.event-item a:hover {
	color: orange; /* 마우스 올리면 오렌지색 (선택사항) */
	font-weight: bold; /* 굵게 (선택사항) */
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
                        // 색상 점 만들기
                        var colorDot = '<span style="color:' + event.color + '; margin-right:8px;">●</span>';
                        
                        // ★ [수정됨] 백틱(`) 대신 따옴표(')와 더하기(+)를 사용해서 안전하게 연결합니다.
                        
                        if (event.color === '#4dc3ff') { 
                            // [CASE 1] 파란색(예약) -> 상세 페이지 이동
                            // contextPath 변수 사용
                            var html = "<div class='event-item'>";
                            html += "<a href='" + contextPath + "/mypage/reservation/" + event.reservation_id + "'>";
                            html += colorDot + " " + event.title;
                            html += "</a></div>";
                            
                            listDiv.innerHTML += html;
                                
                        } else if (event.color === '#ff9f89') { 
                            // [CASE 2] 주황색(찜) -> 삭제 버튼 표시
                            var html = "<div class='event-item' style='display: flex; justify-content: space-between; align-items: center;'>";
                            html += "<span>" + colorDot + " " + event.title + "</span>";
                            html += "<button onclick='deletePick(" + event.reservation_id + ")' style='border:1px solid #ddd; background:#fff; color:red; cursor:pointer; padding:2px 6px; font-size:12px; border-radius:4px;'>삭제</button>";
                            html += "</div>";
                            
                            listDiv.innerHTML += html;
                        }
                    });
                } else {
                    // 일정이 없으면
                    listDiv.innerHTML = "<div class='event-item' style='color:#999;'>일정이 없습니다.</div>";
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

    // 4. 캘린더 삭제 함수
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
						<div style="color: #999;">
							달력의 날짜를 클릭하면<br> 예약/찜 내역이 여기에 표시됩니다.
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>

</body>
</html>