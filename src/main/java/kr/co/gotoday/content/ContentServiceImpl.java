package kr.co.gotoday.content;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
@Service
public class ContentServiceImpl implements ContentService{
	
	//mapper를 만들고 돌아올것
	@Autowired
	ContentMapper contentMapper; 
	@Override
	public List<MainContentViewDTO> getRandomContents(MainContentDTO mcv) {
		// TODO Auto-generated method stub
		return contentMapper.randomContent(mcv); //contentMapper.dddd;
	}

	@Override
	public List<MainContentViewDTO> getHotContents(MainContentDTO mcv) {
		// TODO Auto-generated method stub
		return contentMapper.hotContent(mcv); //contentMapper.dddd;
	}

}
