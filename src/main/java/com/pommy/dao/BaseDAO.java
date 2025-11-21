package com.pommy.dao;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import com.pommy.util.MyBatisUtil;

/**
 * 모든 DAO 클래스의 기본 클래스
 * MyBatis SqlSession 관리를 담당
 */
public class BaseDAO {
    
    protected SqlSessionFactory sqlSessionFactory;
    
    public BaseDAO() {
        this.sqlSessionFactory = MyBatisUtil.getSqlSessionFactory();
    }
    
    /**
     * SqlSession을 열고 반환
     * @return SqlSession
     */
    protected SqlSession getSqlSession() {
        return sqlSessionFactory.openSession();
    }
    
    /**
     * SqlSession을 열고 자동 커밋 설정
     * @param autoCommit 자동 커밋 여부
     * @return SqlSession
     */
    protected SqlSession getSqlSession(boolean autoCommit) {
        return sqlSessionFactory.openSession(autoCommit);
    }
}



