package kr.co.gotoday.reservation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.gotoday.content.ContentVO;
import kr.co.gotoday.payment.PaymentMapper;
import kr.co.gotoday.payment.PaymentVO;

@Service
public class ReservationServiceImpl implements ReservationService{
	@Autowired
	ReservationMapper reservationMapper;
	@Autowired
	PaymentMapper paymentMapper;

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
	public ReservationVO createReservationWithPaymentent(ReservationVO reservationVO, PaymentVO paymentVO) {
		
		try {
			
			// 2. 예약 상태를 CONFIRMED로 변경
			reservationVO.setReservation_status("RESERVED");
			
			// 예약 정보 저장
			int reservationResult = reservationMapper.createReservation(reservationVO);
			if(reservationResult <= 0 ) {
				throw new Exception("에약 정보 저장에 실패했습니다.");
			}
			
			paymentVO.setReservation_id(reservationVO.getReservation_id());
			int paymentResult = paymentMapper.createPayment(paymentVO);//			
			if (paymentResult ==0) {
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