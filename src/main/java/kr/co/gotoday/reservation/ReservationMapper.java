package kr.co.gotoday.reservation;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.payment.PaymentVO;

@Mapper
public interface ReservationMapper {
	int createReservation(ReservationVO reservationVO);
	int createPayment(PaymentVO paymentVO);
	ReservationVO findByReservationId(int reservation_id);
	List<VendorReservationListDTO> findReservationByVendor(int user_id);
	int updateCurrentTicket(Map<String, Object> map);
	int createScheduleByReservation(Map<String, Object> map);
	
}
