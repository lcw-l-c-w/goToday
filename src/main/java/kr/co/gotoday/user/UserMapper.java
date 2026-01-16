package kr.co.gotoday.user;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {
	UserVO login(UserVO vo);
    int register(UserVO vo);
    void createUserTags(UserTagVO vo);
    Long findTagIdByName(String tagName);
    Integer emailCheck(String email);
    
    // 카카오 로그인 
    int insertKakaoUser(UserVO vo);
    UserVO loginByEmail(String email);
}
