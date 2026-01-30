package kr.co.gotoday.replyVendor;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ReplyVendorVO {
	private int reply_vendor_id;
	private String title;
	private String body;
	private Timestamp created_at;
	private int reply_status;
	private int gno;
	private int writer;
	private int user_id;
	private int admin_id;
	private int answer_count;

	private String writer_name;
	
	// 사용자로부터 전송되어지는 값(검색, 페이징, 필터링(조건))
	private String searchType;
	private String searchWord;
	private int page; // 사용자가 요청한 페이지 번호
	private int startIdx; // limit 앞에 들어갈 시작인덱스값
	
	public ReplyVendorVO() {
		this.page = 1;
	}
	
	public int getStartIdx() {
		return (page-1) * 5;
	}
}
