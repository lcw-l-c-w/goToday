package kr.co.gotoday.mypage;

import java.util.List;
import java.util.Map;

import kr.co.gotoday.reply.ReplyVO;

public interface MypageService {
	
	//나의 user_id 기준으로 좋아요 누른 목록들 불러오기
	List<MypageDTO> getMyLikeList(Integer user_id,int offset, int pageSize);
	
	// 나의 문의사항 가져오기 
	Map<String, Object> getMyReplyList(ReplyVO vo);
	
	
	// 문의 상세 내용 가져오기
    ReplyVO getReplyDetail(int reply_id);

    // 문의 답변 가져오기
    ReplyVO getReplyAnswer(int reply_id);
    
    // 1:1 문의사항 list 
    Map<String, Object> getMyInquiryList(MypageDTO dto);

    // 1:1 문의사항 본문
    List<MypageDTO> getInquiryDetail(int creplyId);
	
    // 1:1 문의사항 답변
	MypageDTO getInquiryAnswer(int creply_id);
	
	//좋아요 문의사항 가져오기
	int getLikeCount(int user_id);
	
	

}
