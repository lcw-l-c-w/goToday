package kr.co.gotoday.reservation;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ReservationVO {
	private int reservation_id;
    private String reservation_code;
    private String reserved_for_at;	//날짜랑 시간 정보 합쳐진 것
    private String reservation_status;
    private int total_price;
    private Timestamp created_at;
    private int adult_qty;
    private int child_qty;
    private int teen_qty;
    private int user_id;
    private int content_id;
    private String reservation_type;
    private String receiver_name;
    private String receiver_birth;
    private String receiver_phone;
    private Boolean reserve_visit;
    private String receive_type;
    private int admin_id;
}
