/* NORMALISATION
1. Create date table 
1a. Table stage */
CREATE TABLE date_dim (
	date_key DATE PRIMARY KEY,
	day_of_week VARCHAR(10),
	day_of_month TINYINT,
	month_num TINYINT,
	year_num SMALLINT,
	is_weekend BOOLEAN);

-- 1b. Creating sequence --
INSERT IGNORE INTO date_dim(date_key)
-- (b)Add continuous range (using first date in records) from integers sequence --
SELECT
	DATE_ADD('2016-01-01', INTERVAL (rn - 1) DAY) AS date_key
FROM (
-- (b)Create sequence of integers with window function --
	SELECT
		ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
	FROM orders
-- (b)Using only static dates in records for analysis --
	LIMIT 1093) AS seq;

-- 1c. Generate descriptive values to populate other columns  --
UPDATE date_dim 
SET 
    day_of_week = DAYNAME(date_key),
    day_of_month = DAY(date_key),
    month_num = MONTH(date_key),
    year_num = YEAR(date_key),
    is_weekend = DAYOFWEEK(date_key) IN (1 , 7);
    
-- 1d. Create foreign-key columns in original date source table (orders)
ALTER TABLE clean.orders
	ADD COLUMN order_date_key DATE,
	ADD COLUMN required_date_key DATE,
	ADD COLUMN shipped_date_key DATE;

-- 1e. Populate orig. source table (orders) foreign-key columns from new date table key col --
UPDATE orders o
	LEFT JOIN date_dim d1 ON o.order_date = d1.date_key
	LEFT JOIN date_dim d2 ON o.required_date = d2.date_key
	LEFT JOIN date_dim d3 ON o.shipped_date = d3.date_key
SET
  o.order_date_key = d1.date_key,
  o.required_date_key = d2.date_key,
  o.shipped_date_key = d3.date_key;

-- 1f. Remove source date columns (orders)
ALTER TABLE orders
	DROP COLUMN order_date,
	DROP COLUMN required_date,
	DROP COLUMN shipped_date;
  
 /* 
 2. Create geography (dim) table 
 2a. Create table stage */
CREATE TABLE geo (
  geo_id INT AUTO_INCREMENT PRIMARY KEY,
  state CHAR(2),
  city VARCHAR(100) 
);

-- 2b. Populate geo table from source tables (customers, stores)
INSERT INTO geo (state, city)
SELECT DISTINCT state, city 
FROM customers
	UNION
SELECT DISTINCT state, city 
FROM stores;

-- 2c. Add geo_id column to customers, populate, drop source columns from customers table --
ALTER TABLE customers
  ADD COLUMN geo_id INT;

UPDATE customers AS c
	JOIN geo AS g USING (state, city) 
SET c.geo_id = g.geo_id;

ALTER TABLE customers
  DROP COLUMN state,
  DROP COLUMN city;

-- 2d. Add geo_id column to stores, populate, drop source columns from stores table --
ALTER TABLE stores
  ADD COLUMN geo_id INT;

UPDATE stores AS s
	JOIN geo AS g USING (state, city)
SET s.geo_id = g.geo_id;

ALTER TABLE stores
  DROP COLUMN state,
  DROP COLUMN city;

/*
3. Create Order_Status (dim) table
3a. Create table staging */
CREATE TABLE order_status_dim (
  status_id   INT AUTO_INCREMENT PRIMARY KEY,
  status_name VARCHAR(30));

-- 3b. Inserted string values to match ranking in source table (orders)
INSERT INTO order_status_dim (status_name) VALUES
  ('Pending'),
  ('Processing'),
  ('Shipped'),
  ('Delivered');

-- 3c. changed source col (order_staus)in source table (orders) to id col
ALTER TABLE clean.orders
  RENAME COLUMN order_status TO status_id;





























