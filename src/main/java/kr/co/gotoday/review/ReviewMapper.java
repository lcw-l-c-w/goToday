package kr.co.gotoday.review;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ReviewMapper {

	int createReview(ReviewVO review);
	int updateReview(ReviewVO review);
	int deleteReview(@Param("review_id") int review_id, @Param("user_id") int userId);

	ReviewVO findOneReviewById(int review_id);
	List<ReviewVO> findReviewsByUserId(int user_id);
	List<ReviewVO> findReviewsByContentIdWithSort(Map<String, Object> map);
	List<ReviewVO> findAllReviews();

	Map<String, Object> findAvgRatingByStar(int content_id);
	List<Map<String, Object>> findAvgRatingByTimeSlot(int content_id);

	int checkReviewExistsById(int reservation_id);
	int countReviewsByContentId(int content_id);
	ReviewVO findReviewByReservationId(int reservation_id);

}
