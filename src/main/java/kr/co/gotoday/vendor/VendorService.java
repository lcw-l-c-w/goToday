package kr.co.gotoday.vendor;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.reservation.VendorReservationSearchDTO;

public interface VendorService {
	//content 추가
	int createContent(ContentVO contentVo, ContentScheduleVO contentScheduleVO, 
			MultipartFile file, HttpServletRequest request, List<String> timeList, Integer total_ticket);
	int updateContent(ContentVO contentVo, ContentScheduleVO contentScheduleVO, MultipartFile file,
			HttpServletRequest request, List<String> timeList, Integer total_ticket);

	//content 관리 리스트
	Map<String, Object> getFilterList(int user_id, String keyword, String status, Integer page);

	//수정요청 여부 판단 
	ContentVO getContent(Integer content_id);
	List<ContentScheduleVO> getContentSchedule(Integer content_id);
	
	//예약 확인
	Map<String, Object> findReservationByVendor(VendorReservationSearchDTO dto);
	int updateReservationStatus(int reserve_id);


}
