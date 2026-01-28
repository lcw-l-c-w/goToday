package kr.co.gotoday.content;


import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import util.PageInfo;

@Service
public class ContentServiceImpl implements ContentService {

	private static final int PAGE_SIZE = 8;
	private static final int BLOCK_SIZE = 10;
	// mapper를 만들고 돌아올것
	@Autowired
	private ContentMapper contentMapper;

	@Override
	public List<MainContentViewDTO> getRandomContents(MainContentDTO mcd) {
		// TODO Auto-generated method stub
		// service가 정책 메서드를 호출하지 않고 viewDTO를 반환하면 안됨 .
		// Mapper는 contentVO 반환
		// Service에서 viewDTO 변환
		// 1️⃣ DB에서 날것 데이터 조회
		List<ContentVO> list = contentMapper.randomContent(mcd);

		// 2️⃣ 정책 적용 + ViewDTO 변환
		return list.stream().map(vo -> applyViewPolicy(vo, mcd)).collect(Collectors.toList());
	}

	@Override
	public List<MainContentViewDTO> getRecommendContents(MainContentDTO mcd) {
		// TODO Auto-generated method stub
		List<ContentVO> list = contentMapper.findRecommendedContents(mcd);
		//System.out.println("리스트 출력"+list);
		return list.stream().map(vo -> applyViewPolicy(vo, mcd)).collect(Collectors.toList());
	}

	@Override
	public ContentVO getDetailContents(int content_id, Integer user_id) {
		// 상세페이지 보여주는것
	
		ContentVO vo = contentMapper.selectByID(content_id);
		if (vo == null) {
			return null;
		}
	
		if("false".equals(vo.getReservation_type())) {
			System.out.println("현장대기 실행됨");
			vo.setContentReservation(0); //볼수없게함
		}
		else if ("true".equals(vo.getReservation_type())) {
			System.out.println("사전 예매");
			vo.setContentReservation(1);
		}
		return updateContentStatus(vo);

	}
	
	//예외 : 티켓 관련 조회 ( 승인요청까지도 보여줘야함
	@Override
	public ContentVO getDetailContentsForTicket(int content_id, Integer user_id) {
		// 상세페이지 보여주는것
	
		ContentVO vo = contentMapper.selectTicketDetail(content_id);
		if (vo == null) {
			return null;
		}
		return updateContentStatus(vo);

	}
	//시간 비교
	
	public ContentVO updateContentStatus(ContentVO vo) {
		
		LocalDate today = LocalDate.now();
		
	
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	    LocalDate startDateTime = LocalDate.parse(vo.getStart_at().substring(0, 10));
	    LocalDate endDateTime= LocalDate.parse(vo.getEnd_at().substring(0,10));
	 // !start.isAfter(today) 는 (오늘 >= 시작일) 과 같습니다.
	    if(!startDateTime.isAfter(today) && !endDateTime.isBefore(today)) {
	    	//진행형이면
	    	vo.setContent_status_current("STATUS_OPEN");
	    }
	    else if(startDateTime.isAfter(today)) {
	    	//이후에 시작이면
	    	vo.setContent_status_current("STATUS_SCHEDULED");
	    }
	    else if(endDateTime.isBefore(today)) {
	    	//끝났으면
	    	vo.setContent_status_current("STATUS_CLOSED");
	    }
		return vo;
	}
	
	// 핵심 메서드
	private MainContentViewDTO applyViewPolicy(ContentVO vo, MainContentDTO mcd) {
	    MainContentViewDTO mcv = new MainContentViewDTO(vo);
	    
	    // 1. 비로그인 유저 처리 (mcd 자체가 null이거나 user_id가 null인 경우)
	    if (mcd == null || mcd.getUser_id() == null) {
	        mcv.setBlur(true);
	        mcv.setCtaMessage("로그인하시면 볼 수 있습니다!");
	        mcv.setCtaUrl("/member/login");
	        return mcv;
	    }

	    // 2. 회원인 경우: 관심사 리스트(user_tag_id)가 null이거나 비어있는지 체크
	    // 수정 포인트: mcd.getUser_tag_id() == null 조건을 반드시 앞에 추가
	    if (mcd.getUser_tag_id() == null || mcd.getUser_tag_id().isEmpty()) {
	        mcv.setBlur(true);
	        mcv.setCtaMessage("관심사 설정하시면 볼 수 있습니다!");
	        mcv.setCtaUrl("/mypage/like_list");
	        return mcv;
	    }
	    
	    // 3. 정상인 경우
	    mcv.setBlur(false);
	    return mcv;
	}

	// 날짜 조회
	@Override
	public List<String> getAvailableDatesByContent(Integer content_id) {

		
		return contentMapper.selectDateByID(content_id);
	}

	// 시간 조회
	@Override
	public List<ContentScheduleVO> getAvailableTimesByContent(Integer content_id, String scheduled_at) {
		
		return contentMapper.selectTimeByID(content_id, scheduled_at);
	}

	private static final ZoneId KST = ZoneId.of("Asia/Seoul");
	private static final DateTimeFormatter YY_DOT = DateTimeFormatter.ofPattern("yy.MM.dd");

	private void fillViewFields(List<MainContentViewDTO> list) {
		if (list == null)
			return;

		LocalDate today = LocalDate.now(KST);

		for (MainContentViewDTO dto : list) {
			LocalDate start = toLocalDate(dto.getStart_at());
			LocalDate end = toLocalDate(dto.getEnd_at());

			// 1) 운영기간 텍스트
			if (start != null && end != null) {
				dto.setPeriodText(start.format(YY_DOT) + "~" + end.format(YY_DOT));
			} else if (start != null) {
				dto.setPeriodText(start.format(YY_DOT));
			} else {
				dto.setPeriodText("");
			}

			// 2) D-day (시작일까지 남은 일수)
			if (start != null) {
				long diff = ChronoUnit.DAYS.between(today, start); // 오늘->시작일
				dto.setDday(diff > 0 ? (int) diff : null);  // 오픈예정만
			} else {
				dto.setDday(null);
			}
		}
	}

	private static final DateTimeFormatter DB_FMT =
		    DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

		private LocalDate toLocalDate(String dateTime) {
		    if (dateTime == null || dateTime.isEmpty()) return null;
		    return LocalDateTime.parse(dateTime, DB_FMT).toLocalDate();
		}


	@Override
	public List<MainContentViewDTO> getPopularContent(int limit, String kind) {
		List<MainContentViewDTO> list = contentMapper.selectPopularContent(limit, kind);
		fillViewFields(list);
		return list;
	}

	@Override
	public List<MainContentViewDTO> getUpcomingContent(int limit, String kind) {
		List<MainContentViewDTO> list = contentMapper.selectUpcomingContent(limit, kind);
		fillViewFields(list);
		return list;
	}

	@Override
	public List<MainContentViewDTO> getSearchList(ContentSearchDTO dto) {
		int offset = PageInfo.offset(dto.getPage(), PAGE_SIZE);
		List<MainContentViewDTO> list = contentMapper.search(dto, offset, PAGE_SIZE);
		fillViewFields(list); // 검색결과에도 기간 표시를 원하면
		return list;
	}

	@Override
	public PageInfo getSearchPageInfo(ContentSearchDTO dto) {
		int count = contentMapper.countSearch(dto);
		return PageInfo.of(count, dto.getPage(), PAGE_SIZE, BLOCK_SIZE);
	}

	@Override
	public int selectIdByContentId(int content_id) {
		// TODO Auto-generated method stub
		return contentMapper.findVendorId(content_id);
		
	}


}
