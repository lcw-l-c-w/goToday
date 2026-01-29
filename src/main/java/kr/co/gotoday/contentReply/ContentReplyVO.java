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
	private String writer; //이름
	private int user_id; //첫 작성자 아이디 
	private int userType; // 유형 분리 
	private int content_id;
	private String creply_category;
	private int secret;
	private int reply_status;
	private String update_at;
	private String file_path;
	private int num; // 총 몇건인지 
	private int vendor_id; //벤더아이디 확인용
	private int role; // 0이면 개인/ 1이면 vendor
	
	
	//언니
	private int answer_count;
}
