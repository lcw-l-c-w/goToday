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
}
