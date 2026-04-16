-- ============================================================
-- Домашнє завдання: Нормалізація БД (1НФ → 2НФ → 3НФ)
-- Схема відповідає результату третьої нормальної форми (3НФ)
-- ============================================================

DROP DATABASE IF EXISTS orders_db;
CREATE DATABASE orders_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE orders_db;

-- ------------------------------------------------------------
-- Таблиця: clients (Клієнти)
-- Виділена з замовлень для усунення транзитивної залежності
-- (адреса залежала від клієнта, а не від замовлення — 3НФ)
-- ------------------------------------------------------------
CREATE TABLE clients (
    client_id   INT             NOT NULL AUTO_INCREMENT,
    client_name VARCHAR(100)    NOT NULL,
    client_address VARCHAR(255) NOT NULL,
    PRIMARY KEY (client_id)
);

-- ------------------------------------------------------------
-- Таблиця: products (Товари)
-- Виділена для усунення повторення назви товару у order_items
-- ------------------------------------------------------------
CREATE TABLE products (
    product_id   INT          NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (product_id)
);

-- ------------------------------------------------------------
-- Таблиця: orders (Замовлення)
-- Замовлення пов'язане з клієнтом через client_id (FK)
-- ------------------------------------------------------------
CREATE TABLE orders (
    order_id   INT  NOT NULL,
    client_id  INT  NOT NULL,
    order_date DATE NOT NULL,
    PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_client
        FOREIGN KEY (client_id) REFERENCES clients (client_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- Таблиця: order_items (Позиції замовлення)
-- Зв'язок M:N між orders і products через цю таблицю
-- ------------------------------------------------------------
CREATE TABLE order_items (
    item_id    INT NOT NULL AUTO_INCREMENT,
    order_id   INT NOT NULL,
    product_id INT NOT NULL,
    quantity   INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (item_id),
    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id) REFERENCES orders (order_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ============================================================
-- Тестові дані з початкової таблиці завдання
-- ============================================================

INSERT INTO clients (client_name, client_address) VALUES
    ('Мельник',   'Хрещатик 1'),
    ('Шевченко',  'Басейна 2'),
    ('Коваленко', 'Комп\'ютерна 3');

INSERT INTO products (product_name) VALUES
    ('Лептоп'),
    ('Мишка'),
    ('Принтер');

INSERT INTO orders (order_id, client_id, order_date) VALUES
    (101, 1, '2023-03-15'),
    (102, 2, '2023-03-16'),
    (103, 3, '2023-03-17');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (101, 1, 3),   -- Замовлення 101: Лептоп x3
    (101, 2, 2),   -- Замовлення 101: Мишка  x2
    (102, 3, 1),   -- Замовлення 102: Принтер x1
    (103, 2, 4);   -- Замовлення 103: Мишка  x4
