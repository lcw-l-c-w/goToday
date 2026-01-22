<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<style>
    .review-modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background: rgba(0, 0, 0, 0.7);
        z-index: 99999;
        justify-content: center;
        align-items: center;
    }

    .review-modal-content {
        background: white;
        width: 550px;
        max-height: 90vh;
        overflow-y: auto;
        padding: 30px 40px;
        border-radius: 15px;
        position: relative;
    }

    .review-modal-content h3 {
        margin-bottom: 15px;
        font-size: 20px;
    }

    /* 별점 클릭 스타일 */
    .star-rating {
        display: flex;
        align-items: center;
        gap: 5px;
        margin: 15px 0;
    }

    .star-rating .star {
        font-size: 32px;
        color: #ddd;
        cursor: pointer;
        transition: color 0.2s;
    }

    .star-rating .star:hover,
    .star-rating .star.active {
        color: #ffcc00;
    }

    .star-rating .star.half {
        position: relative;
    }

    #ratingVal {
        font-size: 18px;
        font-weight: bold;
        margin-left: 10px;
        color: #333;
    }

    /* 시간대 선택 */
    .time-zone-select, .time-zone-input {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 14px;
        margin-top: 5px;
    }

    .time-zone-display {
        background: #f0f0f0;
        padding: 10px;
        border-radius: 8px;
        margin-top: 5px;
        color: #333;
    }

    /* 기존 이미지 미리보기 */
    .current-image-preview {
        margin: 10px 0;
        padding: 10px;
        background: #f8f8f8;
        border-radius: 8px;
    }
    .current-image-preview img {
        max-width: 100%;
        max-height: 150px;
        border-radius: 8px;
    }
    .current-image-preview .remove-image {
        display: inline-block;
        margin-top: 8px;
        color: #ff4444;
        cursor: pointer;
        font-size: 13px;
    }
</style>

<div id="reviewModalContent" style="display:none;">
    <div class="review-modal-content">
        <h3 id="modalTitle">리뷰 작성</h3>
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
                <span class="star active" data-value="1">★</span>
                <span class="star active" data-value="2">★</span>
                <span class="star active" data-value="3">★</span>
                <span class="star active" data-value="4">★</span>
                <span class="star active" data-value="5">★</span>
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
                    <span class="remove-image" id="btnRemoveImage">이미지 삭제</span>
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
                <button type="button" id="btnDeleteReview" style="flex:1; padding:12px; background:#ff4444; color:white; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer;">삭제</button>
                <button type="button" id="btnCloseReview2" style="flex:1; padding:12px; background:#ddd; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer;">취소</button>
            </div>
        </form>
    </div>
</div>
