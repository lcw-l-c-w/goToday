package kr.co.gotoday.contentLike;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
@Mapper
public interface ContentLikeMapper {

	//유저가 눌렀는지 count로 반환
	int checkHeartExists(@Param("content_id") Integer content_id, @Param("user_id")Integer user_id);

	// 하트 수 업데이트 
	int updateHeart(@Param("content_id") Integer content_id, @Param("user_id") Integer user_id);
		
	//하트 갯수 반환 
	int getHeart(@Param("content_id") Integer content_id);

	// 하트 제거
	int deleteHeart(@Param("content_id") Integer content_id, @Param("user_id")  Integer user_id);
}
