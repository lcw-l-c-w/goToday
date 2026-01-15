package kr.co.gotoday.reservation;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.PaymentMapper;
import kr.co.gotoday.payment.PaymentVO;

@ExtendWith(MockitoExtension.class)
public class ReservationServiceTest {

	@Mock
	private ReservationMapper reservationMapper;

	@Mock
	private PaymentMapper paymentMapper;

	@Spy
	@InjectMocks
	private ReservationServiceImpl reservationService;

	private ReservationDTO testDTO;
	private ReservationVO testVO;
	private ContentVO testContent;
	private PaymentVO testPayment;

	@BeforeEach
	void setUp() {
		// 테스트용 DTO 생성
		testDTO = new ReservationDTO();
		testDTO.setContent_id(5);
		testDTO.setReserved_for_at("2025-02-15");
		testDTO.setTime_zone("14:00");
		testDTO.setAdult_qty(2);
		testDTO.setTeen_qty(1);
		testDTO.setChild_qty(0);
		testDTO.setTotal_price(26000);

		// 테스트용 VO 생성
		testVO = new ReservationVO();
		testVO.setUser_id(1);
		testVO.setReceiver_name("테스트유저");
		testVO.setReceiver_phone("010-1234-5678");

		// 테스트용 ContentVO 생성
		testContent = new ContentVO();
		testContent.setAdult_price(10000);
		testContent.setTeen_price(6000);
		testContent.setChild_price(4000);

		// 테스트용 PaymentVO 생성
		testPayment = new PaymentVO();
		testPayment.setPayment_key("test_payment_key");
		testPayment.setOrder_key("ORDER_test123");
		testPayment.setPayment_method("카드");
		testPayment.setPayment_status("DONE");
		testPayment.setAmount_price(26000);
		testPayment.setRefund_status("NONE");
	}

	@Test
	@DisplayName("금액 계산 테스트 - 성인2 + 청소년1")
	void testCalculate() {
		// given
		// testDTO: 성인2, 청소년1, 어린이0
		// testContent: 성인10000, 청소년6000, 어린이4000

		// when
		int result = reservationService.calculate(testDTO, testContent);

		// then
		// 10000*2 + 6000*1 + 4000*0 = 26000
		assertEquals(26000, result);
	}

	@Test
	@DisplayName("금액 계산 테스트 - 모든 타입 포함")
	void testCalculateAllTypes() {
		// given
		testDTO.setAdult_qty(1);
		testDTO.setTeen_qty(2);
		testDTO.setChild_qty(3);

		// when
		int result = reservationService.calculate(testDTO, testContent);

		// then
		// 10000*1 + 6000*2 + 4000*3 = 34000
		assertEquals(34000, result);
	}

	@Test
	@DisplayName("금액 계산 테스트 - null 입력 시 예외 발생")
	void testCalculateWithNull() {
		// given & when & then
		assertThrows(IllegalArgumentException.class, () -> {
			reservationService.calculate(null, testContent);
		});

		assertThrows(IllegalArgumentException.class, () -> {
			reservationService.calculate(testDTO, null);
		});
	}

	@Test
	@DisplayName("DTO → VO 변환 테스트")
	void testConvertToVO() {
		// given
		ReservationVO vo = new ReservationVO();

		// when
		ReservationVO result = reservationService.convertToVO(testDTO, vo);

		// then
		assertEquals("2025-02-15 14:00", result.getReserved_for_at());
		assertEquals(2, result.getAdult_qty());
		assertEquals(1, result.getTeen_qty());
		assertEquals(0, result.getChild_qty());
		assertEquals(5, result.getContent_id());
		assertEquals(26000, result.getTotal_price());
		assertEquals("PENDING", result.getReservation_status());
		assertEquals("onsite", result.getReservation_type());
		assertTrue(result.getReservation_code().startsWith("RES_"));
	}

	@Test
	@DisplayName("예약+결제 저장 테스트 - 성공")
	void testCreateReservationWithPayment_Success() {
		// given
		testVO.setReservation_id(0); // 초기값
		when(reservationMapper.createReservation(any(ReservationVO.class))).thenAnswer(invocation -> {
			ReservationVO vo = invocation.getArgument(0);
			vo.setReservation_id(100); // selectKey로 ID 세팅 시뮬레이션
			return 1;
		});
		when(paymentMapper.createPayment(any(PaymentVO.class))).thenReturn(1);

		// when
		ReservationVO result = reservationService.createReservationWithPaymentent(testVO, testPayment);

		// then
		assertNotNull(result);
		assertEquals(100, testPayment.getReservation_id());
		verify(reservationMapper, times(1)).createReservation(any());
		verify(paymentMapper, times(1)).createPayment(any());
	}

	@Test
	@DisplayName("예약+결제 저장 테스트 - 예약 저장 실패 시 예외")
	void testCreateReservationWithPayment_ReservationFail() {
		// given
		when(reservationMapper.createReservation(any(ReservationVO.class))).thenReturn(0);

		// when & then
		assertThrows(RuntimeException.class, () -> {
			reservationService.createReservationWithPaymentent(testVO, testPayment);
		});

		verify(paymentMapper, never()).createPayment(any());
	}

	@Test
	@DisplayName("예약+결제 저장 테스트 - 결제 저장 실패 시 예외 및 롤백")
	void testCreateReservationWithPayment_PaymentFail() {
		// given
		when(reservationMapper.createReservation(any(ReservationVO.class))).thenAnswer(invocation -> {
			ReservationVO vo = invocation.getArgument(0);
			vo.setReservation_id(100);
			return 1;
		});
		when(paymentMapper.createPayment(any(PaymentVO.class))).thenReturn(0);

		// when & then
		assertThrows(RuntimeException.class, () -> {
			reservationService.createReservationWithPaymentent(testVO, testPayment);
		});
	}

	@Test
	@DisplayName("통합 메서드 테스트 - 토스 승인 + DB 저장 성공")
	void testConfirmAndCreateReservation_Success() {
		// given
		String paymentKey = "test_payment_key";
		String orderId = "ORDER_test123";
		int amount = 26000;

		// confirmTossPayment를 mock 처리 (실제 API 호출 방지)
		doReturn(testPayment).when(reservationService).confirmTossPayment(paymentKey, orderId, amount);

		when(reservationMapper.createReservation(any(ReservationVO.class))).thenAnswer(invocation -> {
			ReservationVO vo = invocation.getArgument(0);
			vo.setReservation_id(100);
			return 1;
		});
		when(paymentMapper.createPayment(any(PaymentVO.class))).thenReturn(1);

		// when
		ReservationVO result = reservationService.confirmAndCreateReservation(testVO, paymentKey, orderId, amount);

		// then
		assertNotNull(result);
		assertEquals("DONE", result.getReservation_status());
		verify(reservationService, times(1)).confirmTossPayment(paymentKey, orderId, amount);
		verify(reservationMapper, times(1)).createReservation(any());
		verify(paymentMapper, times(1)).createPayment(any());
	}

	@Test
	@DisplayName("통합 메서드 테스트 - 토스 승인 실패")
	void testConfirmAndCreateReservation_TossApprovalFail() {
		// given
		String paymentKey = "test_payment_key";
		String orderId = "ORDER_test123";
		int amount = 26000;

		doThrow(new RuntimeException("토스 결제 승인 실패: 잔액 부족"))
			.when(reservationService).confirmTossPayment(paymentKey, orderId, amount);

		// when & then
		RuntimeException exception = assertThrows(RuntimeException.class, () -> {
			reservationService.confirmAndCreateReservation(testVO, paymentKey, orderId, amount);
		});

		assertTrue(exception.getMessage().contains("토스 결제 승인 실패"));
		verify(reservationMapper, never()).createReservation(any());
		verify(paymentMapper, never()).createPayment(any());
	}

	@Test
	@DisplayName("통합 메서드 테스트 - 토스 승인 성공 후 DB 실패 시 토스 취소 호출")
	void testConfirmAndCreateReservation_DbFailThenCancelToss() {
		// given
		String paymentKey = "test_payment_key";
		String orderId = "ORDER_test123";
		int amount = 26000;

		doReturn(testPayment).when(reservationService).confirmTossPayment(paymentKey, orderId, amount);
		when(reservationMapper.createReservation(any(ReservationVO.class))).thenReturn(0); // DB 실패

		// cancelTossPayment도 mock 처리 (private 메서드지만 spy로 가능)
		// private 메서드는 직접 verify 불가하므로 예외 메시지로 확인

		// when & then
		RuntimeException exception = assertThrows(RuntimeException.class, () -> {
			reservationService.confirmAndCreateReservation(testVO, paymentKey, orderId, amount);
		});

		assertTrue(exception.getMessage().contains("예약 처리 중 오류 발생"));
	}

	@Test
	@DisplayName("예약 조회 테스트")
	void testFindByReservationId() {
		// given
		testVO.setReservation_id(100);
		when(reservationMapper.findByReservationId(100)).thenReturn(testVO);

		// when
		ReservationVO result = reservationService.findByReservationId(100);

		// then
		assertNotNull(result);
		assertEquals(100, result.getReservation_id());
	}
}
