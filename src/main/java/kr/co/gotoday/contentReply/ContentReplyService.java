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
	
	// 문의 페이징 조회 (질문 + 답글 묶어서 반환)
	List<ContentReplyVO> selectQuestionPage(int content_id, int offset, int limit);

	// 질문 개수 조회 (nested=0만 count)
	int countQuestion(int content_id);

	// 답글 조회 (gno 목록으로 IN)
	List<ContentReplyVO> selectAnswersByGno(List<Integer> gno);


	
}

