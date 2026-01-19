package kr.co.gotoday.reservation;

import lombok.Data;

@Data
public class VendorReservationSearchDTO {
    private Integer user_id;           // ★ 필수
    private String keyword;
    private Integer content_id;
    private String reservation_status;
    private String payment_status;
    private String payment_method;
    private String reserved_for_at;
}


