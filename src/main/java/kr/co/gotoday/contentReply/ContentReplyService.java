package kr.co.gotoday.contentReply;

import java.util.List;

public interface ContentReplyService {

	//게시판 글 작성
	int insertQA(ContentReplyVO vo);

	//벤더가 답변 달아주는 것
	
	// 게시판 글 수정
	int updateQA(ContentReplyVO vo);
	
	//게시판 글 삭제
	int deleteQA( ContentReplyVO vo);
	
	//게시판 유저별 조회 
	List<ContentReplyVO> showQAByID(int user_id);
	
	// 게시판 전체 조회
	List<ContentReplyVO> showQAALL(int content_id);
}
