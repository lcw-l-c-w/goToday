package kr.co.gotoday.review;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.gotoday.reservation.ReservationDetailDTO;
import kr.co.gotoday.reservation.ReservationService;
import kr.co.gotoday.user.UserVO;
import util.MyFileRenamePolicy;

@Controller
public class ReviewController {

	private static final String UPLOAD_PATH = "C:/gotoday_img";

	@Autowired
	private ReviewService reviewService;

	@Autowired
	private ReservationService reservationService;

	private static final Logger log = LoggerFactory.getLogger(ReviewController.class);

	@GetMapping("/review/getData")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getReviewData(
			@RequestParam("reservation_id") int reservationId,
			HttpSession sess) {

		Map<String, Object> response = new HashMap<>();

		try {
			UserVO userVO = (UserVO) sess.getAttribute("loginSess");
			if (userVO == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.badRequest().body(response);
			}

			// 예약 정보 조회
			ReservationDetailDTO dto = reservationService.findReservationDetailById(reservationId, userVO.getUser_id());

			if (dto == null) {
				response.put("success", false);
				response.put("message", "예약 정보를 찾을 수 없습니다.");
				return ResponseEntity.badRequest().body(response);
			}

			response.put("reservation_id", dto.getReservation_id());
			response.put("content_id", dto.getContent_id());
			response.put("title", dto.getTitle());
			response.put("location", dto.getLocation());
			response.put("visited_at", dto.getReserved_for_at());
			response.put("visited_time_zone", dto.getTime_zone());

			// 리뷰 존재 여부 확인
			boolean reviewExists = reviewService.checkReviewExists(reservationId);
			response.put("reviewExists", reviewExists);

			// 리뷰가 존재하면 리뷰 데이터도 함께 반환
			if (reviewExists) {
				ReviewVO review = reviewService.findReviewByReservationId(reservationId);
				response.put("review", review);
			}

			return ResponseEntity.ok(response);

		} catch (Exception e) {
			log.error("[리뷰 데이터 조회 실패] reservationId={}", reservationId, e);
			response.put("success", false);
			response.put("message", "데이터 조회에 실패했습니다.");
			return ResponseEntity.badRequest().body(response);
		}
	}

	@PostMapping("/review/create.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> createReview(
			@RequestParam(value = "image_new", required = false) MultipartFile imageFile,
			@RequestParam("content") String content,
			@RequestParam(value = "rating", required = false, defaultValue = "5") int rating,
			@RequestParam("content_id") int contentId,
			@RequestParam("reservation_id") int reservationId,
			@RequestParam(value = "visited_at", required = false) String visitedAt,
			@RequestParam(value = "visited_time_zone", required = false) String visitedTimeZone,
			HttpSession sess) {

		Map<String, Object> response = new HashMap<>();

		try {
			UserVO userVO = (UserVO) sess.getAttribute("loginSess");

			// 이미지 업로드 처리
			String[] imageNames = processImageUpload(imageFile);

			// ReviewVO 생성
			ReviewVO reviewVO = new ReviewVO();
			reviewVO.setContent(content);
			reviewVO.setRating(rating);
			reviewVO.setContent_id(contentId);
			reviewVO.setReservation_id(reservationId);
			reviewVO.setUser_id(userVO.getUser_id());
			reviewVO.setImage_org(imageNames[0]);
			reviewVO.setImage_new(imageNames[1]);
			reviewVO.setVisited_at(visitedAt);
			reviewVO.setVisited_time_zone(visitedTimeZone);

			reviewService.createReview(reviewVO);

			response.put("success", true);
			response.put("message", "리뷰가 등록되었습니다.");
			return ResponseEntity.ok(response);

		} catch (Exception e) {
			log.error("[리뷰 등록 실패]", e);
			response.put("success", false);
			response.put("message", "리뷰 등록에 실패했습니다.");
			return ResponseEntity.badRequest().body(response);
		}
	}

	@PostMapping("/review/update.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateReview(
			@RequestParam(value = "image_new", required = false) MultipartFile imageFile,
			@RequestParam("review_id") int reviewId,
			@RequestParam("content") String content,
			@RequestParam(value = "rating", required = false, defaultValue = "5") int rating,
			@RequestParam(value = "keep_image", required = false, defaultValue = "false") boolean keepImage,
			HttpSession sess) {

		Map<String, Object> response = new HashMap<>();

		try {
			UserVO userVO = (UserVO) sess.getAttribute("loginSess");

			ReviewVO reviewVO = new ReviewVO();
			reviewVO.setReview_id(reviewId);
			reviewVO.setUser_id(userVO.getUser_id());
			reviewVO.setContent(content);
			reviewVO.setRating(rating);

			//새로운 이미지가 업로드 되거나 사진을 유지 한다면 -> DB에 새로 저장 or 기존 이름 저
	        if (imageFile != null && !imageFile.isEmpty()) {
	            String[] imageNames = processImageUpload(imageFile);
	            reviewVO.setImage_org(imageNames[0]);
	            reviewVO.setImage_new(imageNames[1]);
	            
	        } else if ("true".equals(keepImage)) {
	            // DB에서 기존 정보를 불러와서 원본 이름과 변경된 이름을 다시 세팅해줌
	            ReviewVO oldReview = reviewService.findReviewByReservationId(reviewId); 
	            if (oldReview != null) {
	                reviewVO.setImage_org(oldReview.getImage_org());
	                reviewVO.setImage_new(oldReview.getImage_new());
	            }
	        } else {
	            reviewVO.setImage_org(null);	//삭제하거나 안 넣으면 null
	            reviewVO.setImage_new(null);
	        }

			reviewService.updateReview(reviewVO);

			response.put("success", true);
			response.put("message", "리뷰가 수정되었습니다.");
			return ResponseEntity.ok(response);

		} catch (Exception e) {
			log.error("[리뷰 수정 실패] reviewId={}", reviewId, e);
			response.put("success", false);
			response.put("message", "리뷰 수정에 실패했습니다.");
			return ResponseEntity.badRequest().body(response);
		}
	}

	@PostMapping("/review/delete.do")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteReview(
			@RequestParam("review_id") int reviewId,
			HttpSession sess) {

		Map<String, Object> response = new HashMap<>();

		try {
			UserVO userVO = (UserVO) sess.getAttribute("loginSess");

			reviewService.deleteReview(reviewId, userVO.getUser_id());

			response.put("success", true);
			response.put("message", "리뷰가 삭제되었습니다.");
			return ResponseEntity.ok(response);

		} catch (Exception e) {
			log.error("[리뷰 삭제 실패] reviewId={}", reviewId, e);
			response.put("success", false);
			response.put("message", "리뷰 삭제에 실패했습니다.");
			return ResponseEntity.badRequest().body(response);
		}
	}

	//이미지 업로드 처리 (공통 로직)
	private String[] processImageUpload(MultipartFile imageFile) throws Exception {
		String imageOrg = null;
		String imageNew = null;

		if (imageFile != null && !imageFile.isEmpty()) {
			File dir = new File(UPLOAD_PATH);
			if (!dir.exists()) {
				dir.mkdirs();
			}

			imageOrg = imageFile.getOriginalFilename();
			File originFile = new File(UPLOAD_PATH, imageOrg);

			MyFileRenamePolicy policy = new MyFileRenamePolicy();
			File renamedFile = policy.rename(originFile);

			imageFile.transferTo(renamedFile);
			imageNew = renamedFile.getName();
		}

		return new String[]{imageOrg, imageNew};
	}
}
