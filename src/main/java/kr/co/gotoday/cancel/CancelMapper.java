package kr.co.gotoday.cancel;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.payment.PaymentVO;
import kr.co.gotoday.reservation.ReservationVO;

@Mapper
public interface CancelMapper {
    // 1. 결제 정보 조회
    PaymentVO findPaymentByOrderId(String orderId);
    
    // 2. 예약 정보 조회
    ReservationVO findReservationByReservationId(int reservationId);
    
    // 3. 스케줄 조회 (이건 이제 Service에서 안 쓰지만, 놔둬도 상관없음)
    ContentScheduleVO findContentScheduleByScheduleId(int scheduleId);
    
    // [★수정됨] 4. 결제 취소 정보 업데이트 (VO 통째로 받기)
    int updatePaymentCancelInfo(PaymentVO payment);
    
    // 5. 예약 취소
    int updateReservationStatusToCancel(int reservationId);

    // 6. 티켓 재고 증가
    int increaseTicketStock(@Param("scheduleId") int scheduleId, @Param("count") int count);
    
    // 7. 캘린더 삭제
    int deleteCalendarByReservationId(int reservationId);
}
