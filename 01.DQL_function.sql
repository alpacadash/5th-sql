-- DQL Function
-- 단일행 함수 : 입력 데이터 수만큼 출력 데이터

-- *** [숫자함수] ***
-- 1. 절대값 구하는 함수 : abs()
SELECT -1, ABS(-1);

-- 2. 반올림 구하는 함수 : round(데이터 [, 반올림자릿수]) //반올림자릿수가 -1면 1의 자리 숫자에서 반올림
SELECT ROUND(12.345), ROUND(12.345, -1);

-- 3. 지정한 자리수 이하 버리는 함수 : truncate()
SELECT TRUNCATE(12.345, -1);

-- 4. 나누고 난 나머지 값 연산 함수 : mod()
-- 모듈러스 연산자, % 표기로 연산
SELECT 10 % 3, MOD(10, 3);

-- 5. ? emp table에서 사번이 홀수인 사원의 이름, 사번 검색 
SELECT ename, empno
FROM emp
WHERE MOD(empno, 2) != 0;

-- 6. 제곱수 구하는 함수 : power()
SELECT POWER(4, 3);

-- *** [문자함수] ***
-- 1. 문자열 길이 체크함수 : length() / char_length()
-- mysql 기본 영어 1byte, 한글은 3byte(euckr)
SELECT LENGTH('ABC'), LENGTH('가나다');
SELECT CHAR_LENGTH('ABC'), CHAR_LENGTH('가나다');

-- 2. byte 수 체크 함수 : length()

-- 3. 문자열 일부 추출 함수 : substr(), substring()
-- 서브스트링 : 하나의 문자열에서 일부 언어 발췌하는 로직의 표현
-- substr(데이터, 시작위치, 추출할 개수)
SELECT SUBSTRING('ABCED', 2, 3);

-- 4. ? 년도 구분없이 2월에 입사한 사원이름, 입사일 검색
-- 1980-12-17 00:00:00
SELECT ename, hiredate
FROM emp
WHERE SUBSTRING(hiredate, 6, 2) = '02';

-- 5. 문자열 앞뒤의 잉여 여백 제거 함수 : trim()
SELECT CHAR_LENGTH(TRIM('MYSQL '));
SELECT CHAR_LENGTH(RTRIM('MYSQL '));
SELECT CHAR_LENGTH(LTRIM(' MYSQL'));

-- *** [날짜 함수] ***
-- 1. ?어제, 오늘, 내일 날짜 검색 
SELECT NOW();
SELECT CURRENT_TIMESTAMP();
-- 쿼리 시작 시각 : 로그, created_at, updated_at
SELECT NOW(), SLEEP(2), NOW();

SELECT SYSDATE();
-- 함수 실행 시각 : 현재 서버 상태 체크
SELECT SYSDATE(), SLEEP(2), SYSDATE();

-- 뒷부분에서 진행하기
-- 2.?emp table에서 근무일수 계산하기, 사번과 근무일수(반올림) 검색

-- 3. 특정 개월수 더하는 함수 : date_add(), date_sub()
-- 6개월 이후 검색 
-- YEAR, MONTH, DAY, HOUR, MINUTES, SECONDS
SELECT NOW(), DATE_ADD(NOW(), INTERVAL 6 MONTH);

-- 4. ? 입사일 이후 3개월 지난 일수 검색
SELECT ename, hiredate, DATE_ADD(hiredate, INTERVAL 3 MONTH)
FROM emp;

-- 5. 두 날짜 사이의 개월수 검색 : datediff(day1, day2), timediff(time1, time2), timestampdiff(unit, datetime1, datetime2)
-- 오늘을 기준으로 2016-09-19
-- 결과 앞 기준 - 뒷 기준 날짜 
SELECT DATEDIFF('2016-09-19', CURDATE());
SELECT TIMEDIFF('12:00:00', '08:30:00');
SELECT TIMESTAMPDIFF(MONTH, NOW(), hiredate)
FROM emp;

-- ? emp table에서 근무일수 계산하기, 사번과 근무일수(반올림) 검색
SELECT DATEDIFF(CURDATE(), hiredate)
FROM emp;

-- 6. 주어진 날짜를 기준으로 해당 달의 가장 마지막 날짜 : last_day()
SELECT LAST_DAY('2016-09-19');

-- Date vs Datetime
-- Date : '2026-02-04' -> '2026-02-04 00:00:00'
-- Datetime : '2026-02-04 시:분:초'

-- DATEDIFF : 시간 버리고 날짜만 비교
SELECT
	DATEDIFF('2026-02-05 00:00:00', '2026-02-04 23:59:59'),
    DATEDIFF('2026-02-05 15:00:00', '2026-02-04 13:00:01');

-- TIMESTAMPDIFF
SELECT
	TIMESTAMPDIFF(DAY, '2026-02-05 00:00:00', 
						'2026-02-04 23:59:59');

-- WHERE hiredate >= CURDATE();
-- 어제 23:59 입사, 오늘 23:59 입사, 오늘 00:01 입사 

-- WHERE hiredate = '2026-02-04' (x)
-- WHERE hiredate >= '2026-02-04' AND hiredate < '2026-02-05'

-- *** [형변환 함수] ***
SELECT '123' + 1;
SELECT 'abc' + 1;
SELECT 'abc123' + 1;
SELECT '123abc' + 1;

-- 사용 빈도가 높음
-- [1] date_format : 날짜 -> 문자
-- [2] str_to_date : 날짜로 변경 시키는 함수
-- [3] cast : 변환
	
-- [1] date_format(date, format)
-- 1. 오늘 날짜를 'yyyy-mm-dd' 변환 
SELECT DATE_FORMAT(NOW(), '%Y/%m/%d');

-- [2] str_to_date(str, format)
SELECT STR_TO_DATE('20261123', '%Y%m%d');

-- %Y/%m/%d
/*
%Y	년도 - Year(4자리 표기)
%y	년도 (뒤에 2자리 표기)
%M	월 - 월 이름(January ~ December)
%m	월 - 월 숫자(00 ~ 12)
%d	일(00 ~ 31)
%H	시간 24시간(00 ~ 23)
%h	시간 12시간(00 ~ 12)
%i	분 (00 ~ 59)
%s	초 (00 ~ 59)
*/

-- 3. 숫자를 문자형으로 변환 : cast, convert
-- cast(값 as 데이터형식[길이])
-- 문자 -> 숫자
SELECT CAST('123' AS UNSIGNED);
SELECT CAST('123.456' AS DECIMAL(10, 2));

-- 문자 -> 날짜
SELECT CAST('20260204' AS DATETIME);

-- 날짜 -> 문자
SELECT CAST(NOW() AS CHAR);

-- convert(변환하고싶은 데이터, 데이터형식[(길이)])​

/* 
BINARY 		-- 이진 데이터 
CHAR 		-- 문자열 타입 
DATA 		-- 날짜 
DATATIME 	-- 날짜, 시간 동시에 
DECIMAL 	-- 소수점 까지 
JSON 		-- JSON 타입 SIGEND 
INTEGER 	-- 부호 (음수,양수) 있는 정수형 
TIME 		-- 시간 UNSIGNED INTEGER 양수만 정수형
*/

-- str_to_date() : 날짜로 변경 시키는 함수

-- DQL Group, Function

/* 기본 문법
1. select절
2. from 절
3. where절

 * 그룹함수시 사용되는 문법
1. select절 : 검색하고자 하는 속성
2. from절	: 검색 table
3. group by 절 : 특정 조건별 그룹화하고자 하는 속성
4. having 절 : 그룹함수 사용시 조건절
5. order by절 : 검색된 데이터를 정렬

* 실행 순서
*/

-- 1. count() : 개수 확인 함수
-- emp table의 직원이 몇명?

-- ? comm 받는 직원 수만 검색 

-- 2. sum() : 합계 함수
-- ? 모든 사원의 월급여(sal)의 합

-- ? 모든 직원이 받는 comm 합

-- ?  MANAGER인 직원들의  월급여의 합 

-- ? job 종류 counting[절대 중복 불가 = distinct]
-- 데이터 job 확인

-- 3. avg() : 평균
-- ? emp table의 모든 직원들의 급여 평균 검색

-- ? 커미션 받는 사원수, 총 커미션 합, 평균 구하기

-- 4. max(), min() : 최대값, 최소값
-- 숫자, date 타입에 사용 가능

-- 최대 급여, 최소 급여 검색

-- ? 최근 입사한 사원의 입사일과, 가장 오래된 사원의 입사일 검색
-- max(), min() 함수 사용해 보기

-- 오늘로부터 입사한지 가장 오래된 일수 계산?

/* group by절
- 특정 컬럼값을 기준으로 그룹화
	가령, 10번 부서끼리, 20번 부서끼리..
*/

-- 부서별 커미션 받는 사원수 
-- ? 부서별(group by deptno) (월급여) 평균 구함(avg())

-- ? 소속 부서별 급여 총액과 평균 급여 검색[deptno 오름차순 정렬]

-- ? 소속 부서별 최대 급여와 최소 급여 검색[deptno 오름차순 정렬]
-- 컬럼명 별칭에 여백 포함한 문구를 사용하기 위해서는 쌍따옴표로만 처리

-- *** having절 *** [ 조건을 주고 검색하기 ]
-- 그룹함수 사용시 조건문
-- 1. ? 부서별(group by) 사원의 수(count(*))와 커미션(count(comm)) 받는 사원의 수


-- 조건 추가
-- 2. ? 부서별 그룹을 지은후(group by deptno), 
-- 부서별 평균 급여(avg())가 2000 이상인 부서의 번호와 평균 급여 검색 

-- 3. 부서별 급여중 최대값(max)과 최소값(min)을 구하되 최대 급여가 2900이상(having)인 부서만 출력
