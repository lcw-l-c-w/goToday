<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>
  	<c:choose>
  		<c:when test="${isEdit}">전시 수정</c:when>
  		<c:otherwise>새 전시 등록</c:otherwise>
  	</c:choose>
  </title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background-color: #f5f5f5;
      color: #333;
      line-height: 1.6;
    }

    .page-wrapper {
      min-height: 100vh;
      padding: 40px 20px;
    }

    .content-container {
      max-width: 800px;
      margin: 0 auto;
    }

    .content-form {
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
      padding: 40px;
    }

    /* 뒤로가기 버튼 */
    .back-btn {
      background: none;
      border: none;
      font-size: 24px;
      cursor: pointer;
      color: #666;
      padding: 8px 12px;
      border-radius: 8px;
      transition: background-color 0.2s;
    }

    .back-btn:hover {
      background-color: #f0f0f0;
    }

    /* 헤더 */
    .form-header {
      text-align: center;
      margin-bottom: 40px;
    }

    .form-header h1 {
      font-size: 28px;
      font-weight: 700;
      color: #222;
    }

    .form-header .reject-notice {
      color: #e74c3c;
      font-size: 14px;
      margin-top: 12px;
      padding: 10px 16px;
      background-color: #fdf2f2;
      border-radius: 6px;
      display: inline-block;
    }

    /* 섹션 공통 */
    section {
      margin-bottom: 40px;
    }

    section h2 {
      font-size: 18px;
      font-weight: 600;
      color: #333;
      margin-bottom: 12px;
    }

    section hr {
      border: none;
      border-top: 2px solid #4a90d9;
      margin-bottom: 24px;
    }

    /* 폼 그룹 */
    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      font-size: 14px;
      font-weight: 600;
      color: #555;
      margin-bottom: 8px;
    }

    .form-group input[type="text"],
    .form-group input[type="number"],
    .form-group input[type="date"],
    .form-group textarea {
      width: 100%;
      padding: 12px 16px;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 14px;
      transition: border-color 0.2s, box-shadow 0.2s;
    }

    .form-group input:focus,
    .form-group textarea:focus {
      outline: none;
      border-color: #4a90d9;
      box-shadow: 0 0 0 3px rgba(74, 144, 217, 0.1);
    }

    .form-group input::placeholder,
    .form-group textarea::placeholder {
      color: #aaa;
    }

    /* 라디오 버튼 스타일 */
    .radio-group {
      display: flex;
      gap: 24px;
      margin-top: 8px;
    }

    .radio-item {
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
    }

    .radio-item input[type="radio"] {
      width: 18px;
      height: 18px;
      accent-color: #4a90d9;
      cursor: pointer;
    }

    .radio-item span {
      font-size: 14px;
      color: #555;
    }

    /* 날짜 범위 */
    .date-range {
      display: flex;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }

    .date-range p {
      font-size: 14px;
      color: #666;
    }

    .date-range input[type="date"] {
      padding: 10px 14px;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 14px;
    }

    /* 링크 입력 */
    .link-inputs {
      margin-bottom: 16px;
    }

    .link-inputs input {
      background-color: #fafafa;
    }

    /* 포스터 업로드 */
    .poster-upload-header {
      display: flex;
      gap: 12px;
      margin-bottom: 16px;
    }

    .upload-btn {
      display: inline-block;
      padding: 10px 20px;
      background-color: #4a90d9;
      color: #fff;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 500;
      cursor: pointer;
      transition: background-color 0.2s;
    }

    .upload-btn:hover {
      background-color: #3a7bc8;
    }

    #posterInput {
      display: none;
    }

    .poster-preview {
      border: 2px dashed #ddd;
      border-radius: 12px;
      padding: 40px;
      text-align: center;
      background-color: #fafafa;
      min-height: 200px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .poster-placeholder {
      color: #999;
      font-size: 14px;
    }

    .poster-placeholder img {
      max-width: 100%;
      max-height: 300px;
      margin-top: 16px;
      border-radius: 8px;
      display: none;
    }

    .poster-placeholder img.show {
      display: block;
    }

    /* 상세 정보 */
    .detail-info-section textarea {
      min-height: 120px;
      resize: vertical;
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
    }

    @media (max-width: 600px) {
      .form-row {
        grid-template-columns: 1fr;
      }
    }

    .form-row .form-group > div {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 12px;
    }

    .form-row .form-group > div span {
      min-width: 50px;
      font-size: 14px;
      color: #666;
    }

    .form-row .form-group > div input {
      flex: 1;
      padding: 10px 14px;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 14px;
    }

    .form-row .form-group > div label {
      display: inline;
      margin-bottom: 0;
      margin-right: 8px;
    }

    /* 에디터 영역 */
    .editor-placeholder {
      border: 1px solid #ddd;
      border-radius: 8px;
      padding: 40px;
      background-color: #fafafa;
      text-align: center;
      color: #999;
      min-height: 300px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    /* 하단 버튼 */
    .form-footer {
      display: flex;
      justify-content: center;
      gap: 16px;
      margin-top: 40px;
      padding-top: 32px;
      border-top: 1px solid #eee;
    }

    .cancel-btn,
    .submit-btn {
      padding: 14px 40px;
      font-size: 16px;
      font-weight: 600;
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.2s;
    }

    .cancel-btn {
      background-color: #fff;
      border: 1px solid #ddd;
      color: #666;
    }

    .cancel-btn:hover {
      background-color: #f5f5f5;
      border-color: #ccc;
    }

    .submit-btn {
      background-color: #4a90d9;
      border: none;
      color: #fff;
    }

    .submit-btn:hover {
      background-color: #3a7bc8;
    }

    /* 입력 필드 에러 상태 */
    .form-group input.error,
    .form-group textarea.error {
      border-color: #e74c3c;
    }

    .error-message {
      color: #e74c3c;
      font-size: 12px;
      margin-top: 4px;
    }
  </style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="/gotoday/smarteditor/js/HuskyEZCreator.js"></script>
<script>
//네이버 스마트 에디터
var oEditors = [];
$(function() {
    nhn.husky.EZCreator.createInIFrame({
        oAppRef: oEditors,
        elPlaceHolder: "detail_description",
        sSkinURI: "/gotoday/smarteditor/SmartEditor2Skin.html",    
        htParams : {
            bUseToolbar : true,                // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseVerticalResizer : true,        // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseModeChanger : true,            // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
            fOnBeforeUnload : function(){
            }
        }, //boolean
        fOnAppLoad : function(){
            //예제 코드
            //oEditors.getById["contents"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
        },
        fCreator: "createSEditor2"
    });
})
</script>
</head>
<body>

<div class="page-wrapper">
  <div class="content-container">

    <form class="content-form" method="post" id="frm" action="<c:choose><c:when test='${isEdit}'>update</c:when><c:otherwise>content_create</c:otherwise></c:choose>"  enctype="multipart/form-data">

    <!-- 수정 모드일 때 content_id 전달 -->
    <c:if test="${isEdit}">
        <input type="hidden" name="content_id" value="${contentVo.content_id}">
    </c:if>

    <!-- 상단 -->
    <button type="button" class="back-btn">←</button>
    <header class="form-header">
        <h1><c:choose><c:when test="${isEdit}">전시 수정</c:when><c:otherwise>새 전시 등록</c:otherwise></c:choose></h1>
        <c:if test="${isEdit}">
            <p class="reject-notice">* 거절된 콘텐츠입니다. 내용을 수정하여 다시 제출해주세요.</p>
        </c:if>
    </header>

    <!-- 기본 정보 -->
    <section class="basic-info-section">
        <h2>기본 정보</h2>
        <hr>

		<div class="form-group">
            <label>종류 *</label>
            <div class="radio-group">
                <label class="radio-item">
                    <input type="radio" name="content_kind" value="popup" required <c:if test="${content.content_kind eq 'popup'}">checked</c:if>>
                    <span>팝업스토어</span>
                </label>
                <label class="radio-item">
                    <input type="radio" name="content_kind" value="exhibition" <c:if test="${content.content_kind eq 'exhibition'}">checked</c:if>>
                    <span>전시</span>
                </label>
            </div>
        </div>
		<div class="form-group">
            <label>카테고리 *</label>
            <div class="radio-group">
                 <select name="category" required>
			        <option value="">카테고리를 선택하세요</option>
			        <option value="식품"
			            <c:if test="${content.category eq '식품'}">selected</c:if>>
			            식품
			        </option>
			
			        <option value="캐릭터"
			            <c:if test="${content.category eq '캐릭터'}">selected</c:if>>
			            캐릭터
			        </option>
			
			        <option value="화장품"
			            <c:if test="${content.category eq '화장품'}">selected</c:if>>
			            화장품
			        </option>
			
			        <option value="미디어"
			            <c:if test="${content.category eq '미디어'}">selected</c:if>>
			            미디어
			        </option>
			
			        <option value="미술"
			            <c:if test="${content.category eq '미술'}">selected</c:if>>
			            미술
			        </option>
			
			        <option value="패션"
			            <c:if test="${content.category eq '패션'}">selected</c:if>>
			            패션
			        </option>
			
			        <option value="디지털/테크"
			            <c:if test="${content.category eq '디지털/테크'}">selected</c:if>>
			            디지털/테크
			        </option>
			
			        <option value="키즈/반려동물"
			            <c:if test="${content.category eq '키즈/반려동물'}">selected</c:if>>
			            키즈/반려동물
			        </option>
			
			        <option value="etc"
			            <c:if test="${content.category eq 'etc'}">selected</c:if>>
			            기타 (etc)
			        </option>
			    </select>
            </div>
        </div>
        <div class="form-group">
            <label>전시명 *</label>
            <input type="text" name="title" placeholder="전시명을 입력하세요" value="${content.title}" required>
        </div>

        <div class="form-group">
            <label>장소 *</label>
            <input type="text" name="location" placeholder="형식 : 도로명 주소 , 상호명 ( , 필수)" value="${content.location}" required>
        </div>

        <div class="form-group">
            <label>수령방법 *</label>
            <div class="radio-group">
                <label class="radio-item">
                    <input type="radio" name="reservation_type" value="onsite" required <c:if test="${content.reservation_type eq 'onsite'}">checked</c:if>>
                    <span>현장수령 (상시전시)</span>
                </label>
                <label class="radio-item">
                    <input type="radio" name="reservation_type" value="advance" <c:if test="${content.reservation_type eq 'advance'}">checked</c:if>>
                    <span>사전예매</span>
                </label>
            </div>
        </div>
        <div class="form-group">
            <label>전시 기간 *</label>
            <div class="date-range">
            <p>시작일</p>
            <input type="date" name="start_at" value="${content.startDate}" required>
            <p>~</p>
            <p>종료일</p>
            <input type="date" name="end_at" value="${content.endDate}" required>
            </div>
        </div>

        <div class="form-group">
            <label>판매자 인스타그램 주소</label>
            <div class="link-inputs">
                <input type="text" name="instagram_url" placeholder="INSTAGRAM URL" value="${content.instagram_url}">
            </div>
            <label>판매자 엑스 주소</label>
            <div class="link-inputs">
                <input type="text" name="x_url" placeholder="X URL" value="${content.x_url}">
            </div>
        </div>
    </section>

    <!--  대표 포스터 -->
    <section class="form-section">
    <h2>대표 포스터 *</h2>
    <hr>

    <!-- 업로드 버튼 -->
    <div class="poster-upload-header">
        <label for="posterInput" class="upload-btn">이미지 추가</label>
        <c:if test="${!empty content.main_image_path}">
			<input type="checkbox" name="fileDelete" value="ok"> 기존파일삭제
		</c:if>
        <input type="file" name="main_image_file" id="posterInput" accept="image/*" required>
    </div>

    <!-- 포스터 미리보기 영역 -->
    <div class="poster-preview">
        <div class="poster-placeholder">
            <span id="posterText">대표 포스터를 업로드하세요</span>
            <img id="posterPreviewImg" src="" alt="포스터 미리보기">
        </div>
    </div>
    </section>

    <!-- 상세 정보 -->
    <section class="detail-info-section">
    <h2>상세 정보</h2>
    <hr>

    <div class="form-group">
        <label>전시 소개</label><br>
        <textarea name="description" placeholder="전시에 대한 간단한 소개를 입력하세요">${content.description}</textarea>
    </div>

    <div class="form-row">
        <div class="form-group">
            <label>관람료 *</label>
            <div>
                <span>성인</span><input type="number" name="adult_price" placeholder="0" value="${content.adult_price}" required>원
            </div>
            <div>
                <span>청소년</span><input type="number" name="teen_price" placeholder="0" value="${content.teen_price}" required>원
            </div>
            <div>
                <span>유아</span><input type="number" name="child_price" placeholder="0" value="${content.child_price}" required>원
            </div>
        </div>

        <div class="form-group">
            <div>
            <br><br><br><br>
                <label>운영 시간</label>
                <input type="text" name="content_time_weekday" placeholder="00:00 ~ 00:00" value="${content.content_time}">
            </div>
        </div>
    </div>
    </section>


    <!-- 상세 소개 (에디터) -->
    <section class="form-section">
	    <h2>상세 소개</h2>
	    <hr>
	
	    <!-- 네이버 에디터 placeholder -->
	    <textarea name="detail_description" id="detail_description" style="width:100%;">${content.detail_description }</textarea>
    </section>

    <!-- 하단 버튼 -->
    <footer class="form-footer">
    <button type="button" class="cancel-btn">취소</button>
    <button type="submit" class="submit-btn">
        <c:choose>
            <c:when test="${isEdit}">수정하기</c:when>
            <c:otherwise>등록하기</c:otherwise>
        </c:choose>
    </button>
    </footer>

    </form>

  </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 뒤로가기 버튼
    const backBtn = document.querySelector('.back-btn');
    if (backBtn) {
        backBtn.addEventListener('click', function() {
            if (confirm('작성 중인 내용이 저장되지 않습니다. 뒤로 가시겠습니까?')) {
                history.back();
            }
        });
    }

    // 취소 버튼
    const cancelBtn = document.querySelector('.cancel-btn');
    if (cancelBtn) {
        cancelBtn.addEventListener('click', function() {
            if (confirm('작성을 취소하시겠습니까? 입력한 내용은 저장되지 않습니다.')) {
                history.back();
            }
        });
    }

    // 포스터 이미지 업로드 미리보기
    const posterInput = document.getElementById('posterInput');
    const posterPreviewImg = document.getElementById('posterPreviewImg');
    const posterText = document.getElementById('posterText');

    if (posterInput) {
        posterInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                // 파일 타입 검증
                if (!file.type.startsWith('image/')) {
                    alert('이미지 파일만 업로드 가능합니다.');
                    return;
                }

                // 파일 크기 검증 (5MB 제한)
                if (file.size > 5 * 1024 * 1024) {
                    alert('파일 크기는 5MB 이하만 가능합니다.');
                    return;
                }

                const reader = new FileReader();
                reader.onload = function(e) {
                    posterPreviewImg.src = e.target.result;
                    posterPreviewImg.classList.add('show');
                    posterText.style.display = 'none';
                };
                reader.readAsDataURL(file);
            }
        });
    }

    // 날짜 유효성 검사 (종료일이 시작일보다 빠르면 안됨)
    const dateInputs = document.querySelectorAll('.date-range input[type="date"]');
    if (dateInputs.length >= 2) {
        const startDate = dateInputs[0];
        const endDate = dateInputs[1];

        endDate.addEventListener('change', function() {
            if (startDate.value && endDate.value) {
                if (new Date(endDate.value) < new Date(startDate.value)) {
                    alert('종료일은 시작일보다 이후여야 합니다.');
                    endDate.value = '';
                }
            }
        });

        startDate.addEventListener('change', function() {
            if (startDate.value && endDate.value) {
                if (new Date(endDate.value) < new Date(startDate.value)) {
                    endDate.value = '';
                }
            }
        });
    }

    // 폼 제출 유효성 검사
    const form = document.querySelector('.content-form');
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            // 필수 필드 검사
            const title = form.querySelector('input[placeholder="전시명을 입력하세요"]');
            const location = form.querySelector('input[name="location"]');
            const receiveMethod = form.querySelector('input[name="reservation_type"]:checked');

            let isValid = true;
            let errorMessages = [];

            if (!title || !title.value.trim()) {
                isValid = false;
                errorMessages.push('전시명을 입력해주세요.');
                if (title) title.classList.add('error');
            } else if (title) {
                title.classList.remove('error');
            }

            if (!location || !location.value.trim()) {
                isValid = false;
                errorMessages.push('장소를 입력해주세요.');
                if (location) location.classList.add('error');
            } else if (location) {
                location.classList.remove('error');
            }

            if (!receiveMethod) {
                isValid = false;
                errorMessages.push('수령방법을 선택해주세요.');
            }

            if (dateInputs.length >= 2) {
                if (!dateInputs[0].value || !dateInputs[1].value) {
                    isValid = false;
                    errorMessages.push('전시 기간을 입력해주세요.');
                }
            }

            if (!isValid) {
                alert(errorMessages.join('\n'));
                return;
            }

            // 유효성 검사 통과 시 폼 제출
            if (confirm('전시를 등록하시겠습니까?')) {
            	oEditors.getById["detail_description"].exec("UPDATE_CONTENTS_FIELD", []);
            	document.getElementById("frm").submit();
            }
        });
    }

    // 숫자 입력 필드 음수 방지
    const numberInputs = document.querySelectorAll('input[type="number"]');
    numberInputs.forEach(function(input) {
        input.addEventListener('input', function() {
            if (this.value < 0) {
                this.value = 0;
            }
        });
    });
    
});
</script>

</body>
</html>