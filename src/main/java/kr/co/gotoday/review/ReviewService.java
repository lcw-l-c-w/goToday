package kr.co.gotoday.review;

import java.util.List;

public interface ReviewService {
	void createReview(ReviewVO reviewVO);
	void updateReview(ReviewVO reviewVO);
	void deleteReview(int review_id, int user_id);
	ReviewVO findReviewById(int review_id);
	ReviewVO findReviewByReservationId(int reservation_id);
	boolean checkReviewExists(int reservation_id);
	List<ReviewVO> findReviewsByUserId(int user_id);
}
