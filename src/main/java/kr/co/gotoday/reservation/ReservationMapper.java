package kr.co.gotoday.reservation;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ReservationMapper {
	int payment(ReservationVO reservationVO);
	ReservationVO findByReservationCode(String reservationCode);
}
