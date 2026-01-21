package kr.co.gotoday.content;

import java.util.List;

import util.PageInfo;

public interface ContentService {
	//이채원 구현 : 추천 컨텐츠 + 랜덤 컨텐츠 
	public List<MainContentViewDTO> getRandomContents(MainContentDTO mcd);
	public List<MainContentViewDTO> getRecommandContents(MainContentDTO mcd) ;
	public ContentVO getDetailContents(int content_id, Integer user_id);
	public List<String> getAvailableDatesByContent(Integer content_id);
	public List<ContentScheduleVO> getAvailableTimesByContent(Integer content_id, String scheduled_at);
	List<MainContentViewDTO> getPopularContent(int limit, String kind);
	List<MainContentViewDTO> getUpcomingContent(int limit, String kind);
	List<MainContentViewDTO> getSearchList(ContentSearchDTO dto);
	PageInfo getSearchPageInfo(ContentSearchDTO dto);
	
}
