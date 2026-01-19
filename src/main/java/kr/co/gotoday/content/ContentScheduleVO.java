package kr.co.gotoday.content;

import lombok.Data;

@Data
public class ContentScheduleVO {
	private int schedule_id;
    private String scheduled_at;
    private String time_zone;
    private Integer total_ticket;
    private int current_ticket;
    private int content_id;
	public String getTime_zone() {
		return time_zone;
	}
	public int getCurrent_ticket() {
		return current_ticket;
	}
}
