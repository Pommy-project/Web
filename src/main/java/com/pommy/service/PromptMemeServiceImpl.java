package com.pommy.service;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import com.pommy.dao.PromptMemeMapper;
import com.pommy.model.PromptMeme;
import com.pommy.util.MyBatisUtil;

/**
 * PromptMemeService 구현 클래스
 * MyBatis를 사용하여 데이터베이스 작업 수행
 */
public class PromptMemeServiceImpl implements PromptMemeService {

    @Override
    public List<PromptMeme> getAllPromptMemes() {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            PromptMemeMapper mapper = sqlSession.getMapper(PromptMemeMapper.class);
            return mapper.findAll();
        }
    }

    @Override
    public PromptMeme getPromptMemeById(Long id) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            PromptMemeMapper mapper = sqlSession.getMapper(PromptMemeMapper.class);
            return mapper.findById(id);
        }
    }

    @Override
    public List<PromptMeme> getPromptMemesByUserId(Long userId) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            PromptMemeMapper mapper = sqlSession.getMapper(PromptMemeMapper.class);
            return mapper.findByUserId(userId);
        }
    }

    @Override
    public List<PromptMeme> searchByTitle(String keyword) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            PromptMemeMapper mapper = sqlSession.getMapper(PromptMemeMapper.class);
            return mapper.searchByTitle(keyword);
        }
    }

    @Override
    public List<PromptMeme> getTop3ByViewCount() {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            PromptMemeMapper mapper = sqlSession.getMapper(PromptMemeMapper.class);
            return mapper.findTop3ByViewCount();
        }
    }

    @Override
    public void createPromptMeme(PromptMeme promptMeme) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            PromptMemeMapper mapper = sqlSession.getMapper(PromptMemeMapper.class);
            mapper.insert(promptMeme);
            sqlSession.commit();
        }
    }

    @Override
    public void updatePromptMeme(PromptMeme promptMeme) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            PromptMemeMapper mapper = sqlSession.getMapper(PromptMemeMapper.class);
            mapper.update(promptMeme);
            sqlSession.commit();
        }
    }

    @Override
    public void deletePromptMeme(Long id) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            PromptMemeMapper mapper = sqlSession.getMapper(PromptMemeMapper.class);
            mapper.delete(id);
            sqlSession.commit();
        }
    }

    @Override
    public void incrementViewCount(Long id) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            PromptMemeMapper mapper = sqlSession.getMapper(PromptMemeMapper.class);
            mapper.incrementViewCount(id);
            sqlSession.commit();
        }
    }
}

