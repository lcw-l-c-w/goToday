package kr.co.gotoday.contentReply;

import java.util.List;

import kr.co.gotoday.user.UserVO;

public interface ContentReplyService {

	//게시판 글 작성
	int insertQA(ContentReplyVO vo);

	//벤더가 답변 달아주는 것
	int vendorCreate(ContentReplyVO vo);
	
	//-> 상태 변경해줌
	int updateStatus(int gno);
	// 게시판 글 수정
	int updateQA(ContentReplyVO vo);
	
	//게시판 글 삭제
	int deleteQA( ContentReplyVO vo);
	
	//게시판 유저별 조회 
	List<ContentReplyVO> showQAByID(int user_id);
	
	// 게시판 전체 조회
	List<ContentReplyVO> showQAALL(int content_id);
	
	//게시물 갯수 보여주기 
	int CountQA(int content_id);
	
	//게시판 조회
	List<ContentReplyVO> showDetailByID(int creply_id);
	
	//게시판 수정시에 사용할 조회해오기 
	ContentReplyVO getReplyForUser(int creply_id,int user_id);
	
	//상태 조회
	int showStatus(int gno);
}

