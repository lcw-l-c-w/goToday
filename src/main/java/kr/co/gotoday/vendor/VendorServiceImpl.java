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
import kr.co.gotoday.reservation.ReservationMapper;
import kr.co.gotoday.reservation.VendorReservationListDTO;
import kr.co.gotoday.reservation.VendorReservationSearchDTO;
import util.PageInfo;

@Service
public class VendorServiceImpl implements VendorService {

	@Autowired
	private VendorMapper vendorMapper;
	@Autowired
	private ReservationMapper reservationMapper;

	@Override
	public int createContent(ContentVO contentVo, ContentScheduleVO contentScheduleVO, MultipartFile file,
			HttpServletRequest request, List<String> timeList, Integer total_ticket) {
		// 상시전시 에러 예방 코드
		if (contentScheduleVO == null) {
			contentScheduleVO = new ContentScheduleVO();
		}

		// 파일 명명
		if (file != null && !file.isEmpty()) {
			String uploadDir = request.getServletContext().getRealPath("/upload/poster");
			String org = file.getOriginalFilename();
			String ext = org.substring(org.lastIndexOf("."));
			String filename = UUID.randomUUID().toString() + ext;

			// 파일 저장
			try {
				file.transferTo(new File(uploadDir, filename));
				contentVo.setMain_image_path("/upload/poster/" + filename);
			} catch (Exception e) {
				e.printStackTrace();
				return 0;
			}
		}
		int r = vendorMapper.createContent(contentVo);

		if (r <= 0)
			return 0;

		if (timeList == null || timeList.isEmpty() || total_ticket == null)
			return r;

		int contentId = contentVo.getContent_id();

		// 시간대가 있을 때만 반복
		LocalDate startDate = LocalDate.parse(contentVo.getStart_at());
		LocalDate endDate = LocalDate.parse(contentVo.getEnd_at());

		int a = 0;

		for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {

			String day = date.toString(); // yyyy-MM-dd

			for (String time : timeList) {
				if (time == null || time.trim().isEmpty())
					continue;

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
	public List<ContentVO> getAllContentForFilter(int userId) {
	    return vendorMapper.selectAllContentForFilter(userId);
	}

	@Override
	public Map<String, Object> getFilterList(int user_id, String keyword, String status, Integer page) {
		int pageSize = 5;
		int blockSize = 5;

		Map<String, Object> param = new HashMap<>();
		param.put("user_id", user_id);
		param.put("keyword", keyword);
		param.put("status", status);

		int count = vendorMapper.selectContentListCount(param);

		PageInfo pageInfo = PageInfo.of(count, page, pageSize, blockSize);
		param.put("offset", PageInfo.offset(page, pageSize));
		param.put("pageSize", pageSize);
		
		List<ContentVO> list = vendorMapper.selectContentList(param);

		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		result.put("pageInfo", pageInfo);
		return result;
	}

	@Override
	public Map<String, Object> findReservationByVendor(VendorReservationSearchDTO dto) {
		List<VendorReservationListDTO> list = reservationMapper.findReservationByVendor(dto);

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
		// 중복 제거
		Map<String, ContentScheduleVO> uniqueMap = new HashMap<>();

		for (ContentScheduleVO vo : list) {
			String time = vo.getTime_zone();
			if (time == null || time.trim().isEmpty())
				continue;

			// 최초 1개만 저장
			uniqueMap.putIfAbsent(time, vo);
		}

		return List.copyOf(uniqueMap.values());
	}

	@Override
	public int updateContent(ContentVO contentVo, ContentScheduleVO contentScheduleVO, MultipartFile file,
			HttpServletRequest request, List<String> timeList, Integer total_ticket) {

		if (contentVo == null) {
			return 0;
		}
		// 기존 이미지 유지
		if (file == null || file.isEmpty()) {
			ContentVO origin = vendorMapper.selectContentOne(contentVo.getContent_id());
			if (origin != null) {
				contentVo.setMain_image_path(origin.getMain_image_path());
			}
		}

		int r = vendorMapper.updateContent(contentVo);

		if (r <= 0)
			return 0;

		return r;
	}

	@Override
	public int updateReservationStatus(int reservation_id) { // 여기에 int가 중복되진 않았나요?
		return reservationMapper.updateReservationStatusById(reservation_id);
	}

}
