package kr.co.gotoday.reply;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ReplyMapper {
	int create(ReplyVO vo);
	int adminCreate(ReplyVO vo);
	int updateStatus(int no);
	int count(ReplyVO vo);
	List<ReplyVO> list(ReplyVO vo);
	ReplyVO detail(ReplyVO vo);
	int update(ReplyVO vo);
	int delete(int no);
	ReplyVO getAdminReply(int reply_id);
}
