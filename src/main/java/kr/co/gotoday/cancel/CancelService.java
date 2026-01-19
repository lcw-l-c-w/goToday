package kr.co.gotoday.cancel;

public interface CancelService {

    void cancelPayment(String orderId, String cancelReason) throws Exception;

}