package kr.co.gotoday.reservation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.PaymentVO;

@Service
public class ReservationServiceImpl implements ReservationService{
	@Autowired
	ReservationMapper reservationMapper;

	@Override
	public int calculate(ReservationDTO reservationDTO, ContentVO contentVO) {
		if (reservationDTO == null || contentVO == null) {
            throw new IllegalArgumentException("예약 정보와 콘텐츠 정보 누락");
        }
		
		int adultPrice = reservationDTO.getAdult_qty() * contentVO.getAdult_price();
		int teenPrice = reservationDTO.getTeen_qty() * contentVO.getTeen_price();
		int childPrice = reservationDTO.getChild_qty() * contentVO.getChild_price();
		
		return adultPrice + teenPrice + childPrice;
	}

	@Override
	@Transactional
	public ReservationVO createReservationWithPaymentent(ReservationVO reservationVO, String paymentKey, String orderId, int amount) {
		
		try {
			// 1. 토스페이먼츠 API로 결제 최종 승인
//			boolean paymentConfirmed = paymentService.confirmPaymentWithToss(
//					paymentKey,
//					orderId,
//					amount
//				);
//			if (!paymentConfirmed) {
//				throw new PaymentException("토스페이먼츠 결제 승인에 실패했습니다.");
//			}
			
			// 2. 예약 상태를 CONFIRMED로 변경
			reservationVO.setReservation_status("RESERVED");
			
			// 예약 정보 저장
			int reservationResult = reservationMapper.createReservation(reservationVO);
			if(reservationResult <= 0) {
				throw new Exception("에약 정보 저장에 실패했습니다.");
			}
			
			// 결제 정보 저장
			PaymentVO paymentVO = new PaymentVO();
			paymentVO.setPayment_key(paymentKey);
			paymentVO.setOrder_key(orderId);
			paymentVO.setAmount_price(amount);
			paymentVO.setReservation_id(reservationVO.getReservation_id());
			paymentVO.setPayment_status("COMPLETED");
			
			PaymentVO paymentResult = reservationMapper.createPayment(paymentVO);//			
			if (paymentResult == null ) {
				throw new Exception("결제 정보 저장에 실패했습니다.");
			}
			// 5. 저장된 예약 정보 반환
			return reservationVO;
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("예약 및 결제 처리 중 오류가 발생했습니다.", e);
		}
	}

	@Override
	public ReservationVO findByReservationId(int reservation_id) {
		return reservationMapper.findByReservationId(reservation_id);
	}

}