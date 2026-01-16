package kr.co.gotoday.user;

import java.util.List;

public interface UserService {
	UserVO login(UserVO vo);
	
	boolean registerUserInfo(UserVO vo);
	boolean registerUserTags(List<UserTagVO> tagList);
	
    Long findTagIdByName(String tagName);
    int emailCheck(String email);
    
    // 인가 코드 → Access Token
    String getKakaoAccessToken(String code);       
    // Access Token → 사용자 정보
    UserVO getKakaoUserInfo(String accessToken);
    
    boolean insertKakaoUser(UserVO vo);
    
	UserVO loginByEmail(String email);

}
