package kr.co.gotoday.reservation;

import lombok.Data;

@Data
public class VendorReservationListDTO {
	private int reservation_id;
	private String reservation_code;
	private String reserved_for_at;
	private int adult_qty;
	private int child_qty;
	private int teen_qty;
	private String reservation_status;
	private String receiver_name;
	private String receiver_birth;
	private String receiver_phone;
	private int payment_id;
	private String payment_status;
	private int content_id;
	private String title;

}
