package kr.co.gotoday.content;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ContentMapper {

	//random sql
	List<ContentVO> randomContent(MainContentDTO mcd);	
	//recommand sql
	List<ContentVO> findRecommendedContents(MainContentDTO mcd);
	//상세보기 <스케쥴 제외>
	ContentVO selectByID(@Param("content_id") int content_id);
	// 날짜 조회
	List<String> selectDateByID(@Param("content_id") int content_id);
	//시간 조회
	List<ContentScheduleVO> selectTimeByID(@Param("content_id") int content_id,@Param("scheduled_at") String scheduled_at);
}