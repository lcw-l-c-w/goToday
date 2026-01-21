package kr.co.gotoday.review;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oreilly.servlet.MultipartRequest;

@Controller
public class ReviewController {
	
	@Autowired
	ReviewService reviewService;
	
	@PostMapping("/review/create.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> createReview(HttpServletRequest request) {		
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

	        String visited_at = multi.getParameter("visited_at");
	        String visited_time_zone = multi.getParameter("visited_time_zone");

	        String image_new = multi.getFilesystemName("image_new"); 
	        String image_org = multi.getOriginalFileName("image_org"); 
	        
	        ReviewVO reviewVO = new ReviewVO();
	        reviewVO.setContent(multi.getParameter("content"));
	        reviewVO.setRating(Integer.parseInt(multi.getParameter("rating")));
	        
	        
	        reviewService.createReivew(reviewVO);
	        
	        Map<String, Object> response = new HashMap();
	        response.put("success", true);
	        response.put("message", "리뷰가 등록되었습니다.");
	        return ResponseEntity.ok(response);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        return (ResponseEntity<Map<String, Object>>) ResponseEntity.badRequest();
	    }
	}
}
