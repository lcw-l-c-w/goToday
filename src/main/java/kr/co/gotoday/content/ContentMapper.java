package kr.co.gotoday.content;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ContentMapper {

	//random sql
	List<ContentVO> randomContent(MainContentDTO mcd);	
	//recommand sql
	List<ContentVO> recommandContent(MainContentDTO mcd);
	ContentVO selectByID(@Param("content_id") int content_id);
}
