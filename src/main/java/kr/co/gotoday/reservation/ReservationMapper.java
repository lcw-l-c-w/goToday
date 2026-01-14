package kr.co.gotoday.reservation;

import org.apache.ibatis.annotations.Mapper;

import kr.co.gotoday.payment.PaymentVO;

@Mapper
public interface ReservationMapper {
	int createReservation(ReservationVO reservationVO);
	ReservationVO findByReservationId(int reservation_id);
	PaymentVO createPayment(PaymentVO paymentVO);
}
