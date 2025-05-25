CREATE SCHEMA IF NOT EXISTS raw;

-- Brands
CREATE TABLE raw.brands (
    brand_id TEXT,
    brand_name TEXT
);

-- Categories
CREATE TABLE raw.categories (
    category_id TEXT,
    category_name TEXT
);

-- Customers
CREATE TABLE raw.customers (
    customer_id TEXT,
    first_name TEXT,
    last_name TEXT,
    phone TEXT,
    email TEXT,
    street TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT
);

-- Order Items
CREATE TABLE raw.order_items (
    order_id TEXT,
    item_id TEXT,
    product_id TEXT,
    quantity TEXT,
    list_price TEXT,
    discount TEXT
);

-- Orders
CREATE TABLE raw.orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_date TEXT,
    required_date TEXT,
    shipped_date TEXT,
    store_id TEXT,
    staff_id TEXT
);

-- Products
CREATE TABLE raw.products (
    product_id TEXT,
    product_name TEXT,
    brand_id TEXT,
    category_id TEXT,
    model_year TEXT,
    list_price TEXT
);

-- Staffs
CREATE TABLE raw.staffs (
    staff_id TEXT,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone TEXT,
    active TEXT,
    store_id TEXT,
    manager_id TEXT
);

-- Stocks
CREATE TABLE raw.stocks (
    store_id TEXT,
    product_id TEXT,
    quantity TEXT
);

-- Stores
CREATE TABLE raw.stores (
    store_id TEXT,
    store_name TEXT,
    phone TEXT,
    email TEXT,
    street TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT
);