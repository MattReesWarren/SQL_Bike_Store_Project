/* Model
1. Create new schema 'finalBK' and table/column structure*/

-- 1a. Disable foreign key checks for rebuild
SET FOREIGN_KEY_CHECKS=0;

-- 1b. Create finalBK schema
DROP SCHEMA IF EXISTS finalBK;
CREATE SCHEMA finalBK;
USE finalBK;

-- Set default storage engine for all tables
SET default_storage_engine=InnoDB;

-- 1c. Dimension tables (alphabetical order)

CREATE TABLE finalBK.brands (
  brand_id INT NOT NULL,
  brand_name VARCHAR(255) NOT NULL,
  PRIMARY KEY (brand_id)
);

CREATE TABLE finalBK.categories (
  category_id INT NOT NULL,
  category_name VARCHAR(255) NOT NULL,
  PRIMARY KEY (category_id)
);

CREATE TABLE finalBK.customers (
  customer_id INT NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  geo_id INT NOT NULL,
  PRIMARY KEY (customer_id),
  INDEX (geo_id),
  FOREIGN KEY (geo_id) REFERENCES finalBK.geo(geo_id)
);

CREATE TABLE finalBK.dates (
  date_key DATE NOT NULL,
  day_of_week VARCHAR(10) NOT NULL,
  day_of_month TINYINT NOT NULL,
  month_num TINYINT NOT NULL,
  year_num SMALLINT NOT NULL,
  is_weekend TINYINT(1) NOT NULL,
  PRIMARY KEY (date_key)
);

CREATE TABLE finalBK.geo (
  geo_id INT NOT NULL AUTO_INCREMENT,
  state CHAR(2) NOT NULL,
  city VARCHAR(100) NOT NULL,
  PRIMARY KEY (geo_id)
);

CREATE TABLE finalBK.order_status (
  status_id SMALLINT NOT NULL,
  status_name VARCHAR(30) NOT NULL,
  PRIMARY KEY (status_id)
);

CREATE TABLE finalBK.products (
  product_id INT NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  brand_id INT NOT NULL,
  category_id INT NOT NULL,
  model_year SMALLINT NOT NULL,
  list_price DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (product_id),
  INDEX (brand_id),
  INDEX (category_id),
  FOREIGN KEY (brand_id) REFERENCES finalBK.brands(brand_id),
  FOREIGN KEY (category_id) REFERENCES finalBK.categories(category_id)
);

CREATE TABLE finalBK.staff (
  staff_id INT NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  store_id INT NOT NULL,
  manager_id INT,
  PRIMARY KEY (staff_id),
  INDEX (store_id),
  INDEX (manager_id),
  FOREIGN KEY (store_id) REFERENCES finalBK.stores(store_id),
  FOREIGN KEY (manager_id) REFERENCES finalBK.staff(staff_id)
);

CREATE TABLE finalBK.stores (
  store_id INT NOT NULL,
  store_name VARCHAR(255) NOT NULL,
  geo_id INT NOT NULL,
  PRIMARY KEY (store_id),
  INDEX (geo_id),
  FOREIGN KEY (geo_id) REFERENCES finalBK.geo(geo_id)
);

-- 1d. Sales fact table: combine orders and order_items
CREATE TABLE finalBK.sales (
  order_id INT NOT NULL,
  item_id INT NOT NULL,
  order_date_key DATE NOT NULL,
  required_date_key DATE NOT NULL,
  shipped_date_key DATE,
  customer_id INT NOT NULL,
  store_id INT NOT NULL,
  staff_id INT NOT NULL,
  status_id SMALLINT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  list_price DECIMAL(10,2) NOT NULL,
  discount DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (order_id, item_id),
  INDEX (order_date_key),
  INDEX (customer_id),
  INDEX (store_id),
  INDEX (staff_id),
  INDEX (status_id),
  INDEX (product_id),
  FOREIGN KEY (order_date_key)    REFERENCES finalBK.dates(date_key),
  FOREIGN KEY (required_date_key) REFERENCES finalBK.dates(date_key),
  FOREIGN KEY (shipped_date_key)  REFERENCES finalBK.dates(date_key),
  FOREIGN KEY (customer_id)       REFERENCES finalBK.customers(customer_id),
  FOREIGN KEY (store_id)          REFERENCES finalBK.stores(store_id),
  FOREIGN KEY (staff_id)          REFERENCES finalBK.staff(staff_id),
  FOREIGN KEY (status_id)         REFERENCES finalBK.order_status(status_id),
  FOREIGN KEY (product_id)        REFERENCES finalBK.products(product_id)
);

-- 1e. Stocks fact table: inventory separate
CREATE TABLE finalBK.stocks (
  store_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  PRIMARY KEY (store_id, product_id),
  INDEX (product_id),
  FOREIGN KEY (store_id)   REFERENCES finalBK.stores(store_id),
  FOREIGN KEY (product_id) REFERENCES finalBK.products(product_id)
);

-- 2. Populate dimensions from clean schema
INSERT INTO finalBK.dates SELECT * FROM clean.date_dim;
INSERT INTO finalBK.geo SELECT * FROM clean.geo;
INSERT INTO finalBK.brands SELECT * FROM clean.brands;
INSERT INTO finalBK.categories SELECT * FROM clean.categories;
INSERT INTO finalBK.customers SELECT * FROM clean.customers;
INSERT INTO finalBK.stores SELECT * FROM clean.stores;
INSERT INTO finalBK.staff SELECT * FROM clean.staffs;
INSERT INTO finalBK.products SELECT * FROM clean.products;
INSERT INTO finalBK.order_status SELECT * FROM clean.order_status_dim;

-- 3. Populate sales from clean schema
INSERT INTO finalBK.sales (
  order_id, item_id, order_date_key, required_date_key, shipped_date_key,
  customer_id, store_id, staff_id, status_id, product_id, quantity, list_price, discount
)
SELECT
  o.order_id,
  oi.item_id,
  o.order_date_key,
  o.required_date_key,
  o.shipped_date_key,
  o.customer_id,
  o.store_id,
  o.staff_id,
  o.status_id,
  oi.product_id,
  oi.quantity,
  oi.list_price,
  oi.discount
FROM clean.orders AS o
JOIN clean.order_items AS oi ON o.order_id = oi.order_id;

-- 4. Populate stocks from clean schema
INSERT INTO finalBK.stocks
SELECT * FROM clean.stocks;
	
-- 5. Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS=1;
