package kr.co.gotoday.reservation;

import kr.co.gotoday.content.ContentVo;

public interface ReservationService {
	int calculate(ReservationDTO reservationDTO, ContentVo contentVo);
	ReservationVO findByReservationId(int reservation_id);
	ReservationVO createReservationWithPaymentent(ReservationVO reservationVO, String paymentKey, String orderId, int amount);
}
