CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    NAME VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

DELIMITER //
CREATE TRIGGER before_insert_order_items
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE product_price DECIMAL(10,2);

    SELECT price INTO product_price
    FROM products
    WHERE id = NEW.product_id;

    IF NEW.subtotal <> (product_price * NEW.quantity) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El subtotal no coincide con Precio * Cantidad';
    END IF;
END;
//

CREATE TRIGGER before_update_order_items
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
    DECLARE product_price DECIMAL(10,2);

    SELECT price INTO product_price
    FROM products
    WHERE id = NEW.product_id;

    IF NEW.subtotal <> (product_price * NEW.quantity) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El subtotal no coincide con Precio * Cantidad';
    END IF;
END;
//
DELIMITER ;

INSERT INTO categories (NAME) VALUES
('Electrónica'),
('Hogar'),
('Deportes'),
('Libros'),
('Oficina');

INSERT INTO products (NAME, price, category_id) VALUES
('Laptop', 10.00, 1),
('Silla', 20.00, 2),
('Balón', 30.00, 3),
('Novela', 40.00, 4),
('Escritorio', 50.00, 5);

INSERT INTO users (username, email) VALUES
('user1', 'user1@example.com'),
('user2', 'user2@example.com'),
('user3', 'user3@example.com'),
('user4', 'user4@example.com'),
('user5', 'user5@example.com');

INSERT INTO orders (user_id) VALUES
(1),
(2),
(3),
(4),
(5);

INSERT INTO order_items (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 1, 10.00),
(2, 2, 2, 40.00),
(3, 3, 3, 90.00),
(4, 4, 4, 160.00),
(5, 5, 5, 250.00);

SELECT
    c.id,
    c.NAME AS category,
    COALESCE(SUM(oi.subtotal), 0) AS total_sold
FROM categories c
JOIN products p ON p.category_id = c.id
JOIN order_items oi ON oi.product_id = p.id
GROUP BY c.id, c.NAME
ORDER BY c.id;

DELIMITER //
CREATE PROCEDURE demo_invalid_order_item()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error: El subtotal no coincide con Precio * Cantidad' AS trigger_result;
    END;

    INSERT INTO order_items (order_id, product_id, quantity, subtotal)
    VALUES (1, 1, 2, 15.00);
END;
//
DELIMITER ;

CALL demo_invalid_order_item();
DROP PROCEDURE IF EXISTS demo_invalid_order_item;