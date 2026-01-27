package kr.co.gotoday.reservation;

import lombok.Data;

@Data
public class ReservationDetailDTO {
	private int reservation_id;
	private String reservation_status;
	private String reserved_for_at;
	private String time_zone;
	private String reservation_code;
	private String receive_type;
	private String receiver_name;
	private String receiver_birth;
	private String receiver_phone;
	private int adult_qty;
	private int child_qty;
	private int teen_qty;
	private int content_id;
	
	private String title;
	private String main_image_path;
	private String location;
	
	private String paid_at;
	private String payment_status;
	private String payment_method;
	private int amount_price;
	
	private int cancel_amount;
}
