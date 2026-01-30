package kr.co.gotoday.admin;

import java.util.Map;

public interface AdminService {

	Map<String, Object> getFilterList(int user_id, String keyword, Integer is_active, Integer page);

	int updateActive(int content_id);
	int updateDelete(int content_id);

	int updateRequest(int content_id);
	int updateRejected(int content_id);

	Map<String, Object> getUserList(int user_id, String keyword, Integer role, Integer page);
	Map<String, Object> getRequestList(int user_id, String keyword, String content_status, Integer page);

}
