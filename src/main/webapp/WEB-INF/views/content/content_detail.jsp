<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>콘텐츠 상세</title>
  <style>
    .poster, .posterDetail { width: 300px; }
  
  </style>
 <script>
$(function () {

  // 날짜 조회
  $("#reservation").click(function () {
	  console.log("날짜 선택 클릭됨"); // 🔥 추가
    let content_id = $(this).data("content-id");

    $.ajax({
    	url: "${pageContext.request.contextPath}/schedule/date",

      method: "get",
      data: { content_id: content_id },
      success: function (res) {
    	  let html = "";
    	  res.forEach(function (date) {
    	    html += `
    	      <span class="date-item" data-date="\${date}">
    	        \${date}
    	      </span>
    	    `;
    	  });
    	  $(".reservation_date").html(html);
    	}

    });
  });
	//날짜 시간 모아두기 ->예약버트 누르면 세션으로 url 보낼때 넘겨주기
	let selectedDate =null;
	let selectedTime=null;
  // 시간 조회 (이벤트 위임)
  $(document).on("click", ".date-item", function () {

    let content_id = $("#reservation").data("content-id");
    date = $(this).data("date");
	selectedDate=date;
    $.ajax({
    	url: "${pageContext.request.contextPath}/schedule/time",
      method: "get",
      data: {
        content_id: content_id,
        scheduled_at: date
      },
      success: function (res) {
    	  let html = "";
    	  console.log(typeof res);
    	  res.forEach(function (sch) {
    		  console.log(sch.time_zone);
    	    html +=` 
    	      <div class="reservation_datePick" data-time="\${sch.time_zone}">
    	        시간: \${sch.time_zone}
    	        (잔여석: \${sch.current_ticket})
    	      </div>`;
    	  
    	  });
    	  $(".reservation_timezone").html(html);
    	}
    });
  });
	$(document).on("click",".reservation_datePick",function(){
		selectedTime=$(this).data("time");
	})
	
	$(".reservation_button").click(function () {
		  $.post(
		    "${pageContext.request.contextPath}/reservation/select",
		    {
		      content_id: $("#reservation").data("content-id"),
		      date: selectedDate,
		      time: selectedTime
		    },
		    function (res) {
		    	
		    	location.href = "${pageContext.request.contextPath}/reservation/select";
		    }
		  );
		});
});

	
</script>

</head>
<body>

<!-- ===== 상단 정보 ===== -->
<section>
  <h1>${content.title}</h1>
  <p>${content.start_at} ~ ${content.end_at}</p>
  <p>${content.location}</p>
</section>

<!-- ===== 좌측 포스터 + 좋아요 ===== -->
<section>
  <img class="poster" src="${content.main_image_path}" alt="포스터"/>

  <button>
    ❤️
    <span>${content.like_count}</span>
  </button>
</section>

<!-- ===== 우측 정보 ===== -->
<section>
  <div>
    <h3>소개</h3>
    <p>${content.description}</p>
  </div>

  <div>
    <h3>관람료</h3>
    <ul>
      <li>성인 ${content.adult_price}원</li>
      <li>청소년 ${content.teen_price}원</li>
      <li>어린이 ${content.child_price}원</li>
    </ul>
  </div>

  <div>
    <h3>운영 시간</h3>
  </div>
  
  <div>
  		예약 방식: ${content.reservationTypeLabel}
	
  </div>
</section>

<!-- ===== 예약 영역 (목업) ===== -->
<section>
  <label id="reservation" data-content-id="${content.content_id}">날짜 선택</label>
	<div class="reservation_date"></div>
	<div class="reservation_timezone"> 
	</div>
  <button class="reservation_button">예매하기</button>
  <button>캘린더 저장</button>
</section>

<!-- ===== 상세 설명 ===== -->
<section>
  <h2>상세 정보</h2>
  ${content.detail_description}
  <img class="posterDetail" src="${content.main_image_path}" />
</section>

</body>
</html>
