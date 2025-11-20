package com.pommy.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * 비밀번호 해시화 및 검증 유틸리티 클래스
 * BCrypt를 사용하여 비밀번호를 안전하게 저장하고 검증
 */
public class PasswordUtil {

    /**
     * 비밀번호를 BCrypt로 해시화
     * 
     * @param plainPassword 평문 비밀번호
     * @return 해시화된 비밀번호
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("비밀번호는 비어있을 수 없습니다.");
        }
        // BCrypt의 salt는 자동으로 생성됨
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    /**
     * 평문 비밀번호와 해시화된 비밀번호를 비교
     * 
     * @param plainPassword 평문 비밀번호
     * @param hashedPassword 해시화된 비밀번호
     * @return 일치하면 true, 아니면 false
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
}

