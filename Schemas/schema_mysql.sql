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
