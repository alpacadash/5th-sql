-- DML
-- *** insert ****
CREATE TABLE people (
	name VARCHAR(10),
    age INT 
);

DESC people;

-- 1. 컬럼명 기술없이 데이터 입력
INSERT INTO people VALUES ('DB', 39);

SELECT *
FROM people;

-- 2. 컬럼명 기술후 데이터 입력 
-- 선언된 컬럼 순서에 맞게 데이터 저장 가능
INSERT INTO people(age, name) VALUES (40, 'JAVA');

-- 3. table에 한번에 데이터 insert하기 
INSERT INTO people(name, age) VALUES ('HTML', 45), ('CSS', 28);

-- 4. ? 부서 번호가 10인 데이터는 emp01에 저장, 
-- 부서 번호가 20 or 30인 데이터는 emp02에 저장
-- emp01, emp02 
CREATE TABLE emp01 AS SELECT * FROM emp WHERE 1=0;

INSERT INTO emp01 SELECT * FROM emp WHERE deptno = 10;

SELECT *
FROM emp01;

CREATE TABLE emp02 AS SELECT * FROM emp WHERE 1=0;
INSERT INTO emp02 SELECT * FROM emp WHERE deptno IN (20, 30);
SELECT *
FROM emp02;

DROP TABLE emp01;
DROP TABLE emp02;
-- *** update ***
-- 1. 테이블의 모든 행 변경
SELECT *
FROM emp02;
-- Edit > Preferences > SQL Editor > uncheck safe
UPDATE emp02
SET deptno = 30;

-- 30이전의 데이터로 복원
ROLLBACK;

-- ? emp table로 부터 empno, sal, hiredate, ename 순으로 table 생성
-- 2. emp01 table의 모든 사원의 급여를 10%(sal*1.1) 인상하기
DROP TABLE emp01;

CREATE TABLE emp01 AS SELECT * FROM emp;

UPDATE emp01
SET sal = sal*1.1;

SELECT *
FROM emp01;

-- 3. emp01의 모든 사원의 입사일을 오늘로 변경
UPDATE emp01
SET hiredate = CURDATE();

-- 4. 급여가 3000이상인 사원의 급여만 10%인상
UPDATE emp01
SET sal = sal*1.1
WHERE sal >= 3000;

-- 5.? emp01 table 사원의 급여가 1000이상인 사원들의 급여만 500원씩 삭감 
UPDATE emp01
SET sal = sal - 500
WHERE sal >= 1000;

-- 6. emp01 table에 DALLAS(dept의 loc)에 위치한 부서의 소속 사원들의 급여를 1000인상
UPDATE emp01
SET sal = sal + 1000
WHERE deptno = (	SELECT deptno
					FROM dept
                    WHERE loc = 'DALLAS');

-- 7. emp01 table의 SMITH 사원의 부서 번호를 30으로, 직급은 MANAGER 수정
UPDATE emp01
SET deptno = 30, job = 'MANAGER'
WHERE ename = 'SMITH';

-- *** delete ***
-- 8. 하나의 table의 모든 데이터 삭제
SELECT *
FROM emp02;

DELETE FROM emp01;

ROLLBACK;

-- 9. 특정 row 삭제(where 조건식 기준)
-- emp01 에서 10번만 삭제
DELETE FROM emp02
WHERE deptno = 10;

-- 10. emp01 table에서 comm 존재 자체가 없는(null) 사원 모두 삭제
DELETE FROM emp02
WHERE comm IS NULL;

-- 11. emp01 table에서 comm이 null이 아닌 사원 모두 삭제
DELETE FROM emp02
WHERE comm IS NOT NULL;

-- 12. emp01 table에서 부서명이 RESEARCH 부서에 소속된 사원 삭제 
DELETE FROM emp02
WHERE deptno IN (SELECT deptno
				FROM dept
                WHERE dname = 'RESEARCH');
                
DELETE e
FROM emp02 e
INNER JOIN dept d ON e.deptno = d.deptno
WHERE d.dname = 'RESEARCH';

-- 13. table내용 삭제
DELETE FROM emp02;