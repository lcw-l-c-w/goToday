package kr.co.gotoday.user;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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
    
    // 마이페이지 회원정보 수정 및 마이페이지 사이드바
    UserVO getUserById(int userId);
    // 마이페이지 회원정보 수정
    int updateUserInfo(UserVO vo);
    
    void createUserTagsBatch(List<UserTagVO> list);
    
    int insertNaverUser(UserVO vo);
    
    UserVO loginByNaverKey(String naver_key);

    // 아이디, 비밀번호 찾기
    UserVO findEmail(
    		@Param("name") String name
    		, @Param("birthday") String birthday
    		, @Param("phone_number") String phone_number
    	);
    
    UserVO findUserForPw(
    		@Param("email") String email
    		, @Param("phone_number") String phone_number
    	);
    
    int updateTempPassword(
    		@Param("user_id") int user_id
    		, @Param("tempPw") String tempPw);
	}
