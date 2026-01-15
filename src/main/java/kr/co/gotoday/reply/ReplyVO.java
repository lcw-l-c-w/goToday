package kr.co.gotoday.reply;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class ReplyVO {
	private int reply_id;
    private String title;
    private String body;
    private String reply_status;
    private Timestamp created_at;
    private int gno;
    private int ono;
    private int nested;
    private int user_id;
    private int admin_id;
}
