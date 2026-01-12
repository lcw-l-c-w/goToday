<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- 오른쪽: 실시간 채팅 UI -->
<div class="space-y-4">

 <!-- 실시간 채팅 영역 -->
 <div class="bg-white border rounded-xl p-4 h-80 overflow-y-auto">
   <!-- 채팅 메시지 예시 -->
   <div class="space-y-2 text-sm">
     <div class="text-left">
       <span class="font-bold text-gray-700">관람객</span>
       <p class="bg-gray-100 inline-block px-3 py-2 rounded-lg mt-1">
         전시 관람 시간은 얼마나 걸리나요?
       </p>
     </div>

     <div class="text-right">
       <span class="font-bold text-blue-600">관리자</span>
       <p class="bg-blue-100 inline-block px-3 py-2 rounded-lg mt-1">
         평균적으로 1시간 정도 소요됩니다 😊
       </p>
     </div>
   </div>
 </div>

  <!-- 채팅 입력 영역 -->
<div class="border-t pt-3 flex items-center gap-2">
  
  <!-- 입력창 -->
  <input
    type="text"
    id="chatInput"
    placeholder="메시지를 입력하세요"
    class="flex-1 border rounded-full px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"
  />

  <!-- 전송 버튼 -->
  <button
    id="sendBtn"
    class="bg-blue-500 hover:bg-blue-600 text-white text-sm px-4 py-2 rounded-full"
  >
    전송
  </button>
</div>
</body>
</html>