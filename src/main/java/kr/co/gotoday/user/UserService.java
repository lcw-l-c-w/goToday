package kr.co.gotoday.user;

import java.util.List;

public interface UserService {
	UserVO login(UserVO vo);
	
	boolean registerUserInfo(UserVO vo);
	boolean registerUserTags(List<UserTagVO> tagList);
	
	Long findTagIdByNameAndCategory(String tagName, String category);
    int emailCheck(String email);
    
    // 인가 코드 → Access Token
    String getKakaoAccessToken(String code);       
    // Access Token → 사용자 정보
    UserVO getKakaoUserInfo(String accessToken);
    
    boolean insertKakaoUser(UserVO vo);
    
	UserVO loginByEmail(String email);
	
	// 관리자 로그인
	UserVO adminLogin(UserVO vo);
	
	// 관심사 수정
	List<String> getUserTagNames(int userId);
	boolean updateUserTags(int userId,
            String event,
            List<String> locations,
            List<String> interests);

	// 회원 정보 수정
	UserVO getUserById(int userId);
	boolean updateUserInfo(UserVO vo);
	
	public UserVO getNaverUserInfo(String accessToken);
	
	boolean insertNaverUser(UserVO vo);
	
	public String getNaverAccessToken(String code, String savedState);
	
	public UserVO loginByNaverKey(String naver_key);
	// 아이디 비밀번호 찾기
	String findEmail(String name, String birthday, String phone_number);
	String resetPassword(String email, String phone_number);
	
}
