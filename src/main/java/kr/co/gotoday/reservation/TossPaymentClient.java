package kr.co.gotoday.reservation;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import kr.co.gotoday.payment.PaymentVO;


@Component
public class TossPaymentClient {
private static final Logger log = LoggerFactory.getLogger(TossPaymentClient.class);
	
	@Value("${toss.payments.secret-key}")
	private String secretKey;
	
	@Value("${toss.payments.api-url}")
	private String apiUrl;
	
	//Authorization 헤더 생성
	private String getAuthorizationHeader() {
		byte[] encodedBytes = Base64.getEncoder()
				.encode((secretKey + ":").getBytes(StandardCharsets.UTF_8));
		return "Basic " + new String(encodedBytes);
	}
	
	//토스 API 공통 호출 메서드
	private JSONObject callTossApi(String endpoint, JSONObject requestBody) {
		HttpURLConnection connection = null;
		OutputStream outputStream = null;
		InputStream responseStream = null;
		Reader reader = null;

		try {
			// HTTP 연결 설정
			URL url = new URL(apiUrl + endpoint);
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestProperty("Authorization", getAuthorizationHeader());
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestMethod("POST");
			connection.setDoOutput(true);

			// 요청 전송
			outputStream = connection.getOutputStream();
			outputStream.write(requestBody.toString().getBytes(StandardCharsets.UTF_8));
			outputStream.flush();

			// 응답 처리
			int responseCode = connection.getResponseCode();
			boolean isSuccess = responseCode == 200;

			responseStream = isSuccess ? 
					connection.getInputStream() : connection.getErrorStream();
			reader = new InputStreamReader(responseStream, StandardCharsets.UTF_8);

			JSONParser parser = new JSONParser();
			JSONObject tossResponse = (JSONObject) parser.parse(reader);

			// 실패 시 예외 발생
			if (!isSuccess) {
				String errorMessage = (String) tossResponse.get("message");
				String errorCode = (String) tossResponse.get("code");
				log.error("[토스 API 실패] code={}, message={}", errorCode, errorMessage);
				throw new RuntimeException("토스 API 호출 실패: " + errorMessage);
			}

			return tossResponse;

		} catch (Exception e) {
			throw new RuntimeException("토스 API 호출 중 오류 발생: " + e.getMessage(), e);
		} finally {
			// 리소스 정리
			if (reader != null) try { reader.close(); } catch (Exception ignored) {}
			if (responseStream != null) try { responseStream.close(); } catch (Exception ignored) {}
			if (outputStream != null) try { outputStream.close(); } catch (Exception ignored) {}
			if (connection != null) connection.disconnect();
		}
	}
	
	//결제 승인
	public PaymentVO confirmPayment(String paymentKey, String orderId, int amount) {
		// 요청 데이터 생성
		JSONObject requestBody = new JSONObject();
		requestBody.put("orderId", orderId);
		requestBody.put("amount", String.valueOf(amount));
		requestBody.put("paymentKey", paymentKey);

		// API 호출
		JSONObject tossResponse = callTossApi("/confirm", requestBody);
		
		log.info("[토스 결제 승인 성공] paymentKey={}, orderId={}", paymentKey, orderId);

		// PaymentVO 생성 및 반환
		PaymentVO paymentVO = new PaymentVO();
		paymentVO.setPayment_key((String) tossResponse.get("paymentKey"));
		paymentVO.setOrder_key((String) tossResponse.get("orderId"));
		paymentVO.setPayment_method((String) tossResponse.get("method"));
		paymentVO.setPayment_status((String) tossResponse.get("status"));
		Number totalAmount = (Number) tossResponse.get("totalAmount");
		paymentVO.setAmount_price(totalAmount.intValue());
		paymentVO.setRefund_status("NONE");

		return paymentVO;
	}
	
	//결제 취소
	public void cancelPayment(String paymentKey, String cancelReason) {
		// 요청 데이터 생성
		JSONObject requestBody = new JSONObject();
		requestBody.put("cancelReason", cancelReason);

		// API 호출
		callTossApi("/" + paymentKey + "/cancel", requestBody);
		
		log.info("[토스 결제 취소 성공] paymentKey={}, reason={}", paymentKey, cancelReason);
	}
}