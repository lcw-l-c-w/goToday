package kr.co.gotoday.cancel;

public interface CancelService {

    void cancelPayment(String orderId, String cancelReason) throws Exception;
    void refundPayment(String orderId, String cancelReason, RefundReceiveAccountDTO refundReceiveAccountDTO) throws Exception;
}