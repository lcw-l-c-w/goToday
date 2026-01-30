package kr.co.gotoday.review;

import java.util.List;
import java.util.Map;

public interface ReviewService {
	void createReview(ReviewVO reviewVO);
	void updateReview(ReviewVO reviewVO);
	void deleteReview(int review_id, int user_id);
	ReviewVO findReviewById(int review_id);
	ReviewVO findReviewByReservationId(int reservation_id);
	boolean checkReviewExists(int reservation_id);
	List<ReviewVO> findReviewsByUserId(int user_id);
    List<ReviewVO> getReviewsByContentPaged(int content_id, int page, String sortType );
    Map<String, Object> getRatingSummary(int content_id);
    Map<String, Double> getAvgRatingByTimeZone(int content_id);
    
    List<ReviewVO> findReviewsByUserIdPaged(int user_id, int page, int limit);
    int countReviewsByUserId(int user_id);
	
}
