package kr.co.gotoday.user;

public interface UserService {
	UserVo loginUser(UserVo vo);
    boolean registerUser(UserVo vo);
    Long findTagIdByName(String tagName);
}
