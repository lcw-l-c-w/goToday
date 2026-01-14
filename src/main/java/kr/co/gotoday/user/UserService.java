package kr.co.gotoday.user;

import java.util.List;

public interface UserService {
	UserVO login(UserVO vo);
	
	boolean registerUserInfo(UserVO vo);
	boolean registerUserTags(List<UserTagVO> tagList);
	
    Long findTagIdByName(String tagName);
    int emailCheck(String email);
}
