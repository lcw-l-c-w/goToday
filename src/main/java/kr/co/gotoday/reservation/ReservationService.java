package kr.co.gotoday.reservation;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.PaymentVO;

public interface ReservationService {
	int calculate(ReservationDTO reservationDTO, ContentVO contentVO);

	ReservationVO findByReservationId(int reservation_id);

	ReservationVO convertToVO(ReservationDTO dto, ReservationVO vo);

	//예약 프로세스
	ReservationVO confirmAndCreateReservation(ReservationVO reservationVO, String paymentKey, String orderId, int amount);
	//1. 티켓 차감
	int trySubCurrentTicket(ReservationVO reservationVO) throws Exception;
	//2. 토스 결제 승인 API 호출 -> 승인된 결제 정보 리턴 
	PaymentVO confirmTossPayment(String paymentKey, String orderId, int amount);
	//3. 예약+결제
	ReservationVO createReservationWithPaymentent(ReservationVO reservationVO, PaymentVO paymentVO) throws Exception;	

	int createScheduleByReservation(ReservationVO reservationVO, int user_id, int content_id);
}
