package kr.co.gotoday.review;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.gotoday.reservation.ReservationServiceImpl;

@Service
public class ReviewServiceImpl implements ReviewService{

	@Autowired
	ReviewMapper reviewMapper;
	
	private static final Logger log =
	        LoggerFactory.getLogger(ReservationServiceImpl.class);
	
	@Override
	public void createReview(ReviewVO reviewVO) {
		int result = reviewMapper.createReview(reviewVO);
		if (result < 1) {
			log.error("[리뷰 등록 실패] reviewVO={}", reviewVO);
			throw new RuntimeException("리뷰 등록 실패!");
		}
	}

	@Override
	public void updateReview(ReviewVO reviewVO) {
		int result = reviewMapper.updateReview(reviewVO);
		if (result < 1) {
			log.error("[리뷰 수정 실패] reviewVO={}", reviewVO);
			throw new RuntimeException("리뷰 수정 실패!");
		}
	}

	@Override
	public void deleteReview(int reviewId, int userId) {
		int result = reviewMapper.deleteReview(reviewId, userId);
		if (result < 1) {
			log.error("[리뷰 삭제 실패] reviewId={}, userId={}", reviewId, userId);
			throw new RuntimeException("리뷰 삭제 실패!");
		}
	}

	@Override
	public ReviewVO findReviewById(int reviewId) {
		return reviewMapper.findOneReviewById(reviewId);
	}

	@Override
	public ReviewVO findReviewByReservationId(int reservationId) {
		return reviewMapper.findReviewByReservationId(reservationId);
	}

	@Override
	public boolean checkReviewExists(int reservationId) {
		return reviewMapper.checkReviewExistsById(reservationId) > 0;
	}

	@Override
	public List<ReviewVO> findReviewsByUserId(int user_id) {
		return reviewMapper.findReviewsByUserId(user_id);
	}

	@Override
	public List<ReviewVO> getReviewsByContentPaged(int content_id, int page, String sortType ) {
	    int limit = 10;
	    int offset = (page - 1) * limit;
	    
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("content_id", content_id);
	    map.put("limit", limit);
	    map.put("offset", offset);
	    map.put("sortType", sortType );

	    List<ReviewVO> list = reviewMapper.findReviewsByContentIdWithSort(map);

        for (ReviewVO r : list) {
            r.setMaskedEmail(maskEmail(r.getEmail()));
        }

        return list;
	}

	@Override
	public Map<String, Object> getRatingSummary(int content_id) {
		Map<String, Object> row = reviewMapper.findAvgRatingByStar(content_id);
		
	    Map<String, Object> result = new HashMap<>();
	    result.put("totalReviews", ((Number) row.get("total_reviews")).intValue());
	    result.put("avgRating", ((Number) row.get("avg_rating")).doubleValue());

	    result.put("rating_5", ((Number) row.get("rating_5")).intValue());
	    result.put("rating_4", ((Number) row.get("rating_4")).intValue());
	    result.put("rating_3", ((Number) row.get("rating_3")).intValue());
	    result.put("rating_2", ((Number) row.get("rating_2")).intValue());
	    result.put("rating_1", ((Number) row.get("rating_1")).intValue());
	    return result;
	}

	@Override
	public  Map<String, Double> getAvgRatingByTimeZone(int content_id) {
		List<Map<String, Object>> rows = reviewMapper.findAvgRatingByTimeSlot(content_id);

	    Map<String, Double> result = new HashMap<>();
	    for (Map<String, Object> row : rows) {
	        Object zoneObj = row.get("visited_time_zone");
	        Object avgObj  = row.get("avg_rating");

	        if (avgObj == null) continue;

	        String key;
	        if (zoneObj == null || zoneObj.toString().trim().isEmpty()) {
	            key = "always";   // 상시 전시
	        } else {
	            key = zoneObj.toString();
	        }

	        result.put(key, ((Number) avgObj).doubleValue());
	    }
	    return result;
	}
	
	private String maskEmail(String email) {
	    if (email == null || email.length() < 3) return "***";
	    return email.substring(0, 3) + "****";
	}
}
