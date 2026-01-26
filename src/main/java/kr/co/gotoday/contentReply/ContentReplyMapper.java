package kr.co.gotoday.contentReply;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ContentReplyMapper {
	
	//게시판 생성
	int insertContentQA(ContentReplyVO vo);
	
	// 게시판 삭제
	int deleteReply(ContentReplyVO vo);
	
	// 게시판 수정
	int updateReply(ContentReplyVO vo);
	
	//게시판 전체 조회
	List<ContentReplyVO> selectAllQA(@Param("content_id") int content_id);
		
	//유저 개인이 작성한 게시판만 조회
	List<ContentReplyVO> selectQAByID(@Param("user_id") int user_id);
	
	//벤더가 글 insert
	int insertVendorQA(ContentReplyVO vo);
	
	//갯수 세기 
	int count(@Param("content_id") int content_id);
	
	//상세보기 -> 답변까지 보여줌 
	List<ContentReplyVO> showDetail(@Param("creply_id") int creply_id);
	
	//gno 업데이트
	int updateGno(@Param("creply_id") int creply_id);
	
	//gno 찾기
	int selectGno(@Param("creply_id") int creply_id);
	
	//답변여부 체크
	int updateReplyStatus(@Param("creply_id") int creply_id,
            @Param("reply_status") int reply_status);
	
	//벤터 답변 여부 확인
	int countVendorReplyByGno(@Param("gno") int gno);
	
	//벤더 답변 삭제
	int deleteVendorReplyByGno(@Param("gno") int gno);
	
	
	
}
