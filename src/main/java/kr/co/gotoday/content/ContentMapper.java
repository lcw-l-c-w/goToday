package kr.co.gotoday.content;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ContentMapper {

	//random sql
	List<ContentVo> randomContent(MainContentDTO mcd);	
	//recommand sql
	List<ContentVo> recommandContent(MainContentDTO mcd);
}
