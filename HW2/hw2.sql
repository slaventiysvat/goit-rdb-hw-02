-- ============================================================
-- HW2 — Northwind Database
-- ============================================================
DROP DATABASE IF EXISTS northwind;
CREATE DATABASE northwind CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE northwind;

-- ------------------------------------------------------------
-- DDL — Створення таблиць
-- ------------------------------------------------------------

CREATE TABLE categories (
    id          INT          NOT NULL,
    name        VARCHAR(100) NOT NULL,
    description TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE suppliers (
    id          INT          NOT NULL,
    name        VARCHAR(100) NOT NULL,
    contact     VARCHAR(100),
    address     VARCHAR(255),
    city        VARCHAR(100),
    postal_code VARCHAR(20),
    country     VARCHAR(100),
    phone       VARCHAR(50),
    PRIMARY KEY (id)
);

CREATE TABLE shippers (
    id    INT         NOT NULL,
    name  VARCHAR(100) NOT NULL,
    phone VARCHAR(50),
    PRIMARY KEY (id)
);

CREATE TABLE customers (
    id          INT          NOT NULL,
    name        VARCHAR(100) NOT NULL,
    contact     VARCHAR(100),
    address     VARCHAR(255),
    city        VARCHAR(100),
    postal_code VARCHAR(20),
    country     VARCHAR(100),
    PRIMARY KEY (id)
);

CREATE TABLE employees (
    employee_id INT          NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    first_name  VARCHAR(50)  NOT NULL,
    birthdate   DATE,
    photo       VARCHAR(255),
    notes       TEXT,
    PRIMARY KEY (employee_id)
);

CREATE TABLE products (
    id          INT            NOT NULL,
    name        VARCHAR(100)   NOT NULL,
    supplier_id INT,
    category_id INT,
    unit        VARCHAR(100),
    price       DECIMAL(10, 2) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_products_supplier
        FOREIGN KEY (supplier_id) REFERENCES suppliers (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories (id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE orders (
    id          INT  NOT NULL,
    customer_id INT,
    employee_id INT,
    date        DATE,
    shipper_id  INT,
    PRIMARY KEY (id),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers (id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_orders_employee
        FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_orders_shipper
        FOREIGN KEY (shipper_id) REFERENCES shippers (id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE order_details (
    id         INT NOT NULL,
    order_id   INT NOT NULL,
    product_id INT NOT NULL,
    quantity   INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    CONSTRAINT fk_od_order
        FOREIGN KEY (order_id) REFERENCES orders (id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_od_product
        FOREIGN KEY (product_id) REFERENCES products (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ============================================================
-- Завдання 1
-- Вибрати всі стовпчики з таблиці products (wildcard *)
-- Вибрати тільки стовпчики name, phone з таблиці shippers
-- ============================================================

SELECT * FROM products;

SELECT name, phone FROM shippers;

-- ============================================================
-- Завдання 2
-- Знайти середнє, максимальне та мінімальне значення
-- стовпчика price таблиці products
-- ============================================================

SELECT
    AVG(price)  AS avg_price,
    MAX(price)  AS max_price,
    MIN(price)  AS min_price
FROM products;

-- ============================================================
-- Завдання 3
-- Унікальні значення category_id та price з таблиці products
-- Порядок: price DESC, вивести тільки 10 рядків
-- ============================================================

SELECT DISTINCT category_id, price
FROM products
ORDER BY price DESC
LIMIT 10;

-- ============================================================
-- Завдання 4
-- Кількість продуктів з ціною від 20 до 100
-- ============================================================

SELECT COUNT(*) AS products_count
FROM products
WHERE price BETWEEN 20 AND 100;

-- ============================================================
-- Завдання 5
-- Кількість продуктів та середня ціна у кожного постачальника
-- ============================================================

SELECT
    supplier_id,
    COUNT(*)       AS products_count,
    AVG(price)     AS avg_price
FROM products
GROUP BY supplier_id;
