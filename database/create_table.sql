-- pommy 데이터베이스의 테이블 생성 스크립트
-- 프롬프트밈 공유 플랫폼


-- 데이터베이스 생성 및 선택
CREATE DATABASE IF NOT EXISTS pommy CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pommy;

-- ============================================
-- 1. 사용자 테이블 (users)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '아이디',
    password VARCHAR(255) NOT NULL COMMENT '비밀번호 (해시)',
    nickname VARCHAR(50) NOT NULL COMMENT '닉네임',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    INDEX idx_username (username),
    INDEX idx_nickname (nickname)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 테이블';

-- ============================================
-- 2. 프롬프트밈 테이블 (prompt_memes)
-- ============================================
CREATE TABLE IF NOT EXISTS prompt_memes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL COMMENT '작성자 ID',
    title VARCHAR(200) NOT NULL COMMENT '제목',
    description TEXT COMMENT '설명 (선택사항)',
    prompt_content TEXT NOT NULL COMMENT '프롬프트 내용',
    image_url VARCHAR(500) COMMENT '미리보기 사진 URL',
    sns_url VARCHAR(500) COMMENT 'SNS 링크 (선택사항)',
    ai_type ENUM('GPT', 'GEMINI', 'MIDJOURNEY', 'SORA') NOT NULL COMMENT '사용 AI 종류',
    view_count INT NOT NULL DEFAULT 0 COMMENT '조회수',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_title (title),
    INDEX idx_ai_type (ai_type),
    INDEX idx_view_count (view_count),
    INDEX idx_created_at (created_at),
    FULLTEXT INDEX idx_title_description (title, description) COMMENT '제목/설명 검색용'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='프롬프트밈 테이블';

-- ============================================
-- 3. 세션 테이블 (sessions) - 세션 기반 로그인 관리
-- ============================================
CREATE TABLE IF NOT EXISTS sessions (
    session_id VARCHAR(255) PRIMARY KEY COMMENT '세션 ID',
    user_id BIGINT NOT NULL COMMENT '사용자 ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    expires_at DATETIME NOT NULL COMMENT '만료일',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='세션 테이블';

-- ============================================
-- 테스트 데이터 삽입 (선택사항)
-- ============================================

-- 테스트 사용자 (비밀번호는 해시화 필요 - 예시: 'password123'의 해시)
-- 실제 운영 시에는 비밀번호를 해시화하여 저장해야 합니다.
INSERT INTO users (username, password, nickname) VALUES
('testuser1', '$2a$10$example_hash_here', '테스트유저1'),
('testuser2', '$2a$10$example_hash_here', '테스트유저2')
ON DUPLICATE KEY UPDATE username=username;

-- 테스트 프롬프트밈
INSERT INTO prompt_memes (user_id, title, description, prompt_content, image_url, sns_url, ai_type, view_count) VALUES
(1, '멋진 풍경 이미지', '아름다운 자연 풍경을 그려주세요', 'Create a beautiful landscape with mountains and a lake at sunset', 'https://example.com/image1.jpg', 'https://instagram.com/example', 'MIDJOURNEY', 150),
(1, '고양이 캐릭터', '귀여운 고양이 캐릭터 디자인', 'Design a cute cat character with big eyes', 'https://example.com/image2.jpg', NULL, 'GPT', 89),
(2, '미래 도시', '사이버펑크 스타일의 미래 도시', 'Generate a cyberpunk style futuristic city', 'https://example.com/image3.jpg', 'https://twitter.com/example', 'SORA', 234)
ON DUPLICATE KEY UPDATE title=title;
