package kr.co.gotoday.admin;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.gotoday.content.ContentVO;

@Mapper
public interface AdminMapper {

	List<ContentVO> selectContentList(Map<String, Object> param);
	int updateActive(Integer content_id);
	int updateDelete(Integer content_id);
	int updateContentStatus(@Param("content_id") int content_id,
            @Param("content_status") String content_status);

	List<ContentVO> requestContentList(Map<String, Object> param);

}
