package kr.co.gotoday.reservation;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.PaymentMapper;
import kr.co.gotoday.payment.PaymentVO;

@ExtendWith(MockitoExtension.class)
class ReservationServiceTest {

    @Mock
    private ReservationMapper reservationMapper;

    @Mock
    private PaymentMapper paymentMapper;

    @InjectMocks
    private ReservationServiceImpl reservationService;

    @Nested
    @DisplayName("calculate 메서드 테스트")
    class CalculateTest {

        private ReservationDTO reservationDTO;
        private ContentVO contentVO;

        @BeforeEach
        void setUp() {
            reservationDTO = new ReservationDTO();
            contentVO = new ContentVO();
        }

        @Test
        @DisplayName("성인, 청소년, 어린이 가격이 정상적으로 계산된다")
        void calculate_success() {
            // given
            reservationDTO.setAdult_qty(2);
            reservationDTO.setTeen_qty(1);
            reservationDTO.setChild_qty(3);

            contentVO.setAdult_price(10000);
            contentVO.setTeen_price(8000);
            contentVO.setChild_price(5000);

            // when
            int result = reservationService.calculate(reservationDTO, contentVO);

            // then
            // 성인: 2 * 10000 = 20000
            // 청소년: 1 * 8000 = 8000
            // 어린이: 3 * 5000 = 15000
            // 총합: 43000
            assertEquals(43000, result);
        }

        @Test
        @DisplayName("인원이 0명일 경우 0을 반환한다")
        void calculate_zeroQuantity() {
            // given
            reservationDTO.setAdult_qty(0);
            reservationDTO.setTeen_qty(0);
            reservationDTO.setChild_qty(0);

            contentVO.setAdult_price(10000);
            contentVO.setTeen_price(8000);
            contentVO.setChild_price(5000);

            // when
            int result = reservationService.calculate(reservationDTO, contentVO);

            // then
            assertEquals(0, result);
        }

        @Test
        @DisplayName("성인만 있는 경우 성인 가격만 계산된다")
        void calculate_onlyAdult() {
            // given
            reservationDTO.setAdult_qty(3);
            reservationDTO.setTeen_qty(0);
            reservationDTO.setChild_qty(0);

            contentVO.setAdult_price(15000);
            contentVO.setTeen_price(10000);
            contentVO.setChild_price(5000);

            // when
            int result = reservationService.calculate(reservationDTO, contentVO);

            // then
            assertEquals(45000, result);
        }

        @Test
        @DisplayName("reservationDTO가 null이면 IllegalArgumentException이 발생한다")
        void calculate_nullReservationDTO() {
            // given
            contentVO.setAdult_price(10000);

            // when & then
            assertThrows(IllegalArgumentException.class, () -> {
                reservationService.calculate(null, contentVO);
            });
        }

        @Test
        @DisplayName("contentVO가 null이면 IllegalArgumentException이 발생한다")
        void calculate_nullcontentVO() {
            // given
            reservationDTO.setAdult_qty(1);

            // when & then
            assertThrows(IllegalArgumentException.class, () -> {
                reservationService.calculate(reservationDTO, null);
            });
        }
    }

    @Nested
    @DisplayName("createReservationWithPaymentent 메서드 테스트")
    class CreateReservationWithPaymentTest {

        private ReservationVO reservationVO;
        private String paymentKey;
        private String orderId;
        private int amount;

        @BeforeEach
        void setUp() {
            reservationVO = new ReservationVO();
            reservationVO.setReservation_id(1);
            reservationVO.setUser_id(100);
            reservationVO.setContent_id(200);
            reservationVO.setTotal_price(50000);

            paymentKey = "test_payment_key_123";
            orderId = "ORDER_20240101_001";
            amount = 50000;
        }

        @Test
        @DisplayName("예약과 결제가 정상적으로 생성된다")
        void createReservationWithPayment_success() {
            // given
            when(reservationMapper.createReservation(any(ReservationVO.class))).thenReturn(1);

            PaymentVO createdPayment = new PaymentVO();
            createdPayment.setPayment_key(paymentKey);
            createdPayment.setOrder_key(orderId);
            createdPayment.setAmount_price(amount);
            when(reservationMapper.createPayment(any(PaymentVO.class))).thenReturn(createdPayment);

            // when
            ReservationVO result = reservationService.createReservationWithPaymentent(
                reservationVO, paymentKey, orderId, amount
            );

            // then
            assertNotNull(result);
            assertEquals("CONFIRMED", result.getReservation_status());
            verify(reservationMapper, times(1)).createReservation(any(ReservationVO.class));
            verify(reservationMapper, times(1)).createPayment(any(PaymentVO.class));
        }

        @Test
        @DisplayName("예약 생성 실패 시 RuntimeException이 발생한다")
        void createReservationWithPayment_reservationFail() {
            // given
            when(reservationMapper.createReservation(any(ReservationVO.class))).thenReturn(0);

            // when & then
            RuntimeException exception = assertThrows(RuntimeException.class, () -> {
                reservationService.createReservationWithPaymentent(
                    reservationVO, paymentKey, orderId, amount
                );
            });

            assertTrue(exception.getMessage().contains("예약 및 결제 처리 중 오류가 발생했습니다."));
            verify(reservationMapper, times(1)).createReservation(any(ReservationVO.class));
            verify(reservationMapper, never()).createPayment(any(PaymentVO.class));
        }

        @Test
        @DisplayName("결제 생성 실패 시 RuntimeException이 발생한다")
        void createReservationWithPayment_paymentFail() {
            // given
            when(reservationMapper.createReservation(any(ReservationVO.class))).thenReturn(1);
            when(reservationMapper.createPayment(any(PaymentVO.class))).thenReturn(null);

            // when & then
            RuntimeException exception = assertThrows(RuntimeException.class, () -> {
                reservationService.createReservationWithPaymentent(
                    reservationVO, paymentKey, orderId, amount
                );
            });

            assertTrue(exception.getMessage().contains("예약 및 결제 처리 중 오류가 발생했습니다."));
        }

        @Test
        @DisplayName("예약 상태가 CONFIRMED로 설정된다")
        void createReservationWithPayment_statusConfirmed() {
            // given
            when(reservationMapper.createReservation(any(ReservationVO.class))).thenReturn(1);

            PaymentVO createdPayment = new PaymentVO();
            when(reservationMapper.createPayment(any(PaymentVO.class))).thenReturn(createdPayment);

            // when
            ReservationVO result = reservationService.createReservationWithPaymentent(
                reservationVO, paymentKey, orderId, amount
            );

            // then
            assertNotNull(result);
            assertEquals("CONFIRMED", result.getReservation_status());
        }

        @Test
        @DisplayName("PaymentVO에 올바른 값이 설정되어 저장된다")
        void createReservationWithPayment_paymentVOValues() {
            // given
            when(reservationMapper.createReservation(any(ReservationVO.class))).thenReturn(1);

            PaymentVO createdPayment = new PaymentVO();
            when(reservationMapper.createPayment(any(PaymentVO.class))).thenAnswer(invocation -> {
                PaymentVO paymentVO = invocation.getArgument(0);
                assertEquals(paymentKey, paymentVO.getPayment_key());
                assertEquals(orderId, paymentVO.getOrder_key());
                assertEquals(amount, paymentVO.getAmount_price());
                assertEquals(reservationVO.getReservation_id(), paymentVO.getReservation_id());
                assertEquals("COMPLETED", paymentVO.getPayment_status());
                return createdPayment;
            });

            // when
            reservationService.createReservationWithPaymentent(
                reservationVO, paymentKey, orderId, amount
            );

            // then
            verify(reservationMapper).createPayment(any(PaymentVO.class));
        }
    }
}
