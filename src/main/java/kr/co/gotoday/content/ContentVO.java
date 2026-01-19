package kr.co.gotoday.content;

import java.util.List;

import lombok.Data;

@Data
public class ContentVO {
	private int content_id;
    private String content_kind; //CONTENT_POPUP, CONTENT_EXHIBITION, 둘다 아니면 NULL
    private String category; // 여러 카테고리가 있음 . parsing해서 꺼내올듯.
    private String location;
    private String title;
    private String description;
    private String reservation_type;
    private String start_at;
    private String  end_at;
    private int adult_price;
    private int teen_price;
    private int child_price;
    private String main_image_path;
    private String detail_description;
    private Boolean is_active;//사용자와 상관없음
    private Boolean is_delete; //사용자와 상관없음
    private String content_time;
    private String instagram_url;
    private String x_url;
    private int admin_id;
    private String content_status;
    private List<ContentScheduleVO> contentScheduleList;
    private int user_id;
    private String place_tag;
    
    private int like_count;// 각 content에 대한 like수
    
    public String getReservationTypeLabel() {
        if (reservation_type == null) return "";

        switch (reservation_type) {
            case "true":
                return "사전 예매";
            case "false":
                return "현장 대기 ";
            default:
                return reservation_type; // 혹시 모를 값
        }
    }

    
}
