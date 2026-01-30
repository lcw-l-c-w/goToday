package kr.co.gotoday.contentLike;

import lombok.Data;

@Data
public class ContentLikeVO {
	private Integer user_id;
	private Integer content_id;
	
	
	// 갯수 반환
	private Integer count_num;
	//현재 상태
	private int liked;
}
