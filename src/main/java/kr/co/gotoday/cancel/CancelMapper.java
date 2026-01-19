package kr.co.gotoday.cancel;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.payment.PaymentVO;
import kr.co.gotoday.reservation.ReservationVO;
import kr.co.gotoday.user.CalendarVO;

@Mapper
public interface CancelMapper {
	// 1. 결제 정보 조회
    PaymentVO findPaymentByOrderId(String orderId);
	
    // 2. 예약 정보 조회 (변수명 통일: reservation_id -> reservationId)
    ReservationVO findReservationByReservationId(int reservationId);
	
    // 3. 스케줄 조회 (논리 수정: content_id -> schedule_id)
    // *주의: 특정 회차의 재고를 파악하려면 content_id가 아니라 schedule_id가 필요합니다.
    ContentScheduleVO findContentScheduleByScheduleId(int scheduleId);
	
    // 4. 결제 취소 (반환형 int: 수정된 행의 개수 리턴)
    int updatePaymentStatusToCancel(String orderId);
	
    // 5. 예약 취소
    int updateReservationStatusToCancel(int reservationId);

    // 6. [추가됨] 티켓 재고 증가
    // *중요: 파라미터가 2개 이상일 때는 @Param("이름")을 붙여야 XML의 #{이름}과 매칭됩니다.
    int increaseTicketStock(@Param("scheduleId") int scheduleId, @Param("count") int count);
	
    // 캘린더 일정 삭제
    int deleteCalendarByReservationId(int reservationId);
}
