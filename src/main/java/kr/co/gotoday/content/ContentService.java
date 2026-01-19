package kr.co.gotoday.content;

import java.util.List;

import util.PageInfo;

public interface ContentService {
	List<MainContentViewDTO> getPopularContent(int limit, String kind);
	List<MainContentViewDTO> getUpcomingContent(int limit, String kind);
	List<MainContentViewDTO> getSearchList(ContentSearchDTO dto);
	PageInfo getSearchPageInfo(ContentSearchDTO dto);
}
