package kr.co.gotoday.mypage;

import java.util.List;

public interface MypageService {
	List<MypageDTO> getMyLikeList(Integer user_id);
	
}
