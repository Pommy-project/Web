package com.pommy.util;

import java.io.InputStream;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

/**
 * MyBatis SqlSessionFactory를 관리하는 유틸리티 클래스
 * 싱글톤 패턴으로 구현하여 애플리케이션 전체에서 하나의 인스턴스만 사용
 */
public class MyBatisUtil {
    
    private static SqlSessionFactory sqlSessionFactory;
    
    static {
        try {
            // MyBatis 설정 파일 경로 (클래스패스에서 찾음)
            // resources 폴더의 파일은 클래스패스 루트에 있음
            String resource = "mybatis-config.xml";
            InputStream inputStream = Resources.getResourceAsStream(resource);
            
            // SqlSessionFactory 생성
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
            
        } catch (Exception e) {
            throw new RuntimeException("MyBatis 초기화 실패: " + e.getMessage(), e);
        }
    }
    
    /**
     * SqlSessionFactory 인스턴스 반환
     * @return SqlSessionFactory
     */
    public static SqlSessionFactory getSqlSessionFactory() {
        return sqlSessionFactory;
    }
}

