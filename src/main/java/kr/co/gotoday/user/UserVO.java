package kr.co.gotoday.user;

import java.sql.Timestamp;
import java.util.List;

import lombok.Data;
@Data
public class UserVO {
	private int user_id;
    private String email;
    private int role; //0:유저 1:관리자(업체)
    private String password;
    private String login_type;
    private String name;
    private String gender;
    private String birthday;
    private Timestamp registered_at;
    private String phone_number;
    
    private List<UserTagVO> userTagList;
    
    // 카카오 로그인   
    private String kakao_email; 
    private String kakao_nickname;
    
    //추가 -> admin에 대한 여부
    private int admin; // 0: admin이 아님 / 1: admin이 맞음 
}
