package com.pommy.service;

import java.util.List;
import com.pommy.model.User;

/**
 * User 관련 비즈니스 로직을 처리하는 서비스 인터페이스
 */
public interface UserService {

    /**
     * 모든 사용자 조회
     * 
     * @return 사용자 목록
     */
    List<User> getAllUsers();

    /**
     * ID로 사용자 조회
     * 
     * @param id 사용자 ID
     * @return 사용자 정보
     */
    User getUserById(Long id);

    /**
     * 사용자 생성
     * 
     * @param user 사용자 정보
     */
    void createUser(User user);

    /**
     * 사용자 정보 수정
     * 
     * @param user 사용자 정보
     */
    void updateUser(User user);

    /**
     * 사용자 삭제
     * 
     * @param id 사용자 ID
     */
    void deleteUser(Long id);

    /**
     * 사용자명으로 사용자 조회 (로그인용)
     * 
     * @param username 사용자명
     * @return 사용자 정보
     */
    User getUserByUsername(String username);
}
