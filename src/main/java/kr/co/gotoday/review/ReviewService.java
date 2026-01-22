package kr.co.gotoday.review;

public interface ReviewService {
	void createReview(ReviewVO reviewVO);
	void updateReview(ReviewVO reviewVO);
	void deleteReview(int reviewId, int userId);
	ReviewVO findReviewByReservationId(int reservationId);
	boolean checkReviewExists(int reservationId);
}
