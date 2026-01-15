package kr.co.gotoday.chat;
import java.sql.Timestamp;

import lombok.Data;

@Data
public class ChatVO {
	private int chat_id;
    private int user_id;
    private int content_id;
    private Timestamp created_at;
    private String message;
}
