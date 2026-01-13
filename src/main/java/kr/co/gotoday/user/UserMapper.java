package kr.co.gotoday.user;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {
	UserVo loginUser(UserVo vo);
    int registerUser(UserVo vo);
    void createUserTags(UserTagVO vo);
    Long findTagIdByName(String tagName);
}
