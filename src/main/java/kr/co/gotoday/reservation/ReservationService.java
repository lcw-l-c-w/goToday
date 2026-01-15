package kr.co.gotoday.reservation;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.PaymentVO;

public interface ReservationService {
	int calculate(ReservationDTO reservationDTO, ContentVO contentVO);
	ReservationVO findByReservationId(int reservation_id);
	ReservationVO createReservationWithPaymentent(ReservationVO reservationVO, PaymentVO paymentVO);
}
