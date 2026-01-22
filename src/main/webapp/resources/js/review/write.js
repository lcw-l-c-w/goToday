// 전역 변수
let reviewOverlay = null;
let currentRating = 5;
let isEditMode = false;

// 상시 전시 여부 판단 (시간 차이 5시간 이상이면 상시)
function checkAllDayExhibition(timeZone) {
    if (!timeZone || timeZone === '' || timeZone === 'ALL') {
        return true;
    }

    const match = timeZone.match(/(\d{1,2}):(\d{2})\s*[~-]\s*(\d{1,2}):(\d{2})/);
    if (!match) {
        return true;
    }

    const startHour = parseInt(match[1], 10);
    const startMinute = parseInt(match[2], 10);
    const endHour = parseInt(match[3], 10);
    const endMinute = parseInt(match[4], 10);

    const startTotalMinutes = startHour * 60 + startMinute;
    const endTotalMinutes = endHour * 60 + endMinute;

    const diffMinutes = endTotalMinutes - startTotalMinutes;
    const diffHours = diffMinutes / 60;

    return diffHours >= 5;
}

// 모달 열기 - 부모 윈도우에 오버레이 생성
function openReviewModal(dto) {
    const parentDoc = window.parent.document;
    const parentBody = parentDoc.body;

    // 기존 오버레이가 있으면 제거
    const existingOverlay = parentDoc.getElementById('reviewModalOverlay');
    if (existingOverlay) {
        existingOverlay.remove();
    }

    // 오버레이 생성
    reviewOverlay = parentDoc.createElement('div');
    reviewOverlay.id = 'reviewModalOverlay';
    reviewOverlay.style.cssText = `
        display: flex;
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background: rgba(0, 0, 0, 0.7);
        z-index: 99999;
        justify-content: center;
        align-items: center;
    `;

    // 모달 컨텐츠 복사
    const modalContent = document.getElementById('reviewModalContent').innerHTML;
    reviewOverlay.innerHTML = modalContent;

    // 부모 body에 추가
    parentBody.appendChild(reviewOverlay);

    // 스타일 추가
    addModalStyles(parentDoc);

    const overlay = reviewOverlay;

    // 리뷰 존재 여부 확인
    isEditMode = dto.reviewExists === true;

    // 모달 제목 및 버튼 설정
    if (isEditMode) {
        overlay.querySelector('#modalTitle').textContent = '리뷰 확인/수정';
        overlay.querySelector('#createButtons').style.display = 'none';
        overlay.querySelector('#editButtons').style.display = 'flex';
    } else {
        overlay.querySelector('#modalTitle').textContent = '리뷰 작성';
        overlay.querySelector('#createButtons').style.display = 'flex';
        overlay.querySelector('#editButtons').style.display = 'none';
    }

    // 기본 데이터 세팅
    overlay.querySelector('#m_resId').value = dto.reservation_id;
    overlay.querySelector('#m_contentId').value = dto.content_id;
    overlay.querySelector('#m_title').textContent = dto.title;
    overlay.querySelector('#m_address').textContent = dto.location || dto.address || '';
    overlay.querySelector('#m_date').textContent = dto.visited_at;
    overlay.querySelector('#m_visitedAt').value = dto.visited_at;

    // 방문 시간대 처리
    setupTimeZone(overlay, dto.visited_time_zone);

    // 수정 모드일 때 기존 리뷰 데이터 채우기
    if (dto.reviewExists && dto.review) {
    const review = dto.review;

    // 모달 타이틀
    overlay.querySelector('#modalTitle').textContent = '리뷰 수정';

    // 버튼 토글
    overlay.querySelector('#createButtons').style.display = 'none';
    overlay.querySelector('#editButtons').style.display = 'flex';

    // 리뷰 기본값 세팅
    overlay.querySelector('#m_reviewId').value = review.review_id;
    overlay.querySelector('#m_content').value = review.content || '';
    overlay.querySelector('#m_rating').value = review.rating || 5;
    overlay.querySelector('#ratingVal').textContent = (review.rating || 5) + '.0';

    // 별점 UI 반영
    updateStars(
        overlay.querySelectorAll('.star-rating .star'),
        review.rating || 5
    );

    // 현재 이미지 세팅
    if (review.image_new) {
        const imageUrl = `/gotoday/uploads/${review.image_new}`;
        overlay.querySelector('#currentImage').src = imageUrl;
        overlay.querySelector('#currentImageArea').style.display = 'block';
        overlay.querySelector('#m_keepImage').value = 'true';
    } else {
        overlay.querySelector('#currentImageArea').style.display = 'none';
        overlay.querySelector('#m_keepImage').value = 'false';
    }

} else {
    // ===== 신규 등록 모드 =====
    overlay.querySelector('#modalTitle').textContent = '리뷰 작성';

    overlay.querySelector('#createButtons').style.display = 'flex';
    overlay.querySelector('#editButtons').style.display = 'none';

    overlay.querySelector('#m_reviewId').value = '';
    overlay.querySelector('#m_content').value = '';
    overlay.querySelector('#m_rating').value = 5;
    overlay.querySelector('#ratingVal').textContent = '5.0';

    overlay.querySelector('#currentImageArea').style.display = 'none';
    overlay.querySelector('#m_keepImage').value = 'true';
}
    

    // 별점 클릭 이벤트 바인딩
    initStarRating(overlay);

    // 버튼 이벤트 바인딩
    bindButtonEvents(overlay);

    // 오버레이 클릭 시 닫기
    reviewOverlay.addEventListener('click', function(e) {
        if (e.target === reviewOverlay) {
            closeReviewModal();
        }
    });
}

// 시간대 설정
function setupTimeZone(overlay, timeZone) {
    const timeContainer = overlay.querySelector('#timeInputContainer');
    const isAllDay = checkAllDayExhibition(timeZone);

    if (timeZone && timeZone !== '' && !isAllDay) {
        overlay.querySelector('#m_visitedTimeZone').value = timeZone;
        timeContainer.innerHTML = `<div class="time-zone-display">${timeZone}</div>`;
    } else {
        timeContainer.innerHTML = `
            <select class="time-zone-select" id="timeZoneSelect">
                <option value="">시간대를 선택하세요</option>
                <option value="MORNING">오전 (09:00-12:00)</option>
                <option value="LAUNCH">점심 (12:00-15:00)</option>
                <option value="AFTERNOON">오후 (15:00-18:00)</option>
                <option value="EVENING">저녁 (18:00-21:00)</option>
            </select>
        `;
        const selectEl = timeContainer.querySelector('#timeZoneSelect');
        selectEl.addEventListener('change', function() {
            overlay.querySelector('#m_visitedTimeZone').value = this.value;
        });
    }
}

// 기존 리뷰 데이터 채우기
function fillReviewData(overlay, review) {
    overlay.querySelector('#m_reviewId').value = review.review_id;
    overlay.querySelector('#m_content').value = review.content;

    // 별점 설정
    currentRating = review.rating || 5;
    overlay.querySelector('#m_rating').value = currentRating;
    overlay.querySelector('#ratingVal').textContent = currentRating + '.0';

    // 별 표시 업데이트
    const stars = overlay.querySelectorAll('.star-rating .star');
    updateStars(stars, currentRating);

    // 시간대 설정 (수정 모드)
    if (review.visited_time_zone) {
        overlay.querySelector('#m_visitedTimeZone').value = review.visited_time_zone;
        const selectEl = overlay.querySelector('#timeZoneSelect');
        if (selectEl) {
            selectEl.value = review.visited_time_zone;
        }
    }

    // 기존 이미지 표시
    if (review.image_new) {
        const imageArea = overlay.querySelector('#currentImageArea');
        const currentImage = overlay.querySelector('#currentImage');
        imageArea.style.display = 'block';
        currentImage.src = '/gotoday_img/' + review.image_new;
        overlay.querySelector('#m_keepImage').value = 'true';

        // 이미지 삭제 버튼 이벤트
        overlay.querySelector('#btnRemoveImage').addEventListener('click', function() {
            imageArea.style.display = 'none';
            overlay.querySelector('#m_keepImage').value = 'false';
        });
    }
}

// 버튼 이벤트 바인딩
function bindButtonEvents(overlay) {
    // 등록 버튼
    const btnSubmit = overlay.querySelector('#btnSubmitReview');
    if (btnSubmit) {
        btnSubmit.addEventListener('click', submitReview);
    }

    // 수정 버튼
    const btnUpdate = overlay.querySelector('#btnUpdateReview');
    if (btnUpdate) {
        btnUpdate.addEventListener('click', updateReview);
    }

    // 삭제 버튼
    const btnDelete = overlay.querySelector('#btnDeleteReview');
    if (btnDelete) {
        btnDelete.addEventListener('click', deleteReview);
    }

    // 취소 버튼들
    const btnClose = overlay.querySelector('#btnCloseReview');
    if (btnClose) {
        btnClose.addEventListener('click', closeReviewModal);
    }

    const btnClose2 = overlay.querySelector('#btnCloseReview2');
    if (btnClose2) {
        btnClose2.addEventListener('click', closeReviewModal);
    }
}

// 부모 문서에 스타일 추가
function addModalStyles(parentDoc) {
    if (parentDoc.getElementById('reviewModalStyles')) return;

    const style = parentDoc.createElement('style');
    style.id = 'reviewModalStyles';
    style.textContent = `
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
            user-select: none;
        }
        .star-rating .star:hover,
        .star-rating .star.active {
            color: #ffcc00;
        }
        #ratingVal {
            font-size: 18px;
            font-weight: bold;
            margin-left: 10px;
            color: #333;
        }
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
    `;
    parentDoc.head.appendChild(style);
}

// 별점 클릭 이벤트 초기화
function initStarRating(overlay) {
    const stars = overlay.querySelectorAll('.star-rating .star');
    const ratingInput = overlay.querySelector('#m_rating');
    const ratingVal = overlay.querySelector('#ratingVal');

    stars.forEach((star, index) => {
        star.addEventListener('click', function() {
            currentRating = parseInt(this.dataset.value);
            ratingInput.value = currentRating;
            ratingVal.textContent = currentRating + '.0';
            updateStars(stars, currentRating);
        });

        star.addEventListener('mouseenter', function() {
            const hoverValue = parseInt(this.dataset.value);
            updateStars(stars, hoverValue);
        });

        star.addEventListener('mouseleave', function() {
            updateStars(stars, currentRating);
        });
    });

    // 초기 별 표시
    updateStars(stars, currentRating);
}

// 별 표시 업데이트
function updateStars(stars, rating) {
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.add('active');
        } else {
            star.classList.remove('active');
        }
    });
}

// 모달 닫기
function closeReviewModal() {
    if (reviewOverlay) {
        reviewOverlay.remove();
        reviewOverlay = null;
    }
    isEditMode = false;
    currentRating = 5;
}

// 리뷰 등록
function submitReview() {
    const parentDoc = window.parent.document;
    const form = parentDoc.querySelector('#reviewForm');

    if (!form) {
        alert('폼을 찾을 수 없습니다.');
        return;
    }

    const formData = new FormData(form);

    const content = formData.get('content');
    if (!content || content.trim() === '') {
        alert('리뷰 내용을 입력해주세요.');
        return;
    }

    $.ajax({
        url: "/gotoday/review/create.do",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function(res) {
            if (res.success) {
                alert("리뷰가 등록되었습니다.");
                closeReviewModal();
                location.reload();
            } else {
                alert(res.message || "리뷰 등록에 실패했습니다.");
            }
        },
        error: function() {
            alert("서버 오류가 발생했습니다.");
        }
    });
}

// 리뷰 수정
function updateReview() {
    const parentDoc = window.parent.document;
    const form = parentDoc.querySelector('#reviewForm');

    if (!form) {
        alert('폼을 찾을 수 없습니다.');
        return;
    }

    const formData = new FormData(form);

    const content = formData.get('content');
    if (!content || content.trim() === '') {
        alert('리뷰 내용을 입력해주세요.');
        return;
    }

    $.ajax({
        url: "/gotoday/review/update.do",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function(res) {
            if (res.success) {
                alert("리뷰가 수정되었습니다.");
                closeReviewModal();
                location.reload();
            } else {
                alert(res.message || "리뷰 수정에 실패했습니다.");
            }
        },
        error: function() {
            alert("서버 오류가 발생했습니다.");
        }
    });
}

// 리뷰 삭제
function deleteReview() {
    if (!confirm('정말로 리뷰를 삭제하시겠습니까?')) {
        return;
    }

    const parentDoc = window.parent.document;
    const reviewId = parentDoc.querySelector('#m_reviewId').value;

    if (!reviewId) {
        alert('리뷰 정보를 찾을 수 없습니다.');
        return;
    }

    $.ajax({
        url: "/gotoday/review/delete.do",
        type: "POST",
        data: { review_id: reviewId },
        success: function(res) {
            if (res.success) {
                alert("리뷰가 삭제되었습니다.");
                closeReviewModal();
                location.reload();
            } else {
                alert(res.message || "리뷰 삭제에 실패했습니다.");
            }
        },
        error: function() {
            alert("서버 오류가 발생했습니다.");
        }
    });
}
