package kr.co.gotoday.contentLike;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.gotoday.user.UserMapper;

@Service
public class ContentLikeServiceImpl implements ContentLikeService{
	// 주입
	@Autowired
	ContentLikeMapper contentLikeMapper;
	@Autowired
	UserMapper userMapper;
	//하트 관리하기 
	@Transactional 
	@Override
	public ContentLikeVO getHeartByContentId(Integer content_id,Integer user_id) {
		// TODO Auto-generated method stub
		ContentLikeVO vo= new ContentLikeVO();
		//일단 하트 확인하기
		
		if(userMapper.getUserById(user_id).getRole()==0) {
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
		return vo;
	}
	@Override
	public int checkContentLike(Integer content_id, Integer user_id) {
		// TODO Auto-generated method stub
		return contentLikeMapper.checkHeartExists(content_id, user_id);
	}
}
