package kr.co.gotoday.payment;

import lombok.Data;

@Data
public class PaymentDTO {
	private String orderId;      // 주문 번호
    private String orderName;    // 주문 상품명
    private Integer amount;      // 결제 금액
    private String customerName; // 구매자 이름
    private String customerEmail;// 구매자 이메일
}
