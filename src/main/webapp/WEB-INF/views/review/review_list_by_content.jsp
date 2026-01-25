<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<style>
.review-summary-box {
    display: flex;
    align-items: center; /* 세로 중앙 정렬 */
    gap: 40px;
    margin: 20px 0;
    padding: 20px;
    background: #fcfcfc; /* 배경을 살짝 넣어 구분감 주기 */
    border-radius: 8px;
}

.summary-left {
    width: 120px; /* 너비 축소 */
    text-align: center;
    border-right: 1px solid #eee; /* 중간 구분선 추가 */
    padding-right: 20px;
}

.avg-score {
    font-size: 28px; /* 36px -> 28px로 축소 */
    font-weight: 800;
    color: #333;
}

.avg-score .max {
    font-size: 14px;
    color: #bbb;
}

.total-count {
    font-size: 13px;
    color: #888;
    margin-top: 4px;
}

/* 중간 막대바 영역 */
.summary-middle {
    flex: 1.5; /* 막대바 영역 비중 확대 */
}

.rating-row {
    display: flex;
    align-items: center;
	gap: 10px;
    margin: 4px 0;
}

.star-label {
    width: 70px;
    font-size: 14px;
    color: #ffc107;
    white-space: nowrap;
}

.bar-bg {
    flex: 1; 
    height: 10px;
    background: #f0f0f0;
    border-radius: 5px;
    overflow: hidden;
    position: relative;
}

.bar-fill {
	height: 100%;
    background: #4dc3ff;
    border-radius: 5px;
    transition: width 0.3s ease
}

.cnt-label {
	width: 35px;
    font-size: 12px;
    color: #888;
    text-align: right;
}

.summary-right {
    flex: 1;
    padding-left: 20px;
    border-left: 1px solid #eee;
}

.time-title {
    font-weight: 700;
    margin-bottom: 10px;
}

.time-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 4px 0;
}

.review-divider {
    margin: 25px 0;
    border: none;
    border-top: 1px solid #eee;
}

/* 리뷰 아이템 */
.review-item {
    border-bottom: 1px solid #eee;
    padding: 20px 0;
}

.review-header {
    display: flex;
    justify-content: space-between;
}

.review-user-name {
    font-weight: 700;
}

.review-timezone {
    font-size: 13px;
    color: #888;
}

.review-rating .star {
    color: #ddd;
}

.review-rating .star.filled {
    color: #ffc107;
}

.review-body {
    margin: 10px 0;
}

.review-images img {
    max-width: 120px;
    border-radius: 6px;
    margin-top: 8px;
}

.review-footer {
    font-size: 12px;
    color: #888;
}

.load-more-btn {
    display: block;
    margin: 30px auto;
    padding: 10px 24px;
    border: 1px solid #333;
    background: #fff;
    border-radius: 20px;
    cursor: pointer;
}
.sort-btn {
  padding: 6px 14px;
  border: 1px solid #ddd;
  background: #fff;
  border-radius: 20px;
  cursor: pointer;
  font-size: 13px;
}

.sort-btn.active {
  background: #333;
  color: #fff;
  border-color: #333;
}
</style>
<c:choose>
 <c:when test="${ratingSummary.totalReviews == 0}">
     <div class="review-summary-box" style="justify-content: center;">
         <div style="text-align:center; padding: 30px 0; width:100%;">
             <div style="font-size:18px; font-weight:700; margin-bottom:8px;">
        			아직 등록된 리뷰가 없습니다.
             </div>
             <div style="font-size:14px; color:#888;">
                	이 콘텐츠의 첫 번째 리뷰를 남겨보세요 😊
             </div>
         </div>
     </div>
 </c:when>
 <c:otherwise>
     <div class="review-summary-box">
         <div class="summary-left">
             <div class="avg-score">
                 <span class="score">${ratingSummary.avgRating}</span>
                 <span class="max"> / 5</span>
             </div>
             <div class="total-count">
                	총 ${ratingSummary.totalReviews}개 리뷰
             </div>
         </div>

         <div class="summary-middle">
             <div id="ratingBars">
                 <c:forEach var="i" begin="1" end="5">
                     <c:set var="star" value="${6 - i}" /> 
                     <c:set var="count" 
                         value="${star == 5 ? ratingSummary.rating_5 : 
                                 (star == 4 ? ratingSummary.rating_4 : 
                                 (star == 3 ? ratingSummary.rating_3 : 
                                 (star == 2 ? ratingSummary.rating_2 : 
                                 ratingSummary.rating_1)))}" />
                     <c:set var="percent" 
                         value="${ratingSummary.totalReviews > 0 
                                 ? (count * 100.0 / ratingSummary.totalReviews) 
                                 : 0}" />

                     <div class="rating-row">
                         <div class="star-label">
                             <c:forEach begin="1" end="${star}">
                                 <span style="color: #ffc107;">★</span>
                             </c:forEach>
                         </div>
                         <div class="bar-bg">
                             <div class="bar-fill" style="width: ${percent}%;"></div>
                         </div>
                         <div class="cnt-label">${count}개</div>
                    </div>
                 </c:forEach>
             </div>
         </div>

         <div class="summary-right">
             <div class="time-title">시간대별 평점</div>
             <div id="timeZoneSummary">
                 <c:forEach var="entry" items="${avgRatingByTimeZone}">
                     <div class="time-row">
                         <span>
                             <c:choose>
                                 <c:when test="${entry.key eq 'MORNING'}">9:00 - 12:00</c:when>
                                 <c:when test="${entry.key eq 'LAUNCH'}">12:00 - 15:00</c:when>
                                 <c:when test="${entry.key eq 'AFTERNOON'}">15:00 - 18:00</c:when>
                                 <c:when test="${entry.key eq 'EVENING'}">18:00 - 21:00</c:when>
                                 <c:otherwise>${entry.key}</c:otherwise>
                             </c:choose>
                         </span>
                         <span style="color: #ffc107;">
                             <c:forEach begin="1" end="5" var="starIdx">
                                 ${starIdx <= entry.value ? '★' : '☆'}
                             </c:forEach>
                             <span style="color:#333; font-weight:bold; margin-left:5px;">
                                 ${entry.value}
                             </span>
                         </span>
                     </div>
                 </c:forEach>
             </div>
         </div>
     </div>
 </c:otherwise>
</c:choose>

<hr class="review-divider">
<div id="reviewSortBar" style="display:flex; gap:10px; margin: 20px 0;">
  <button class="sort-btn active" data-sort="latest">최신순</button>
  <button class="sort-btn" data-sort="highRating">별점 높은순</button>
  <button class="sort-btn" data-sort="lowRating">별점 낮은순</button>
</div>
<div id="reviewList">
	<c:choose>
        <c:when test="${empty reviewList}">
            <div class="no-review-list"style="text-align:center; padding: 40px 0; color:#888;">
             	 아직 작성된 리뷰가 없습니다.
            </div>
        </c:when>
	    <c:otherwise>
		    <c:forEach var="r" items="${reviewList}">
		        <div class="review-item">
		            <div class="review-header">
		                <div class="review-user">
		                    <span class="review-user-name">${r.maskedEmail}</span>
		                    <span class="review-timezone">· ${r.visited_time_zone}</span>
		                </div>
		
		                <div class="review-rating">
		                    <c:forEach begin="1" end="5" var="i">
		                        <span class="star ${i <= r.rating ? 'filled' : ''}">★</span>
		                    </c:forEach>
		                </div>
		            </div>
		
		            <div class="review-body">
		                <div class="review-content">${r.content}</div>
		
		                <c:if test="${not empty r.image_new}">
		                    <div class="review-images">
		                        <img src="${pageContext.request.contextPath}/uploads/${r.image_new}">
		                    </div>
		                </c:if>
		            </div>
		
		            <div class="review-footer">
		                ${r.visited_at}
		            </div>
		        </div>
		    </c:forEach>
		    <c:if test="${not empty reviewList and fn:length(reviewList) == 5}">
			    <button id="loadMoreBtn" class="load-more-btn">
			        리뷰 더보기
			    </button>
			</c:if>
	    </c:otherwise>
    </c:choose>
</div>


<script>
const ratingSummary = {
  totalReviews: ${ratingSummary.totalReviews != null ? ratingSummary.totalReviews : 0},
  avgRating: ${ratingSummary.avgRating != null ? ratingSummary.avgRating : 0},
  rating5: ${ratingSummary.rating_5 != null ? ratingSummary.rating_5 : 0},
  rating4: ${ratingSummary.rating_4 != null ? ratingSummary.rating_4 : 0},
  rating3: ${ratingSummary.rating_3 != null ? ratingSummary.rating_3 : 0},
  rating2: ${ratingSummary.rating_2 != null ? ratingSummary.rating_2 : 0},
  rating1: ${ratingSummary.rating_1 != null ? ratingSummary.rating_1 : 0}
};

let currentPage = 1;
let currentSortType = "latest";
const ctx = "${pageContext.request.contextPath}";
const contentId = ${content.content_id};

document.addEventListener("click", function (e) {
	
  if (e.target && e.target.id === "loadMoreBtn") {
    loadMoreReviews();
  }
  
  if (e.target && e.target.classList.contains("sort-btn")) {
    const sortType = e.target.dataset.sort;
    changeSortType(sortType, e.target);
  }
});

function loadMoreReviews() {
  const nextPage = currentPage + 1;

  const url =
    ctx + "/detail/" + contentId +
    "?page=" + nextPage + "&sortType=" + currentSortType;

  console.log("AJAX url =", url);

  fetch(url, {
    headers: { "X-Requested-With": "XMLHttpRequest" }
  })
  .then(res => res.text())
  .then(html => {

    const parser = new DOMParser();
    const doc = parser.parseFromString(html, "text/html");

    const newItems = doc.querySelectorAll(".review-item");

    if (newItems.length === 0) {
      const oldBtn = document.getElementById("loadMoreBtn");
      if (oldBtn) oldBtn.style.display = "none";
      return;
    }

    const reviewList = document.getElementById("reviewList");

    newItems.forEach(item => {
      reviewList.appendChild(item.cloneNode(true));
    });

    currentPage = nextPage;

    // 기존 버튼 제거
    const oldBtn = document.getElementById("loadMoreBtn");
    if (oldBtn) oldBtn.remove();

    // 다음 페이지가 더 있으면 버튼 다시 생성
    if (newItems.length === 5) {
      const btn = document.createElement("button");
      btn.id = "loadMoreBtn";
      btn.className = "load-more-btn";
      btn.innerText = "리뷰 더보기";
      reviewList.after(btn);
    }

  })
  .catch(err => {
    console.error("리뷰 더보기 실패:", err);
    alert("리뷰를 더 불러오지 못했습니다.");
  });
}

function changeSortType(sortType, clickedBtn) {

  if (currentSortType === sortType) return;

  currentSortType = sortType;
  currentPage = 0;

  // 버튼 active 처리
  document.querySelectorAll(".sort-btn").forEach(btn => {
    btn.classList.remove("active");
  });
  clickedBtn.classList.add("active");

  // 기존 리뷰 싹 비우기
  const reviewList = document.getElementById("reviewList");
  reviewList.innerHTML = "";

  // 기존 더보기 버튼 제거
  const oldBtn = document.getElementById("loadMoreBtn");
  if (oldBtn) oldBtn.remove();

  loadMoreReviews();
}
</script>
