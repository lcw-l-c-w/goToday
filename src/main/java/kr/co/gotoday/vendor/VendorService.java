package kr.co.gotoday.vendor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentVO;

public interface VendorService {
	int createContent(ContentVO contentVo, MultipartFile file, HttpServletRequest request);
	
	Map<String, Object> list(ContentVO contentVo);

}
