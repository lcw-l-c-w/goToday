<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GoToday | My Page</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        :root { --main-color: #4dc3ff; --border-color: #eee; --text-gray: #666; }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Pretendard', sans-serif; background-color: #fff; color: #333; }

        .container { max-width: 1100px; margin: 40px auto; padding: 0 20px; }
        
        /* 상단 프로필 영역 */
        .profile-section {
            display: flex;
            align-items: center;
            padding: 40px;
            background: #fcfcfc;
            border: 1px solid var(--border-color);
            border-radius: 15px;
            margin-bottom: 50px;
        }
        .profile-img { width: 100px; height: 100px; background: #eee; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 50px; }
        .profile-text { margin-left: 30px; }
        .profile-text h2 { font-size: 24px; font-weight: bold; }
        .profile-text p { color: var(--text-gray); margin-top: 5px; }
        
        /* 마이페이지 탭 메뉴 */
        .mypage-tabs {
            display: flex;
            list-style: none;
            border-bottom: 2px solid #eee;
            margin-bottom: 30px;
        }
        .tab-item {
            padding: 15px 30px;
            cursor: pointer;
            font-weight: bold;
            color: #999;
            transition: 0.3s;
        }
        .tab-item.active {
            color: #333;
            border-bottom: 3px solid var(--main-color);
        }

        /* 예약 카드 그리드 레이아웃 (카드형 반복문 핵심) */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
        }

        .res-card {
            border: 1px solid var(--border-color);
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }
        .res-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.08);
        }
        .res-thumb {
            width: 100%;
            height: 180px;
            object-fit: cover;
            background: #f0f0f0;
        }
        .res-content { padding: 15px; }
        .res-tag {
            display: inline-block;
            padding: 2px 8px;
            background: var(--main-color);
            color: #fff;
            font-size: 11px;
            border-radius: 4px;
            margin-bottom: 10px;
        }
        .res-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 8px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .res-info { font-size: 13px; color: var(--text-gray); line-height: 1.5; }
        
        .empty-msg {
            grid-column: 1 / -1;
            text-align: center;
            padding: 100px 0;
            color: #999;
        }
    </style>
</head>
<body>

<div class="container">
    <section class="profile-section">
        <div class="profile-img">👤</div>
        <div class="profile-text">
            <h2>${loginMember.name}님 반가워요!</h2>
            <p>${loginMember.email}</p>
        </div>
    </section>

    <ul class="mypage-tabs">
        <li class="tab-item active">나의 예매 내역</li>
        <li class="tab-item">찜한 목록</li>
        <li class="tab-item">문의 내역</li>
    </ul>

    <div class="card-grid">
        <c:choose>
            <c:when test="${not empty reserveList}">
                <c:forEach var="res" items="${reserveList}">
                    <div class="res-card" onclick="location.href='/gotoday/reserve/detail?id=${res.reserve_id}'">
                        <img src="${pageContext.request.contextPath}${res.main_image_path}" class="res-thumb">
                        <div class="res-content">
                            <span class="res-tag">예약완료</span>
                            <div class="res-title">${res.title}</div>
                            <div class="res-info">
                                📅 ${res.reserved_at}<br>
                                🕒 ${res.time_zone}<br>
                                🎫 ${res.total_quantity}매
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="res-card">
                    <img src="https://via.placeholder.com/300x200" class="res-thumb">
                    <div class="res-content">
                        <span class="res-tag">예시</span>
                        <div class="res-title">아직 예매 내역이 없어요.</div>
                        <div class="res-info">새로운 전시를 찾아보세요!</div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    $(function() {
        // 탭 전환 이벤트
        $(".tab-item").click(function() {
            $(".tab-item").removeClass("active");
            $(this).addClass("active");
            // 탭 클릭시 AJAX로 데이터를 다시 불러오거나 섹션을 숨길 수 있습니다.
        });
    });
</script>

</body>
</html>