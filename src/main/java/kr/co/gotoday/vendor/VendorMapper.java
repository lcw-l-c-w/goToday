package kr.co.gotoday.vendor;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentVO;

@Mapper
public interface VendorMapper {
	
	int createContent(ContentVO contentVo);
	int createSchedule(ContentScheduleVO contentScheduleVO);
	List<ContentVO> selectContentList(Map<String, Object> param);
	ContentVO selectContentOne(Integer content_id);
	List<ContentScheduleVO> selectContentScheduleList(Integer content_id);
	int updateContent(ContentVO contentVO);
	int selectContentListCount(Map<String, Object> param);
	List<ContentVO> selectAllContentForFilter(int user_id);
}
