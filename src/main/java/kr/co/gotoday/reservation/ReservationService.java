package kr.co.gotoday.reservation;

import java.util.List;
import java.util.Map;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.PaymentVO;

public interface ReservationService {
	int calculate(ReservationDTO reservationDTO, ContentVO contentVO);

	ReservationVO findByReservationId(int reservation_id);

	ReservationVO convertToVO(ReservationDTO dto, ReservationVO vo);
	//티켓 차감
	void subCurrentTicket(ReservationVO reservationVO, int content_id);
	//토스 결제 승인 API 호출 -> 승인된 결제 정보 리턴 
	PaymentVO confirmTossPayment(String paymentKey, String orderId, int amount);
	//결제 정보가 성공 -> 티켓 차감 -> 예약 결제로 리턴
	ReservationVO confirmAndCreateReservation(ReservationVO reservationVO, String paymentKey, String orderId, int amount);
	//예약+결제
	ReservationVO createReservationWithPaymentent(ReservationVO reservationVO, PaymentVO paymentVO);	

	int createScheduleByReservation(ReservationVO reservationVO, int user_id, int content_id);
}
