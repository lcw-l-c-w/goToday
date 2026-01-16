package kr.co.gotoday.user;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class CalendarVO {
	private int calendar_id;
    private Timestamp selected_at;
    private String type;
    private int content_id;
    private int user_id;
}
