-- DDL
-- *** create, drop ***
-- 존재하는 table 삭제 명령어
-- 1. table 삭제 
DROP TABLE emp01;

-- 2. table 생성  
-- name(varchar), age(int) 컬럼 보유한 people table 생성

-- 3. emp01 table 생성(존재하는 table기반 생성)
-- emp table의 모든 데이터로 emp01 생성
-- 4. 특정 컬럼(empno)만으로 emp02 table 생성

-- 5. ? deptno=10 조건문 반영 -> empno, ename, deptno의 필드를 갖는 emp03 table 생성

-- 6. ? 데이터없이 table 구조로만 emp04 table생성 

-- *** alter, truncate ***
-- emp01 table로 실습
DROP TABLE emp01;

CREATE TABLE emp01 AS SELECT ename, empno FROM emp;

SELECT * FROM emp01;

-- 1. emp01 table에 job 컬럼 추가(job varchar(10))
ALTER TABLE emp01
ADD COLUMN job VARCHAR(10);

DESC emp01;

SELECT * FROM emp01;

UPDATE emp01
SET job = 'DDL';
-- 2. 컬럼 사이즈 변경
ALTER TABLE emp01
RENAME COLUMN job TO job_name;

ALTER TABLE emp01
MODIFY job_name CHAR(10);

DESC emp01;
-- 3. job 컬럼 삭제 
ALTER TABLE emp01
DROP job_name;

-- 4. table의 데이터만 삭제
TRUNCATE TABLE emp01;

SELECT * FROM emp01;

-- TRUNCATE vs DELETE
-- DDL         DML
-- X		   WHERE
-- FAST		   SLOW

﻿-- *** Constraints ***
-- 1. table의 제약조건 정보 확인
-- information_schema.table_constraints;

SELECT *
FROM information_schema.table_constraints
WHERE table_schema = 'scott';

-- 2. not null
DROP TABLE people;
CREATE TABLE people (
	name VARCHAR(10),
    age INT,
    CONSTRAINT uk_people_name UNIQUE (name)
);
INSERT INTO people VALUES('DB', 28);
INSERT INTO people VALUES('DB', 30);
INSERT INTO people(age) VALUES(30);
INSERT INTO people(name) VALUES('DB');
SELECT *
FROM people;
-- 3. unique

-- 4. pk
DROP TABLE people;
CREATE TABLE people (
	pno INT PRIMARY KEY,
	name VARCHAR(10),
    age INT
);

INSERT INTO people VALUES(1, 'DB', 30);

-- 5. fk --list
CREATE TABLE list (
	list_no INT PRIMARY KEY,
	content VARCHAR(10),
    pno INT,
    CONSTRAINT fk_list_pno FOREIGN KEY (pno) REFERENCES people(pno)
);

INSERT INTO list VALUES(1, 'FK', 1);
INSERT INTO list VALUES(1, 'FK2', 2);

SELECT *
FROM list;
-- 6. check
-- 7. default
DROP TABLE list;
DROP TABLE people;
CREATE TABLE people (
	pno INT,
	name VARCHAR(10),
    age INT CHECK(age >= 0),
    type CHAR(1) CHECK(type IN ('M', 'F')),
    job VARCHAR(20) DEFAULT 'HK'
);

INSERT INTO people(age) VALUES(1);
INSERT INTO people(type) VALUES('Z');
INSERT INTO people(job) VALUES('Engineer');

SELECT *
FROM people;

-- 8. auto_increment
DROP TABLE board;
CREATE TABLE board(
	bno BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(10)
);

INSERT INTO board(title) VALUES ('IT'), ('CLOUD'), ('DB');

SELECT *
FROM board;

-- 
-- [시나리오 1] 신규 부서 및 사원 관리
-- 1. 테이블 생성: dept_test (deptno 숫자형 PK, dname 문자형 20자 NOT NULL, loc 문자형 20자)
DROP TABLE dept_test;
CREATE TABLE dept_test(
	deptno INT PRIMARY KEY,
    dname VARCHAR(20) NOT NULL,
    loc VARCHAR(20)
);


-- 2. 데이터 입력: 50번 부서, 'IT', 'SEOUL' 추가
INSERT INTO dept_test VALUES (50, 'IT', 'SEOUL');

SELECT *
FROM dept_test;

-- 3. 데이터 수정: IT 부서의 위치(loc)를 'PANGYO'로 변경
UPDATE dept_test
SET loc = 'PANGYO'
WHERE dname = 'IT';

-- 4. 컬럼 추가: dept_test 테이블에 budget(예산) 컬럼(숫자형) 추가
ALTER TABLE dept_test
ADD budget INT;

-- 5. 데이터 삭제: 부서 번호가 50인 행 삭제
DELETE FROM dept_test
WHERE deptno = 50;

-- 
-- [시나리오 2] 인사 시스템 데이터 정제 (응용)
-- 1. 복사 생성: emp 테이블에서 부서번호 20, 30번인 사원의 empno, ename, sal, deptno로 emp_senior 생성
CREATE TABLE emp_senior AS SELECT empno, ename, sal, deptno FROM emp WHERE deptno IN (20, 30);

SELECT *
FROM emp_senior;

-- 2. 제약 조건 추가: emp_senior 테이블의 empno 컬럼을 PK로 설정
ALTER TABLE emp_senior
ADD CONSTRAINT pk_emp_senior
PRIMARY KEY (empno);

DESC emp_senior;
-- 3. 일괄 수정: 부서번호가 20번인 사원들의 급여를 15% 인상
UPDATE emp_senior
SET sal = sal*1.15
WHERE deptno = 20;

-- 4. 조건 삭제: 급여(sal)가 2000 미만인 사원 데이터 삭제
DELETE FROM emp_senior
WHERE sal < 2000;

-- 5. 구조 유지 및 데이터 전체 삭제: 테이블 구조는 남기고 모든 데이터만 삭제
TRUNCATE TABLE emp_senior;

-- 
-- [시나리오 3] 서비스 회원 관리 시스템
-- 1. 테이블 생성: users 
--    (id: 숫자형, PK, 자동증가 / username: 문자형 20자, 중복불가, 필수 / 
--     email: 문자형 50자, 중복불가 / reg_date: 날짜형, 기본값 현재시간(CURRENT_TIMESTAMP))
DROP TABLE users;
CREATE TABLE users(
	id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(50) UNIQUE,
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT *
FROM users;

DESC users;
-- 2. 데이터 입력: 'admin', 'admin@test.com' / 'guest', 'guest@test.com' 두 개 행 추가
--    (id와 reg_date는 자동 입력되도록 설정)
INSERT INTO users (username, email) VALUES ('admin', 'admin@test.com'), ('guest', 'guest@test.com');

-- 3. 컬럼 수정: 유저의 상태를 나타내는 status 컬럼(문자형 10자, 기본값 'ACTIVE') 추가
ALTER TABLE users
ADD status VARCHAR(10) DEFAULT 'ACTIVE';

-- 4. 제약 조건 추가: email 컬럼이 NULL이 되지 않도록(NOT NULL) 제약 조건 수정
ALTER TABLE users
MODIFY email VARCHAR(50) NOT NULL;

-- 5. 데이터 수정: 'guest' 사용자의 상태(status)를 'INACTIVE'로 변경

-- 6. 데이터 삭제: 가입일(reg_date)이 오늘 이전인 데이터 중 상태가 'INACTIVE'인 사용자 삭제

-- 7. 테이블 삭제: users 테이블을 데이터베이스에서 완전히 제거