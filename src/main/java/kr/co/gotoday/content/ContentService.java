package kr.co.gotoday.content;

import java.util.List;

public interface ContentService {
	//이채원 구현 : 추천 컨텐츠 + 랜덤 컨텐츠 
	public List<MainContentViewDTO> getRandomContents(MainContentDTO mcv);
	public List<MainContentViewDTO> getHotContents(MainContentDTO mcv) ;
}
