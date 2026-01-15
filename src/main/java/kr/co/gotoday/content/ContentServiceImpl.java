package kr.co.gotoday.content;

import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
@Service
public class ContentServiceImpl implements ContentService{
	
	//mapper를 만들고 돌아올것
	@Autowired
	ContentMapper contentMapper; 
	
	
	@Override
	public List<MainContentViewDTO> getRandomContents(MainContentDTO mcd) {
		// TODO Auto-generated method stub
		//service가 정책 메서드를 호출하지 않고 viewDTO를 반환하면 안됨 . 
		// Mapper는 contentVO 반환
		//Service에서 viewDTO 변환
		   // 1️⃣ DB에서 날것 데이터 조회
        List<ContentVO> list = contentMapper.randomContent(mcd);

        // 2️⃣ 정책 적용 + ViewDTO 변환
        return list.stream()
                   .map(vo -> applyViewPolicy(vo, mcd))
                   .collect(Collectors.toList());
	}

	@Override
	public List<MainContentViewDTO> getRecommandContents(MainContentDTO mcd) {
		// TODO Auto-generated method stub
	      List<ContentVO> list = contentMapper.recommandContent(mcd);

	        return list.stream()
	                   .map(vo -> applyViewPolicy(vo, mcd))
	                   .collect(Collectors.toList());
	    }	

	@Override
	public ContentVO getDetailContents(int content_id,Integer user_id) {
		//상세페이지 보여주는것 
		System.out.println("service~~집입"+content_id);
		ContentVO vo= contentMapper.selectByID(content_id);
		if(vo==null) {
			System.out.println("이게 문제인거임?");
			return null;
		}  

		System.out.println("db 조회결과 vo="+vo);
	

		return vo;
	}

	//핵심 메서드
	
	private MainContentViewDTO applyViewPolicy(ContentVO vo, MainContentDTO mcd) {
		MainContentViewDTO mcv= new MainContentViewDTO(vo);
		 if (mcd.getUser_id()== null) {
	            mcv.setBlur(true);
	            mcv.setCtaMessage("로그인하시면 볼 수 있습니다!");
	            mcv.setCtaUrl("/member/login");
	            return mcv;
	        }

	        // 회원 + 관심사 없음
	        if (mcd.getUser_tag_id().isEmpty()&& mcd.getUser_id()!=null) {
	            mcv.setBlur(true);
	            mcv.setCtaMessage("관심사 설정하시면 볼 수 있습니다!");
	            mcv.setCtaUrl("/mypage/like_list");
	            return mcv;
	        }
	        //정상인 경우
	        mcv.setBlur(false);
	        return mcv;

	}

}
