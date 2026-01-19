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

	private static final int PAGE_SIZE = 3;
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
	public List<MainContentViewDTO> getRecommandContents(MainContentDTO mcd) {
		// TODO Auto-generated method stub
		List<ContentVO> list = contentMapper.findRecommendedContents(mcd);

		return list.stream().map(vo -> applyViewPolicy(vo, mcd)).collect(Collectors.toList());
	}

	@Override
	public ContentVO getDetailContents(int content_id, Integer user_id) {
		// 상세페이지 보여주는것
		System.out.println("service~~집입" + content_id);
		ContentVO vo = contentMapper.selectByID(content_id);
		if (vo == null) {
			System.out.println("이게 문제인거임?");
			return null;
		}

		System.out.println("db 조회결과 vo=" + vo);

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
		// TODO Auto-generated method stub

		return contentMapper.selectDateByID(content_id);
	}

	// 시간 조회
	@Override
	public List<ContentScheduleVO> getAvailableTimesByContent(Integer content_id, String scheduled_at) {
		// TODO Auto-generated method stub
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
				dto.setDday((int) diff);
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

}
