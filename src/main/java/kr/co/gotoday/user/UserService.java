package kr.co.gotoday.user;

public interface UserService {
	UserVO login(UserVO vo);
    boolean register(UserVO vo);
    Long findTagIdByName(String tagName);
    int emailCheck(String email);
}
