package kr.co.gotoday.cancel;

public interface CancelService {

    void cancelPayment(String orderId, String cancelReason, String refundAccount) throws Exception;

}