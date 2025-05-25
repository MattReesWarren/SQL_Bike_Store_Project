/* LOAD 'clean' schema
 1. Create staging */

CREATE SCHEMA IF NOT EXISTS clean;

-- Brands
CREATE TABLE clean.brands (
    brand_id INT,
    brand_name VARCHAR(255)
);

-- Categories
CREATE TABLE clean.categories (
    category_id INT,
    category_name VARCHAR(255)
);

-- Customers
CREATE TABLE clean.customers (
    customer_id INT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20)
);

-- Order Items
CREATE TABLE clean.order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price DECIMAL(10 , 2 ),
    discount DECIMAL(10 , 2 )
);

-- Orders
CREATE TABLE clean.orders (
    order_id INT,
    customer_id INT,
    order_status SMALLINT,
    order_date VARCHAR(10),
    required_date VARCHAR(10),
    shipped_date VARCHAR(10),
    store_id INT,
    staff_id INT
);

-- Products
CREATE TABLE clean.products (
    product_id INT,
    product_name VARCHAR(255),
    brand_id INT,
    category_id INT,
    model_year SMALLINT,
    list_price DECIMAL(10 , 2 )
);

-- Staffs
CREATE TABLE clean.staffs (
    staff_id INT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(20),
    active_staff BOOLEAN,
    store_id INT,
    manager_id INT
);

-- Stocks
CREATE TABLE clean.stocks (
    store_id INT,
    product_id INT,
    quantity INT
);

-- Stores
CREATE TABLE clean.stores (
    store_id INT,
    store_name VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20)
);

/* 2. Restructing for project context */

ALTER TABLE clean.customers
	DROP COLUMN phone,
	DROP COLUMN email,
	DROP COLUMN street,
	DROP COLUMN zip_code;

ALTER TABLE clean.staffs
	DROP COLUMN email,
	DROP COLUMN phone,
	DROP COLUMN active_staff;

ALTER TABLE clean.stores
	DROP COLUMN phone,
	DROP COLUMN email,
	DROP COLUMN street,
	DROP COLUMN zip_code;