package kr.co.gotoday.chatbot;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.gotoday.calendar.CalendarService;
import kr.co.gotoday.content.ContentSearchDTO; // ★ DTO 추가
import kr.co.gotoday.content.ContentService;
import kr.co.gotoday.content.MainContentViewDTO; // ★ 결과 DTO 변경
import kr.co.gotoday.reservation.ReservationListDTO;
import kr.co.gotoday.reservation.ReservationService;
import kr.co.gotoday.user.CalendarVO;

@Service
public class AiChatService {

    @Autowired private ReservationService reservationService;
    @Autowired private CalendarService calendarService;
    @Autowired private ContentService contentService;

    private final String OLLAMA_URL = "http://localhost:11434/api/generate";
    private final String MODEL_NAME = "gemma3"; 

    public String processUserRequest(String userMsg, int userId) {
        
        // (프롬프트는 기존과 동일)
//        String systemPrompt = 
//            "너는 전시회 예약 시스템 'GoToday'의 AI 비서야. 아래 규칙에 따라 답변해.\n" +
//            "사용자 질문: " + userMsg + "\n\n" +
//            "규칙:\n" +
//            "1. 예약 내역을 물으면 'CMD:HISTORY' 라고 답해.\n" +
//            "2. 캘린더 추가를 원하면 'CMD:ADD_CALENDAR|전시명|YYYY-MM-DD' 형식으로 답해.\n" +
//            "3. 전시회 정보나 검색을 요청하면 'CMD:SEARCH|검색어' 라고 답해. (예: 코난 찾아줘 -> CMD:SEARCH|코난)\n" +
//            "4. 예약/취소 방법을 물으면 'CMD:LINK_GUIDE' 라고 답해.\n" +
//            "5. 그 외 질문은 'CMD:OTHER' 라고 답해.\n" +
//            "단답형 명령어로만 대답해.";
    	String systemPrompt = 
    		    "너는 전시회 예약 시스템 'GoToday'의 AI 비서야. 아래 규칙에 따라 답변해.\n" +
    		    "사용자 질문: " + userMsg + "\n\n" +
    		    "규칙:\n" +
    		    // ★ 1번 수정: '조회', '보여줘', '뭐 있어' 처럼 확인하는 말만 HISTORY로 오게 함
    		    "1. 예약된 내역이나 표를 '확인'하거나 '보여달라'고 하면 'CMD:HISTORY' 라고 답해.\n" +
    		    
    		    "2. 캘린더 추가를 원하면 'CMD:ADD_CALENDAR|전시명|YYYY-MM-DD' 형식으로 답해.\n" +
    		    "3. 전시회 정보나 검색을 요청하면 'CMD:SEARCH|검색어' 라고 답해.\n" +
    		    
    		    // ★ 4번 수정: '취소', '환불', '하고 싶어'를 강력하게 넣음
    		    "4. '취소'하고 싶거나, '환불' 를 물으면 무조건 'CMD:LINK_GUIDE' 라고 답해.\n" +
    		    
    		    "5. 그 외 질문은 'CMD:OTHER' 라고 답해.\n" +
    		    "단답형 명령어로만 대답해.";

        String aiResponse = callOllama(systemPrompt);

        // 라우팅 로직
        if (aiResponse.contains("CMD:HISTORY")) {
            return getReservationHistory(userId);
            
        } else if (aiResponse.contains("CMD:ADD_CALENDAR")) {
            return addToCalendar(aiResponse, userId);
            
        } else if (aiResponse.contains("CMD:SEARCH")) {
            // ★ 기존 검색 서비스 연결
            return searchContent(aiResponse);
            
        } else if (aiResponse.contains("CMD:LINK_GUIDE")) {
            return "예약 및 취소는 마이페이지에서 가능합니다.<br><a href='/gotoday/mypage/main'>[마이페이지 바로가기]</a>";
            
        } else {
            return "정확한 안내를 위해 1:1 문의를 이용해주세요.<br><a href='/gotoday/mypage/reply_list'>[1:1 문의 바로가기]</a>";
        }
    }

    // ★ [수정됨] 기존 ContentSearchDTO를 활용한 검색
    private String searchContent(String cmd) {
        try {
            // CMD:SEARCH|코난
            String[] parts = cmd.split("\\|");
            if (parts.length < 2) return "검색어를 찾을 수 없습니다.";
            
            String keyword = parts[1].trim();
            
            // 1. 기존 DTO 생성 및 설정
            ContentSearchDTO searchDTO = new ContentSearchDTO();
            searchDTO.setQ(keyword); // 검색어 설정 ('q' 필드)
            // 필요한 경우 정렬 조건이나 종료된 전시 제외 옵션 등을 여기서 추가 설정 가능
            // searchDTO.setHideEnded(true); 
            
            // 2. 기존 서비스 호출 (getSearchList)
            // 반환 타입이 List<MainContentViewDTO> 입니다.
            List<MainContentViewDTO> resultList = contentService.getSearchList(searchDTO);
            
            if (resultList == null || resultList.isEmpty()) {
                return "'" + keyword + "'에 대한 검색 결과가 없습니다.";
            }
            
            // 3. 결과 메시지 생성
            StringBuilder sb = new StringBuilder();
            sb.append("총 ").append(resultList.size()).append("건이 검색되었습니다.<br>");
            
            for (MainContentViewDTO dto : resultList) {
                // MainContentViewDTO의 필드를 사용 (content_id, title 등)
                sb.append("- <a href='/gotoday/detail/").append(dto.getContent_id()).append("' target='_blank'>")
                  .append("<b>").append(dto.getTitle()).append("</b>")
                  .append("</a><br>");
            }
            sb.append("<br>제목을 클릭하면 상세 페이지로 이동합니다.");
            
            return sb.toString();
            
        } catch (Exception e) {
            e.printStackTrace();
            return "검색 중 오류가 발생했습니다.";
        }
    }
    
    // (나머지 메서드들은 기존 유지)
 // [기능 1] 예약 내역 조회 (필터링 추가)
    private String getReservationHistory(int userId) {
        // 1. 일단 DB에서 다 가져오기 ("ALL")
        List<ReservationListDTO> list = reservationService.findReservationListByUserId(userId, "ALL");
        
        if (list == null || list.isEmpty()) {
            return "회원님, 예약 내역이 없습니다.";
        }
        
        StringBuilder sb = new StringBuilder();
        int count = 0; // 보여줄 예약 개수 카운트
        
        for (ReservationListDTO dto : list) {
            // ★ [핵심 수정] 상태가 'DONE'(예약완료)인 것만 필터링
            // (만약 이용 완료된 것도 보고 싶으시면 || "VISITED".equals(...) 추가)
            if ("DONE".equals(dto.getReservation_status())) {
                
                if (count == 0) {
                    sb.append("회원님의 <b>예약 완료</b> 내역입니다.<br>");
                }
                
                sb.append("- <b>").append(dto.getTitle()).append("</b>")
                  .append(" (").append(dto.getReserved_for_at()).append(")<br>");
                
                count++;
            }
        }
        
        // 반복문이 끝났는데 count가 0이면, 예약은 있지만 다 취소된 상태임
        if (count == 0) {
            return "현재 '예약 완료' 상태인 내역이 없습니다. (취소된 내역 제외)";
        }
        
        return sb.toString();
    }
    
 // [기능 2] 캘린더 추가 (검색 + 저장 로직)
    private String addToCalendar(String cmd, int userId) {
        try {
            // cmd 형식: CMD:ADD_CALENDAR|전시명|YYYY-MM-DD
            String[] parts = cmd.split("\\|");
            if (parts.length < 3) return "전시명과 날짜를 정확히 인식하지 못했습니다.";

            String keyword = parts[1].trim();
            String date = parts[2].trim();

            // 1. 전시명으로 content_id 찾기 (기존 검색 서비스 활용)
            ContentSearchDTO searchDTO = new ContentSearchDTO();
            searchDTO.setQ(keyword); // 검색어 설정
            
            // 검색 실행 (리스트 반환)
            List<MainContentViewDTO> searchResult = contentService.getSearchList(searchDTO);

            if (searchResult == null || searchResult.isEmpty()) {
                return "죄송합니다. '" + keyword + "' 관련 전시를 찾을 수 없어 캘린더에 추가하지 못했습니다.";
            }

            // 2. 가장 정확도 높은 첫 번째 결과 선택
            MainContentViewDTO bestMatch = searchResult.get(0);
            int contentId = (int) bestMatch.getContent_id(); // long -> int 변환
            String title = bestMatch.getTitle();

            // 3. 캘린더 서비스 호출 (PICK 추가)
            CalendarVO vo = new CalendarVO();
            vo.setUser_id(userId);
            vo.setContent_id(contentId);
            vo.setSelected_at(date); // YYYY-MM-DD
            vo.setType("PICK");      // 찜(PICK) 타입으로 저장

            calendarService.addPick(vo);

            return "네, <b>[" + title + "]</b> 전시를 <b>" + date + "</b> 캘린더에 찜해드렸습니다!<br>마이페이지 캘린더에서 확인해 보세요.";

        } catch (Exception e) {
            e.printStackTrace();
            return "일정 추가 중 오류가 발생했습니다.";
        }
    }
    
    private String callOllama(String prompt) {
        try {
            URL url = new URL(OLLAMA_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            String jsonBody = String.format("{\"model\": \"%s\", \"prompt\": \"%s\", \"stream\": false}", MODEL_NAME, prompt.replace("\"", "\\\"").replace("\n", " "));
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            if (conn.getResponseCode() == 200) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) response.append(line);
                ObjectMapper mapper = new ObjectMapper();
                JsonNode node = mapper.readTree(response.toString());
                return node.get("response").asText().trim();
            }
            return "CMD:OTHER";
        } catch (Exception e) { return "CMD:OTHER"; }
    }
}