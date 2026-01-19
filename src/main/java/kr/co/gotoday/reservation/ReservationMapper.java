package kr.co.gotoday.reservation;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.payment.PaymentVO;
import kr.co.gotoday.user.CalendarVO;

@Mapper
public interface ReservationMapper {
	int createReservation(ReservationVO reservationVO);
	int createPayment(PaymentVO paymentVO);
	ReservationVO findByReservationId(int reservation_id);
	List<VendorReservationListDTO> findReservationByVendor(int user_id);
	int subCurrentTicket(Map<String, Object> map);
	int addCurrentTicket(Map<String, Object> map);
	int createScheduleByReservation(CalendarVO calendarVO);
	PaymentVO findByOrderId(String order_key);
	int updatePaymentStatus(Map<String, Object> map);
	int updateReservationStatusById(int reservation_id);
}
