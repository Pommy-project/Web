package com.pommy.dao;

import java.util.List;
import com.pommy.model.PromptMeme;

/**
 * PromptMeme 관련 데이터베이스 작업을 위한 Mapper 인터페이스
 */
public interface PromptMemeMapper {

    /**
     * 모든 프롬프트밈 조회 (최신순)
     */
    List<PromptMeme> findAll();

    /**
     * ID로 프롬프트밈 조회
     */
    PromptMeme findById(Long id);

    /**
     * 사용자 ID로 프롬프트밈 조회
     */
    List<PromptMeme> findByUserId(Long userId);

    /**
     * 제목으로 검색
     */
    List<PromptMeme> searchByTitle(String keyword);

    /**
     * 조회수 상위 3개 조회
     */
    List<PromptMeme> findTop3ByViewCount();

    /**
     * 프롬프트밈 추가
     */
    int insert(PromptMeme promptMeme);

    /**
     * 프롬프트밈 수정
     */
    int update(PromptMeme promptMeme);

    /**
     * 프롬프트밈 삭제
     */
    int delete(Long id);

    /**
     * 조회수 증가
     */
    int incrementViewCount(Long id);
}

