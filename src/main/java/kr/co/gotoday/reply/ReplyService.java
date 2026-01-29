package kr.co.gotoday.reply;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

public interface ReplyService {
	int update(ReplyVO vo);
	Map<String, Object> list(ReplyVO vo);
	int create(ReplyVO vo);
	int adminCreate(ReplyVO vo);
	int delete(int reply_id);
	ReplyVO detail(ReplyVO vo);
	ReplyVO getAdminReply(int reply_id);
	int deleteAdminOnly(int reply_id);
}
