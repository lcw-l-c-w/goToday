package kr.co.gotoday.review;

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
		int result  = reviewMapper.createReview(reviewVO);
		
		if (result < 1) {
			log.error("[리뷰 등록 실패] reviewVO={}",reviewVO);
			throw new RuntimeException("리뷰 등록 실패!");
		}
	}

}
