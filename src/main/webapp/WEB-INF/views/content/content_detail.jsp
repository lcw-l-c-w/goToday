<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>콘텐츠 상세 | ${content.title}</title>
  
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
  
  <style>
    :root { --main-color: #00c7ae; --border-color: #eee; }
    body { font-family: 'Pretendard', sans-serif; margin: 0; padding: 20px; background-color: #fff; }
    .container { display: flex; max-width: 1100px; margin: 0 auto; gap: 40px; }

    /* 좌측 포스터 영역 */
    .left-section { flex: 0 0 350px; }
    .poster { width: 100%; border-radius: 12px; box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
    .like-section { margin-top: 15px; display: flex; align-items: center; gap: 8px; }

    /* 우측 상세 및 예약 영역 */
    .right-section { flex: 1; display: flex; flex-direction: column; gap: 25px; }
    .content-header h1 { font-size: 28px; margin: 0 0 10px; }
    .content-meta { color: #666; line-height: 1.6; }

    /* 예약 컨테이너 (달력 + 시간) */
    .reservation-container { 
        display: grid; grid-template-columns: 1.2f 1fr; gap: 20px; 
        border: 1px solid var(--border-color); padding: 20px; border-radius: 15px; background: #fafafa;
    }
    
    /* FullCalendar 커스텀 스타일 */
    #calendar { background: #fff; padding: 10px; border-radius: 10px; border: 1px solid #ddd; font-size: 13px; }
    .fc-daygrid-day { cursor: pointer; }
    .fc-day-selected { background-color: rgba(0, 199, 174, 0.1) !important; border: 2px solid var(--main-color) !important; }

    /* 시간 선택 스타일 */
    .time-selection-title { font-weight: bold; margin-bottom: 15px; display: block; }
    .reservation_timezone { display: flex; flex-direction: column; gap: 10px; max-height: 350px; overflow-y: auto; }
    .reservation_datePick { 
        padding: 12px; border: 1px solid #ddd; border-radius: 8px; background: #fff; cursor: pointer;
        transition: all 0.2s; font-size: 14px; display: flex; justify-content: space-between;
    }
    .reservation_datePick:hover { border-color: var(--main-color); }
    .reservation_datePick.active { background-color: var(--main-color); color: white; border-color: var(--main-color); }

    /* 하단 버튼 */
    .btn-group { display: flex; gap: 10px; }
    .reservation_button { flex: 2; padding: 18px; background: var(--main-color); color: white; border: none; border-radius: 8px; font-weight: bold; cursor: pointer; font-size: 16px; }
    .calendar-save { flex: 1; padding: 18px; background: #fff; border: 1px solid #ddd; border-radius: 8px; cursor: pointer; }
  </style>

  <script>
    $(function () {
      let selectedDate = null;
      let selectedTime = null;
      let scheduleId = null;

      // 1. FullCalendar 초기화
      const calendarEl = document.getElementById('calendar');
      const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        height: 'auto',
        headerToolbar: { left: 'prev', center: 'title', right: 'next' },
        selectable: true,
        // 날짜 클릭 이벤트
        dateClick: function(info) {
          // 스타일 처리
          $(".fc-daygrid-day").removeClass("fc-day-selected");
          $(info.dayEl).addClass("fc-day-selected");
          
          selectedDate = info.dateStr;
          fetchTimes(selectedDate);
        }
      });
      calendar.render();

      // 2. 시간 조회 함수 (AJAX)
      function fetchTimes(date) {
        let content_id = $("#content_id").val();
        $.ajax({
          url: "${pageContext.request.contextPath}/schedule/time",
          method: "get",
          data: { content_id: content_id, scheduled_at: date },
          success: function (res) {
            let html = `<span class="time-selection-title">\${date} 시간 선택</span>`;
            if(res.length === 0) {
              html += "<p>해당 날짜에 일정이 없습니다.</p>";
            }
            res.forEach(sch => {
              html += `
                <div class="reservation_datePick" data-time="\${sch.time_zone}" data-schedule-id="\${sch.schedule_id}">
                  <span>\${sch.time_zone}</span>
                  <small>잔여: \${sch.current_ticket}석</small>
                </div>`;
            });
            $(".reservation_timezone").html(html);
          }
        });
      }

      // 3. 시간 선택 시 활성화 효과
      $(document).on("click", ".reservation_datePick", function () {
        $(".reservation_datePick").removeClass("active");
        $(this).addClass("active");

        selectedTime = $(this).data("time");
        scheduleId = $(this).data("schedule-id");
      });

      // 4. 예매하기 버튼 클릭
      $(".reservation_button").click(function () {
        if(!selectedDate || !selectedTime) {
          alert("날짜와 시간을 모두 선택해주세요!");
          return;
        }

        $.post("${pageContext.request.contextPath}/reserve/schedule.do", {
          content_id: $("#content_id").val(),
          reserved_for_at: selectedDate,
          time_zone: selectedTime,
          schedule_id: scheduleId
        }, function (res) {
          location.href = "${pageContext.request.contextPath}/reservation/select";
        });
      });
    });
  </script>
</head>
<body>

<div class="container">
  <section class="left-section">
    <img class="poster" src="${content.main_image_path}" alt="포스터"/>
    <div class="like-section">
      <button style="background:none; border:none; font-size:24px; cursor:pointer;">❤️</button>
      <strong>${content.like_count}</strong>
    </div>
  </section>

  <section class="right-section">
    <div class="content-header">
      <small style="color:var(--main-color); font-weight:bold;">팝업스토어 & 전시</small>
      <h1>${content.title}</h1>
      <div class="content-meta">
        <p>📅 ${content.start_at} ~ ${content.end_at}</p>
        <p>📍 ${content.location}</p>
      </div>
    </div>

    <div class="reservation-container">
      <div id='calendar'></div>
      <div class="reservation_timezone">
        <span class="time-selection-title">날짜를 선택해 주세요.</span>
        </div>
    </div>

    <div style="background:#f9f9f9; padding:20px; border-radius:12px;">
      <h3 style="margin-top:0;">관람 정보</h3>
      <p>성인: ${content.adult_price}원 / 청소년: ${content.teen_price}원</p>
      <div class="btn-group">
        <input type="hidden" id="content_id" value="${content.content_id}" />
        <button class="reservation_button">예매하기</button>
        <button class="calendar-save">공유하기</button>
      </div>
    </div>
  </section>
</div>

<hr style="margin:50px 0; border:0; border-top:1px solid #eee;">

<section style="max-width:1100px; margin:0 auto; padding-bottom:100px;">
  <h2>상세 정보</h2>
  <div class="detail-description">
    ${content.detail_description}
    <br>
    <img src="${content.main_image_path}" style="width:100%; border-radius:10px; margin-top:20px;">
  </div>
</section>

</body>
</html>