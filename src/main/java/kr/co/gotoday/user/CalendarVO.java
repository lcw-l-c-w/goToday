package kr.co.gotoday.user;

import lombok.Data;

@Data
public class CalendarVO {
	private int calendar_id;
    private String selected_at;
    private String type;
    private int content_id;
    private int user_id;
    private int reservation_id;
}
