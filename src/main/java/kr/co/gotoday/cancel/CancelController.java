package kr.co.gotoday.cancel;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class CancelController {

    @Autowired
    CancelService cancelService;

    // 마이페이지 등에서 '취소하기' 버튼 클릭 시 호출 (AJAX 요청 권장)
    @PostMapping("/payment/cancel.do")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> cancelPayment(
            @RequestParam String orderId,
            @RequestParam(defaultValue = "단순 변심") String reason) {
        
        Map<String, Object> result = new HashMap<>();

        try {
            // 서비스 호출
            cancelService.cancelPayment(orderId, reason);
            
            result.put("success", true);
            result.put("msg", "결제가 정상적으로 취소되었습니다.");
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "취소 실패: " + e.getMessage());
            return ResponseEntity.status(500).body(result);
        }
    }
}