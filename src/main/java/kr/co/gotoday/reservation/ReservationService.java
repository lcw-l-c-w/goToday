package kr.co.gotoday.reservation;

import java.util.List;
import java.util.Map;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.PaymentVO;

public interface ReservationService {
	int calculate(ReservationDTO reservationDTO, ContentVO contentVO);

	ReservationVO findByReservationId(int reservation_id);
	PaymentVO findByOrderId(String order_key);

	ReservationVO convertToVO(ReservationDTO dto, ReservationVO vo);
	
	ContentScheduleVO findCurrentTickets(int schedule_id);

	//예약 프로세스
	ReservationVO confirmAndCreateReservation(ReservationVO reservationVO, String paymentKey, String orderId, int amount);
	
	//티켓 차감/복구
	int trySubCurrentTicket(ReservationVO reservationVO) throws Exception;
	int tryAddCurrentTicket(ReservationVO reservationVO) throws Exception;

	//예약+결제
	ReservationVO createReservationWithPaymentent(ReservationVO reservationVO, PaymentVO paymentVO) throws Exception;	

	void createScheduleByReservation(ReservationVO reservationVO);

	void updatePaymentStatus(String order_key);
	
	int updateReservationStatusById(int reservation_id);
	
	List<ReservationListDTO> findReservationListByUserId(int user_id, String filter);

	Map<String, Object> findReservationListByUserId(int user_id, String filter, Integer page);

	ReservationDetailDTO findReservationDetailById(int reservation_id, int user_id);
}
