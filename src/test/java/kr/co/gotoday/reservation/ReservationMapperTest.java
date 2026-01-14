package kr.co.gotoday.reservation;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import config.MvcConfig;
import kr.co.gotoday.payment.PaymentVO;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
    "file:src/main/webapp/WEB-INF/spring/root-context.xml"  // ← DB 설정만!
})
@TestPropertySource(locations = "classpath:db.properties")
@Transactional  // 테스트 후 자동 롤백
class ReservationMapperTest {

    @Autowired
    private ReservationMapper reservationMapper;

    private ReservationVO reservationVO;

    @BeforeEach
    void setUp() {
        reservationVO = new ReservationVO();
        reservationVO.setReservation_code("TEST_" + System.currentTimeMillis());
        reservationVO.setReserved_for_at("2024-12-25 10:00");
        reservationVO.setReservation_status("PENDING");
        reservationVO.setTotal_price(50000);
        reservationVO.setAdult_qty(2);
        reservationVO.setTeen_qty(1);
        reservationVO.setChild_qty(0);
        reservationVO.setUser_id(1);
        reservationVO.setContent_id(1);
        reservationVO.setReservation_type("TICKET");
        reservationVO.setReceiver_name("홍길동");
        reservationVO.setReceiver_birth("1990-01-01");
        reservationVO.setReceiver_phone("010-1234-5678");
        reservationVO.setReserve_visit(true);
        reservationVO.setReceive_type("EMAIL");
    }

    @Test
    @DisplayName("예약 정보가 정상적으로 저장된다")
    void createReservation_success() {
        // when
        int result = reservationMapper.createReservation(reservationVO);

        // then
        assertEquals(1, result);
    }

    @Test
    @DisplayName("예약 코드로 예약 정보를 조회할 수 있다")
    void findByReservationId_success() {
        // given
        int reservationId = reservationVO.getReservation_id();
        reservationMapper.createReservation(reservationVO);

        // when
        ReservationVO found = reservationMapper.findByReservationId(reservationId);

        // then
        assertNotNull(found);
        assertEquals(reservationId, found.getReservation_id());
        assertEquals("PENDING", found.getReservation_status());
        assertEquals(50000, found.getTotal_price());
        assertEquals(2, found.getAdult_qty());
        assertEquals("홍길동", found.getReceiver_name());
    }

    @Test
    @DisplayName("존재하지 않는 예약 코드 조회 시 null을 반환한다")
    void findByReservationCode_notFound() {
    	reservationVO.setReservation_id(0);
        // when
        ReservationVO found = reservationMapper.findByReservationId(reservationVO.getReservation_id());

        // then
        assertNull(found);
    }

    @Test
    @DisplayName("결제 정보가 정상적으로 저장된다")
    void createPayment_success() {
        // given - 먼저 예약 생성
        reservationMapper.createReservation(reservationVO);

        // 생성된 예약 조회하여 ID 확인
        ReservationVO savedReservation = reservationMapper.findByReservationId(reservationVO.getReservation_id() );

        PaymentVO paymentVO = new PaymentVO();
        paymentVO.setPayment_key("test_payment_key_123");
        paymentVO.setOrder_key("ORDER_TEST_001");
        paymentVO.setAmount_price(50000);
        paymentVO.setReservation_id(savedReservation.getReservation_id());
        paymentVO.setPayment_status("COMPLETED");
        paymentVO.setPayment_method("CARD");
        paymentVO.setRefund_status("NONE");

        // when
        PaymentVO result = reservationMapper.createPayment(paymentVO);

        // then
        assertNotNull(result);
    }
}
