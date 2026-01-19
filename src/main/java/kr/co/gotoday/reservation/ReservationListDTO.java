package kr.co.gotoday.reservation;

import java.time.LocalDate;

import lombok.Data;

@Data
public class ReservationListDTO {
	private int reservation_id;
	private String reservation_status;
	private LocalDate reserved_for_at;
	private String time_zone;
	private int content_id;
	
	private String dDay;

}
