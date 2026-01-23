package kr.co.gotoday.mypage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.co.gotoday.reply.ReplyMapper;
import kr.co.gotoday.reply.ReplyVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MypageServiceImpl implements MypageService {

	private final MypageMapper mypageMapper;
    private final ReplyMapper replyMapper;
    
    @Override
    public List<MypageDTO> getMyLikeList(Integer user_id) {
        return mypageMapper.selectMyLikeList(user_id);
    }
   

    @Override
    public Map<String, Object> getMyReplyList(ReplyVO vo) {
        int count = mypageMapper.countMyReplyList(vo.getUser_id());
        
        // 총페이지수
        int totalPage = count / 5;
        if (count % 5 > 0) totalPage++;
        
        List<ReplyVO> list = mypageMapper.selectMyReplyList(vo);
        
        Map<String, Object> map = new HashMap<>();
        map.put("count", count);
        map.put("totalPage", totalPage);
        map.put("list", list);
        
        // 페이징 처리
        int endPage = (int)(Math.ceil(vo.getPage()/5.0)*5);
        int startPage = endPage - 4;
        if (endPage > totalPage) endPage = totalPage;
        boolean isPrev = startPage > 1;
        boolean isNext = endPage < totalPage;
        
        map.put("endPage", endPage);
        map.put("startPage", startPage);
        map.put("isPrev", isPrev);
        map.put("isNext", isNext);
        
        return map;
    }
    
    // 문의글 본문 조회
    @Override
    public ReplyVO getReplyDetail(int reply_id) {
        return mypageMapper.selectReplyDetail(reply_id);
    }
    
    // 답변 글 조회
    @Override
    public ReplyVO getReplyAnswer(int reply_id) {
        return mypageMapper.selectReplyAnswer(reply_id);
    }
    
}
