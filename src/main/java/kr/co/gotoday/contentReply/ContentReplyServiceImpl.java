package kr.co.gotoday.contentReply;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
		//벤더가 insert
		return contentReplyMapper.insertVendorQA(vo);
	}
	//
	//업데이트
	@Override
	public int updateQA(ContentReplyVO vo) {
		return contentReplyMapper.updateReply(vo);
		
	}

	//게시물 삭제(이게 유저가 삭제한 경우 => 답변 여부 체크 후 vendor껏도 삭제하기
	// 벤더가 삭제한 경우-> 답변 여부만 업데이트 해주기 (1->0)
	@Transactional
	@Override
	public int deleteQA(ContentReplyVO vo) {
		List<ContentReplyVO> detailList = contentReplyMapper.showDetail(vo.getCreply_id());
		if (detailList == null || detailList.isEmpty()) {
	        return 0; // 이미 삭제된 글이거나 존재하지 않는 경우
	    }
	    
	    // 가져온 실제 데이터를 vo 객체에 채워줍니다.
	    ContentReplyVO dbData = detailList.get(0);
	    vo.setVendor_id(dbData.getVendor_id());
	    vo.setGno(dbData.getGno());
	   
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
		return contentReplyMapper.selectQAByID(user_id);
	}

	//게시물 전체 보여주기 
	@Override
	public List<ContentReplyVO> showQAALL(int content_id) {
		return contentReplyMapper.selectAllQA(content_id);
	}
	
	//게시물 갯수 보여주기 
	@Override
	public int CountQA(int content_id) {
		return CountQA(content_id);
	}

	@Override
	public List<ContentReplyVO> showDetailByID(int creply_id) {
		return contentReplyMapper.showDetail(creply_id);
	}

	@Override
	public ContentReplyVO getReplyForUser(int creply_id, int user_id) {
		
		return contentReplyMapper.showQADetail(creply_id, user_id);
	}

	@Override
	public int updateStatus(int gno) {
		
		return contentReplyMapper.updateReplyStatus(gno, 1);
	}

	@Override
	public int showStatus(int gno) {
		// TODO Auto-generated method stub
		return contentReplyMapper.countVendorReplyByGno(gno);
	}


  
	@Override
	public List<ContentReplyVO> selectQuestionPage(int content_id, int offset, int limit) {

	    // 1) 질문 목록 조회 (nested=0)
	    List<ContentReplyVO> questions =
	        contentReplyMapper.selectQuestionPage(content_id, offset, limit);

	    if (questions.isEmpty()) return questions;

	    // 2) 질문들의 gno 수집 (리스트 이름도 gno로)
	    List<Integer> gno = questions.stream()
	        .map(ContentReplyVO::getGno)
	        .distinct()
	        .collect(Collectors.toList());

	    // 3) 답글들 조회 (nested=1 AND gno IN (...))
	    List<ContentReplyVO> answers =
	        contentReplyMapper.selectAnswersByGno(gno);

	    // 4) gno 기준으로 답글 그룹핑 (질문 1개당 답글 여러 개)
	    Map<Integer, List<ContentReplyVO>> answerMap =
	        answers.stream().collect(Collectors.groupingBy(ContentReplyVO::getGno));

	    // 5) 질문에 답글 리스트 세팅
	    for (ContentReplyVO q : questions) {
	        q.setAnswers(answerMap.getOrDefault(q.getGno(), Collections.emptyList()));
	    }

	    return questions;
	}

	@Override
	public int countQuestion(int content_id) {
	    return contentReplyMapper.countQuestion(content_id);
	}

	@Override
	public List<ContentReplyVO> selectAnswersByGno(List<Integer> gno) {
	    if (gno == null || gno.isEmpty()) return Collections.emptyList();
	    return contentReplyMapper.selectAnswersByGno(gno);
	}

	
	
	
	
	
}


	

	

