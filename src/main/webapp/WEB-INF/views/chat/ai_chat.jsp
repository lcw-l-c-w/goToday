<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>GoToday AI 비서</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>

    <h2>🤖 GoToday AI 비서 (Test Ver)</h2>
    <hr>
    
    <div id="chatBox" style="width: 500px; height: 400px; border: 1px solid #000; overflow-y: scroll; padding: 10px;">
        <div style="background-color: #eee; padding: 5px; margin-bottom: 5px;">
            <b>AI:</b> 안녕하세요! 예약 내역 조회, 캘린더 추가 등을 도와드릴게요.
        </div>
    </div>

    <br>

    <input type="text" id="userMsg" placeholder="예: 내 예약 내역 보여줘" style="width: 400px; padding: 5px;">
    <button id="btnSend" style="padding: 5px 10px;">전송</button>

    <script>
        $(document).ready(function() {
            
            $("#btnSend").click(function() {
                sendMessage();
            });

            $("#userMsg").keypress(function(e) {
                if (e.which == 13) sendMessage();
            });

            function sendMessage() {
                var msg = $("#userMsg").val();
                if(msg.trim() == "") return;

                // 1. 내 말 화면에 표시
                $("#chatBox").append("<div style='text-align:right; margin:5px;'><b>나:</b> " + msg + "</div>");
                $("#userMsg").val("");
                scrollToBottom();

                // 2. 서버로 전송
                $.ajax({
                    url: "${pageContext.request.contextPath}/api/ai-chat",
                    type: "POST",
                    data: { msg: msg },
                    success: function(response) {
                        // 3. AI 답변 표시
                        $("#chatBox").append("<div style='background-color:#eee; padding:5px; margin:5px;'><b>AI:</b> " + response + "</div>");
                        scrollToBottom();
                    },
                    error: function() {
                        alert("오류가 발생했습니다.");
                    }
                });
            }

            function scrollToBottom() {
                $("#chatBox").scrollTop($("#chatBox")[0].scrollHeight);
            }
        });
    </script>

</body>
</html>