package kr.co.gotoday.user;

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
    public boolean register(UserVO vo) {
        try {
            int result = userMapper.register(vo);

            if (result > 0 && vo.getUserTagList() != null && !vo.getUserTagList().isEmpty()) {
                for (UserTagVO tag : vo.getUserTagList()) {
                    tag.setUser_id(vo.getUser_id());
                    userMapper.createUserTags(tag);
                }
            }
            return result > 0;
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
