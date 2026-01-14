package kr.co.gotoday.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
}
