package kr.co.gotoday.contentReply;

import java.util.List;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
public class ContentReplyServiceImpl implements ContentReplyService{
	
	@Autowired
	private ContentReplyMapper contentReplyMapper;

	@Override
	public int insertQA(ContentReplyVO vo) {
		// 매퍼가 성공하면 1, 실패하면 0을 반환
		return contentReplyMapper.insertContentQA(vo);
		
	}

	@Override
	public int updateQA(ContentReplyVO vo) {
		// TODO Auto-generated method stub
		return contentReplyMapper.updateReply(vo);
		
	}

	@Override
	public int deleteQA(ContentReplyVO vo) {
		// TODO Auto-generated method stub
		return contentReplyMapper.deleteReply(vo);
		
	}

	@Override
	public List<ContentReplyVO> showQAByID(int user_id) {
		// TODO Auto-generated method stub
		return contentReplyMapper.selectQAByID(user_id);
	}

	@Override
	public List<ContentReplyVO> showQAALL(int content_id) {
		// TODO Auto-generated method stub
		return contentReplyMapper.selectAllQA(content_id);
	}


	
}
