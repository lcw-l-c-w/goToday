package kr.co.gotoday.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.user.UserVO;

@Service
public class AdminServiceImpl implements AdminService {
	
	@Autowired
	private AdminMapper adminMapper;
	
	@Override
	public Map<String, Object> getFilterList(int user_id, String keyword, Integer is_active) {
		Map<String, Object> param = new HashMap<>();
		param.put("user_id", user_id);
		param.put("keyword", keyword);
		param.put("is_active", is_active);
		
		List<ContentVO> list = adminMapper.selectContentList(param);
		
		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		return result;
	}
	
	@Override
	public Map<String, Object> getRequestList(
	        int user_id,
	        String keyword,
	        String content_status
			) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("user_id", user_id);
	    param.put("keyword", keyword);
	    param.put("content_status", content_status);

	    List<ContentVO> list = adminMapper.requestContentList(param);

	    Map<String, Object> result = new HashMap<>();
	    result.put("list", list);
	    return result;
	}
	
	@Override
	public Map<String, Object> getUserList(
			int user_id, 
			String keyword, 
			Integer role
			){
		Map<String, Object> param = new HashMap<>();
		param.put("user_id", user_id);
		param.put("keyword", keyword);
		param.put("role", role);
		
		List<UserVO> userList = adminMapper.userList(param);
		Map<String, Object> result = new HashMap<>();
		result.put("userList", userList);
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
