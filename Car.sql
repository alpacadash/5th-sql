DROP DATABASE IF EXISTS car_eer;
CREATE DATABASE car_eer;
USE car_eer;

CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE car (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE mechanic (
    mechanic_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE service (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_date DATE,
    car_id INT NOT NULL,
    mechanic_id INT NOT NULL,
    FOREIGN KEY (car_id) REFERENCES car(car_id),
    FOREIGN KEY (mechanic_id) REFERENCES mechanic(mechanic_id)
);
