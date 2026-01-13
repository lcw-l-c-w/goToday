package kr.co.gotoday.reservation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.gotoday.content.ContentVo;

@Service
public class ReservationServiceImpl implements ReservationService{
	@Autowired
	ReservationMapper reservationMapper;

	@Override
	public int calculate(ReservationDTO reservationDTO, ContentVo contentVo) {
		if (reservationDTO == null || contentVo == null) {
            throw new IllegalArgumentException("예약 정보와 콘텐츠 정보 누락");
        }
		
		int adultPrice = reservationDTO.getAdult_qty() * contentVo.getAdult_price();
		int teenPrice = reservationDTO.getTeen_qty() * contentVo.getTeen_price();
		int childPrice = reservationDTO.getChild_qty() * contentVo.getChild_price();
		
		return adultPrice + teenPrice + childPrice;
	}

	@Override
	public int payment(ReservationVO reservationVO) {
		return reservationMapper.payment(reservationVO);
	}

}
