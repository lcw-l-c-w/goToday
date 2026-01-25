package kr.co.gotoday.contentReply;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;
@Data
public class ContentReplyVO { // 테이블 :content_reply

	private int creply_id;
	private String title;
	private String body;
	private String created_at;
	private int gno;
	private int ono;
	private int nested;
	private int writer; //숫자로 받는게 편함 
	private int user_id; //첫 작성자 아이디 
	private int content_id;
	private String creply_category;
	private int secret;
	private int reply_status;
	private String update_at;
	private String file_path;
}
