package kr.co.gotoday.content;

import java.util.List;

public interface ContentService {
	List<MainContentViewDTO> getPopularContent(int limit, String kind);
	List<MainContentViewDTO> getUpcomingContent(int limit, String kind);
}
