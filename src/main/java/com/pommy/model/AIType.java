package com.pommy.model;

/**
 * AI 타입 Enum
 * 프롬프트밈에서 사용된 AI 종류를 나타냄
 */
public enum AIType {
    GPT("GPT", "https://chat.openai.com/"),
    GEMINI("GEMINI", "https://gemini.google.com/"),
    MIDJOURNEY("MIDJOURNEY", "https://www.midjourney.com/"),
    SORA("SORA", "https://openai.com/sora");
    
    private final String value;
    private final String url;
    
    AIType(String value, String url) {
        this.value = value;
        this.url = url;
    }
    
    public String getValue() {
        return value;
    }
    
    /**
     * AI 공식 사이트 URL 반환
     * @return AI 공식 사이트 URL
     */
    public String getUrl() {
        return url;
    }
    
    /**
     * 문자열로부터 AIType을 찾음
     * @param value 문자열 값
     * @return AIType 또는 null
     */
    public static AIType fromValue(String value) {
        if (value == null) {
            return null;
        }
        for (AIType type : AIType.values()) {
            if (type.value.equalsIgnoreCase(value) || type.name().equalsIgnoreCase(value)) {
                return type;
            }
        }
        return null;
    }
}