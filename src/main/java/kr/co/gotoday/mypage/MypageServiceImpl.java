package kr.co.gotoday.mypage;

import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MypageServiceImpl implements MypageService {

	private final MypageMapper mypageMapper;

    @Override
    public List<MypageDTO> getMyLikeList(Integer user_id) {
        return mypageMapper.selectMyLikeList(user_id);
    }
    
}
