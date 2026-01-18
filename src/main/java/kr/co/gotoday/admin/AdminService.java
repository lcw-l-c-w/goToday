package kr.co.gotoday.admin;

import java.util.Map;

public interface AdminService {

	Map<String, Object> getFilterList(int user_id, String keyword, String activate);

}
