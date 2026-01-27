package kr.co.gotoday.user;

import java.security.SecureRandom;
import java.util.Base64;

public class OAuthStateUtil {
    private static final SecureRandom secureRandom = new SecureRandom();

    // 32 bytes = 256 bits -> Base64URL로 약 43자
    public static String generateState() {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
