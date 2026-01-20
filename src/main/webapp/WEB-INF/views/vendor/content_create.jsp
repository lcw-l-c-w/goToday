<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
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
<link rel="stylesheet" href="${ctx}/css/vendor_content_create.css">
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

    <form class="content-form" method="post" id="frm" 
    	action="${pageContext.request.contextPath}/vendor/${isEdit ? 'content_update' : 'content_create'}" enctype="multipart/form-data">

    <input type="hidden" name="content_id" value="${contentVO.content_id}">

    <!-- 상단 -->
    <button type="button" class="back-btn">←</button>
    <header class="form-header">
        <h1><c:choose><c:when test="${isEdit}">전시 수정</c:when><c:otherwise>새 전시 등록</c:otherwise></c:choose></h1>
    </header>

    <!-- 기본 정보 -->
    <section class="basic-info-section">
        <h2>기본 정보</h2>
        <hr>

		<div class="form-group">
            <label>종류 *</label>
            <div class="radio-group">
                <label class="radio-item">
                    <input type="radio" name="content_kind" value="popup" required <c:if test="${contentVO.content_kind eq 'popup'}">checked</c:if>>
                    <span>팝업스토어</span>
                </label>
                <label class="radio-item">
                    <input type="radio" name="content_kind" value="exhibition" <c:if test="${contentVO.content_kind eq 'exhibition'}">checked</c:if>>
                    <span>전시</span>
                </label>
            </div>
        </div>
        <div class="form-row">
			<div class="form-group">
	            <label>카테고리 *</label>
	            <div class="radio-group">
	                 <select name="category" required>
				        <option value="">카테고리를 선택하세요</option>
				        <option value="식품"
				            <c:if test="${contentVO.category eq '식품'}">selected</c:if>>
				            식품
				        </option>
				        <option value="캐릭터"
				            <c:if test="${contentVO.category eq '캐릭터'}">selected</c:if>>
				            캐릭터
				        </option>
				        <option value="화장품"
				            <c:if test="${contentVO.category eq '화장품'}">selected</c:if>>
				            화장품
				        </option>
				        <option value="미디어"
				            <c:if test="${contentVO.category eq '미디어'}">selected</c:if>>
				            미디어
				        </option>
				        <option value="미술"
				            <c:if test="${contentVO.category eq '미술'}">selected</c:if>>
				            미술
				        </option>
				        <option value="패션"
				            <c:if test="${contentVO.category eq '패션'}">selected</c:if>>
				            패션
				        </option>
				        <option value="디지털/테크"
				            <c:if test="${contentVO.category eq '디지털/테크'}">selected</c:if>>
				            디지털/테크
				        </option>
				        <option value="키즈/반려동물"
				            <c:if test="${contentVO.category eq '키즈/반려동물'}">selected</c:if>>
				            키즈/반려동물
				        </option>
				        <option value="etc"
				            <c:if test="${contentVO.category eq 'etc'}">selected</c:if>>
				            기타 (etc)
				        </option>
				    </select>
	            </div>
	        </div>
			<div class="form-group">
	            <label>장소 태그 *</label>
	            <div class="radio-group">
	                 <select name="place_tag" required>
				        <option value="">장소 태그를 선택하세요</option>
				        <option value="성수"
				            <c:if test="${contentVO.place_tag eq '성수'}">selected</c:if>>
				            성수
				        </option>
				        <option value="홍대"
				            <c:if test="${contentVO.place_tag eq '홍대'}">selected</c:if>>
				            홍대
				        </option>
				        <option value="여의도"
				            <c:if test="${contentVO.place_tag eq '여의도'}">selected</c:if>>
				            여의도
				        </option>
				        <option value="강남"
				            <c:if test="${contentVO.place_tag eq '강남'}">selected</c:if>>
				            강남
				        </option>
				        <option value="혜화"
				            <c:if test="${contentVO.place_tag eq '혜화'}">selected</c:if>>
				            혜화
				        </option>
				        <option value="한남"
				            <c:if test="${contentVO.place_tag eq '한남'}">selected</c:if>>
				            한남
				        </option>
				        <option value="etc"
				            <c:if test="${contentVO.place_tag eq 'etc'}">selected</c:if>>
				            기타 (etc)
				        </option>
				    </select>
	            </div>
	        </div>
        </div>
        <div class="form-group">
            <label>전시명 *</label>
            <input type="text" name="title" placeholder="전시명을 입력하세요" value="${contentVO.title}" required>
        </div>

        <div class="form-group">
            <label>장소 *</label>
            <input type="text" name="location" placeholder="형식 : 도로명 주소 , 상호명 ( , 필수)" value="${contentVO.location}" required>
        </div>

        <div class="form-group">
            <label>수령방법 *</label>
            <div class="radio-group">
                <label class="radio-item">
                    <input type="radio" name="reservation_type" value="true" required <c:if test="${contentVO.reservation_type eq 'true'}">checked</c:if>>
                    <span>예매 필수</span>
                </label>
                <label class="radio-item">
                    <input type="radio" name="reservation_type" value="false" <c:if test="${contentVO.reservation_type eq 'false'}">checked</c:if>>
                    <span>현장 대기</span>
                </label>
            </div>
        </div>
       	<div class="form-group">
            <label>전시 기간 *</label>
            <div class="date-range">
	            <p>시작일</p>
	            <input type="date" name="start_at" value="${contentVO.start_at}" required>
	            <p>~</p>
	            <p>종료일</p>
	            <input type="date" name="end_at" value="${contentVO.end_at}" required>
            </div>
        </div>
        <div class="form-row"  id= "schedule-visual" style="<c:if test='${empty scheduleList}'>display:none</c:if>">
	        <div class="form-group">
	            <div class="schedule-section">
					<label>전시 시간대 등록</label>
					<button type="button" id="addScheduleBtn">+ 시간대 추가</button>
				</div>
			</div>
			<div class="form-group">	
	            <div id="scheduleList">
	            	<c:choose>
	            		<c:when test="${not empty scheduleList}">
	            			<c:forEach var="sch" items="${scheduleList}">
				       			<div class="schedule-item">
								    <input type="text" name="Time[]" value="${sch.time_zone}" required>
								    <button type="button" class="remove-btn">삭제</button>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
				       		<div class="schedule-item">
							    <input type="text" name="Time[]" placeholder="시간대 (예 : 10:00 ~ 11:00)">
							    <button type="button" class="remove-btn">삭제</button>
							</div>
						</c:otherwise>
	            	</c:choose>
    			</div>
	        </div>
	        <div class="form-group">
	        	<label>시간당 티켓 수</label>
	        	<input type="number" name="total_ticket" value="<c:out value='${not empty scheduleList ? scheduleList[0].total_ticket :""}'/>" min="0">
	        </div>
		</div>
        <div class="form-group">
            <label>판매자 인스타그램 주소</label>
            <div class="link-inputs">
                <input type="text" name="instagram_url" placeholder="INSTAGRAM URL" value="${contentVO.instagram_url}">
            </div>
            <label>판매자 엑스 주소</label>
            <div class="link-inputs">
                <input type="text" name="x_url" placeholder="X URL" value="${contentVO.x_url}">
            </div>
        </div>
    </section>

    <!--  대표 포스터 -->
    <section class="form-section">
    <h2>대표 포스터 *</h2>
    <hr>

    <!-- 업로드 버튼 -->
    <div class="poster-upload-header">
        <c:if test="${empty contentVO.main_image_path}">
	        <label for="posterInput" class="upload-btn">이미지 추가</label>
		</c:if>
        <input type="file" name="main_image_file" id="posterInput" accept="image/*">
    </div>

    <!-- 포스터 미리보기 영역 -->
    <div class="poster-preview">
        <div class="poster-placeholder">
            <span id="posterText">대표 포스터를 업로드하세요</span>
            <img id="posterPreviewImg"
			     src="<c:out value='${pageContext.request.contextPath}${contentVO.main_image_path}'/>"
			     alt="포스터 미리보기"
			     class="<c:if test='${not empty contentVO.main_image_path}'>show</c:if>">
        </div>
    </div>
    </section>

    <!-- 상세 정보 -->
    <section class="detail-info-section">
    <h2>상세 정보</h2>
    <hr>

    <div class="form-group">
        <label>전시 소개</label><br>
        <textarea name="description" placeholder="전시에 대한 간단한 소개를 입력하세요">${contentVO.description}</textarea>
    </div>

    <div class="form-row">
        <div class="form-group">
            <label>관람료 *</label>
            <div>
                <span>성인</span><input type="number" name="adult_price" placeholder="0" value="${contentVO.adult_price}" required>원
            </div>
            <div>
                <span>청소년</span><input type="number" name="teen_price" placeholder="0" value="${contentVO.teen_price}" required>원
            </div>
            <div>
                <span>유아</span><input type="number" name="child_price" placeholder="0" value="${contentVO.child_price}" required>원
            </div>
        </div>

        <div class="form-group">
            <div>
            <br><br><br><br>
                <label>운영 시간</label>
                <input type="text" name="content_time" placeholder="00:00 ~ 00:00" value="${contentVO.content_time}">
            </div>
        </div>
    </div>
    </section>


    <!-- 상세 소개 (에디터) -->
    <section class="form-section">
	    <h2>상세 소개</h2>
	    <hr>
	
	    <!-- 네이버 에디터 placeholder -->
	    <textarea name="detail_description" id="detail_description" style="width:100%;">${contentVO.detail_description }</textarea>
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

<c:if test="${not empty contentVO.main_image_path}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const posterText = document.getElementById("posterText");
            const posterImg  = document.getElementById("posterPreviewImg");

            if (posterText) posterText.style.display = "none";
            if (posterImg) posterImg.classList.add("show");
        });
    </script>
</c:if>

<script>
document.addEventListener('DOMContentLoaded', function() {
	
	//수정 모드 + 시간대 전시면 내용 불러옴
	const hasSchedule = ${not empty scheduleList};
	if(hasSchedule) {
		document.getElementById("schedule-visual").style.display = "block";
	}
	
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
    //상시 버튼에 따라 숨기기
    document.querySelectorAll('input[name="reservation_type"]').forEach(radio => {
        radio.addEventListener("change", () => {
            document.getElementById("schedule-visual").style.display =
                radio.value === "true" ? "block" : "none";
        });
    });

    //5개 이상 시 버튼 비활성화
    function updateAddButtonState() {
        const btn = document.getElementById("addScheduleBtn");
        const count = document.getElementById("scheduleList").children.length;

        btn.disabled = count >= 5;
    }
    
    // 스케줄 추가 버튼
    document.getElementById("addScheduleBtn").addEventListener("click", function () {
        const scheduleList = document.getElementById("scheduleList");
        const item = document.createElement("div");
        item.className = "schedule-item";

        item.innerHTML = `
            <input type="text" name="Time[]" placeholder="시간대 (예 : 10:00 ~ 11:00)" required>
            <button type="button" class="remove-btn">삭제</button>
        `;

        scheduleList.appendChild(item);
        updateAddButtonState();
    });

    /* 삭제 버튼 (이벤트 위임) */
    document.addEventListener("click", function (e) {
        if (e.target.classList.contains("remove-btn")) {
            e.target.closest(".schedule-item").remove();
            updateAddButtonState();
        }
    });

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
            	 const reservation = document.querySelector('input[name="reservation_type"]:checked').value;

            	    if (reservation === 'false') {
            	        document.querySelector('input[name="total_ticket"]')?.remove();
            	        document.querySelectorAll('input[name="Time[]"]').forEach(e => e.remove());
            	    }
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