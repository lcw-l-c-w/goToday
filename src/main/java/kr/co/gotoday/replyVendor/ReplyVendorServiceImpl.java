package kr.co.gotoday.replyVendor;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;

@Service
//@RequiredArgsConstructor
public class ReplyVendorServiceImpl implements ReplyVendorService {
	
	@Autowired
	private ReplyVendorMapper mapper;
	
	//유저 /벤더
	@Override
	public int create(ReplyVendorVO vo) {
		return mapper.create(vo);
	}
	
	@Override
	public int adminCreate(ReplyVendorVO vo) {
		return mapper.adminCreate(vo);
	}
	
	@Override
	public int update(ReplyVendorVO vo) {
		return mapper.update(vo);
	}

	@Override
	public int delete(int reply_id) {
		mapper.deleteAdmin(reply_id);
		return mapper.delete(reply_id);
	}
	
	@Override
	public int deleteAdminOnly(int reply_id) {
		return mapper.deleteAdmin(reply_id);
	}

	@Override
	public Map<String, Object> list(ReplyVendorVO param) {
		int count = mapper.count(param); // 총개수
        // 총페이지수
        int totalPage = count / 5;
        if (count % 5 > 0) totalPage++;
        List<ReplyVendorVO> list = mapper.list(param); // 목록
        
        Map<String, Object> map = new HashMap<>();
        map.put("count", count);
        map.put("totalPage", totalPage);
        map.put("list", list);
        
        // 하단에 페이징처리
        int endPage = (int)(Math.ceil(param.getPage()/5.0)*5);
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

	@Override
	public ReplyVendorVO detail(ReplyVendorVO vo) {
		return mapper.detail(vo);
	}

	@Override
	public ReplyVendorVO getAdminReply(int reply_id) {
	    return mapper.getAdminReply(reply_id);
	}

}
