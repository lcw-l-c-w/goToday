package kr.co.gotoday.vendor;

import java.io.File;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
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
			MultipartFile file, HttpServletRequest request, List<String> timeList, Integer total_ticket) {
		//상시전시 에러 예방 코드
		if (contentScheduleVO == null) {
		    contentScheduleVO = new ContentScheduleVO();
		}
		
		//파일 명명
		if(file !=null  && !file.isEmpty()) {
			String uploadDir = request.getServletContext().getRealPath("/upload/poster");
			String org = file.getOriginalFilename();
			String ext = org.substring(org.lastIndexOf("."));
			String filename = UUID.randomUUID().toString() + ext;

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
		
		if(r<=0) return 0;
		
		if (timeList == null || timeList.isEmpty() || total_ticket == null) return r;

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

		        vendorMapper.createSchedule(contentScheduleVO);
		    }
		}
		return r;
	}
	
	@Override
	public Map<String, Object> getFilterList(int user_id, String keyword, String status) {
		Map<String, Object> param = new HashMap<>();
		param.put("user_id", user_id);
		param.put("keyword", keyword);
		param.put("status", status);
		
		List<ContentVO> list = vendorMapper.selectContentList(param);
		
		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		return result;
	}
	
	@Override
	public ContentVO getContent(Integer content_id) {
		return vendorMapper.selectContentOne(content_id);
	}
	
	@Override
	public List<ContentScheduleVO> getContentSchedule(Integer content_id) {
		List<ContentScheduleVO> list = vendorMapper.selectContentScheduleList(content_id);
		//중복 제거
		Map<String, ContentScheduleVO> uniqueMap = new HashMap<>();
		
		for(ContentScheduleVO vo : list) {
			String time = vo.getTime_zone();
			if(time ==null || time.trim().isEmpty()) continue;
			
			//최초 1개만 저장
			uniqueMap.putIfAbsent(time, vo);
		}
		
		return List.copyOf(uniqueMap.values());
	}
	
	@Override
	public int deleteContentSchedule(Integer content_id) {
		// 수정 모드일 경우 기존 스케줄 삭제
		if (content_id != null) {
		    vendorMapper.deleteContentSchedule(content_id);
		}
		return content_id;
	}
	
	@Override
	public int updateContent(ContentVO contentVo, ContentScheduleVO contentScheduleVO, 
			MultipartFile file, HttpServletRequest request, List<String> timeList, Integer total_ticket) {
		
		if (contentVo == null) {
	        return 0;
	    }
		//기존 이미지 유지
		if (file == null || file.isEmpty()) {
		    ContentVO origin = vendorMapper.selectContentOne(contentVo.getContent_id());
		    if (origin != null) {
		        contentVo.setMain_image_path(origin.getMain_image_path());
		    }
		}
		
		int r = vendorMapper.updateContent(contentVo);
		
		if(r<=0) return 0;
		
		// 수정일 때 스케줄이 없으면 content만 수정하고 종료
		if (timeList == null || timeList.isEmpty() || total_ticket == null) {
		    return r;
		}

		// 수정일때 기존 스케줄 삭제
	    vendorMapper.deleteContentSchedule(contentVo.getContent_id());
		
	    // 일정 수정 안 하고 content만 수정ㄴ
	    if (contentVo.getStart_at() == null || contentVo.getEnd_at() == null) {
	        return r; 
	    }
	    LocalDate startDate = LocalDate.parse(contentVo.getStart_at());
	    LocalDate endDate   = LocalDate.parse(contentVo.getEnd_at());

	    for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
	        for (String time : timeList) {
	            if (time == null || time.trim().isEmpty()) continue;

	            ContentScheduleVO vo = new ContentScheduleVO();
	            vo.setContent_id(contentVo.getContent_id());
	            vo.setScheduled_at(date.toString());
	            vo.setTime_zone(time);
	            vo.setTotal_ticket(total_ticket);
	            vo.setCurrent_ticket(total_ticket);

	            vendorMapper.createSchedule(vo);
	        }
	    }

	    return r;
	}


}
