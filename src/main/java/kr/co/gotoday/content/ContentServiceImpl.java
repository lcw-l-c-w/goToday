package kr.co.gotoday.content;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ContentServiceImpl implements ContentService{

	@Autowired
	private ContentMapper contentMapper;
	
	@Override
	public List<MainContentViewDTO> getPopularContent(int limit, String kind) {
		
		return contentMapper.selectPopularContent(limit, kind);
	}

	@Override
	public List<MainContentViewDTO> getUpcomingContent(int limit, String kind) {
		return contentMapper.selectUpcomingContent(limit, kind);
	}

}
