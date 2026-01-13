<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <div class="wrap">
  <div class="sub">
    <div class="size">

      <!-- 게시판 제목 -->
      <h3 class="sub_title">답변 게시판</h3>

      <div class="bbs">

        <!-- ================= 사용자 문의글 VIEW ================= -->
        <div class="view">

          <!-- 제목 영역 -->
          <div class="title">
            <dl>
              <dt>두준쿠 팝업 넣어주세요</dt>
              <dd class="date">작성일 : 2026-01-05 10:12:43</dd>
            </dl>
          </div>

          <!-- 내용 -->
          <div class="cont">
            두준쿠 팝업 넣어주세요
          </div>

          <!-- 버튼 영역 -->
          <div class="btnSet clear">
            <div class="fl_l">

              <!-- 공통 -->
              <a href="#" class="btn">목록</a>

              <!-- 관리자만 노출 -->
              <!-- ADMIN -->
              <a href="#" class="btn">답변</a>

              <!-- 작성자만 노출 -->
              <!-- USER (본인 글) -->
              <a href="#" class="btn">수정</a>

            </div>
          </div>

        </div>
        <!-- ================= 사용자 문의글 VIEW END ================= -->


        <!-- ================= 관리자 답변 VIEW ================= -->
        <!-- 답변이 있을 때만 노출 -->
        <div class="view reply">

          <div class="title">
            <dl>
              <dt>관리자 답변</dt>
              <dd class="date">답변일 : 2026-01-05 12:30:10</dd>
            </dl>
          </div>

          <div class="cont">
            안녕하세요.<br>
            두준쿠 팝업은 내부 검토 후 반영 예정입니다.<br>
            감사합니다.
          </div>

          <!-- 관리자만 노출 -->
          <div class="btnSet clear">
            <div class="fl_l">
              <a href="#" class="btn">수정</a>
            </div>
          </div>

        </div>
        <!-- ================= 관리자 답변 VIEW END ================= -->


      </div>
    </div>
  </div>
</div>
</body>
</html>
</html>