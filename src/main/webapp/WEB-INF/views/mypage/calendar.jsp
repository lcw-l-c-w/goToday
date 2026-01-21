<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang='ko'>

<head>
<meta charset='utf-8' />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' rel='stylesheet' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>

<style>
body {
    margin: 0;
    padding: 20px;
    font-family: 'Malgun Gothic', sans-serif;
}

/* 캘린더 스타일 미세 조정 */
#calendar {
    max-width: 100%;
}

.fc-toolbar-title {
    font-size: 20px !important;
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
</style>

<script>
    // 1. 전역 변수로 선언 (AJAX로 받아온 데이터를 여기에 담습니다)
    var myEvents = [];

    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');

        // 2. 캘린더 설정 (렌더링은 데이터 받은 후 자동으로 됨)
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView : 'dayGridMonth',
            locale : 'ko',
            selectable : true, 
            height: 700, // 높이 고정 (선택사항)

            // [중요] 날짜를 클릭했을 때 실행되는 함수
            dateClick : function(info) {
                // (1) 클릭한 날짜 가져오기
                var clickedDate = info.dateStr;

                // (2) 오른쪽 제목 변경
                document.getElementById('selected-date-title').innerText = clickedDate;

                // (3) 해당 날짜에 맞는 일정 찾기
                // ★ 중요: DTO의 변수명이 start이므로 event.start로 비교해야 함!
                var filteredEvents = myEvents.filter(function(event) {
                    return event.start === clickedDate;
                });

                // (4) 오른쪽 리스트 초기화 후 다시 그리기
                var listDiv = document.getElementById('event-list-box');
                listDiv.innerHTML = ""; 

                if (filteredEvents.length > 0) {
                    // 일정이 있으면 리스트 생성
                    filteredEvents.forEach(function(event) {
                        // 색상 점(●)을 추가해서 리스트에 보여줌
                        var colorDot = '<span style="color:' + event.color + '; margin-right:8px;">●</span>';
                        listDiv.innerHTML += "<div class='event-item'>" + colorDot + event.title + "</div>";
                    });
                } else {
                    // 일정이 없으면
                    listDiv.innerHTML = "<div class='event-item' style='color:#999;'>일정이 없습니다.</div>";
                }
            },
            
            // 초기에는 빈 배열이지만, 나중에 addEventSource로 채워짐
            events : [] 
        });

        calendar.render();

        // 3. [핵심] 서버에서 데이터 가져오기 (AJAX)
        $.ajax({
            url: "${pageContext.request.contextPath}/mypage/calendar-data", // 컨트롤러 주소
            type: "GET",
            dataType: "json",
            success: function(data) {
                // (1) 받아온 데이터를 전역 변수에 저장 (클릭 이벤트에서 쓰기 위함)
                myEvents = data;

                // (2) 캘린더에 데이터 주입 및 렌더링
                calendar.addEventSource(myEvents);
            },
            error: function(err) {
                console.log("데이터 로드 실패:", err);
            }
        });
    });
</script>
</head>

<body>

    <table width="100%" height="800" border="0" cellspacing="0" cellpadding="0">
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
                            달력의 날짜를 클릭하면<br> 
                            예약/찜 내역이 여기에 표시됩니다.
                        </div>
                    </div>
                </div>
            </td>
        </tr>
    </table>

</body>
</html>