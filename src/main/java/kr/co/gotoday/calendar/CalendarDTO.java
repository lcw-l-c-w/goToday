package kr.co.gotoday.calendar;

import lombok.Data;

@Data
public class CalendarDTO {
	private String title;  // 일정 제목 (content 테이블에서 가져옴)
    private String start;  // 시작 날짜 (selected_at) - 형식: "2026-01-20"
    private String color;  // 배경색 (예약 vs 찜 구분용)
    
    
    private int reservation_id;
    private int content_id;
}
