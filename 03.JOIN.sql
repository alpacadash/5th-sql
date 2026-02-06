-- JOIN
USE scott;

SELECT *
FROM salgrade;
/*
1. 조인이란?
	다수의 table를 활용하여 검색하는 명령어

2. 사용 table 
	1. emp & dept 
	  : deptno 컬럼을 기준으로 연관

	 2. emp & salgrade
	  : sal 컬럼을 기준으로 연관


3. table 별칭 사용 
	검색시 다중 table의 컬럼명이 다를 경우 table별칭 사용 불필요
	서로 다른 table간의 컬럼명이 중복된 경우, 컬럼 구분을 위해 정확한 table 소속 명시
	- table명 또는 table별칭
	- 주의사항 : 컬럼별칭 as[옵션], table별칭 as 사용 불가


4. 조인 종류 
	1. Equi 조인
		 = 동등비교 연산자 사용
		 : 테이블에서 같은 조건이 존재할 경우의 값 검색 

	2. Not - Equi 조인
		: 특정 범위내의 데이터 조인
		: between ~ and(비교 연산자)

	3. Self 조인 
		: 동일 테이블 조인
			emp의 empno[사번]과 mgr[사번] 관계

	4. Outer 조인 
		: 두개 이상의 테이블 조인시, 검색되지 않는 문제를 해결하기 위해 사용되는 조인
		- left/right outer join 
			join 명령어 기준 왼쪽(먼저 사용된것)/오른쪽의 모든 데이터 선택 후, 이후 테이블의 데이터와 join
		
*/	

-- 1. dept table의 구조 검색
DESC dept;
DESC emp;
DESC salgrade;
-- dept, emp, salgrade table의 모든 데이터 검색

-- *** Equi 조인 ***
-- = 동등 비교
-- 사원들의 이름, 사번, 부서위치 정보 검색 후 출력
SELECT e.ename, e.empno, d.loc, d.deptno
FROM emp AS e
INNER JOIN dept AS d
ON e.deptno = d.deptno;

-- 2. SMITH 의 이름ename, 사번empno, 근무지역(부서위치)loc 정보를 검색
SELECT e.ename, e.empno, d.loc, d.deptno
FROM emp AS e
INNER JOIN dept AS d
ON e.deptno = d.deptno
WHERE e.ename = 'SMITH';

-- 3. deptno가 동일한 모든 데이터 검색
-- emp & dept
SELECT *
FROM emp AS e
INNER JOIN dept AS d
ON e.deptno = d.deptno;

-- 4. 2+3 번 항목 결합해서 SMITH에 대한 모든 정보(ename, empno, sal, comm, deptno, loc) 검색하기
SELECT *
FROM emp AS e
INNER JOIN dept AS d
ON e.deptno = d.deptno
WHERE e.ename = 'SMITH';

-- 5.  SMITH에 대한 이름(ename)과 부서번호(deptno), 부서명(dept의 dname) 검색하기
SELECT e.ename, d.deptno, d.dname
FROM emp AS e
INNER JOIN dept AS d
ON e.deptno = d.deptno
WHERE e.ename = 'SMITH';

-- 6. 조인을 사용해서 뉴욕에 근무하는 사원의 이름과 급여를 검색 
-- loc='NEW YORK', ename, sal
SELECT e.ename, e.sal, d.loc
FROM emp AS e
INNER JOIN dept AS d
ON e.deptno = d.deptno
WHERE d.loc = 'NEW YORK';

-- 7. 조인 사용해서 ACCOUNTING 부서(dname)에 소속된 사원의 이름과 입사일 검색
SELECT e.ename, e.hiredate
FROM emp AS e
INNER JOIN dept AS d
ON e.deptno = d.deptno
WHERE d.dname = 'ACCOUNTING';

-- 8. 직급이 MANAGER인 사원의 이름, 부서명 검색
SELECT e.ename, d.dname
FROM emp AS e
INNER JOIN dept AS d
ON e.deptno = d.deptno
WHERE e.job = 'MANAGER';

-- *** Not - Equi 조인 ***
-- salgrade table(급여 등급 관련 table)

-- 9. 사원의 급여가 몇등급인지 검색
-- between ~ and
SELECT e.empno, e.sal, s.grade
FROM emp AS e
INNER JOIN salgrade AS s
ON e.sal BETWEEN s.losal AND s.hisal;

-- ? 등급이 3등급인 사원들의 이름과 급여 검색
SELECT e.empno, e.sal, s.grade
FROM emp AS e
INNER JOIN salgrade AS s
ON e.sal BETWEEN s.losal AND s.hisal
WHERE s.grade = 3;

-- 10. 사원(emp) 테이블의 부서 번호(deptno)로 부서 테이블을 참조하여 사원명, 부서번호, 부서의 이름(dname) 검색

-- *** Outer 조인 ***
SELECT *
FROM emp;

/*emp를 두개의 table로 사용 
1. 별칭 e : employee 직원 table
2. 별칭 m : manager table 
*/

-- 11. SMITH 직원의 매니저 이름 검색
/* manager table의 ename 검색
   employee table에 ename='SMITH'
	- SMITH라는 이름으로 상사의 사번 검색
	-> 상사의 사번으로 manager의 사번으로 매니저 이름 검색
*/
SELECT e.mgr
FROM emp e
WHERE ename = 'SMITH';

SELECT ename
FROM emp m
WHERE m.empno = 7902;

SELECT m.ename
FROM emp AS e
INNER JOIN emp AS m
ON e.mgr = m.empno
WHERE e.ename = 'SMITH';
	
-- ? SMITH 직원의 매니저의 부서번호 검색
SELECT d.deptno
FROM emp AS e
INNER JOIN emp AS m
INNER JOIN dept AS d
ON m.deptno = d.deptno AND e.mgr = m.empno
WHERE e.ename = 'SMITH';

-- ? 12. 매니저가 KING인 사원들의 이름과 직급 검색
SELECT e.ename, e.job
FROM emp AS e
INNER JOIN emp AS m
ON e.mgr = m.empno
WHERE m.ename = 'KING';


-- ? 13. SMITH와 동일한 근무지에서 근무하는 사원의 이름 검색
SELECT c.ename, c.deptno
FROM emp s
INNER JOIN emp c
ON s.deptno = c.deptno
WHERE s.ename = 'SMITH';

SELECT e.ename
FROM emp e
JOIN dept d ON e.deptno = d.deptno
WHERE d.loc = (
    SELECT d.loc
    FROM emp e
    JOIN dept d ON e.deptno = d.deptno
    WHERE e.ename = 'SMITH'
);
-- *** 4. outer join ***
-- 14. 모든 사원명, 매니저 명 검색, 단 매니저가 없는 사원도 검색되어야 함
-- null값을 포함한 검색도 가능
SELECT e.ename '사원' , m.ename '매니저'
FROM emp e
INNER JOIN emp m
ON e.mgr = m.empno;

SELECT e.ename '사원' , m.ename '매니저'
FROM emp e
LEFT OUTER JOIN emp m
ON e.mgr = m.empno;


/* 1. 모든 사원의 모든 매니저명 포함해서 검색
   - 매니저가 없는 사원일지라도 해당 사원의 정보 포함해서 검색 
   2. 경우의 수1 : 매니저가 없는 사원이 있을수 있다
      경우의 수2 : 매니저가 있는 사원이 있을수 있다 
     
   3. 발생된 논리적인 오류   
   - 매니저가 없는 사원 정보가 검색 불가능인 경우 
   
   4. 해결책
   - 모든 사원은 매니저는 KING인 경우는 없지만 다른 사원들은 존재
   - KING의 mgr 컬럼값은 null이나, 검색이 되어야 함
   - 매니저 table에는 null이라는 매니저 사번은 존재하지 않음
   - 검색
      null값이라도 검색이 되어야 함
      매니저 테이블에는 매니저사번이 null이 매니저는 없지만 검색에 포함해야만 사원 table의 KING도 검색
   5. 데이터가 없는 쪽은 사원 table의 mgr과 매니저 table의 매니저사번 
      - 사원 table에는 mgr 컬럼값에 null 보유 
      - 매니저 table의 매니저 사번에는 null 자체가 없음
      - 결론 : 데이터가 없는 쪽은  매니저 table 
      
*/

-- ? 15. 모든 직원명, 부서번호, 부서명 검색
-- 부서 테이블의 40번 부서와 조인할 사원 테이블의 부서 번호가 없지만,
-- outer join이용해서 40번 부서의 부서 이름도 검색하기 
SELECT e.ename, e.deptno, d.dname
FROM emp e
RIGHT OUTER JOIN dept d
ON e.deptno = d.deptno
WHERE d.deptno = 40;

-- UNION, UNION ALL

SELECT ename FROM emp
UNION ALL
SELECT deptno FROM dept;

-- ANSI Join vs Oracle Join
/*
1. ANSI JOIN 
SQL 표준(ANSI SQL) 에서 정의한 공식 조인 문법
SELECT *
FROM A
JOIN B
ON A.col = B.col;

2. Oracle JOIN
Oracle에서 사용하던 비표준 조인 문법
FROM 절에 테이블 나열
WHERE 절에서 조인 조건 작성
외부 조인은 (+) 기호 사용

SELECT *
FROM A, B
WHERE A.col = B.col;

*/

-- Natural Join (자연 조인)
-- 두 테이블에서 이름이 같은 모든 컬럼을 자동으로 조인

-- Cross Join (카테시안 곱)
-- 조인 조건 없이 모든 경우의 수

-- 중복 제거
-- ex. 사원이 배정된 부서가 총 몇 개인지 조회




-- 추가 실습
-- 매니저보다 먼저 입사한 사원 목록 조회
-- 자신의 매니저보다 입사일(hiredate)이 빠른 사원의 이름, 입사일, 매니저 이름, 매니저 입사일을 조회
SELECT e.ename, e.hiredate, m.ename, m.hiredate
FROM emp e
INNER JOIN emp m
ON e.mgr = m.empno
WHERE e.hiredate < m.hiredate;


-- 사원이 한 명도 없는 부서 정보 조회
-- 사원이 배정되지 않은 부서의 부서번호, 부서명, 위치를 조회
SELECT d.deptno, d.dname, d.loc
FROM dept d
LEFT JOIN emp e
ON d.deptno = e.deptno
WHERE e.empno IS NULL;

-- 같은 부서에 근무하는 동료 사원 쌍 찾기(단, 본인 제외 및 중복 쌍 제거)
SELECT e1.ename, e2.ename, e1.deptno
FROM emp e1
INNER JOIN emp e2
ON e1.deptno = e2.deptno AND e1.empno < e2.empno;
/*
예시 출력

'SMITH', 'JONES', '20'
'SMITH', 'SCOTT', '20'
'SMITH', 'ADAMS', '20'
'SMITH', 'FORD', '20'
'ALLEN', 'WARD', '30'
'ALLEN', 'MARTIN', '30'
'ALLEN', 'BLAKE', '30'
'ALLEN', 'TURNER', '30'
'ALLEN', 'JAMES', '30'
...
*/

-- 사원별 관리자 및 관리자의 관리자(차상위자) 조회
-- 사원명, 직속 상사명, 차상위 상사명을 함께 조회. 상사가 없으면 'None'으로 표시
SELECT e.ename, COALESCE(m.ename, 'None'), COALESCE(mm.ename, 'None')
FROM emp e
LEFT JOIN emp m
ON e.mgr = m.empno
LEFT JOIN emp mm
ON m.mgr = mm.empno;


-- 'CHICAGO'에서 근무하는 사원들의 평균 급여 등급
-- 시카고에서 근무하는 사원들의 평균 급여가 아닌, 급여 등급의 평균
SELECT AVG(s.grade)
FROM emp e
INNER JOIN dept d
ON e.deptno = d.deptno
INNER JOIN salgrade s
ON e.sal BETWEEN s.losal AND s.hisal
WHERE d.loc = 'CHICAGO';



-- 자신의 급여 등급보다 높은 등급의 상사를 둔 사원
-- 사원의 급여 등급이 상사의 급여 등급보다 낮은 사원들의 이름과 등급, 상사의 이름과 등급을 조회
-- salgrade 테이블 활용
SELECT e.ename, es.grade, m.ename, ms.grade
FROM emp e
INNER JOIN emp m
ON e.mgr = m.empno
INNER JOIN salgrade es
ON e.sal BETWEEN es.losal AND es.hisal
INNER JOIN salgrade ms
ON m.sal BETWEEN ms.losal AND ms.hisal
WHERE es.grade < ms.grade;


-- 부서별 급여 합계와 전체 합계를 동시에 조회 (UNION)
-- 각 부서별 이름과 급여 합계를 구하고, 마지막 행에 모든 부서의 총합계를 추가
SELECT d.dname, COALESCE(SUM(e.sal), 0)
FROM emp e
RIGHT JOIN dept d
ON e.deptno = d.deptno
GROUP BY d.dname 

UNION ALL

SELECT 'TOTAL', COALESCE(SUM(sal), 0)
FROM emp;

-- 특정 사원(예: SCOTT)보다 급여를 많이 받는 사원의 이름과 부서명 조회
-- 'SCOTT'보다 많은 급여를 받는 사원의 이름, 급여, 부서명을 조회
SELECT e.ename, e.sal, d.dname
FROM emp e
INNER JOIN dept d ON e.deptno = d.deptno
INNER JOIN emp target ON target.ename = 'SCOTT'
WHERE e.sal > target.sal;

-- 사원이 한 명도 없는 부서 조회 (LEFT JOIN)
SELECT d.deptno, d.dname, d.loc
FROM dept d
LEFT JOIN emp e ON d.deptno = e.deptno
WHERE e.empno IS NULL;
-- 급여 등급(SALGRADE)이 매칭되지 않는 사원 조회(LEFT JOIN)
SELECT e.ename, e.sal, s.grade
FROM emp e
LEFT JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
WHERE s.grade IS NULL;

