<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>리뷰 등록 | Gotody</title>
<style>
    /* 배경 어둡게 */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0; left: 0;
        width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.7);
        z-index: 1000;
        justify-content: center;
        align-items: center;
    }
    .modal-content {
        background: white;
        width: 450px;
        padding: 30px;
        border-radius: 15px;
        position: relative;
    }
    /* 별점 스타일 */
    .star-wrapper {
        display: flex;
        align-items: center;
        gap: 10px;
        margin: 15px 0;
    }
    #starRange { width: 150px; cursor: pointer; }
    #starDisplay { font-size: 24px; color: #ffcc00; }
</style>

<div id="reviewModal" class="modal-overlay">
    <div class="modal-content">
        <h3>리뷰 작성</h3>
        <hr>
        <div id="targetInfo" style="margin: 15px 0; font-size: 14px; background: #f8f8f8; padding: 10px;">
            <p>전시: <span id="m_title"></span></p>
            <p>위치: <span id="m_address"></span></p>
            <p>방문일: <span id="m_date"></span></p>
        </div>

        <form id="reviewForm">
            <input type="hidden" name="reservation_id" id="m_resId">
            
            <label>별점 <span id="ratingVal">5.0</span></label>
            <div class="star-wrapper">
                <input type="range" id="starRange" name="rating" min="0" max="5" step="0.5" value="5">
                <div id="starDisplay">⭐⭐⭐⭐⭐</div>
            </div>

            <div id="timeZoneArea" style="margin-bottom:15px;">
                <label>방문 시간대</label>
                <div id="timeInputContainer"></div>
            </div>

            <textarea name="content" style="width:100%; height:100px; margin-bottom:15px;" placeholder="소중한 리뷰를 남겨주세요."></textarea>

            <label>사진 업로드 (1장)</label>
            <input type="file" name="reviewPhoto" id="reviewPhoto" accept="image/*" style="margin-bottom:20px;">

            <div style="display:flex; gap:10px;">
                <button type="button" onclick="submitReview()" style="flex:1; padding:10px; background:#4dc3ff; color:white; border:none; border-radius:5px;">등록</button>
                <button type="button" onclick="closeReviewModal()" style="flex:1; padding:10px; background:#ddd; border:none; border-radius:5px;">취소</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openReviewModal(data) {
        // 1. 기본 정보 세팅
        $("#m_resId").val(data.reservation_id);
        $("#m_title").text(data.title);
        $("#m_address").text(data.address);
        $("#m_date").text(data.visitDate);

        // 2. 시간대 처리 (서버에서 준 값이 'ALL'이면 select, 아니면 readonly input)
        let timeHtml = "";
        if(data.visitTime === 'ALL') {
            timeHtml = `<select name="visitTime" style="width:100%; padding:8px;">
                            <option value="MORNING">오전(09:00-12:00)</option>
                            <option value="AFTERNOON">오후(12:00-18:00)</option>
                        </select>`;
        } else {
            timeHtml = `<input type="text" name="visitTime" value="\${data.visitTime}" readonly style="width:100%; padding:8px; background:#eee; border:1px solid #ddd;">`;
        }
        $("#timeInputContainer").html(timeHtml);

        $("#reviewModal").css("display", "flex");
    }

    function closeReviewModal() {
        $("#reviewModal").hide();
        $("#reviewForm")[0].reset();
    }

    // 별점 슬라이더 이벤트
    $("#starRange").on("input", function() {
        let val = parseFloat($(this).val()).toFixed(1);
        $("#ratingVal").text(val);
        // 별 아이콘 로직은 간단히 텍스트로 대체하거나 CSS width로 조절 가능
    });

    function submitReview() {
        const form = $('#reviewForm')[0];
        const formData = new FormData(form);

        $.ajax({
            url: "/gotoday/review/create.do",
            type: "POST",
            data: formData,
            contentType: false,
            processData: false,
            success: function(res) {
                alert("리뷰가 등록되었습니다.");
                location.reload();
            }
        });
    }
</script>
</body>
</html>