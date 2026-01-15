package kr.co.gotoday.reservation;

import kr.co.gotoday.content.ContentVO;

public interface ReservationService {
	int calculate(ReservationDTO reservationDTO, ContentVO contentVO);
	ReservationVO findByReservationId(int reservation_id);
	ReservationVO createReservationWithPaymentent(ReservationVO reservationVO, String paymentKey, String orderId, int amount);
}
