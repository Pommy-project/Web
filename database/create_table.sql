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



INSERT INTO prompt_memes
(user_id, title, description, prompt_content, image_url, sns_url, ai_type, view_count)
VALUES
-- 1. 이탈리안 브레인롯 상어
(
    1,
    '이탈리안 브레인롯 상어 밈',
    '밝은 파란색 나이키 신발을 사지에 신고 해변에 서 있는 상어를 초현실적으로 표현한 사진 생성 프롬프트.',
    'shark standing on a beach, wearing bright blue Nike sneakers on all fins, ocean waves in the background, sunny day, surreal, photorealistic',
    'shark_meme.png',
    NULL,
    'GPT',
    0
),

-- 2. 지브리 스타일 변환
(
    1,
    '지브리 스타일 인물 변환 프롬프트',
    '첨부된 실제 사진을 따뜻하고 아기자기한 지브리 애니메이션 풍으로 다시 그려주는 이미지 변환 프롬프트.',
    '이미지 그리기. 이사진을 지브리 스타일로 그려줘',
    'ghibli_1.png',
    NULL,
    'GPT',
    0
),

-- 3. 노숙자 난입 밈
(
    1,
    '노숙자 실사 난입 밈 제작',
    '실내 거실 사진 속에 지친 표정의 한국인 노숙자가 자연스럽게 등장하도록 하는 포토리얼한 합성 프롬프트.',
    'Insert a lifelike homeless Korean man into this scene. He has greasy, medium-length black hair, a scruffy beard, and a tired, weathered face and looking like he hasn’t showered in weeks. He wears faded, torn sweatpants, scuffed leather boots, a wrinkled plaid shirt, and a worn-out dark jacket. He has just stepped into the living room, holding a small, crumpled backpack with miscellaneous personal items. His expression is weary but alert, and he slightly leans forward as if examining the surroundings',
    'homeless_meme.png',
    NULL,
    'GEMINI',
    0
),



-- 5. PVC 피규어 스타일 변환
(
    1,
    'PVC 피규어 스타일 촬영 변환1',
    '첨부된 사진을 광택 코팅된 PVC 피규어 제품 사진처럼 재해석하고, 받침대·패키지 박스까지 포함한 스튜디오 촬영 느낌을 구현하는 프롬프트.',
    '사진을 광택 코팅된 수집용 PVC 피규어처럼 보이게 변환하되, 제품 사진 스타일로 연출해 주세요. 피규어는 전시용 받침대 위에 놓여있고, 옆에는 패키지 박스가 있습니다. 조명은 스튜디오 소프트박스+은은한 림라이트를 사용하며, 자연스러운 그림자가 생기도록 합니다. 촬영은 50mm 렌즈, 얕은 심도 효과를 살려 배경은 흐리게 하고, 배경 자체는 게이밍 PC 책상으로 설정합니다',
    'figure_meme.png',
    NULL,
    'GEMINI',
    0
),

-- 6. 흑인 셰프 & 할머니 영상 프롬프트
(
    1,
    '한우해장국 셰프 & 할머니 영상 시나리오',
    '분주한 한식당 주방에서 흑인 셰프가 한우해장국을 만들고 한국 할머니와 대화를 나누는 초현실적 고퀄리티 영상 생성 프롬프트.',
    'In a bustling Korean restaurant kitchen, a Black chef is energetically preparing and serving a steaming bowl of traditional Korean beef hangover soup (한우해장국). The scene is vivid with boiling pots, steam rising, and the sounds of a busy kitchen in the background. The chef proudly places the dish on the counter and speaks in Korean: “양구네 시래기 해장국 나왔습니다.” A Korean grandmother sitting at the counter receives the bowl with a smile and replies playfully in Korean: “어제 술 마시길 잘 했다. 호호” Ultra-realistic cinematic lighting.',
    'chef_video.png',
    NULL,
    'SORA',
    0
),

-- 2. 지브리 스타일 변환
(
    1,
    '지브리 스타일 인물 변환 프롬프트2',
    '첨부된 실제 사진을 따뜻하고 아기자기한 지브리 애니메이션 풍으로 다시 그려주는 이미지 변환 프롬프트.',
    '이미지 그리기. 이사진을 지브리 스타일로 그려줘',
    'ghibli_2.png',
    NULL,
    'GPT',
    0
),
-- 7. 4컷 병맛 만화 스토리보드
(
    1,
    '4컷 병맛 만화 생성 템플릿',
    '평범한 학생이 사무실에서 병맛적인 사건에 휘말리는 4컷 만화 구성을 자동으로 생성하는 프롬프트.',
    '## 🌟 4컷 만화 아이디어 🌟 ## **만화 주제/키워드:** (랜덤 주제 정해짐) **장르:** 병맛 개그 **그림체:** 미국 코믹북 스타일 **주인공 타입:** 평범한 학생 ...',
    '4cut_comic.png',
    NULL,
    'GPT',
    0
),

-- 8. 시네마틱 2컷 눈밭 사진
(
    1,
    '눈 덮인 산속 2컷 시네마틱 사진',
    '사용자 사진을 참고해 새벽의 눈 덮인 산속에서 촬영한 2컷 구성의 시네마틱 사진을 생성하는 프롬프트.',
    '첨부한 사진의 외형을 참고하여, 시네마틱하고 현실적인 9:16 세로 2컷 사진을 만들어줘. 인물은 너무 어둡지는 않은 새벽의 눈 덮인 산속에 서 있고...',
    'snow_2cut.png',
    NULL,
    'GPT',
    0
),

-- 5. PVC 피규어 스타일 변환
(
    1,
    'PVC 피규어 스타일 촬영 변환2',
    '첨부된 사진을 광택 코팅된 PVC 피규어 제품 사진처럼 재해석하고, 받침대·패키지 박스까지 포함한 스튜디오 촬영 느낌을 구현하는 프롬프트.',
    '사진을 광택 코팅된 수집용 PVC 피규어처럼 보이게 변환하되, 제품 사진 스타일로 연출해 주세요. 피규어는 전시용 받침대 위에 놓여있고, 옆에는 패키지 박스가 있습니다. 조명은 스튜디오 소프트박스+은은한 림라이트를 사용하며, 자연스러운 그림자가 생기도록 합니다. 촬영은 50mm 렌즈, 얕은 심도 효과를 살려 배경은 흐리게 하고, 배경 자체는 게이밍 PC 책상으로 설정합니다',
    'figure_meme2.png',
    NULL,
    'GEMINI',
    0
)
