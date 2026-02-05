-- DQL
/*

1. 기본 검색
1-1. 단순 검색
	select절 속성명[ , ..]
	from절 table명;
	- 실행 순서 : from 절 -> select 절

1-2. 정렬 포함 검색
	select절
	from절
	order by절
	- 실행 순서 : from절 -> select절 -> order by절
	
1-3. 조건식 포함 검색
	select절
	from절
	where절
	- 실행 순서 : from절 -> where절-> select절
	
1-4. 조건식과 정렬 포함 검색
	select절
	from절
	where절
	order by절
	- 실행 순서 : from절 -> where절 -> select절 -> order by절
	
*/
USE scott; 
-- 2. 해당 계정의 모든 table 목록 검색
SHOW tables;

-- 3. emp table의 모든 정보 검색
DESCRIBE emp;
DESC emp;
-- 4. emp table의 구조 검색[묘사]
-- mysql
/*
[type]
int
	- 정수, 4바이트
	- -21억 ~ 21억
double
	- 실수, 8바이트
	- 소수점아래 7자리까지

varchar(10)
	- 가변길이 문자형, 1~65535바이트
	- 총 10글자 사용 가능

datetime
	- 날짜, 8바이트
	- 'YYYY-MM-DD HH:MM:SS' 형식으로 사용

[emp table field]
empno : 사원번호
ename : 사원이름, 사원명
job : 업무
mgr : 사원을 관리하는 매니저 번호
hiredate : 입사일
sal : 급여
comm : 커미션, 보너스
deptno : 부서 번호
*/

SELECT *
FROM emp;

-- 5. emp table의 사번(empno)과 이름(ename)만 검색
-- 검색되는 컬럼명에 별칭 부여 방법
-- 문법 : 컬럼명 별칭 또는 컬럼명 as 별칭
SELECT empno AS '사원 번호', ename 이름
FROM emp;

-- 6. emp table의 입사일(hiredate) 검색
-- 검색 결과 : 날짜 타입 yy/mm/dd, 차후에 함수로 가공
SELECT empno, hiredate
FROM emp;
	
-- 7. emp table의 검색시 칼럼명 empno를 사번이란 별칭으로 검색 
SELECT empno AS '사번'
FROM emp;

-- 8. emp table에서 부서번호 검색시 중복 데이터 제거후 검색 
-- 키워드 : 중복제거 키워드 - distinct
-- 사원들이 소속된 부서 번호(deptno)만 검색
SELECT DISTINCT deptno
FROM emp;

-- deptno는 중복 제거, empno 출력
SELECT DISTINCT deptno, empno
FROM emp;

-- 9. 데이터를 오름차순(asc)으로 검색하기(순서 정렬)
-- 키워드 : 정렬 키워드 - order by
-- asc : 오름차순, desc : 내림차순
-- ?사번을 오름차순으로 정렬해서 사번만 검색
SELECT empno
FROM emp
ORDER BY empno ASC;

SELECT empno
FROM emp
ORDER BY empno DESC;

-- ? 부서번호 정렬
SELECT empno, deptno
FROM emp
ORDER BY deptno ASC, empno DESC;

-- 10.emp table 에서 deptno 내림차순 정렬 적용해서 ename과 deptno 검색하기
SELECT ename, deptno
FROM emp
ORDER BY deptno DESC;
-- ?empno와 deptno를 검색하되 단 deptno는 오름차순으로
SELECT empno, deptno
FROM emp
ORDER BY deptno ASC;

-- order by 다음에 어떤 컬럼이 오는지에 따라 결과가 달라짐

-- 11. 입사일(date 타입의 hiredate) 검색, date 타입은 정렬가능 따라서 경력자(입사일이 오래된 직원)부터 검색(asc)

SELECT ename, hiredate
FROM emp
ORDER BY hiredate ASC;

-- *** 연산식 ***

-- 12. emp table의 모든 직원명(ename), 월급여(sal), 연봉(sal*12) 검색
-- 단 sal 컴럼값은 comm을 제외한 sal만으로 연봉 검색
SELECT ename, sal, sal*12 AS '연봉'
FROM emp;

-- 13. 모든 직원의 연봉 검색(sal *12 + comm) 검색
SELECT ename, sal, (sal *12 + comm) AS '연봉'
FROM emp;


-- null 값을 보유한 컬럼들은 연산시에 데이터 존재 자체가 무시
-- null값 보유한 컬럼의 연산은 어떤 방법으로 전처리를 해야 하나요?
-- null값의 컬럼을 0으로 수치화 해서 연산 : ifnull/nvl(컬럼명, 변경하고자 하는 수치값)
-- IFNULL(a, b)
SELECT ename, sal, (sal *12 + IFNULL(comm, 0)) AS '연봉'
FROM emp;

-- COALESCE(a, b, c, ...) :
SELECT ename, sal, (sal *12 + COALESCE(comm, 0)) AS '연봉'
FROM emp;

-- comm 값을 확정 : comm, sal * 0.1, 500
SELECT ename, COALESCE(comm, sal*0.1, 10) AS '확정보너스'
FROM emp;
-- phone -> home -> '연락처없음'

-- *** 조건식 ***
-- where
-- deptno가 10인 사원 검색
SELECT *
FROM emp
WHERE deptno = 10;

-- comm 조건 검색을 할때에는?
SELECT *
FROM emp
WHERE comm = null;

-- 14. comm이 null인 사원에 대한 검색(ename, comm)
SELECT *
FROM emp
WHERE comm IS null;

-- 15. comm이 null이 아닌 사원에 대한 검색(ename, comm)

-- 16. ename, 전체연봉... comm 포함 연봉 검색

-- 17. emp table에서 deptno 값이 20인(조건식 where) 직원 정보 모두(*) 출력하기 
-- ? 검색된 데이터의 sal 값이 내림차순으로 정렬검색
SELECT *
FROM emp
WHERE deptno = 20
ORDER BY sal DESC;

-- 18. emp table에서 ename이 smith(SMITH)에 해당하는 deptno값 검색
-- ename 컬럼값, 동등비교 =
SELECT ename, deptno
FROM emp
WHERE BINARY(ename) = 'SMITH';

-- Windows : 1 (Not case sensitive)
SHOW VARIABLES LIKE 'lower_case_table_names';

-- 19. sal가 900이상(>=)인 직원들의 이름(ename), sal 검색
SELECT ename, sal
FROM emp
WHERE sal >= 900;

-- 20. deptno가 10이고(and) job이 메니저인 사원이름 검색 
SELECT ename
FROM emp
WHERE deptno = 10 AND job = 'MANAGER';

-- 21. ?deptno가 10이거나(or) job이 메니저(MANAGER)인 사원이름(ename) 검색
-- or 연산자
SELECT ename
FROM emp
WHERE deptno = 10 OR job = 'MANAGER';

-- 22. deptno가 10이 아닌 모든 사원명(ename) 검색
-- 아니다 : not 부정 연산자, !=, <>
-- !=
SELECT ename, deptno
FROM emp
WHERE deptno != 10;

SELECT ename, deptno
FROM emp
WHERE deptno <> 10;

SELECT ename, deptno
FROM emp
WHERE NOT deptno = 10;

-- 23. sal이 2000 이하(sal<=2000)이거나(or) 3000이상인(sal>=3000) 사원명(ename) 검색
SELECT ename
FROM emp
WHERE sal <= 2000 OR sal >= 3000;

SELECT ename
FROM emp
WHERE NOT sal <= 2000 AND NOT sal >= 3000;

SELECT ename
FROM emp
WHERE sal > 2000 AND sal < 3000;

-- 24. comm이 300 or 500 or 1400인 사원명, comm 검색
-- in 연산자 활용
-- or로 처리되는 모든 데이터를 in (값1, 값2, ...)
SELECT ename, comm
FROM emp
WHERE comm IN (300, 500, 1400);
    
-- 25. ?comm이 300 or 500 or 1400이 아닌(not) 사원명, comm 검색
-- ?comm이 null 인 사원들도 모두 출력하려면?
SELECT ename, comm
FROM emp
WHERE comm IS NULL OR NOT comm IN (300, 500, 1400);

-- 26. 81년도에 입사한 사원 이름 검색
-- between ~ and
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN '1981-01-01' AND '1981-12-31';

-- 27. ename이 M으로 시작되는 모든 사원번호(empno), 이름(ename) 검색  
-- 연산자 like : 한 음절 _ , 음절 개수 무관하게 검색할 경우 %
SELECT ename, empno
FROM emp
WHERE ename LIKE 'M%';

-- 28. ename이 M으로 시작되는 전체 자리수가 두음절의 사원번호, 이름 검색
SELECT ename, empno
FROM emp
WHERE ename LIKE 'M_';

-- 29. 두번째 음절의 단어가 M인 모든 사원명 검색 
SELECT ename, empno
FROM emp
WHERE ename LIKE '_M%';

-- 30. 단어가 M을 포함한 모든 사원명 검색 
SELECT ename, empno
FROM emp
WHERE ename LIKE '%M%';

-- 연산자 정리

-- 1.DQL
-- EMP 테이블에서 급여(sal)가 1500에서 3000 사이이고, 
-- 업무(job)가 'MANAGER'가 아닌 사원들의 이름(ename), 업무(job), 급여(sal)를 출력. 
-- (단, 급여가 높은 순(내림차순)으로 정렬)

-- 정렬(ORDER BY)의 숨은 디테일
SELECT empno AS '사번'
FROM emp
ORDER BY 사번 DESC;
-- NULL?
SELECT ename, comm
FROM emp
ORDER BY comm DESC;

SELECT ename, comm
FROM emp
ORDER BY (comm IS NULL) ASC, comm ASC;

SELECT ename, comm
FROM emp
ORDER BY IFNULL(comm, 9999999999) ASC;

SELECT ename, sal, deptno
FROM emp
ORDER BY 3 ASC, 2 DESC;

-- 연산자 우선순위 (AND vs OR)
-- AND > OR
-- 부서가 10 또는 20 이면서 직업이 CLERK 사원?
SELECT ename, deptno
FROM emp
WHERE (deptno = 10 OR deptno = 20) AND job = 'CLERK';

-- 집합 연산자 (Set Operators)
-- SELECT를 하나로 합칠때
-- UNION

-- 2.DQL_function
/*
CAST(expr AS type)
데이터를 지정된 데이터 타입으로 변환
주요 변환 타입:
CHAR: 문자열
SIGNED: 부호 있는 정수 (음수 가능)
UNSIGNED: 부호 없는 정수 (양수만)
DATE / DATETIME / TIME: 날짜 및 시간
DECIMAL: 정밀한 소수점 연산
*/
-- 1. 숫자를 문자로 변환 (문자열 결합 시 유용)

-- 2. 문자열을 정수로 변환 (계산이 필요할 때)

-- 3. 실수를 정밀한 소수점으로 변환 (DECIMAL(전체자리수, 소수점자리수))
-- 12.3456을 소수점 둘째자리까지 반올림하여 표현

-- 4. 문자열을 날짜로 변환

-- CONVERT(expr, type)

-- 1. 기본적인 타입 변환

-- 2. 문자셋 변환 (UTF8MB4로 변환할 때)

/*
제어 흐름 함수 (Conditionals)
IFNULL 외에도 조건에 따라 값을 바꾸는 함수들은 쿼리의 유연성 향상

IF(조건, 참일때, 거짓일때): 간단한 2지선다 조건문
COALESCE(값1, 값2, ...): 여러 인자 중 NULL이 아닌 첫 번째 값을 반환 (IFNULL의 확장판)
*/
-- 1. 급여에 따른 보너스 여부 표시
-- 2. comm이 없으면 0, 0도 없으면 '미정' 출력 (데이터 보정)

/*
문자열 결합 및 조작 (String Manipulation)
CONCAT(str1, str2, ...): 여러 문자열을 하나로 합칩니다.
REPLACE(str, from, to): 특정 문자를 찾아 바꿉니다.
*/
-- 1. 사원이름과 직무를 'SMITH(CLERK)' 형태로 출력

-- 2. 직무명에서 'MAN'을 'PERSON'으로 변경