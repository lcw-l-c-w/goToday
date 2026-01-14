package kr.co.gotoday.vendor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentVo;

public interface VendorService {
	int createContent(ContentVo contentVo, MultipartFile file, HttpServletRequest request);
	
	Map<String, Object> list(ContentVo contentVo);

}
