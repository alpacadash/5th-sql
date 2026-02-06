USE scott;

-- 외래키 체크 일시 중지 (삭제 시 오류 방지)
SET FOREIGN_KEY_CHECKS = 0;

-- 기존 테이블 삭제 (인덱스는 테이블 삭제 시 함께 삭제됨)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menus;
DROP TABLE IF EXISTS restaurants;

-- 외래키 체크 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;

-- 1. 음식점 테이블
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    min_order_amount INT DEFAULT 0,
    delivery_fee INT DEFAULT 0,
    business_hours VARCHAR(100),
    rating DECIMAL(2,1) DEFAULT 0.0,
    status ENUM('open', 'closed', 'break') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_status (status)
);

-- 2. 메뉴 테이블
CREATE TABLE menus (
    menu_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price INT NOT NULL,
    image_url VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,
    is_popular BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_menus_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES restaurants(restaurant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_restaurant (restaurant_id),
    INDEX idx_available (is_available),
    INDEX idx_popular (is_popular)
);

-- 3. 주문 테이블
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    restaurant_id INT NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    address_detail VARCHAR(255),
    request_note TEXT,
    menu_total INT NOT NULL,
    delivery_fee INT DEFAULT 0,
    total_amount INT NOT NULL,
    payment_method ENUM('card', 'cash', 'point') NOT NULL,
    order_status ENUM('pending', 'accepted', 'cooking', 'ready', 'delivering', 'completed', 'cancelled') DEFAULT 'pending',
    ordered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    accepted_at TIMESTAMP NULL,
    cooking_started_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    CONSTRAINT fk_orders_restaurant FOREIGN KEY (restaurant_id) 
        REFERENCES restaurants(restaurant_id),
    INDEX idx_restaurant (restaurant_id),
    INDEX idx_customer_phone (customer_phone),
    INDEX idx_status (order_status),
    INDEX idx_ordered_at (ordered_at)
);

-- 4. 주문 상세 테이블
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    menu_id INT NOT NULL,
    menu_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    unit_price INT NOT NULL,
    options VARCHAR(255),
    subtotal INT NOT NULL,
    CONSTRAINT fk_items_order FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_items_menu FOREIGN KEY (menu_id) 
        REFERENCES menus(menu_id),
    INDEX idx_order (order_id),
    INDEX idx_menu (menu_id)
);

-- 데이터 삽입 (음식점)
INSERT INTO restaurants (name, category, phone, address, min_order_amount, delivery_fee, business_hours, status) VALUES 
('교촌치킨 홍대점', '치킨', '02-337-8282', '서울시 마포구 와우산로29길 14', 15000, 3000, '10:00-23:00', 'open'),
('피자헛 강남점', '피자', '02-568-9900', '서울시 강남구 테헤란로 123', 20000, 4000, '11:00-22:00', 'open'),
('진짜맛있는중국집', '중식', '02-442-7733', '서울시 송파구 올림픽로 35', 12000, 2500, '11:30-21:30', 'closed');

-- 데이터 삽입 (메뉴)
INSERT INTO menus (restaurant_id, name, description, price, image_url, is_available, is_popular) VALUES 
(1, '후라이드치킨', '바삭하고 담백한 오리지널 후라이드', 18000, '/images/menus/fried_chicken.jpg', TRUE, TRUE),
(1, '양념치킨', '달콤 매콤한 시그니처 양념치킨', 19000, '/images/menus/yangnyeom_chicken.jpg', TRUE, TRUE),
(1, '반반치킨', '후라이드와 양념을 한번에', 19000, '/images/menus/half_chicken.jpg', TRUE, FALSE),
(1, '콜라 1.25L', '시원한 코카콜라', 2000, '/images/menus/cola.jpg', TRUE, FALSE),
(1, '치즈볼', '모짜렐라 치즈볼', 5000, '/images/menus/cheese_ball.jpg', FALSE, FALSE);

-- 데이터 삽입 (주문)
INSERT INTO orders (order_number, restaurant_id, customer_name, customer_phone, delivery_address, address_detail, request_note, menu_total, delivery_fee, total_amount, payment_method, order_status, ordered_at, accepted_at, cooking_started_at) VALUES 
('20250205-184533-5001', 1, '김민준', '010-3847-2910', '서울시 강남구 테헤란로 231', '501호', '수저 많이 주세요', 38000, 3000, 41000, 'card', 'cooking', '2025-02-05 18:45:33', '2025-02-05 18:46:10', '2025-02-05 18:46:15'),
('20250205-193020-5002', 1, '이서연', '010-9234-5671', '서울시 마포구 와우산로 94', '201호', '양파 빼주세요', 24000, 3000, 27000, 'cash', 'pending', '2025-02-05 19:30:20', NULL, NULL);

-- 데이터 삽입 (주문 상세)
INSERT INTO order_items (order_id, menu_id, menu_name, quantity, unit_price, options, subtotal) VALUES 
(1, 1, '후라이드치킨', 2, 18000, '순살로 변경', 36000),
(1, 4, '콜라 1.25L', 2, 2000, NULL, 4000),
(2, 2, '양념치킨', 1, 19000, '맵기 1단계', 19000),
(2, 5, '치즈볼', 1, 5000, NULL, 5000);

COMMIT;