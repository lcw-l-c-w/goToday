package kr.co.gotoday.contentLike;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ContentLikeServiceImpl implements ContentLikeService{
	// 주입
	@Autowired
	ContentLikeMapper contentLikeMapper;
	//하트 관리하기 
	@Override
	public ContentLikeVO getHeartByContentId(Integer content_id,Integer user_id) {
		// TODO Auto-generated method stub
		ContentLikeVO vo= new ContentLikeVO();
		//일단 하트 확인하기
		int isLiked= contentLikeMapper.checkHeartExists(content_id, user_id);
		
		if(isLiked==0) {
			//없으면 
			contentLikeMapper.updateHeart(content_id, user_id);
			vo.setLiked(1);
		}
		else {
			//있으면 
			contentLikeMapper.deleteHeart(content_id, user_id);
			vo.setLiked(0);
		}
		Integer like_count= contentLikeMapper.getHeart(content_id);
		
		vo.setContent_id(content_id);
		vo.setCount_num(like_count==null ? 0: like_count);
		return vo;
	}
	@Override
	public int CheckContentLike(Integer content_id, Integer user_id) {
		// TODO Auto-generated method stub
		return contentLikeMapper.checkHeartExists(content_id, user_id);
	}
}
