package kr.co.gotoday.vendor;

import org.apache.ibatis.annotations.Mapper;

import kr.co.gotoday.content.ContentVO;

@Mapper
public interface VendorMapper {
	
	int createContent(ContentVO contentVo);
}
