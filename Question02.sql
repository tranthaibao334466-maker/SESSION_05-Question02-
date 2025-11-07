CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	category VARCHAR(50)
);

CREATE TABLE orders(
	id SERIAL PRIMARY KEY,
	product_id INT REFERENCES products(id),
	quantity INT,
	total_price NUMERIC(10,2)
);

INSERT INTO products (name,category) VALUES
('Laptop Dell', 'Electronics'),
('IPhone 15', 'Electronics'),
('Bàn học gỗ', 'Furniture'),
('Ghế xoay', 'Furniture');

INSERT INTO orders(product_id,quantity,total_price) VALUES
(1,2,2200),
(2,3,3300),
(3,5,2500),
(4,4,1600),
(1,1,1100);
SELECT * FROM products;
SELECT * FROM orders; 

-- Thống kê doanh thu cho mỗi sản phẩm 
SELECT product_id, SUM(total_price) AS total_revenue
FROM orders GROUP BY product_id ORDER BY product_id;

-- Tìm ra sản phẩm có doanh thu cao nhất 
SELECT product_id, SUM(total_price) AS total_revenue
FROM orders GROUP BY product_id 
ORDER BY SUM(total_price) DESC, product_id ASC LIMIT 1; -- Nếu hai sản phẩm cùng total_revenue thì sắp xếp theo mã sản phẩm 

-- Thống kê tổng doanh thu theo từng nhóm 
SELECT p.category "Danh mục", SUM(o.total_price) AS "Tổng doanh thu"
FROM products as p
JOIN orders as o 
ON p.id = o.product_id 
GROUP BY p.category; 
	
-- Tìm nhóm category có sản phẩm bán chạy nhất và tổng doanh thu lớn hơn 3000
    -- Tìm nhóm có tổng doanh thu các sản phẩm lớn hơn 3000 
	SELECT p.category "Danh mục"
	FROM products as p 
	JOIN orders as o 
	ON p.id = o.product_id 
	GROUP BY p.category HAVING SUM(o.total_price) > 3000
	
	INTERSECT 
	-- Tìm nhóm có sản phẩm bán chạy nhất 
	SELECT p.category "Danh mục"
	FROM products as p
	JOIN orders as o 
	ON p.id = o.product_id 
	GROUP BY p.category HAVING SUM(o.total_price) >= ALL(SELECT SUM(o.total_price) FROM orders GROUP BY product_id )
