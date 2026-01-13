package kr.co.gotoday.reservation;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReservationDTO {
	private int content_id; 
	private String reserved_for_at;
	private String time_zone;
	private int adult_qty;
	private int child_qty;
	private int teen_qty;
}
