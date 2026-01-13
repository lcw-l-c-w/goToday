package kr.co.gotoday.user;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService{
	
	private final UserMapper userMapper;

    @Override
    public UserVo loginUser(UserVo vo) {
        return userMapper.loginUser(vo);
    }

    @Override
    @Transactional // 유저 정보와 태그 정보를 함께 저장할 때 트랜잭션 보장
    public boolean registerUser(UserVo vo) {
        int result = userMapper.registerUser(vo);

        if (result > 0 && vo.getUserTagList() != null) {
            for (UserTagVO tag : vo.getUserTagList()) {
                tag.setUser_id(vo.getUser_id());
                userMapper.createUserTags(tag);
            }
        }
        return result > 0;
    }

    @Override
    public Long findTagIdByName(String tagName) {
        return userMapper.findTagIdByName(tagName);
    }
}
