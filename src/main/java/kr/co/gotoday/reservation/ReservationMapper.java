package kr.co.gotoday.reservation;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.co.gotoday.payment.PaymentVO;

@Mapper
public interface ReservationMapper {
	int createReservation(ReservationVO reservationVO);
	ReservationVO findByReservationId(int reservation_id);
	int createPayment(PaymentVO paymentVO);
	List<VendorReservationListDTO> findReservationByVendor(int user_id);

}
