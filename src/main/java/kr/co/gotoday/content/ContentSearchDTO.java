package kr.co.gotoday.content;

import java.util.List;

import lombok.Data;
@Data
public class ContentSearchDTO {
	
	private String content_kind;
	private List<String> category;
	private List<String> place_tag;
	private String start_at;
	private String end_at;
	private String reservation_type;
	private int adult_price;
	private String q;
	
	private  Integer page = 1;
	
	// relevance, newest, popular
	private String sort;
	
	private Boolean hideEnded; 
	private Boolean onlyFree; // 무료만 보기 체크 여부

}
