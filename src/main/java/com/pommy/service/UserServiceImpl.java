package com.pommy.service;

import java.util.ArrayList;
import java.util.List;
import org.apache.ibatis.session.SqlSession;
import com.pommy.dao.UserMapper;
import com.pommy.model.User;
import com.pommy.util.MyBatisUtil;

/**
 * UserService 구현 클래스
 * MyBatis를 사용하여 데이터베이스 작업 수행
 */
public class UserServiceImpl implements UserService {

    @Override
    public List<User> getAllUsers() {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            return mapper.findAll();
        }
    }

    @Override
    public User getUserById(Long id) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            return mapper.findById(id);
        }
    }

    @Override
    public void createUser(User user) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            mapper.insert(user);
            sqlSession.commit();
        }
    }

    @Override
    public void updateUser(User user) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            mapper.update(user);
            sqlSession.commit();
        }
    }

    @Override
    public void deleteUser(Long id) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            mapper.delete(id);
            sqlSession.commit();
        }
    }

    @Override
    public User getUserByUsername(String username) {
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            return mapper.findByUsername(username);
        }
    }

    @Override
    public List<User> getUsersByIds(List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return new ArrayList<>();
        }
        try (SqlSession sqlSession = MyBatisUtil.getSqlSessionFactory().openSession()) {
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            return mapper.findByIds(ids);
        }
    }
}
