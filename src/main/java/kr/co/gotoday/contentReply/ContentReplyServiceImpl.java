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

import kr.co.gotoday.user.UserMapper;
import kr.co.gotoday.user.UserVO;
@Transactional
@Service
public class ContentReplyServiceImpl implements ContentReplyService{
	
	@Autowired
	private ContentReplyMapper contentReplyMapper;

	@Autowired
	private UserMapper userMapper;
	
	// 게시물 생성(회원인경우)
	@Transactional
	@Override
	public int insertQA(ContentReplyVO vo) {
		// 매퍼가 성공하면 1, 실패하면 0을 반환
		UserVO userVO=userMapper.getUserById(vo.getUser_id());
		vo.setWriter(userVO.getName());
		int success=contentReplyMapper.insertContentQA(vo);
		if(success==1) {
			//성공시에는
			contentReplyMapper.updateGno(vo.getCreply_id());
		}
		return success;
	}
	
	//답변해줌 (vendor)
	@Override
	public int vendorCreate(ContentReplyVO vo) {
		// TODO Auto-generated method stub
		//벤더가 insert
		return contentReplyMapper.insertVendorQA(vo);
	}
	//
	//업데이트
	@Override
	public int updateQA(ContentReplyVO vo) {
		// TODO Auto-generated method stub
		return contentReplyMapper.updateReply(vo);
		
	}

	//게시물 삭제(이게 유저가 삭제한 경우 => 답변 여부 체크 후 vendor껏도 삭제하기
	// 벤더가 삭제한 경우-> 답변 여부만 업데이트 해주기 (1->0)
	@Transactional
	@Override
	public int deleteQA(ContentReplyVO vo) {
		// TODO Auto-generated method stub
		System.out.println("삭제 요청 유저: " + vo.getUser_id());
	    System.out.println("삭제 대상 글번호: " + vo.getCreply_id());
	    System.out.println("글에 저장된 Vendor ID: " + vo.getVendor_id());
	    System.out.println("삭제 대상 그룹번호(gno): " + vo.getGno()); // 이게 0이면 JSP 확인 필요!
		if(vo.getUser_id()!=vo.getVendor_id()) {
			//user인경우에 
				
				if(contentReplyMapper.countVendorReplyByGno(vo.getGno())>0) {
					//벤더가 답변해준 경우-> 벤더 게시물 삭제하기(매퍼 생성해야함) 
					contentReplyMapper.deleteVendorReplyByGno(vo.getGno());
				}
				return contentReplyMapper.deleteReply(vo);
				
		}
		else {
			//vendor가 삭제한 경우에 
			 contentReplyMapper.updateReplyStatus(vo.getGno(), 0); // 0이면 답변 안 한 상태  
				return contentReplyMapper.deleteReply(vo);
			
		}
	}

	//게시물 유저별 보여주기 
	@Override
	public List<ContentReplyVO> showQAByID(int user_id) {
		// TODO Auto-generated method stub
		return contentReplyMapper.selectQAByID(user_id);
	}

	//게시물 전체 보여주기 
	@Override
	public List<ContentReplyVO> showQAALL(int content_id) {
		// TODO Auto-generated method stub
		return contentReplyMapper.selectAllQA(content_id);
	}
	
	//게시물 갯수 보여주기 
	@Override
	public int CountQA(int content_id) {
		// TODO Auto-generated method stub
		return CountQA(content_id);
	}

	@Override
	public List<ContentReplyVO> showDetailByID(int creply_id) {
		// TODO Auto-generated method stub
		return contentReplyMapper.showDetail(creply_id);
	}

	@Override
	public ContentReplyVO getReplyForUser(int creply_id, int user_id) {
		
		return contentReplyMapper.showQADetail(creply_id, user_id);
	}

	@Override
	public int updateStatus(int gno) {
		// TODO Auto-generated method stub
		
		return contentReplyMapper.updateReplyStatus(gno, 1);
	}


	

	
}
