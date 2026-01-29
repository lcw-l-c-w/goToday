package kr.co.gotoday.mypage;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.gotoday.reply.ReplyVO;

@Mapper
public interface MypageMapper {
	// 내가 좋아요 누른 콘텐츠 목록
    List<MypageDTO> selectMyLikeList(@Param("user_id") Integer user_id);
 
    // 내 Q&A 문의 목록
    List<ReplyVO> selectMyReplyList(ReplyVO vo);
    int countMyReplyList(@Param("user_id") int user_id);
    
    ReplyVO selectReplyDetail(@Param("reply_id") int reply_id);
    ReplyVO selectReplyAnswer(@Param("reply_id") int reply_id);
    
    // 1:1 문의사항
    List<MypageDTO> selectMyInquiryList(MypageDTO dto);
    int countMyInquiryList(MypageDTO dto);
    
    // 1:1 문의사항 detail(질문, 답변)
    // 1:1 문의사항 본문
    List<MypageDTO> selectInquiryDetail(int creplyId);
    // 1:1 문의사항 답변
    MypageDTO selectInquiryAnswer(@Param("creply_id") int creply_id);
}
