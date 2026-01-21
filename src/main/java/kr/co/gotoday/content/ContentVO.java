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
    
    //추가 private 
    private String content_status_current; // s현재 상태 
    
    private int like_count;// 각 content에 대한 like수
    private int liked; //새로고침시 like되어있으면 파란색이 들어오게끔 설정해야함
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
    
    
    public String getContentKindName() {
    	if (content_kind == null) return "";
    	if(content_kind.equals("popup")) {
    		return "팝업";
    	}
    	else if( content_kind.equals("exhibition"))
    		return "전시";
    
    	return "";
    }
    
    //종료/ 오픈예정/ 진행중 
    public String getContentStatusCurrent() {
    	if(content_status_current.equals("STATUS_OPEN")) return "진행중";
    	else if(content_status_current.equals("STATUS_SCHEDULED")) return "오픈예정";
    	else if(content_status_current.equals("STATUS_CLOSED")) return "종료";
    	
    	return "";
    }
}
