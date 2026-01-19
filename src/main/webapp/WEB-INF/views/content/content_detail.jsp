<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>GoToday | ${content.title}</title>
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
  
  <style>
    :root { --main-color: #4dc3ff; --border-color: #eee; --text-gray: #666; }
    body { font-family: 'Pretendard', sans-serif; margin: 0; padding: 0; color: #333; }

    /* --- Navigation Bar --- */
    .navbar {
      display: flex; align-items: center; justify-content: space-between;
      padding: 0 50px; height: 70px; border-bottom: 1px solid #eee; background: #fff;
    }
    .nav-left { display: flex; align-items: center; gap: 40px; }
    .nav-logo img { height: 35px; cursor: pointer; }
    
    .nav-menu { display: flex; gap: 30px; list-style: none; margin: 0; padding: 0; height: 100%; }
    .nav-menu li { position: relative; display: flex; align-items: center; height: 70px; } /* 네비바 높이에 맞춤 */
    
    .nav-menu a { 
      text-decoration: none; 
      color: #333; 
      font-weight: 500; 
      font-size: 16px; 
      transition: color 0.2s ease;
      display: block;
    }

    /* 마우스 호버 및 활성화 상태 스타일 */
    .nav-menu li:hover a, 
    .nav-menu li.active a { 
      color: var(--main-color); 
    }

    /* 하단 파란색 선 애니메이션 */
    .nav-menu li::after {
      content: "";
      position: absolute;
      bottom: -1px; /* 네비바 하단 보더와 맞춤 */
      left: 0;
      width: 0;
      height: 3px;
      background-color: var(--main-color);
      transition: width 0.3s ease;
    }

    /* 호버하거나 active 클래스가 있을 때 선이 늘어남 */
    .nav-menu li:hover::after,
    .nav-menu li.active::after {
      width: 100%;
    }
    
    .nav-right { display: flex; align-items: center; gap: 25px; }
    .search-bar { position: relative; border-bottom: 1px solid #333; display: flex; align-items: center; }
    .search-bar input { border: none; outline: none; padding: 5px 25px 5px 5px; width: 180px; font-size: 14px; }
    .search-bar i { position: absolute; right: 5px; cursor: pointer; }
    .user-icon img { width: 24px; cursor: pointer; }

    /* --- Content Layout --- */
    .container { max-width: 1100px; margin: 40px auto; padding: 0 20px; }
    .breadcrumb { font-size: 13px; color: var(--text-gray); margin-bottom: 15px; }
    .breadcrumb span { color: var(--main-color); }

    .content-title-area { display: flex; justify-content: space-between; align-items: flex-end; border-bottom: 2px solid #333; padding-bottom: 15px; margin-bottom: 30px; }
    .content-title-area h1 { margin: 0; font-size: 28px; letter-spacing: -1px; }
    .sns-group { display: flex; gap: 12px; }
    .sns-group img { width: 22px; cursor: pointer; opacity: 0.8; }

    .main-box { display: flex; gap: 50px; align-items: flex-start; margin-bottom: 60px; }
    
    /* Left: Poster */
    .poster-side { flex: 0 0 400px; }
    .poster-img { width: 100%; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
    .like-count { display: flex; align-items: center; gap: 5px; margin-top: 15px; font-weight: bold; color: #444; }

    /* Right: Info & Reservation */
    .info-side { flex: 1; }
    .info-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
    .info-table th { text-align: left; width: 100px; padding: 12px 0; color: #333; font-size: 15px; vertical-align: top; }
    .info-table td { padding: 12px 0; font-size: 15px; color: #555; line-height: 1.6; }

    .reserve-section { display: flex; gap: 20px; border-top: 1px solid #eee; padding-top: 30px; }
    #calendar { flex: 1.2; border: 1px solid #eee; border-radius: 10px; padding: 10px; background: #fff; font-size: 12px; }
    
    .time-selector { flex: 1; border: 1px solid #eee; border-radius: 10px; padding: 15px; background: #fafafa; }
    .time-title { font-weight: bold; font-size: 14px; margin-bottom: 15px; display: block; }
    .time-option { display: flex; align-items: center; padding: 10px; background: #fff; border: 1px solid #eee; border-radius: 6px; margin-bottom: 8px; cursor: pointer; transition: 0.2s; }
    .time-option:hover { border-color: var(--main-color); }
    .time-option input { margin-right: 12px; accent-color: var(--main-color); }
    .time-val { flex: 1; font-size: 14px; }
    .seat-val { font-size: 12px; color: var(--text-gray); }

    .action-btns { display: flex; gap: 10px; margin-top: 25px; }
    .btn-reserve { flex: 1; background: var(--main-color); color: #fff; border: none; padding: 16px; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; }
    .btn-share { width: 55px; background: #fff; border: 1px solid #ddd; border-radius: 6px; cursor: pointer; font-size: 20px; }

    /* 상세 정보 섹션 */
    .detail-section { border-top: 1px solid #eee; padding-top: 40px; margin-top: 40px; }
    .detail-section h2 { font-size: 22px; margin-bottom: 20px; }
    .detail-content { line-height: 1.8; color: #444; }
    .detail-img { width: 100%; margin-top: 20px; border-radius: 8px; }
  </style>

  <script>
    $(function() {
      let selectedDate = null;
      let selectedTime = null;
      let scheduleId = null;

      // 1. 달력 설정
      const calendarEl = document.getElementById('calendar');
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

      // 2. 시간 데이터 가져오기 (AJAX)
      function fetchTimes(date) {
        $.ajax({
          url: "${pageContext.request.contextPath}/schedule/time",
          data: { content_id: $("#content_id").val(), scheduled_at: date },
          success: function(res) {
            let html = `<span class="time-title">\${date} 시간 선택</span>`;
            if(!res || res.length === 0) {
              html += "<p style='font-size:12px; color:#999;'>예정된 회차가 없습니다.</p>";
            } else {
              res.forEach(sch => {
                html += `
                  <label class="time-option">
                    <input type="radio" name="sch_radio" data-id="\${sch.schedule_id}" data-time="\${sch.time_zone}">
                    <span class="time-val">\${sch.time_zone}</span>
                    <span class="seat-val">\${sch.current_ticket}석</span>
                  </label>`;
              });
            }
            $(".reservation_timezone").html(html);
            selectedTime = null;
            scheduleId = null;
          }
        });
      }

      // 3. 시간 선택 시 변수 저장
      $(document).on("change", "input[name='sch_radio']", function() {
        selectedTime = $(this).data("time");
        scheduleId = $(this).data("id");
      });

      // 4. 예매하기 버튼 클릭
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
    });
  </script>
</head>
<body>

  <header class="navbar">
    <div class="nav-left">
      <a href="/gotoday/main" class="nav-logo"><img src="https://via.placeholder.com/120x40?text=GoToday" alt="Logo"></a>
      <ul class="nav-menu">
        <li><a href="#">Q&A</a></li>
        <li><a href="/gotoday/popup">PopUp</a></li>
        <li><a href="/gotoday/exhibition">Exhibition</a></li>
      </ul>
    </div>
    <div class="nav-right">
      <div class="search-bar">
        <input type="text" placeholder="검색어를 입력하세요">
        <i>🔍</i>
      </div>
      <div class="user-icon"><img src="https://cdn-icons-png.flaticon.com/512/1077/1077114.png" alt="User"></div>
    </div>
  </header>

  <div class="container">
    <div class="breadcrumb">콘텐츠 > 팝업 > <span>#미디어</span></div>
    
    <div class="content-title-area">
      <div>
        <h1>컨텐츠명 : ${content.title}</h1>
        <p style="margin:8px 0 0; color:#666;">${content.start_at} ~ ${content.end_at} &nbsp;|&nbsp; ${content.location} 📍</p>
      </div>
      <div class="sns-group">
        <img src="https://cdn-icons-png.flaticon.com/512/733/733579.png" alt="X">
        <img src="https://cdn-icons-png.flaticon.com/512/2111/2111463.png" alt="IG">
        <img src="https://cdn-icons-png.flaticon.com/512/1358/1358023.png" alt="Link">
      </div>
    </div>

    <div class="main-box">
      <section class="poster-side">
        <img src="${content.main_image_path}" class="poster-img" alt="Poster">
        <div class="like-count">💙 ${content.like_count}</div>
      </section>

      <section class="info-side">
        <table class="info-table">
          <tr><th>소개</th><td>${content.description}</td></tr>
          <tr><th>관람료</th><td>성인 ${content.adult_price}원 / 청소년 ${content.teen_price}원 / 어린이 ${content.child_price}원</td></tr>
          <tr><th>운영시간</th><td>10:00 ~ 18:00 (월요일 휴관)</td></tr>
          <tr><th>예약방식</th><td>${content.reservationTypeLabel} (QR 입장)</td></tr>
        </table>

        <div class="reserve-section">
          <div id="calendar"></div>
          <div class="time-selector">
            <div class="reservation_timezone">
              <span class="time-title">시간대 선택</span>
              <p style="font-size:12px; color:#999; margin-top:20px;">먼저 달력에서 날짜를 선택해주세요.</p>
            </div>
          </div>
        </div>

        <div class="action-btns">
          <input type="hidden" id="content_id" value="${content.content_id}">
          <button class="btn-reserve">예매하기</button>
          <button class="btn-share">🤍</button>
        </div>
      </section>
    </div>

    <section class="detail-section">
      <h2>상세 정보</h2>
      <div class="detail-content">
        ${content.detail_description}
      </div>
      <c:if test="${not empty content.main_image_path}">
        <img src="${content.main_image_path}" class="detail-img" alt="상세이미지">
      </c:if>
    </section>
  </div>

</body>
</html>