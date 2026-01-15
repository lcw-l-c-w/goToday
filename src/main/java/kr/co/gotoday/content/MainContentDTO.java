package kr.co.gotoday.content;

import java.util.List;

import kr.co.gotoday.user.UserTagVO;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MainContentDTO {
	// 메인홈페이지 + 팝업 + 전시 창 홈페이지 전용 요구사항
	
	private String content_kind; // CONTENT_POPUP |CONTENT_EXHIBITION |  NULL인지 확인 
	private Integer user_id; //null 허용 
	private List<UserTagVO> user_tag_id; // user 테이블에 연결되어있는 user_tag의 모든 내용(관심사 내용)을 list로 가져옴 
	//private ContentFetchType fetchType; // 어떤 방식으로 컨텐츠를 뽑을지 (여기서 3개로 나뉘어짐 - RANDOM, HOT, RECOMMEND, UPCOMMING,) -> 이건 다른 기능을 구현하는 친구랑 충돌 가능성 존재
	private int limit;// 하면에서 보여줄 갯수 제한

	
	
}
