package kr.co.gotoday.vendor;

import org.apache.ibatis.annotations.Mapper;

import kr.co.gotoday.content.ContentVo;

@Mapper
public interface VendorMapper {
	
	int contentCreate(ContentVo contentVo);
}
