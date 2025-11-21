package com.pommy.service;

import java.util.List;
import com.pommy.model.PromptMeme;

/**
 * PromptMeme 관련 비즈니스 로직을 처리하는 서비스 인터페이스
 */
public interface PromptMemeService {

    /**
     * 모든 프롬프트밈 조회 (최신순)
     */
    List<PromptMeme> getAllPromptMemes();

    /**
     * ID로 프롬프트밈 조회
     */
    PromptMeme getPromptMemeById(Long id);

    /**
     * 사용자 ID로 프롬프트밈 조회
     */
    List<PromptMeme> getPromptMemesByUserId(Long userId);

    /**
     * 제목으로 검색
     */
    List<PromptMeme> searchByTitle(String keyword);

    /**
     * 조회수 상위 3개 조회
     */
    List<PromptMeme> getTop3ByViewCount();

    /**
     * 프롬프트밈 생성
     */
    void createPromptMeme(PromptMeme promptMeme);

    /**
     * 프롬프트밈 수정
     */
    void updatePromptMeme(PromptMeme promptMeme);

    /**
     * 프롬프트밈 삭제
     */
    void deletePromptMeme(Long id);

    /**
     * 조회수 증가
     */
    void incrementViewCount(Long id);
}

