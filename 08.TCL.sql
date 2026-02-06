-- TCL
-- 1 ON, 0 OFF
SELECT @@autocommit;
SET @@autocommit = 0;

-- 실습 테이블 생성 및 데이터 초기화
CREATE DATABASE IF NOT EXISTS tcl_study;
USE tcl_study;

-- 1. 계좌 테이블
CREATE TABLE IF NOT EXISTS accounts (
    id INT PRIMARY KEY,
    name VARCHAR(20),
    balance INT
);

-- 2. 상품 테이블
CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    stock INT,
    price INT
);

-- 3. 주문 테이블
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(50)
);

-- 초기 데이터
TRUNCATE accounts;
TRUNCATE products;
TRUNCATE orders;

INSERT INTO accounts VALUES (1, 'Java', 100000), (2, 'DB', 50000);
INSERT INTO products VALUES (1, '노트북', 10, 1500000), (2, '마우스', 20, 30000);

COMMIT;

-- *** COMMIT, ROLLBACK ***
-- Auto-Commit 상태 확인 (1: ON / 0: OFF)

-- 정상적인 상품 가격 변경 (COMMIT)(products)
-- product_id = 1, 1600000으로 변경

UPDATE products
SET price = 1600000
WHERE id = 1;

SELECT * FROM products;
COMMIT;
-- 실수로 모든 상품 가격을 0원으로 변경(ROLLBACK)
-- 시나리오: 실수로 모든 상품 가격을 0원으로 변경함
UPDATE products
SET price = 0;

ROLLBACK;

-- 실수! WHERE 조건 없이 UPDATE 실행

-- 확인해보니 모든 상품이 0원이 됨

-- 취소! 원래대로 복구

-- 확인: 모든 데이터가 원래대로 복구됨

--
-- 송금 중 시스템 오류 발생 (ROLLBACK)(accounts)
START TRANSACTION;


-- Java(1)가 DB(2)에게 5만원 송금 시도
-- (시스템 오류로 DB 입금 쿼리 실행 실패 가정)
UPDATE accounts
SET balance = balance - 50000
WHERE id = 1;

ROLLBACK;

COMMIT;

SELECT * FROM accounts;
--
-- *** SAVEPOINT ***
-- 저장점 생성 : SAVEPOINT 저장점이름;
-- 특정 저장점으로 되돌리기 : ROLLBACK TO SAVEPOINT 저장점이름; 또는 ROLLBACK TO 저장점이름;
-- 저장점 삭제 : RELEASE SAVEPOINT 저장점이름;
START TRANSACTION;

-- 주문 중 옵션 상품 변경(orders)
-- 기본 상품(스마트폰) 추가 
INSERT INTO orders(item_name) VALUES ('스마트폰');
SAVEPOINT orders_base;
-- 사은품(케이스) 추가
INSERT INTO orders(item_name) VALUES ('케이스');

SELECT * FROM orders;

-- *** 데이터 잠금 (LOCK) ***
-- 공유 락 (Shared Lock / S-Lock): 읽기 허용, 수정 불가
-- 다른 세션에서 테스트
START TRANSACTION;

SELECT stock FROM products
WHERE id = 1 FOR SHARE;


SELECT SLEEP (20);

COMMIT;
-- 배타 락 (Exclusive Lock / X-Lock): 읽기/수정 모두 대기

-- 데드락 (Deadlock)
-- 두 개 이상의 트랜잭션이 서로가 보유한 락을 기다리면서 영원히 진행되지 않는 상태

-- 데드락 발생 예시
-- 트랜잭션 A: '노트북' 락 획득 → '마우스' 락 대기
-- 트랜잭션 B: '마우스' 락 획득 → '노트북' 락 대기

CREATE TABLE items (id INT PRIMARY KEY, name VARCHAR(50));
INSERT INTO items VALUES (1, '노트북'), (2, '마우스');

-- 사은품 마음 변심으로 취소
ROLLBACK TO orders_base;

-- 새로운 사은품(보조배터리) 추가 후 확정
INSERT INTO orders(item_name) VALUES ('보조배터리');
COMMIT;