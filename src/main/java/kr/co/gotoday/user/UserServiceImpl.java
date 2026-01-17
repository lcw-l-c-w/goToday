package kr.co.gotoday.user;

import java.util.List;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
public class UserServiceImpl implements UserService{
	
	@Autowired
	private UserMapper userMapper;

    @Override
    public UserVO login(UserVO vo) {
        return userMapper.login(vo);
    }

    @Override
    @Transactional
    public boolean registerUserInfo(UserVO vo) {
    	return userMapper.register(vo) > 0 ? true : false;
    }
    
    @Override
    @Transactional
    public boolean registerUserTags(List<UserTagVO> tagList) {
    	try {
    	    if (tagList != null) tagList.forEach(userMapper::createUserTags);
    	    return true;
    	} catch (Exception e) {
    	    e.printStackTrace();
    	    return false;
    	}
    }

    @Override
    public Long findTagIdByName(String tagName) {
        return userMapper.findTagIdByName(tagName);
    }

    @Override
    public int emailCheck(String email) {
        return userMapper.emailCheck(email);
    }
    
    // 카카오 로그인 서비스
    @Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;
    @Value("${kakao.redirect-uri}")
    private String kakaoRedirectUri;

    @Override
    public String getKakaoAccessToken(String code) {
        RestTemplate rt = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", kakaoRestApiKey);
        params.add("redirect_uri", kakaoRedirectUri);
        params.add("code", code);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

        ResponseEntity<String> response = rt.exchange(
                "https://kauth.kakao.com/oauth/token",
                HttpMethod.POST,
                request,
                String.class
        );

        JSONObject json = new JSONObject(response.getBody());
        return json.getString("access_token");
    }

    @Override
    public UserVO getKakaoUserInfo(String accessToken) {
        RestTemplate rt = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        HttpEntity<String> entity = new HttpEntity<>(headers);

        ResponseEntity<String> response = rt.exchange(
                "https://kapi.kakao.com/v2/user/me",
                HttpMethod.GET,
                entity,
                String.class
        );

        JSONObject json = new JSONObject(response.getBody());
        JSONObject kakaoAccount = json.getJSONObject("kakao_account");
        JSONObject profile = kakaoAccount.getJSONObject("profile");

        UserVO user = new UserVO();
        user.setKakao_nickname(profile.getString("nickname"));
        user.setKakao_email(kakaoAccount.optString("email"));
        return user;
    }
    
    @Override
    @Transactional
    public boolean insertKakaoUser(UserVO vo) {
        return userMapper.insertKakaoUser(vo) > 0 ? true : false;
    }
    
    @Override
    public UserVO loginByEmail(String email) {
    	return userMapper.loginByEmail(email);
    }
    
    @Override
    public UserVO adminLogin(UserVO vo) {
        return userMapper.adminLogin(vo);
    }
    
    // 관심사 수정
    @Override
    public List<String> getUserTagNames(int userId) {
        return userMapper.getUserTagNames(userId);
    }
    // 관심사 수정
    @Override
    @Transactional
    public boolean updateUserTags(int userId, List<String> tagNames) {
    	// 기존 태그 삭제
        userMapper.deleteUserTags(userId);
        // 새로운 태그 추가
        for (String tagName : tagNames) {
            Long tagId = userMapper.findTagIdByName(tagName);
            // 태그가 존재하지 않는 경우 스킵
            if (tagId == null) continue;
            UserTagVO ut = new UserTagVO();
            ut.setUser_id(userId);
            ut.setTag_id(tagId.intValue());
            userMapper.insertUserTag(ut);
        }
        return true;
    }
    
    //회원정보 수정
    @Override
    public UserVO getUserById(int userId) {
        return userMapper.getUserById(userId);
    }
    //회원정보 수정
    @Override
    @Transactional
    public boolean updateUserInfo(UserVO vo) {
    	// 패스워드 입력 안 하면 null로 두기 → XML에서 처리
        if (vo.getPassword() != null && vo.getPassword().isEmpty()) {
            vo.setPassword(null);
        }
        int result = userMapper.updateUserInfo(vo);
        return result > 0;
    }
}
