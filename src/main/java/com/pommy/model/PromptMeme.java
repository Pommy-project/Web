package com.pommy.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * PromptMeme 엔티티 클래스
 * 데이터베이스의 prompt_memes 테이블과 매핑
 */
public class PromptMeme {
    
    private Long id;
    private Long userId;
    private String title;
    private String description;
    private String promptContent;
    private String imageUrl;
    private String snsUrl;
    private String aiType; // ENUM: GPT, GEMINI, MIDJOURNEY, SORA
    private Integer viewCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // 기본 생성자
    public PromptMeme() {
    }
    
    // 생성자
    public PromptMeme(Long userId, String title, String promptContent, String aiType) {
        this.userId = userId;
        this.title = title;
        this.promptContent = promptContent;
        this.aiType = aiType;
        this.viewCount = 0;
    }
    
    // Getter and Setter
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getPromptContent() {
        return promptContent;
    }
    
    public void setPromptContent(String promptContent) {
        this.promptContent = promptContent;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getSnsUrl() {
        return snsUrl;
    }
    
    public void setSnsUrl(String snsUrl) {
        this.snsUrl = snsUrl;
    }
    
    public String getAiType() {
        return aiType;
    }
    
    public void setAiType(String aiType) {
        this.aiType = aiType;
    }
    
    /**
     * AIType Enum 리스트로 변환
     * @return AIType 리스트
     */
    public List<AIType> getAiTypes() {
        if (aiType == null || aiType.trim().isEmpty()) {
            return new ArrayList<>();
        }
        return Arrays.stream(aiType.split(","))
                .map(String::trim)
                .map(AIType::fromValue)
                .filter(type -> type != null)
                .collect(Collectors.toList());
    }
    
    /**
     * 단일 AIType Enum 설정
     * @param aiType AIType Enum
     */
    public void setAiTypeEnum(AIType aiType) {
        if (aiType == null) {
            this.aiType = null;
        } else {
            this.aiType = aiType.getValue();
        }
    }
    
    public Integer getViewCount() {
        return viewCount;
    }
    
    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @Override
    public String toString() {
        return "PromptMeme{" +
                "id=" + id +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", aiType='" + aiType + '\'' +
                ", viewCount=" + viewCount +
                ", createdAt=" + createdAt +
                '}';
    }
}

