package kr.co.gotoday.content;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ContentMapper {

	// random sql
	List<ContentVO> randomContent(MainContentDTO mcd);

	// recommand sql
	List<ContentVO> findRecommendedContents(MainContentDTO mcd);

	// 상세보기 <스케쥴 제외>
	ContentVO selectByID(@Param("content_id") int content_id);

	// 날짜 조회
	List<String> selectDateByID(@Param("content_id") int content_id);

	// 시간 조회
	List<ContentScheduleVO> selectTimeByID(@Param("content_id") int content_id,
			@Param("scheduled_at") String scheduled_at);

	List<MainContentViewDTO> selectPopularContent(@Param("limit") int limit, @Param("kind") String kind);

	List<MainContentViewDTO> selectUpcomingContent(@Param("limit") int limit, @Param("kind") String kind);

	List<MainContentViewDTO> search(@Param("dto") ContentSearchDTO dto, @Param("offset") int offset,
			@Param("size") int size);

	int countSearch(@Param("dto") ContentSearchDTO dto);
	
	//티켓 조회 (승인/ 승인 대기 상태에도 다 보이게끔)
	ContentVO selectTicketDetail(@Param("content_id") int content_id);
}
