package kr.co.gotoday.content;

import java.util.List;

import javax.servlet.http.HttpSession;

public interface ContentService {
	//이채원 구현 : 추천 컨텐츠 + 랜덤 컨텐츠 
	public List<MainContentViewDTO> getRandomContents(MainContentDTO mcd);
	public List<MainContentViewDTO> getRecommandContents(MainContentDTO mcd) ;
	public ContentVO getDetailContents(int content_id, Integer user_id);
}
