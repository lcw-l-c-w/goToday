package kr.co.gotoday.replyVendor;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ReplyVendorMapper {
	int create(ReplyVendorVO vo);
	int adminCreate(ReplyVendorVO vo);
	int updateStatus(int no);
	int count(ReplyVendorVO vo);
	List<ReplyVendorVO> list(ReplyVendorVO vo);
	ReplyVendorVO detail(ReplyVendorVO vo);
	int update(ReplyVendorVO vo);
	int delete(int no);
	int deleteAdmin(int no);
	ReplyVendorVO getAdminReply(int reply_id);
}
