<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
    .site-footer {
        background-color: #fff;
        border-top: 1px solid #eee;
        padding: 50px 0; /* 위아래 여백을 조금 더 넓게 */
        color: #666;
        font-family: 'Pretendard', sans-serif;
    }

    .footer-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
        display: flex;
        align-items: flex-start; /* 상단 정렬 */
        gap: 50px; /* 로고와 정보 사이 간격 */
    }

    /* 로고 영역 */
    .footer-logo {
        flex-shrink: 0; /* 크기 고정 */
        width: 150px;   /* 로고 이미지 크기에 맞춰 조절 */
    }

    .footer-logo img {
        width: 100%;
        height: auto;
        display: block;
        /* 로고가 너무 밝으면 아래 속성 사용 */
        /* filter: grayscale(100%); opacity: 0.8; */
    }

    /* 중앙 정보 영역 */
    .footer-content {
        flex: 1;
        font-size: 13px;
        line-height: 1.8;
    }

    .company-name {
        font-size: 15px;
        font-weight: 700;
        color: #333;
        margin-bottom: 10px;
    }

    .info-line {
        display: flex;
        flex-wrap: wrap;
        gap: 0 15px;
        margin-bottom: 2px;
    }

    .info-line span, .info-line a {
        color: #777;
        position: relative;
    }

    /* 구분선 (|) 추가 */
    .info-line span:not(:last-child)::after {
        content: "";
        display: inline-block;
        width: 1px;
        height: 10px;
        background-color: #ddd;
        margin-left: 15px;
        vertical-align: middle;
    }

    .footer-content a {
        text-decoration: none;
        font-weight: 500;
    }

    .footer-content a:hover {
        text-decoration: underline;
    }

    .copyright {
        margin-top: 15px;
        font-size: 12px;
        color: #aaa;
        letter-spacing: 0.5px;
    }

    /* 우측 보증보험 영역 */
    .footer-right {
        flex-shrink: 0;
        width: 220px;
        text-align: right;
    }

    .sgi-logo {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 8px;
        margin-bottom: 8px;
    }

    .sgi-logo img {
        height: 18px;
    }

    .escrow-info {
        font-size: 11px;
        color: #999;
        line-height: 1.5;
    }
</style>

<footer class="site-footer">
    <div class="footer-container">
        <div class="footer-logo">
            <img src="<c:url value='/img/logo3.png'/>" alt="COMPANY LOGO">
        </div>

        <div class="footer-content">
            <div class="company-name">(주)머지 (MERGE)</div>
            <div class="info-line">
                <span>대표 : 김가빈</span>
                <span>주소 : 서울특별시 마포구 월드컵북로4길 77 (에이아이 복지몰)</span>
            </div>
            <div class="info-line">
                <span>이메일 : <a href="mailto:help@company.com">been.dev.kim@gmail.com</a></span>
                <span>고객센터 : 1588-XXXX</span>
                <a href="${pageContext.request.contextPath}/reply/index.do" style="color: #333; font-weight: 700;">1:1 문의 ></a>
            </div>
            <div class="info-line">
                <span>사업자등록번호 : 000-00-00000</span>
                <span>통신판매업신고 : 제2026-서울OO-0000호</span>
                <a href="#" style="color: #333; font-weight: 700;">사업자 정보 확인 ></a>
            </div>
            <div class="info-line">
                <span>호스팅 서비스사업자 : (주)MERGE</span>
            </div>
            <div class="copyright">
                Copyright © COMPANY Corp. All Rights Reserved.
            </div>
        </div>

        <div class="footer-right">
            <div class="sgi-logo">
                <a href="#" style="font-size: 11px; color: #666; text-decoration: none;">서비스가입사실확인 ></a>
            </div>
            <div class="escrow-info">
                고객님은 안전거래를 위한 현금 등으로 결제 시<br>
                저희 쇼핑몰에서 가입한 구매안전서비스를<br>
                이용하실 수 있습니다.
            </div>
        </div>
    </div>
</footer>