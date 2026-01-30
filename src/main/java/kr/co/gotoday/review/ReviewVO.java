package kr.co.gotoday.review;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ReviewVO {
	private int review_id;
    private String content;
    private int rating;
    private String image_org;
    private String image_new;
    private String visited_at;
    private String visited_time_zone;
    private Timestamp created_at;
    private int content_id;
    private int user_id;
    private int reservation_id;

    // 조인용 필드 (리뷰 목록 조회 시 사용)
    private String title;
    private String main_image_path;
    
    //작성자: 이메일 앞 3글자로 표시
    private String email;
    private String maskedEmail;
}
