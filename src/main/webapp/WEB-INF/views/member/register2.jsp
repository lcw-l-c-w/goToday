<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입-관심사입력</title>
</head>
<body>
<div class="container">
    <div class="step-container">
        <span class="step">정보입력</span>
        <span class="step active">관심사 입력</span>
        <span class="step">가입완료</span>
    </div>

    <form action="/registerUser" method="POST">
        <section class="interest-section">
            <h3 class="section-title">전시 or 팝업</h3>
            <div class="tag-group">
                <input type="radio" name="content_status" id="type_exhibit" value="EXHIBIT" class="tag-item">
                <label for="type_exhibit" class="tag-label">전시</label>

                <input type="radio" name="content_status" id="type_popup" value="POPUP" class="tag-item">
                <label for="type_popup" class="tag-label">팝업</label>
            </div>
        </section>

        <section class="interest-section">
            <h3 class="section-title">사람들이 많이가는 핫 플레이스!</h3>
            <div class="tag-group">
                <input type="checkbox" name="location" value="성수" id="loc_성수" class="tag-item">
                <label for="loc_성수" class="tag-label">성수</label>

                <input type="checkbox" name="location" value="홍대" id="loc_홍대" class="tag-item">
                <label for="loc_홍대" class="tag-label">홍대</label>

                <input type="checkbox" name="location" value="여의도" id="loc_여의도" class="tag-item">
                <label for="loc_여의도" class="tag-label">여의도</label>

                <input type="checkbox" name="location" value="강남" id="loc_강남" class="tag-item">
                <label for="loc_강남" class="tag-label">강남</label>

                <input type="checkbox" name="location" value="혜화" id="loc_혜화" class="tag-item">
                <label for="loc_혜화" class="tag-label">혜화</label>

                <input type="checkbox" name="location" value="한남" id="loc_한남" class="tag-item">
                <label for="loc_한남" class="tag-label">한남</label>
            </div>
        </section>

        <section class="interest-section">
            <h3 class="section-title">관심있는 분야</h3>
            <div class="tag-group">
                <input type="checkbox" name="category" value="식품" id="cat_식품" class="tag-item">
                <label for="cat_식품" class="tag-label">식품</label>

                <input type="checkbox" name="category" value="캐릭터" id="cat_캐릭터" class="tag-item">
                <label for="cat_캐릭터" class="tag-label">캐릭터</label>

                <input type="checkbox" name="category" value="화장품" id="cat_화장품" class="tag-item">
                <label for="cat_화장품" class="tag-label">화장품</label>

                <input type="checkbox" name="category" value="미디어" id="cat_미디어" class="tag-item">
                <label for="cat_미디어" class="tag-label">미디어</label>

                <input type="checkbox" name="category" value="미술" id="cat_미술" class="tag-item">
                <label for="cat_미술" class="tag-label">미술</label>

                <input type="checkbox" name="category" value="패션" id="cat_패션" class="tag-item">
                <label for="cat_패션" class="tag-label">패션</label>

                <input type="checkbox" name="category" value="디지털/테크" id="cat_디지털/테크" class="tag-item">
                <label for="cat_디지털/테크" class="tag-label">디지털/테크</label>

                <input type="checkbox" name="category" value="키즈/반려동물" id="cat_키즈/반려동물" class="tag-item">
                <label for="cat_키즈/반려동물" class="tag-label">키즈/반려동물</label>

                <input type="checkbox" name="category" value="etc" id="cat_etc" class="tag-item">
                <label for="cat_etc" class="tag-label">etc</label>
            </div>
        </section>

        <div class="footer">
            <button type="submit" class="next-btn">다음단계</button>
        </div> 
    </form>
</div>
</body>
</html>