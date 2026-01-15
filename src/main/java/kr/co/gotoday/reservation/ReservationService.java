package kr.co.gotoday.reservation;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.PaymentVO;

public interface ReservationService {
	int calculate(ReservationDTO reservationDTO, ContentVO contentVO);
	ReservationVO findByReservationId(int reservation_id);
	ReservationVO createReservationWithPaymentent(ReservationVO reservationVO, PaymentVO paymentVO);

	//토스 결제 승인 API 호출 -> 승인된 결제 정보 리턴 
	PaymentVO confirmTossPayment(String paymentKey, String orderId, int amount);
	//토스 결제 OK -> 예약/결제 DB insert를 하나의 트랜잭션으로 처리. 
	//토스 승인 이후 DB 저장이 실패되면 토스 결제도 취소 처리해야 함. 
	ReservationVO confirmAndCreateReservation(ReservationVO reservationVO, String paymentKey, String orderId, int amount);
	
	ReservationVO convertToVO(ReservationDTO dto, ReservationVO vo);

}
