package kr.co.gotoday.replyVendor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

public interface ReplyVendorService {
	int update(ReplyVendorVO vo);
	Map<String, Object> list(ReplyVendorVO vo);
	int create(ReplyVendorVO vo);
	int adminCreate(ReplyVendorVO vo);
	int delete(int reply_id);
	ReplyVendorVO detail(ReplyVendorVO vo);
	ReplyVendorVO getAdminReply(int reply_id);
	int deleteAdminOnly(int reply_id);
}
