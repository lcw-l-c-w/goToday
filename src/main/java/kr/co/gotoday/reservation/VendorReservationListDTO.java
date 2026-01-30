package kr.co.gotoday.reservation;

import lombok.Data;

@Data
public class VendorReservationListDTO {
    private String reserve_id;
    private String reservation_code;
    private String visit_date;
    private String visit_time;
    private Integer person_count;
    private String reserve_status;
    private String pay_status;
    private String content_title;
    private String payment_method;
    private int amount_price;
    
    // 추가된 필드 (수령인 정보)
    private String receiver_name;
    private String receiver_phone;
}