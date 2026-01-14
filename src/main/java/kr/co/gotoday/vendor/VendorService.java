package kr.co.gotoday.vendor;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentVO;

public interface VendorService {
	int createContent(ContentVO contentVo, ContentScheduleVO contentScheduleVO, 
			MultipartFile file, HttpServletRequest request, List<String> timeList, int total_ticket);
	
	Map<String, Object> list(ContentVO contentVo);

}
