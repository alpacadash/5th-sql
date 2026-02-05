-- Subquery 
-- 1. SMITH라는 직원 부서명 검색
-- ? 조인
SELECT e.ename, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.ename = 'SMITH';

-- 서브쿼리
SELECT d.dname
FROM dept d
WHERE d.deptno = (SELECT e.deptno
					FROM emp e
					WHERE e.ename = 'SMITH');

-- 2. SMITH와 동일한 직급(job)을 가진 사원들 검색(SMITH 포함)
SELECT e.ename
FROM emp e
WHERE e.job = (SELECT e.job
					FROM emp e
					WHERE e.ename = 'SMITH');

-- 3. SMITH와 급여가 동일하거나 더 많은(>=) 사원명과 급여 검색
SELECT e.ename, e.sal
FROM emp e
WHERE e.sal >= (	SELECT e.sal
					FROM emp e
					WHERE e.ename = 'SMITH');

-- 4. DALLAS에 근무하는 사원의 이름, 부서 번호 검색
SELECT e.ename, e.deptno
FROM emp e
WHERE e.deptno = (	SELECT d.deptno
					FROM dept d
					WHERE d.loc = 'DALLAS');
			
-- 5. 평균 급여보다 더 많이 받는(>) 사원만 검색
SELECT e.ename, e.sal
FROM emp e
WHERE e.sal > (	SELECT AVG(e.sal)
				FROM emp e)
UNION ALL

SELECT 'AVG', AVG(e.sal)
FROM emp e;

-- 다중행 서브 쿼리(sub query의 결과값이 하나 이상)
-- 6.급여가 3000이상 사원이 소속된 부서에 속한  사원이름, 급여 검색
-- 급여가 3000이상 사원의 부서 번호
-- in 연산자 안에 있는 서브쿼리
SELECT e.ename, e.sal
FROM emp e
WHERE e.deptno IN (	SELECT s.deptno
					FROM emp s
					WHERE s.sal >= 3000 );

-- 7. in 연산자를 이용하여 부서별로 가장 급여를 많이 받는 사원의 정보(사번, 사원명, 급여, 부서번호) 검색
-- 사번, 사원명, 급여, 부서번호 

-- ? 부서별로 가장 급여를 많이 받는 사원
	
-- ? 결과를 부서번호 내림차순 정렬
SELECT e.empno, e.ename, e.sal, e.deptno
FROM emp e
WHERE (e.deptno, e.sal) IN ( SELECT s.deptno, MAX(s.sal)
							FROM emp s
                            GROUP BY s.deptno )
ORDER BY e.deptno DESC;

-- 8. 직급(job)이 MANAGER인 사람이 속한 부서의 부서 번호와 부서명(dname)과 지역검색(loc)
SELECT d.deptno, d.dname
FROM dept d
WHERE d.deptno IN (	SELECT e.deptno
					FROM emp e
                    WHERE e.job = 'MANAGER' );
                    
-- 실습

-- 스칼라
-- 모든 사원의 이름, 급여, 그리고 회사 전체 평균 급여를 나란히 출력
SELECT e.ename, e.sal ,(SELECT AVG(sal) FROM emp)
FROM emp e;

-- 사원 이름과 그 사원이 속한 부서의 이름을 출력
SELECT e.ename, (SELECT d.dname FROM dept d WHERE e.deptno = d.deptno)
FROM emp e;

-- 사원명과 해당 사원 부서의 '최대 급여'를 함께 출력
SELECT e.ename, (SELECT MAX(sal) FROM emp WHERE deptno = e.deptno)
FROM emp e;

-- '급여 등급(SALGRADE)' 테이블을 참고하여 사원의 이름과 등급(GRADE) 출력
SELECT e.ename, (SELECT s.grade FROM salgrade s WHERE e.sal BETWEEN s.losal AND s.hisal)
FROM emp e;

-- 인라인뷰
-- 부서별 평균 급여 테이블을 먼저 만들고, 이를 부서 테이블과 조인하여 부서명과 평균 급여를 출력
SELECT d.dname, v.avg_sal
FROM dept d, (SELECT deptno, AVG(sal) avg_sal FROM emp GROUP BY deptno) v
WHERE d.deptno = v.deptno;

-- 81년도에 입사한 사원들 중에서만 급여가 2000 이상인 사람 출력
SELECT *
FROM( SELECT * FROM emp WHERE hiredate LIKE '1981%') v
WHERE v.sal >= 2000;

-- 각 부서에서 가장 먼저 입사한 사원의 정보를 출력
SELECT e.ename, e.hiredate, e.deptno
FROM emp e, (SELECT deptno, MIN(hiredate) earlist FROM emp GROUP BY deptno) v
WHERE e.deptno = v.deptno AND e.hiredate = v.earlist;

-- 사원 정보에 ename과 더불어 부서 위치(LOC) 출력
SELECT e.ename, d.loc
FROM emp e
INNER JOIN (SELECT deptno, loc FROM dept WHERE loc = 'DALLAS') d ON e.deptno = d.deptno;

-- 부서별 인원수와 평균 급여를 가진 가상 테이블을 만들고, 인원수가 5명 이상인 부서만 조회
SELECT *
FROM (SELECT deptno, COUNT(*) AS cnt, AVG(sal) FROM emp GROUP BY deptno) v
WHERE v.cnt >= 5;

-- 일반 서브쿼리
-- 직급이 'MANAGER'인 사원들이 속한 부서의 모든 사원을 출력
SELECT *
FROM emp
WHERE deptno IN (
    SELECT DISTINCT deptno
    FROM emp
    WHERE job = 'MANAGER'
);

-- 30번 부서의 그 누구보다도 급여를 많이 받는 사원 출력
-- ALl, ANY
SELECT ename, sal
FROM emp
WHERE sal > ALL (	SELECT sal
					FROM emp
					WHERE deptno = 30);

-- 부하 직원이 한 명이라도 있는 '관리자' 사원들의 이름을 출력
-- EXISTS
SELECT m.ename
FROM emp m
WHERE EXISTS(	SELECT 1
				FROM emp e
				WHERE e.mgr = m.empno);

SELECT DISTINCT m.ename
FROM emp m
INNER JOIN emp s
ON s.mgr = m.empno;

SELECT m.ename
FROM emp m
INNER JOIN emp s
ON s.mgr = m.empno
GROUP BY m.ename;

