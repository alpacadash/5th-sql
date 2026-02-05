/* 
DQL Practice
*/
USE scott;
/*
부서번호가 10번인 사원번호, 이름, 월급 출력
*/
SELECT empno, ename, sal
FROM emp
WHERE deptno = 10;
/*
사원번호가 7369인 사람의 이름, 입사일, 부서 번호 출력
*/
SELECT ename, hiredate, deptno
FROM emp
WHERE empno = 7369;
/*
이름이 ALLEN인 사람의 정보 출력
*/
SELECT *
FROM emp
WHERE ename = 'ALLEN';
/*
입사일이 83/01/12인 사원의 이름, 부서번호, 월급 출력
*/
SELECT ename, deptno, sal, hiredate
FROM emp
WHERE hiredate = 1983-01-12;

/*
직업이 MANAGER가 아닌 사람의 모든 정보를 출력
*/
SELECT *
FROM emp
WHERE NOT job = 'MANAGER';

/*
입사일이 81/04/02 이후에 입사한 사원의 정보 출력
*/
SELECT *
FROM emp
WHERE hiredate > '1981-04-02';

/*
급여가 800이상인 사람의 이름, 급여, 부서번호 출력
*/
SELECT ename, sal, deptno
FROM emp
WHERE sal >= 800;


/*
부서번호가 20번 이상인 사원의 보든 정보 출력
*/
SELECT *
FROM emp
WHERE deptno >= 20;

/*
이름이 K로 시작하는 사람의 모든정보 출력
*/
SELECT *
FROM emp
WHERE ename LIKE 'K%';

/*
입사일이 81/12/09 보다 먼저 입사한 사람들의 모든 정보 출력
*/
SELECT *
FROM emp
WHERE hiredate < '1981-12-09';

/*
입사번호가 7698보다 작거나 같은 사람들의 입사번호와 이름 출력
*/
SELECT empno, ename
FROM emp
WHERE empno <= 7698;

/*
입사일이 81/04/02보다 늦고  82/12/09보다 빠른 사원의 이름, 월급, 부서번호 출력
*/
SELECT ename, sal, deptno
FROM emp
WHERE hiredate > '1981-04-02' AND hiredate < '1982-12-09';

/*
급여가 1600보다 크고[초과] 3000보다 작은[미만] 사람의 이름, 직업, 급여 출력
*/
SELECT ename, job, sal
FROM emp
WHERE sal > 1600 AND sal < 3000;

/*
사원번호가 7654와 7782사이 이외의 사원의 모든 정보 출력
*/
SELECT *
FROM emp
WHERE empno NOT BETWEEN 7654 AND 7782;

/*
직업이 MANAGER와 SALESMAN인 사람의 모든 정보 출력
*/
SELECT *
FROM emp
WHERE job IN ('MANAGER', 'SALESMAN');

/**16.
부서번호와 20,30번을 제외한 모든 사람의 이름, 사원번호, 부서번호 출력
*/
SELECT ename, empno, deptno
FROM emp
WHERE deptno NOT IN (20, 30);

/*
이름이 S로 시작하는 사원의 사원번호, 이름, 입사일, 부서번호 출력
*/
SELECT empno, ename, hiredate, deptno
FROM emp
WHERE ename LIKE 'S%';

/*
이름중 S자가 들어가 있는 사람만 모든 정보 출력
*/
SELECT *
FROM emp
WHERE ename LIKE '%S%';

/*
이름이 S로 시작하고 마지막 글자가 T인 사람의 정보 출력(단, 이름은 전체 5자)
*/
SELECT *
FROM emp
WHERE ename LIKE 'S___T';

/*
커미션이 null인 사원의 정보를출력
*/
SELECT *
FROM emp
WHERE comm IS NULL;

/*
커미션이 null이 아닌 사원의 정보 출력하
*/
SELECT *
FROM emp
WHERE comm IS NOT NULL;

/*
부서번호가 30번이고 급여가 1500이상인 사람의 이름, 부서, 월급(sal) 출력
*/
SELECT ename, deptno, sal
FROM emp
WHERE deptno = 30 AND sal >= 1500;

/*
이름의 첫글자가 K로 시작하거나 부서번호가 30인 사람의 사원번호, 이름, 부서번호 출력
*/
SELECT empno, ename, deptno
FROM emp
WHERE ename LIKE 'K%' OR deptno = 30;

/*
급여가 1500이상이고 부서번호가 30번인 사원중 직업이 MANAGER인 사람의 정보 출력
*/
SELECT *
FROM emp
WHERE sal >= 1500 AND deptno = 30 AND job = 'MANAGER';

/*
부서번호가 30인 사람중 사원번호 정렬
*/
SELECT *
FROM emp
WHERE deptno = 30
ORDER BY empno;

/*
급여가 많은 순으로 정렬
*/
SELECT *
FROM emp
ORDER BY sal DESC;

/*
부서번호로 오름차순 -> 급여가 많은 사람 순 출력
*/
SELECT *
FROM emp
ORDER BY deptno ASC, sal DESC;

/*
부서번호로 내림차순 -> 급여순으로 내림차순
*/
SELECT *
FROM emp
ORDER BY deptno DESC, sal DESC;