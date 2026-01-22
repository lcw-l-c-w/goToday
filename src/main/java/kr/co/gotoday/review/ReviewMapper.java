package kr.co.gotoday.review;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ReviewMapper {

	int createReview(ReviewVO review);
	int updateReview(ReviewVO review);
	int deleteReview(@Param("review_id") int reviewId, @Param("user_id") int userId);

	ReviewVO findOneReviewById(@Param("review_id") int reviewId);
	List<ReviewVO> findReviewsByUserId(@Param("user_id") int userId);
	List<ReviewVO> findReviewsByContentIdWithSort(@Param("content_id") int contentId, @Param("sortType") String sortType);
	List<ReviewVO> findAllReviews();

	Map<String, Object> findAvgRatingByStar(@Param("content_id") int contentId);
	List<Map<String, Object>> findAvgRatingByTimeSlot(@Param("content_id") int contentId);

	int checkReviewExistsById(@Param("reservation_id") int reservationId);
	int countReviewsByContentId(@Param("content_id") int contentId);

}
