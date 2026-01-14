package kr.co.gotoday.user;

import java.sql.Timestamp;
import java.util.List;

public class UserVO {
	private int user_id;
    private String email;
    private int role; //0:유저 1:관리자
    private String password;
    private String login_type;
    private String name;
    private String gender;
    private String birthday;
    private Timestamp registered_at;
    private String phone_number;
    
    private List<UserTagVO> userTagList;
}
