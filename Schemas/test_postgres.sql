TRUNCATE TABLE order_items, orders, products, categories, users RESTART IDENTITY CASCADE;

INSERT INTO categories ("NAME") VALUES
('Electrónica'),
('Hogar'),
('Deportes'),
('Libros'),
('Oficina');

INSERT INTO products ("NAME", price, category_id) VALUES
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
    c."NAME" AS category,
    COALESCE(SUM(oi.subtotal), 0) AS total_sold
FROM categories c
JOIN products p ON p.category_id = c.id
JOIN order_items oi ON oi.product_id = p.id
GROUP BY c.id, c."NAME"
ORDER BY c.id;

-- Prueba de trigger: este INSERT debe fallar con el mensaje esperado
INSERT INTO order_items (order_id, product_id, quantity, subtotal)
VALUES (1, 1, 2, 15.00);