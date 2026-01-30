package kr.co.gotoday.payment;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class PaymentVO {
	private int payment_id;
    private String payment_method;
    private String payment_status;
    private int amount_price;
    private Timestamp paid_at;
    private int reservation_id;
    private String refund_status;
    private String payment_key;
    private String order_key;
    
    
    private int cancel_amount;
}
