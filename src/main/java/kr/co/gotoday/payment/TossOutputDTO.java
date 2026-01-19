package kr.co.gotoday.payment;

import lombok.Data;

@Data
public class TossOutputDTO {
	// 1. 핵심 결제 정보
	private String paymentKey; // (필수) 결제 고유 번호 (취소할 때 필요)
	private String orderId; // (필수) 우리 주문 번호
	private Long amount; // 결제 금액 (토스는 totalAmount라고 줌)
	private String method; // 결제 수단 (카드, 가상계좌, 간편결제 등)

	// 2. 상태 및 시간
	private String status; // 결제 상태 (DONE:완료, CANCELED:취소 등)
	private String approvedAt; // 결제 승인 일시 (2024-01-01T...)

	// 3. 부가 정보 (선택사항)
	private String orderName; // 주문명 (토스 티셔츠 외 1건)
	private String receiptUrl; // 매출전표(영수증) 확인 주소

	// 4. 카드 상세 (카드로 결제했을 경우만 저장)
	private String cardCompany; // 카드사명 (현대, 삼성 등)
	private String cardNumber; // 카드번호 (마스킹 된 것)
}
