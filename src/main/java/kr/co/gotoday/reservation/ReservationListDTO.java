package kr.co.gotoday.reservation;

import java.time.LocalDate;

import lombok.Data;

@Data
public class ReservationListDTO {
	private int reservation_id;
	private String reservation_status;
	private LocalDate reserved_for_at;
	private String time_zone;
	private String reservation_code;
	private String receive_type;
	
	private String payment_status;
	
	private int content_id;
	private String title;
	private String main_image_path;
	
	private String dday;
	
	private String order_id; //payment 의 orderKey 저장하려고 추가(취소하려면 orderKey 필요)

}
