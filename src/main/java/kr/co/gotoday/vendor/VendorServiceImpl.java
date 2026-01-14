package kr.co.gotoday.vendor;

import java.io.File;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentVO;

@Service
public class VendorServiceImpl implements VendorService {
	
	@Autowired
	private VendorMapper vendorMapper;
	
	@Override
	public int createContent(ContentVO contentVo, ContentScheduleVO contentScheduleVO, 
			MultipartFile file, HttpServletRequest request, List<String> timeList, int total_ticket) {
		if(file !=null  && !file.isEmpty()) {
			//파일 명명
			String uploadDir = request.getServletContext().getRealPath("/upload/poster");
			String org = file.getOriginalFilename();
			String ext = org.substring(org.lastIndexOf("."));
			String filename = UUID.randomUUID().toString() + ext;
			
			File dir = new File(uploadDir);

			//파일 저장
			try {
				file.transferTo(new File(uploadDir, filename));
				contentVo.setMain_image_path("/upload/poster/" + filename);
			} catch (Exception e) {
				e.printStackTrace();
				return 0;
			}
		}
		int r = vendorMapper.createContent(contentVo);
		
		int contentId = contentVo.getContent_id();

	    // 시간대가 있을 때만 반복
		LocalDate startDate = LocalDate.parse(contentVo.getStart_at());
		LocalDate endDate   = LocalDate.parse(contentVo.getEnd_at());

		int a=0;
		
		for (LocalDate date = startDate;
		     !date.isAfter(endDate);
		     date = date.plusDays(1)) {

		    String day = date.toString(); // yyyy-MM-dd

		    for (String time : timeList) {
		        if (time == null || time.trim().isEmpty()) continue;

		        contentScheduleVO.setContent_id(contentId);
		        contentScheduleVO.setScheduled_at(day);
		        contentScheduleVO.setTime_zone(time);
		        contentScheduleVO.setCurrent_ticket(total_ticket);
		        contentScheduleVO.setTotal_ticket(total_ticket);

		        a = vendorMapper.createSchedule(contentScheduleVO);
		    }
		}
		
		if (a>0) {
			return r;
		}else {
			return 0;
		}
	}
	
	@Override
	public Map<String, Object> list(ContentVO contentVo){
		Map<String, Object> map = new HashMap<>();
		
		return map;
	}
	
	

}
