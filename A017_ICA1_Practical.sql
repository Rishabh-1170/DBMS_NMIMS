CREATE DATABASE inventory_mgmt;
USE inventory_mgmt;

CREATE TABLE suppliers(
supplier_id int PRIMARY KEY,
supplier_name varchar(30),
contact decimal(10,0) NOT NULL,
city varchar(30));

CREATE TABLE categories(
category_id int PRIMARY KEY,
catgeory_name varchar(30));

CREATE TABLE products(
prod_ID int PRIMARY KEY,
prod_name varchar(30),
category_id int,
supplier_id int,
price decimal(10,2) CHECK(price>0.01),
stock int,
FOREIGN KEY(category_id) REFERENCES categories(category_id),
FOREIGN KEY(supplier_id) REFERENCES suppliers(supplier_id));

CREATE TABLE purchases(
purchase_id int PRIMARY KEY,
prod_ID int,
quantity int,
purchase_date date,
supplier_id int,
FOREIGN KEY(prod_ID) REFERENCES products(prod_ID),
FOREIGN KEY(supplier_id) REFERENCES suppliers(supplier_id));

CREATE TABLE sales(
sale_id int PRIMARY KEY,
prod_ID int,
quantity int,
sale_date date,
customer_name varchar(30),
FOREIGN KEY(prod_ID) REFERENCES products(prod_ID));

INSERT INTO categories
VALUES
(1, 'Soaps'),
(2, 'Tshirts'),
(3, 'Shoes'),
(4, 'Stationery'),
(5, 'Bags');

INSERT INTO suppliers
VALUES
(1, 'Trader1', 9384728423, 'Mumbai'),
(2, 'Trader2', 9452374829, 'Pune'),
(3, 'Trader3', 7827472843, 'Nagpur'),
(4, 'Trader4', 8274829457, 'Mumbai'),
(5, 'Trader5', 7472847632, 'Nashik');
INSERT INTO suppliers VALUE(6, 'Trader6', 9287467285, 'Delhi');

INSERT INTO products
VALUES
(1, 'Soap1', 1, 1, 200, 5),
(2, 'Soap2', 1, 2, 100, 11),
(3, 'Tshirt1', 2, 1, 5000, 30),
(4, 'Shoes1', 3, 4, 1000, 25),
(5, 'Pencil1', 4, 3, 20, 100),
(6, 'Bag1', 5, 5, 1700, 8);

INSERT INTO purchases
VALUES
(1, 1, 6, '12-08-25',1),
(2, 2, 13, '12-08-25',2),
(3, 3, 34, '12-08-25',1),
(4, 4, 29, '12-08-25', 4),
(5, 5, 200, '12-08-25', 3),
(6, 6, 10, '12-08-25', 5);

INSERT INTO sales
VALUES
(1, 1, 1, '12-08-25', 'Mukesh'),
(2, 2, 2, '12-08-25', 'Gukesh'),
(3, 3, 4, '12-08-25', 'Mahesh'),
(4, 4, 4, '12-08-25', 'Lokesh'),
(5, 5, 100, '12-08-25', 'Mukesh'),
(6, 6, 2, '12-08-25', 'Suresh');

-- 1. --
SELECT * FROM products 
WHERE stock<10;

-- 2. --
SELECT * FROM products 
ORDER BY price DESC LIMIT 5;

-- 3. --
SELECT * FROM suppliers
WHERE city='Delhi';

-- 4. --
SELECT * FROM products
WHERE supplier_id='4';

-- 5. --
SELECT c.catgeory_name, COUNT(p.prod_ID) as product_count FROM categories c
LEFT JOIN products p on c.category_id = p.category_id
GROUP BY c.catgeory_name;

-- 6. --
SELECT quantity FROM purchases
WHERE prod_ID=5;

-- 7. --
SELECT * FROM sales
WHERE quantity=0;

-- 8. --
SELECT * from sales
WHERE sale_date in ('06-08-25','07-08-25','08-08-25','09-08-25','09-08-25','10-08-25','11-08-25','12-08-25');

-- 9. --
SELECT prod_ID from sales
WHERE quantity>50;

-- 10. --
SELECT supplier_id from purchases 
WHERE quantity>5;

-- 11. --
SELECT c.catgeory_name, AVG(p.price) as avg_price
FROM categories c
JOIN products p on c.category_id = p.category_id
GROUP BY c.catgeory_name;

-- 12. --
SELECT p.prod_ID, p.prod_name, SUM(s.quantity) as total_sold
FROM products p
JOIN sales s on p.prod_ID = s.prod_ID
GROUP BY p.prod_ID, p.prod_name
ORDER BY total_sold DESC
LIMIT 1;

-- 14. --
SELECT s.sale_id, p.prod_name, s.quantity, s.sale_date, s.customer_name
FROM sales s
JOIN products p on s.prod_ID = p.prod_ID;

-- 15. --
SELECT pu.purchase_id, p.prod_name, pu.quantity, pu.purchase_date, s.supplier_name
FROM purchases pu
JOIN products p on pu.prod_ID = p.prod_ID
JOIN suppliers s on pu.supplier_id = s.supplier_id;

-- 17. --
SELECT p.prod_ID, p.prod_name, MAX(pu.purchase_date) AS last_purchase_date
FROM products p
LEFT JOIN purchases pu ON p.prod_ID = pu.prod_ID
GROUP BY p.prod_ID , p.prod_name;

-- 18. -- 
SELECT customer_name, COUNT(prod_ID) AS products_bought
FROM sales
GROUP BY customer_name
HAVING COUNT(prod_ID) > 3;

-- 19. --
SELECT SUM(price * stock) AS total_stock_value
FROM products;

-- 20. --
SELECT * FROM products
ORDER BY stock DESC LIMIT 1;

-- 22. --
SELECT customer_name, SUM(p.price * s.quantity) AS total_spent
FROM sales s
JOIN products p ON s.prod_ID = p.prod_ID
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 3;

-- 23. --
SELECT sale_date, SUM(quantity), SUM(p.price * s.quantity) AS total_value
FROM sales s
JOIN products p ON s.prod_ID = p.prod_ID
GROUP BY sale_date
ORDER BY sale_date;

