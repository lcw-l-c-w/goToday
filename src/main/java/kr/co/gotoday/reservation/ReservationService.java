package kr.co.gotoday.reservation;

import kr.co.gotoday.content.ContentVo;

public interface ReservationService {
	int calculate(ReservationDTO reservationDTO, ContentVo contentVo);
	int payment(ReservationVO reservationVO);
}
