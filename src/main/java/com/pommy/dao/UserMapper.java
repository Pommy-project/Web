package com.pommy.dao;

import java.util.List;
import com.pommy.model.User;

/**
 * User 관련 데이터베이스 작업을 위한 Mapper 인터페이스
 * UserMapper.xml과 연결됨
 */
public interface UserMapper {

    /**
     * 모든 사용자 조회
     * 
     * @return 사용자 목록
     */
    List<User> findAll();

    /**
     * ID로 사용자 조회
     * 
     * @param id 사용자 ID
     * @return 사용자 정보
     */
    User findById(Long id);

    /**
     * 사용자 추가
     * 
     * @param user 사용자 정보
     * @return 삽입된 행 수
     */
    int insert(User user);

    /**
     * 사용자 정보 수정
     * 
     * @param user 사용자 정보
     * @return 수정된 행 수
     */
    int update(User user);

    /**
     * 사용자 삭제
     * 
     * @param id 사용자 ID
     * @return 삭제된 행 수
     */
    int delete(Long id);

    /**
     * 사용자명으로 사용자 조회 (로그인용)
     * 
     * @param username 사용자명
     * @return 사용자 정보
     */
    User findByUsername(String username);

    /**
     * 여러 ID로 사용자 조회 (성능 최적화용)
     * 
     * @param ids 사용자 ID 목록
     * @return 사용자 목록
     */
    List<User> findByIds(List<Long> ids);
}
