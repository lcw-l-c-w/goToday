package kr.co.gotoday.mypage;

import java.util.List;
import java.util.Map;

import kr.co.gotoday.reply.ReplyVO;

public interface MypageService {
	List<MypageDTO> getMyLikeList(Integer user_id);
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

}
