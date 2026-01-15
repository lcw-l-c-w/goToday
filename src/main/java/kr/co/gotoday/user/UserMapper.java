package kr.co.gotoday.user;

<<<<<<< HEAD

public class UserMapper {
=======
import org.apache.ibatis.annotations.Mapper;
>>>>>>> origin/develop

@Mapper
public interface UserMapper {
	UserVO login(UserVO vo);
    int register(UserVO vo);
    void createUserTags(UserTagVO vo);
    Long findTagIdByName(String tagName);
    Integer emailCheck(String email);
}
