-- DCL
-- DB 접근 권한 제어 및 관리 명령어 집합
-- 핵심 명령어: CREATE USER, DROP USER, GRANT, REVOKE
-- 계정 구조: '계정명'@'접속허용IP' (IP 다르면 별개 계정 취급)

-- [참고] IP 주소 지정 방식
-- '%'           : 모든 IP 허용 (외부 접속용)
-- 'localhost'   : 서버 로컬 소켓 접속 (가장 빠름)
-- '192.168.%'   : 특정 네트워크 대역 허용
-- '10.0.0.50'   : 특정 서버 IP만 허용

-- *** CREATE, DROP ***
-- 계정 생성 (CREATE USER)
-- CREATE USER '명칭'@'IP' IDENTIFIED BY '비밀번호';

-- 모든 IP 접속 가능 계정(dev_user, dev1234!)
CREATE USER 'dev_user'@'%' IDENTIFIED BY 'dev1234!';

SELECT user, host
FROM mysql.user;
-- 로컬 전용 관리자 계정(local_admin, admin1234!)
CREATE USER 'local_admin'@'localhost' IDENTIFIED BY 'admin1234!';

-- 계정 삭제 (DROP USER)
-- DROP USER '명칭'@'IP';
DROP USER 'local_admin'@'localhost';

-- *** GRANT, REVOKE ***
-- 종류
-- ALL PRIVILEGES : 모든 권한
-- SELECT, INSERT, UPDATE, DELETE : DML 권한
-- CREATE, ALTER, DROP : DDL 권한
-- USAGE : 권한 없음 (로그인만 가능)

-- 범위 표기
-- *.* : 서버 내 모든 DB, 모든 테이블
-- db_name.* : 특정 DB의 모든 테이블
-- db_name.table : 특정 DB의 특정 테이블

-- 권한 부여 (GRANT)
-- GRANT 권한 ON 범위 TO '계정'@'IP';
GRANT ALL PRIVILEGES ON *.* TO 'dev_user'@'%';


-- 특정 DB에 대한 모든 권한 부여

-- 특정 테이블 읽기 권한만 부여

-- 권한 위임 옵션 (받은 권한을 타인에게 부여 가능) : WITH GRANT OPTION
-- GRANT SELECT ON shop_db.* TO 'manager'@'%' WITH GRANT OPTION;

-- 권한 회수 (REVOKE)
-- REVOKE 권한 ON 범위 FROM '계정'@'IP';

-- 특정 권한(DELETE)만 제거
REVOKE DELETE ON hr.* FROM 'dev_user'@'%';

-- 모든 권한 일괄 회수
REVOKE ALL PRIVILEGES ON *.* FROM 'dev_user'@'%';

-- 권한 확인 및 적용
-- 권한 확인 (SHOW GRANTS)
SHOW GRANTS;
SHOW GRANTS FOR 'dev_user'@'%';

-- 전체 사용자 목록 조회
SELECT user, host FROM mysql.user;

-- 설정 즉시 적용 (FLUSH)
FLUSH PRIVILEGES;

-- 실습
-- 역할별 계정 운영
-- 실습 DB 및 테이블 생성
-- root 계정으로 로그인 후 실행
-- 실습용 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS dcl_study;
USE dcl_study;

-- 테스트 테이블 생성
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price INT
);

CREATE TABLE secret_data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    content VARCHAR(200)
);
-- 테스트 데이터 삽입
INSERT INTO products VALUES (1, '노트북', 1500000), (2, '마우스', 30000);
INSERT INTO secret_data VALUES (1, '기밀 정보입니다');

-- 'newbie' 계정 생성 (로컬 접속, 비번 ''newbie1234!')
CREATE USER 'newbie'@'localhost' IDENTIFIED BY 'newbie1234!';
-- 'newbie'에게 products 테이블 조회 권한만 부여
GRANT SELECT ON dcl_study.products TO 'newbie'@'localhost';
-- 테스트 (newbie로 로그인 후)
SELECT * FROM dcl_study.products;
SELECT * FROM dcl_study.secret_data;
-- INSERT, UPDATE 권한 추가
GRANT INSERT, UPDATE ON dcl_study.products TO 'newbie'@'localhost';
-- 'newbie' 권한 회수
REVOKE SELECT, INSERT, UPDATE ON dcl_study.products FROM 'newbie'@'localhost';
-- 계정 삭제
DROP USER 'newbie'@'localhost';