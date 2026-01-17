package kr.co.gotoday.user;

import java.util.List;

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
    
    // 관리자 로그인
    UserVO adminLogin(UserVO vo);
    
    // 관심사 수정
    List<String> getUserTagNames(int userId);
    void deleteUserTags(int userId);
    void insertUserTag(UserTagVO vo);
}
