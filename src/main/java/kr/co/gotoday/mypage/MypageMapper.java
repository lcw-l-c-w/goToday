package kr.co.gotoday.mypage;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MypageMapper {
	// 내가 좋아요 누른 콘텐츠 목록
    List<MypageDTO> selectMyLikeList(@Param("user_id") Integer user_id);
 
}
