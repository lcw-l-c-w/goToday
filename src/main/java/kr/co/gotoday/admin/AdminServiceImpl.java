package kr.co.gotoday.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.user.UserVO;
import util.PageInfo;

@Service
public class AdminServiceImpl implements AdminService {
	
	@Autowired
	private AdminMapper adminMapper;
	
	@Override
	public Map<String, Object> getFilterList(int user_id, String keyword, Integer is_active, Integer page) {
		int pageSize = 7;
		int blockSize = 5;
		
		Map<String, Object> param = new HashMap<>();
		param.put("user_id", user_id);
		param.put("keyword", keyword);
		param.put("is_active", is_active);
		
		int count = adminMapper.selectContentListCount(param);
		
		PageInfo pageInfo = PageInfo.of(count, page, pageSize, blockSize); 
		
		param.put("offset", PageInfo.offset(page, pageSize));
		param.put("pageSize", pageSize);
		List<ContentVO> list = adminMapper.selectContentList(param);
		
		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		result.put("pageInfo", pageInfo);
		return result;
	}
	
	@Override
	public Map<String, Object> getRequestList(
	        int user_id,
	        String keyword,
	        String content_status,
	        Integer page
			) {
		int pageSize = 7;
		int blockSize = 5;
		
	    Map<String, Object> param = new HashMap<>();
	    param.put("user_id", user_id);
	    param.put("keyword", keyword);
	    param.put("content_status", content_status);
	    
	    int count = adminMapper.requestContentListCount(param);
	    PageInfo pageInfo = PageInfo.of(count, page, pageSize, blockSize); 
	    param.put("offset", PageInfo.offset(page, pageSize));
		param.put("pageSize", pageSize);
		
	    List<ContentVO> list = adminMapper.requestContentList(param);

	    Map<String, Object> result = new HashMap<>();
	    result.put("list", list);
	    result.put("pageInfo", pageInfo);
	    return result;
	}
	
	@Override
	public Map<String, Object> getUserList(
			int user_id, 
			String keyword, 
			Integer role,
			Integer page
			){
		int pageSize = 8;
		int blockSize = 5;
		
		Map<String, Object> param = new HashMap<>();
		param.put("user_id", user_id);
		param.put("keyword", keyword);
		param.put("role", role);
		
		int count = adminMapper.userListCount(param);
	    PageInfo pageInfo = PageInfo.of(count, page, pageSize, blockSize); 
	    param.put("offset", PageInfo.offset(page, pageSize));
		param.put("pageSize", pageSize);
		
		List<UserVO> userList = adminMapper.userList(param);
		
		Map<String, Object> result = new HashMap<>();
		result.put("userList", userList);
		result.put("pageInfo", pageInfo);
		return result;
		
	}

	
	@Override
	public int updateActive(int content_id) {
		return adminMapper.updateActive(content_id);
	}
	
	@Override
	public int updateDelete(int content_id) {
		return adminMapper.updateDelete(content_id);
	}
	
	@Override
	public int updateRequest(int content_id) {
		return adminMapper.updateContentStatus(content_id, "STATUS_APPROVAL");

	}
	
	@Override
	public int updateRejected(int content_id) {
		return adminMapper.updateContentStatus(content_id, "STATUS_REJECTED");

	}


	
	

}
