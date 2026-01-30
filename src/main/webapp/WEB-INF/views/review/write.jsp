<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/review/write.css">

<div id="reviewModalContent" style="display:none;">
    <div class="review-modal-content">
        <div class="modal-header">
            <h3 id="modalTitle">리뷰 작성</h3>
        </div>
        
        <hr>
        <div id="targetInfo" style="margin: 15px 0; font-size: 14px; background: #f8f8f8; padding: 15px; border-radius: 8px;">
            <p><strong>전시:</strong> <span id="m_title"></span></p>
            <p><strong>위치:</strong> <span id="m_address"></span></p>
            <p><strong>방문일:</strong> <span id="m_date"></span></p>
        </div>

        <form id="reviewForm" enctype="multipart/form-data">
            <input type="hidden" name="reservation_id" id="m_resId">
            <input type="hidden" name="content_id" id="m_contentId">
            <input type="hidden" name="review_id" id="m_reviewId">
            <input type="hidden" name="rating" id="m_rating" value="5">
            <input type="hidden" name="visited_at" id="m_visitedAt">
            <input type="hidden" name="visited_time_zone" id="m_visitedTimeZone">
            <input type="hidden" name="keep_image" id="m_keepImage" value="true">

            <label style="font-weight:600;">별점 <span id="ratingVal">5.0</span></label>
            <div class="star-rating" id="starRating">
                <span class="star" data-value="1">★</span>
                <span class="star" data-value="2">★</span>
                <span class="star" data-value="3">★</span>
                <span class="star" data-value="4">★</span>
                <span class="star" data-value="5">★</span>
            </div>

            <div id="timeZoneArea" style="margin-bottom:15px;">
                <label style="font-weight:600;">방문 시간대</label>
                <div id="timeInputContainer"></div>
            </div>

            <label style="font-weight:600;">리뷰 내용</label>
            <textarea name="content" id="m_content" style="width:100%; height:100px; margin: 10px 0 15px 0; padding: 10px; border: 1px solid #ddd; border-radius: 8px; resize: none;" placeholder="소중한 리뷰를 남겨주세요."></textarea>

            <div id="currentImageArea" style="display:none;">
                <label style="font-weight:600;">현재 이미지</label>
                <div class="current-image-preview">
                    <img id="currentImage" src="" alt="현재 이미지">
 					<!-- 이미지 삭제 -->
                </div>
            </div>

            <label style="font-weight:600;">사진 업로드 (1장)</label>
            <input type="file" name="image_new" id="reviewPhoto" accept="image/*" style="margin: 10px 0 20px 0; width: 100%;">

            <!-- 등록 모드 버튼 -->
            <div id="createButtons" style="display:flex; gap:10px;">
                <button type="button" id="btnSubmitReview" style="flex:1; padding:12px; background:#4dc3ff; color:white; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer;">등록</button>
                <button type="button" id="btnCloseReview" style="flex:1; padding:12px; background:#ddd; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer;">취소</button>
            </div>

            <!-- 수정 모드 버튼 -->
            <div id="editButtons" style="display:none; gap:10px;">
                <button type="button" id="btnUpdateReview" style="flex:1; padding:12px; background:#4dc3ff; color:white; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer;">수정</button>
                <button type="button" id="btnCloseReview2" style="flex:1; padding:12px; background:#ddd; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer;">취소</button>
            </div>
        </form>
    </div>
</div>

<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/resources/js/review/write.js"></script>

