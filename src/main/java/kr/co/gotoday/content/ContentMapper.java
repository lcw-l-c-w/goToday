package kr.co.gotoday.content;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface ContentMapper {
	List<MainContentViewDTO> selectPopularContent(@Param("limit") int limit,
												@Param("kind") String kind);
	List<MainContentViewDTO> selectUpcomingContent(@Param("limit") int limit,
													@Param("kind") String kind);
}
