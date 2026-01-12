package kr.co.gotoday.content;

import java.sql.Timestamp;
import java.util.List;

public class ContentVo {
	private int content_id;
    private String contentkind;
    private String category;
    private String location;
    private String title;
    private String description;
    private String reservation_type;
    private Timestamp start_at;
    private Timestamp end_at;
    private int adult_price;
    private int teen_price;
    private int child_price;
    private String main_image_path;
    private String detail_description;
    private Boolean is_active;
    private Boolean is_delete;
    private String content_time;
    private String instagram_url;
    private String x_url;
    private int admin_id;
    private String content_status;
    private List<ContentScheduleVO> contentScheduleList;
}
