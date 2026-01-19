package kr.co.gotoday.cancel;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.gotoday.content.ContentScheduleVO;
import kr.co.gotoday.payment.PaymentVO;
import kr.co.gotoday.reservation.ReservationVO;

@Service
public class CancelServiceImpl implements CancelService{

    @Autowired
    CancelMapper cancelMapper;

    // 토스페이먼츠 시크릿 키 (개발자센터에서 확인, "test_sk_..." 형태)
    private final String TOSS_SECRET_KEY = "test_sk_DpexMgkW36ym117LE2x48GbR5ozO"; 
    

    @Override
    @Transactional // 중간에 에러나면 모든 DB 작업 롤백
    public void cancelPayment(String orderId, String cancelReason) throws Exception {
        
        // 1. orderId로 결제 정보 조회
        PaymentVO payment = cancelMapper.findPaymentByOrderId(orderId);
        if (payment == null) {
            throw new Exception("결제 정보를 찾을 수 없습니다.");
        }
        
        // 2. 예약 정보 조회 (PaymentVO에서 예약 ID 꺼내기)
        int targetReservationId = payment.getReservation_id();
        ReservationVO reservation = cancelMapper.findReservationByReservationId(targetReservationId);
        
        if (reservation == null) {
            throw new Exception("예약 정보를 찾을 수 없습니다.");
        }

        // 3. 취소할 티켓 총 수량 계산
        int cancelTicketCount = reservation.getAdult_qty() + reservation.getChild_qty() + reservation.getTeen_qty();
        
        // 4. 스케줄 ID 확보 (중요: ContentId가 아니라 ScheduleId 사용)
        int targetScheduleId = reservation.getSchedule_id(); 
        
        
        // 5. 토스페이먼츠 API 호출 (외부 연동)
        // 실패 시 Exception 발생 -> 아래 DB 로직 실행 안 됨 (안전)
        String paymentKey = payment.getPayment_key();
        sendCancelRequestToToss(paymentKey, cancelReason);


        // --- 6. DB 업데이트 진행 (여기서부터 하나라도 실패하면 롤백) ---
        
        // (1) 캘린더에서 일정 삭제
        cancelMapper.deleteCalendarByReservationId(targetReservationId);
        
        // (2) 티켓 재고 다시 채워넣기
        int stockResult = cancelMapper.increaseTicketStock(targetScheduleId, cancelTicketCount);
        
        // (3) 결제 상태 취소로 변경
        int payResult = cancelMapper.updatePaymentStatusToCancel(orderId);
        
        // (4) 예약 상태 취소로 변경
        int resResult = cancelMapper.updateReservationStatusToCancel(targetReservationId);

        // 7. 핵심 데이터 DB 업데이트 실패 체크
        // (재고, 결제상태, 예약상태는 무조건 1개 이상 바뀌어야 함)
        if (payResult == 0 || resResult == 0 || stockResult == 0) {
            throw new RuntimeException("DB 상태 업데이트 실패 (데이터 불일치)");
        }
    }

    // 토스 API 호출 메서드 (HttpURLConnection 사용)
    private void sendCancelRequestToToss(String paymentKey, String cancelReason) throws Exception {
        URL url = new URL("https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        // 헤더 설정
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "application/json");
        
        // 인증 헤더 (Basic Auth: SecretKey를 Base64 인코딩)
        String encodedAuth = Base64.getEncoder().encodeToString((TOSS_SECRET_KEY + ":").getBytes(StandardCharsets.UTF_8));
        connection.setRequestProperty("Authorization", "Basic " + encodedAuth);
        connection.setDoOutput(true);

        // Body 설정 (JSON 문자열)
        String jsonBody = "{\"cancelReason\":\"" + cancelReason + "\"}";

        // 전송
        try (OutputStream os = connection.getOutputStream()) {
            byte[] input = jsonBody.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        // 응답 코드 확인
        int code = connection.getResponseCode();
        if (code != 200) {
            // 에러 처리 (필요시 에러 스트림을 읽어서 로그 출력)
            throw new Exception("토스 결제 취소 실패: 응답 코드 " + code);
        }
        
        // 성공 시 별도 응답을 읽을 필요가 없다면 여기서 종료
    }
}