package kr.co.gotoday.cancel;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody; // ★ 이거 필수!
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class CancelController {

    @Autowired
    CancelService cancelService;

    @PostMapping("/payment/cancel.do")
    @ResponseBody
    // ★ 수정: @RequestParam 대신 @RequestBody Map<String, Object> params 사용
    public ResponseEntity<Map<String, Object>> cancelPayment(@RequestBody Map<String, Object> params) {
        
        Map<String, Object> result = new HashMap<>();

        try {
            // ★ JSON 맵에서 하나씩 꺼내기
            String orderId = (String) params.get("orderId");
            String reason = (String) params.get("reason");

            // 기본값 처리 (reason이 없을 경우)
            if (reason == null || reason.trim().isEmpty()) {
                reason = "단순 변심";
            }

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