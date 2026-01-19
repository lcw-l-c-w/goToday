<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <title>콘텐츠 상세</title>
  <style>
    .poster, .posterDetail { 
      width: 300px;
    }
  </style>
</head>
<body>

<div class="page-wrapper">
  <div class="content-container">
    <section class="top-area">
		<div class="content-info">
		  <span>컨텐츠 &gt; 팝업</span>
		  <a href="#" class="tag">#미디어</a>
		  <h1>팝업 제목 : 치이카와 베이비 팝업</h1>
		  <p class="period">2026.01.01 ~ 2026.03.02</p>
		  <p class="location"><a href = "#" class="search-location">홍대 어딘가</a></p>
		</div>

		<!-- 공유 버튼 그룹 -->
		<div class="share-group">
		  <button class="share-btn" aria-label="인스타그램 링크">
		    <img src="icon-share.svg" alt="링크">
		  </button>
		  <button class="share-btn" aria-label="엑스 링크">
		    <img src="icon-share.svg" alt="링크">
		  </button>
		  <button class="share-btn" aria-label="공유">
		    <img src="icon-share.svg" alt="공유">
		  </button>
		  
		  <ul class="share-list">
		    <li>
		      <a href="#" class="share-item instagram">
		        <img src="icon-instagram.svg" alt="카카오톡 공유">
		      </a>
		    </li>
		    <li>
		      <a href="#" class="share-item instagram">
		        <img src="icon-instagram.svg" alt="인스타그램 공유">
		      </a>
		    </li>
		    <li>
		      <a href="#" class="share-item facebook">
		        <img src="icon-facebook.svg" alt="엑스 공유">
		      </a>
		    </li>
		    <li>
		      <a href="#" class="share-item link">
		        <img src="icon-link.svg" alt="URL">
		      </a>
		    </li>
		  </ul>
		  
		</div>

    </section>
    
    <!-- 좌측 영역 -->
    <section class="left-area">
		<div>
		  <img src="poster.jpg" alt="포스터" class="poster" />
		</div>
		<button class="like-btn" aria-label="좋아요">
		  <img src="icon-heart.svg" alt="좋아요">
		  <span class="like-count">123</span>
		</button>
    </section>

    <!-- 우측 영역 -->
    <section class="right-area">
		<div class="info-box">
		  <p>소개</p>
		  <span>어쩌고 저쩌고 간략하게 소개하는 란</span>
		</div>
      
		<div class="price-box">
		  <p>관람료</p>
		  <ul>
		    <li>성인 17,000원</li>
		    <li>청소년 17,000원</li>
		  </ul>
		</div>

		<div class="operating-hours">
		  <p>운영시간</p>
		  <span>10 : 00 ~ 18 : 00</span>
		</div>
		
		<div class="receive-method">
		  <p>수령방법</p>
		  <span>사전예매</span>
		</div>
		
		
		<!-- 예약 영역 -->
		<div class="reservation-box">
			<form action="/reserve/schedule.do" method="post">
			
			<input type="hidden" name="content_id" value="${content.content_id}" />
			
			<!-- 스케쥴리스트가 있으면 시간대 선택해야 함.  -->
			<c:if test="${ !empty content.contentScheduleList}">
			
				<label>날짜 선택</label>
				<input type="date" name="scheduled_at" />
				
				<label>시간대 선택</label>
				<select name="time_zone">
					<c:forEach var="vo" items="${contentSchedulVO}">
						<option value="${vo.start_at} ~ ${vo.end_At}">
							${vo.start_at} ~ ${vo.end_At}
						</option>
					</c:forEach>
				</select>
			
			</c:if>
			
			<!-- 상시 전시의 경우 스케쥴리스트가 null임 -->
			<c:if test="${empty content.contentScheduleList}">
				<p>현장 수령 상품입니다. 방문 후 바로 이용 가능합니다.</p>
			</c:if>
			
			  <button type="submit" class="reserve-btn">예매하기</button>
			
			</form>
	    </div>
    </section>

    <!-- 탭 영역 -->
    <div class="tab-wrapper">

      <!-- 탭 메뉴 -->
      <ul class="tab-menu">
        <li class="tab-item active">상세정보</li>
        <li class="tab-item">리뷰</li>
      </ul>

      <!-- 탭 콘텐츠 -->
      <div class="tab-content">

        <!-- 상세정보 -->
        <section class="tab-panel active">
          <h2>상세 정보</h2>
          <p>
            해당 전시는 어쩌고 저쩌고 설명이 들어갑니다.<br />
            전시 소개, 유의사항, 관람 정보 등을 보여줍니다.
          </p>
          <img src="detail.jpg" alt="포스터" class="posterDetail" />
        </section>

        <!-- 리뷰 탭 전체 -->
        <section class="review-section">

          <!-- 리뷰 요약 영역 -->
          <div class="review-summary">

            <!-- 좌측: 전체 별점 분포 -->
            <div class="rating-summary-left">
              <h3>별점 분포</h3>

              <div class="average-score">
                <span class="score">4.7</span>
                <span class="stars">★★★★★</span>
                <span class="count">(총 34개 리뷰)</span>
              </div>

              <!-- 별점별 막대(개수 숫자로 보여주고 바 형식으로 시각화) -->
              <ul class="rating-bars">
                <li>
                  <span class="label">5점</span>
                  <div class="bar">
                    <div class="fill" style="width: 80%;"></div>
                  </div>
                  <span class="value">24</span>
                </li>
                <li>
                  <span class="label">4점</span>
                  <div class="bar">
                    <div class="fill" style="width: 60%;"></div>
                  </div>
                  <span class="value">7</span>
                </li>
                <li>
                  <span class="label">3점</span>
                  <div class="bar">
                    <div class="fill" style="width: 20%;"></div>
                  </div>
                  <span class="value">3</span>
                </li>
                <li>
                  <span class="label">2점</span>
                  <div class="bar">
                    <div class="fill"></div>
                  </div>
                  <span class="value">0</span>
                </li>
                <li>
                  <span class="label">1점</span>
                  <div class="bar">
                    <div class="fill"></div>
                  </div>
                  <span class="value">0</span>
                </li>
              </ul>
            </div>

            <!-- 우측: 시간대별 평균 -->
            <div class="rating-summary-right">
              <h3>방문 시간대별 평점</h3>

              <ul class="time-rating-list">
                <li>
                  <span class="time">10:00 ~ 12:00</span>
                  <span class="stars">★★★★★</span>
                  <span class="score">5.0</span>
                </li>
                <li>
                  <span class="time">12:00 ~ 14:00</span>
                  <span class="stars">★★★★☆</span>
                  <span class="score">4.0</span>
                </li>
                <li>
                  <span class="time">14:00 ~ 16:00</span>
                  <span class="stars">★★★★★</span>
                  <span class="score">5.0</span>
                </li>
              </ul>
            </div>

          </div>

          <!-- 리뷰 리스트 헤더 -->
          <div class="review-list-header">
            <h3>리뷰 목록 (총개수)</h3>

            <!-- 정렬 버튼 -->
            <select class="review-sort">
              <option value="latest">최신순</option>
              <option value="high">별점 높은순</option>
              <option value="low">별점 낮은순</option>
            </select>
          </div>

          <!-- 리뷰 리스트 : 더보기 누르면 추가 -->
          <ul class="review-list">
            
            
            <!-- 리뷰 아이템 -->
            <li class="review-item">
              <div class="review-header">
                <span class="user">김*</span>
                <span class="stars">★★★★★</span>
                <span class="date">2026.01.13</span>
              </div>
              
              <div class="review-meta">
                <span class="time-slot">10:00 ~ 12:00</span>
              </div>
              
              <p class="review-content">
                오전 시간대 방문했는데 사람도 적당하고 좋았습니다.
                작품 설명도 자세해서 이해하기 좋았어요.
              </p>
              
              <div class="review-images">
                <img src="review1.jpg" alt="리뷰 이미지" />
              </div>
            </li>
            
            <!-- 리뷰 아이템 -->
            <li class="review-item">
              <div class="review-header">
                <span class="user">박*</span>
                <span class="stars">★★★★☆</span>
                <span class="date">2026.01.12</span>
              </div>
              
              <div class="review-meta">
                <span class="time-slot">12:00 ~ 14:00</span>
              </div>
              
              <p class="review-content">
                전시는 재밌었는데 점심시간이라 사람이 조금 많았어요.
              </p>
            </li>
            
            <!-- 페이징 / 더보기 -->
            <div class="review-pagination">
              <button class="load-more">리뷰 더보기</button>
            </div>
            
          </ul>

        </section>

      </div>
    </div>
    
  </div>
</div>

</body>
</html>