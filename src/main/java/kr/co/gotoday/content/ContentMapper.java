package kr.co.gotoday.content;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import util.PageInfo;
@Mapper
public interface ContentMapper {
	List<MainContentViewDTO> selectPopularContent(@Param("limit") int limit,
												@Param("kind") String kind);
	List<MainContentViewDTO> selectUpcomingContent(@Param("limit") int limit,
													@Param("kind") String kind);
	List<MainContentViewDTO> search(@Param("dto") ContentSearchDTO dto,
									@Param("offset") int offset,
									@Param("size") int size	);
	int countSearch(@Param("dto") ContentSearchDTO dto);
}
