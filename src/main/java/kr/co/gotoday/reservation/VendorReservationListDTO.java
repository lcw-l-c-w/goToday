package kr.co.gotoday.reservation;

import lombok.Data;

@Data
public class VendorReservationListDTO {
	private int user_id;
	
	private String keyword; //예약번호/예약자명
	private int reservation_id;
	private String reservation_code;
	private String reserved_for_at;
	private String time_zone;
	private int adult_qty;
	private int child_qty;
	private int teen_qty;
	private String reservation_status;
	private String receiver_name;
	private String receiver_birth;
	private String receiver_phone;
	private int payment_id;
	private String payment_status;
	private String payment_method;
	private int content_id;
	private String title;

}
