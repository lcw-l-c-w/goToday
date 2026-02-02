package kr.co.gotoday.mypage;

import lombok.Data;

@Data
public class MypageDTO {
	private Integer content_id;
    private String title;
    private String main_image_path;
    private java.sql.Timestamp start_at;
    private java.sql.Timestamp end_at;
    private int user_id;
    
    // 1:1 문의사항 페이징용 
    private int page = 1;      // 기본 1페이지
    private int startIdx;
    // 1:1 문의사항
    private int creply_id;
    private int answer_count;
    private java.sql.Timestamp created_at;
    private int reply_status;
    private int secret;
    // 1:1 문의사항 detail
    private String body;                // 문의글 본문
    private String file_path;	// 사진
    private String answer_body;         // 답변 본문
    private int gno;           // 그룹 번호 (답변 연결용)
    private int nested;        // 0:본문, 1:답변
}
