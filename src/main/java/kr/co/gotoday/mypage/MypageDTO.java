package kr.co.gotoday.mypage;

import lombok.Data;

@Data
public class MypageDTO {
	private Integer content_id;
    private String title;
    private String main_image_path;
    private java.sql.Timestamp start_at;
    private java.sql.Timestamp end_at;
}
