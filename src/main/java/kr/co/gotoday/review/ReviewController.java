package kr.co.gotoday.review;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oreilly.servlet.MultipartRequest;

import kr.co.gotoday.user.UserVO;

@Controller
public class ReviewController {
	
	@Autowired
	ReviewService reviewService;
	

	
	@PostMapping("/review/create.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> createReview(
			HttpServletRequest request, HttpSession sess) {		
		
		String uploadPath = "C:/gotoday_img";
		
		//해당 폴더가 없으면 생성
		File dir = new File(uploadPath);
	    if (!dir.exists()) {
	        dir.mkdirs();
	    }
		
	    int maxSize = 10 * 1024 * 1024; // 10MB
	    
	    try {
	        MultipartRequest multi = new MultipartRequest(
	            request, 
	            uploadPath,
	            maxSize, 
	            new util.MyFileRenamePolicy()
	        );
	        
	        UserVO userVO = (UserVO) sess.getAttribute("loginSess");

	        String visited_at = multi.getParameter("visited_at");
	        String visited_time_zone = multi.getParameter("visited_time_zone");

	        String image_new = multi.getFilesystemName("image_new");
	        String image_org = multi.getOriginalFileName("image_org");

	        ReviewVO reviewVO = new ReviewVO();
	        reviewVO.setContent(multi.getParameter("content"));

	        String ratingStr = multi.getParameter("rating");
	        if (ratingStr != null && !ratingStr.isEmpty()) {
	            reviewVO.setRating(Integer.parseInt(ratingStr));
	        }

	        reviewVO.setVisited_at(visited_at);
	        reviewVO.setVisited_time_zone(visited_time_zone);
	        reviewVO.setImage_org(image_org);
	        reviewVO.setImage_new(image_new);
	        reviewVO.setContent_id(Integer.parseInt(multi.getParameter("content_id")));
	        reviewVO.setReservation_id(Integer.parseInt(multi.getParameter("reservation_id")));
	        reviewVO.setUser_id(userVO.getUser_id());

	        //등록 서비스 호출
	        reviewService.createReview(reviewVO);

	        Map<String, Object> response = new HashMap<>();
	        response.put("success", true);
	        response.put("message", "리뷰가 등록되었습니다.");
	        return ResponseEntity.ok(response);

	    } catch (Exception e) {
	        e.printStackTrace();
	        Map<String, Object> errorResponse = new HashMap<>();
	        errorResponse.put("success", false);
	        errorResponse.put("message", "리뷰 등록에 실패했습니다.");
	        return ResponseEntity.badRequest().body(errorResponse);
	    }
	}
}
