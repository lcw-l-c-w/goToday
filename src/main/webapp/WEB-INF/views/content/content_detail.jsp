<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>콘텐츠 상세</title>
  <style>
    .poster, .posterDetail { width: 300px; }
  </style>
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
    <p>${content.time_zone}</p>
  </div>
</section>

<!-- ===== 예약 영역 (목업) ===== -->
<section>
  <label>날짜 선택</label>
  <input type="date" value="${content.scheduled_at}" />

  <button>예매하기</button>
  <button>캘린더 저장</button>
</section>

<!-- ===== 상세 설명 ===== -->
<section>
  <h2>상세 정보</h2>
  <p>${content.description}</p>

  <img class="posterDetail" src="${content.main_image_path}" />
</section>

</body>
</html>
