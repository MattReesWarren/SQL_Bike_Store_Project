/* PROFILING on clean schema */

-- 1. Row counts --
SELECT 
    'brands' AS tbl, COUNT(*) AS row_count
FROM
    clean.brands
UNION ALL 
SELECT 
    'categories', COUNT(*)
FROM
    clean.categories
UNION ALL 
SELECT 
    'customers', COUNT(*)
FROM
    clean.customers
UNION ALL 
SELECT 
    'products', COUNT(*)
FROM
    clean.products
UNION ALL 
SELECT 
    'stores', COUNT(*)
FROM
    clean.stores
UNION ALL 
SELECT 
    'orders', COUNT(*)
FROM
    clean.orders
UNION ALL 
SELECT 
    'order_items', COUNT(*)
FROM
    clean.order_items
UNION ALL 
SELECT 
    'staffs', COUNT(*)
FROM
    clean.staffs
UNION ALL 
SELECT 
    'stocks', COUNT(*)
FROM
    clean.stocks;

-- 2.Key-based duplicate check (dimension & fact tables with key cols)--
SELECT 
    'brands' AS tbl,
    COUNT(*) - COUNT(DISTINCT brand_id) AS dup_count
FROM 
    clean.brands
UNION ALL 
SELECT 
    'categories', COUNT(*) - COUNT(DISTINCT category_id)
FROM 
    clean.categories
UNION ALL 
SELECT 
    'customers', COUNT(*) - COUNT(DISTINCT customer_id)
FROM
    clean.customers
UNION ALL 
SELECT 
    'order_items', COUNT(*) - COUNT(DISTINCT order_id, item_id)
FROM
    clean.order_items
UNION ALL 
SELECT 
    'orders', COUNT(*) - COUNT(DISTINCT order_id)
FROM
    clean.orders
UNION ALL 
SELECT 
    'products', COUNT(*) - COUNT(DISTINCT product_id)
FROM
    clean.products
UNION ALL 
SELECT 
    'staffs', COUNT(*) - COUNT(DISTINCT staff_id)
FROM
    clean.staffs
UNION ALL 
SELECT 
    'stocks', COUNT(*) - COUNT(DISTINCT store_id, product_id)
FROM
    clean.stocks
UNION ALL 
SELECT 
    'stores', COUNT(*) - COUNT(DISTINCT store_id)
FROM
    clean.stores;
    
-- 3. Full-row duplicate check (fact tables only)--
-- 3a. orders --
SELECT 
    COUNT(*) - COUNT(DISTINCT 
        order_id,
        customer_id,
        order_date,
        required_date,
        shipped_date,
        store_id,
        staff_id,
        order_status) AS full_row_dups
FROM
    clean.orders;

-- 3b.Order_items --
SELECT 
    COUNT(*) - COUNT(DISTINCT 
        order_id,
        product_id,
        quantity,
        list_price,
        discount) AS full_row_dups
FROM
    clean.order_items;

-- 3c.Stocks --
SELECT 
    COUNT(*) - COUNT(DISTINCT 
        store_id, 
        product_id, 
        quantity) AS full_row_dups
FROM
    clean.stocks;

-- 4. NULL & DISTINCT Count --

SELECT 'brands' AS tbl, 'brand_id' AS col, SUM(brand_id IS NULL) AS null_count, COUNT(DISTINCT brand_id) AS distinct_count
FROM clean.brands
UNION ALL
SELECT 'brands' AS tbl, 'brand_name' AS col, SUM(brand_name IS NULL) AS null_count, COUNT(DISTINCT brand_name) AS distinct_count
FROM clean.brands
UNION ALL
SELECT 'categories' AS tbl, 'category_id' AS col, SUM(category_id IS NULL) AS null_count, COUNT(DISTINCT category_id) AS distinct_count
FROM clean.categories
UNION ALL
SELECT 'categories' AS tbl, 'category_name' AS col, SUM(category_name IS NULL) AS null_count, COUNT(DISTINCT category_name) AS distinct_count
FROM clean.categories
UNION ALL
SELECT 'customers' AS tbl, 'customer_id' AS col, SUM(customer_id IS NULL) AS null_count, COUNT(DISTINCT customer_id) AS distinct_count
FROM clean.customers
UNION ALL
SELECT 'customers' AS tbl, 'first_name' AS col, SUM(first_name IS NULL) AS null_count, COUNT(DISTINCT first_name) AS distinct_count
FROM clean.customers
UNION ALL
SELECT 'customers' AS tbl, 'last_name' AS col, SUM(last_name IS NULL) AS null_count, COUNT(DISTINCT last_name) AS distinct_count
FROM clean.customers
UNION ALL
SELECT 'customers' AS tbl, 'city' AS col, SUM(city IS NULL) AS null_count, COUNT(DISTINCT city) AS distinct_count
FROM clean.customers 
UNION ALL
SELECT 'customers' AS tbl, 'state' AS col, SUM(state IS NULL) AS null_count, COUNT(DISTINCT state) AS distinct_count
FROM clean.customers
UNION ALL
SELECT 'order_items' AS tbl, 'order_id' AS col, SUM(order_id IS NULL) AS null_count, COUNT(DISTINCT order_id) AS distinct_count
FROM clean.order_items
UNION ALL
SELECT 'order_items' AS tbl, 'item_id' AS col, SUM(item_id IS NULL) AS null_count, COUNT(DISTINCT item_id) AS distinct_count
FROM clean.order_items
UNION ALL
SELECT 'order_items' AS tbl, 'product_id' AS col, SUM(product_id IS NULL) AS null_count, COUNT(DISTINCT product_id) AS distinct_count
FROM clean.order_items
UNION ALL
SELECT 'order_items' AS tbl, 'quantity' AS col, SUM(quantity IS NULL) AS null_count, COUNT(DISTINCT quantity) AS distinct_count
FROM clean.order_items
UNION ALL
SELECT 'order_items' AS tbl, 'list_price' AS col, SUM(list_price IS NULL) AS null_count, COUNT(DISTINCT list_price) AS distinct_count
FROM clean.order_items
UNION ALL
SELECT 'order_items' AS tbl, 'discount' AS col, SUM(discount IS NULL) AS null_count, COUNT(DISTINCT discount) AS distinct_count
FROM clean.order_items
UNION ALL
SELECT 'orders' AS tbl, 'order_id' AS col, SUM(order_id IS NULL) AS null_count, COUNT(DISTINCT order_id) AS distinct_count
FROM clean.orders
UNION ALL
SELECT 'orders' AS tbl, 'customer_id' AS col, SUM(customer_id IS NULL) AS null_count, COUNT(DISTINCT customer_id) AS distinct_count
FROM clean.orders
UNION ALL
SELECT 'orders' AS tbl, 'order_status' AS col, SUM(order_status IS NULL) AS null_count, COUNT(DISTINCT order_status) AS distinct_count
FROM clean.orders
UNION ALL
SELECT 'orders' AS tbl, 'order_date' AS col, SUM(order_date IS NULL) AS null_count, COUNT(DISTINCT order_date) AS distinct_count
FROM clean.orders
UNION ALL
SELECT 'orders' AS tbl, 'required_date' AS col, SUM(required_date IS NULL) AS null_count, COUNT(DISTINCT required_date) AS distinct_count
FROM clean.orders
UNION ALL
SELECT 'orders' AS tbl, 'shipped_date' AS col, SUM(shipped_date IS NULL) AS null_count, COUNT(DISTINCT shipped_date) AS distinct_count
FROM clean.orders
UNION ALL
SELECT 'orders' AS tbl, 'store_id' AS col, SUM(store_id IS NULL) AS null_count, COUNT(DISTINCT store_id) AS distinct_count
FROM clean.orders
UNION ALL
SELECT 'orders' AS tbl, 'staff_id' AS col, SUM(staff_id IS NULL) AS null_count, COUNT(DISTINCT staff_id) AS distinct_count
FROM clean.orders
UNION ALL
SELECT 'products' AS tbl, 'product_id' AS col, SUM(product_id IS NULL) AS null_count, COUNT(DISTINCT product_id) AS distinct_count
FROM clean.products
UNION ALL
SELECT 'products' AS tbl, 'product_name' AS col, SUM(product_name IS NULL) AS null_count, COUNT(DISTINCT product_name) AS distinct_count
FROM clean.products
UNION ALL
SELECT 'products' AS tbl, 'brand_id' AS col, SUM(brand_id IS NULL) AS null_count, COUNT(DISTINCT brand_id) AS distinct_count
FROM clean.products
UNION ALL
SELECT 'products' AS tbl, 'category_id' AS col, SUM(category_id IS NULL) AS null_count, COUNT(DISTINCT category_id) AS distinct_count
FROM clean.products
UNION ALL
SELECT 'products' AS tbl, 'model_year' AS col, SUM(model_year IS NULL) AS null_count, COUNT(DISTINCT model_year) AS distinct_count
FROM clean.products
UNION ALL
SELECT 'products' AS tbl, 'list_price' AS col, SUM(list_price IS NULL) AS null_count, COUNT(DISTINCT list_price) AS distinct_count
FROM clean.products
UNION ALL
SELECT 'staffs' AS tbl, 'staff_id' AS col, SUM(staff_id IS NULL) AS null_count, COUNT(DISTINCT staff_id) AS distinct_count
FROM clean.staffs
UNION ALL
SELECT 'staffs' AS tbl, 'first_name' AS col, SUM(first_name IS NULL) AS null_count, COUNT(DISTINCT first_name) AS distinct_count
FROM clean.staffs
UNION ALL
SELECT 'staffs' AS tbl, 'last_name' AS col, SUM(last_name IS NULL) AS null_count, COUNT(DISTINCT last_name) AS distinct_count
FROM clean.staffs
UNION ALL
SELECT 'staffs' AS tbl, 'store_id' AS col, SUM(store_id IS NULL) AS null_count, COUNT(DISTINCT store_id) AS distinct_count
FROM clean.staffs
UNION ALL
SELECT 'staffs' AS tbl, 'manager_id' AS col, SUM(manager_id IS NULL) AS null_count, COUNT(DISTINCT manager_id) AS distinct_count
FROM clean.staffs
UNION ALL
SELECT 'stocks' AS tbl, 'store_id' AS col, SUM(store_id IS NULL) AS null_count, COUNT(DISTINCT store_id) AS distinct_count
FROM clean.stocks
UNION ALL
SELECT 'stocks' AS tbl, 'product_id' AS col, SUM(product_id IS NULL) AS null_count, COUNT(DISTINCT product_id) AS distinct_count
FROM clean.stocks
UNION ALL
SELECT 'stocks' AS tbl, 'quantity' AS col, SUM(quantity IS NULL) AS null_count, COUNT(DISTINCT quantity) AS distinct_count
FROM clean.stocks
UNION ALL
SELECT 'stores' AS tbl, 'store_id' AS col, SUM(store_id IS NULL) AS null_count, COUNT(DISTINCT store_id) AS distinct_count
FROM clean.stores
UNION ALL
SELECT 'stores' AS tbl, 'store_name' AS col, SUM(store_name IS NULL) AS null_count, COUNT(DISTINCT store_name) AS distinct_count
FROM clean.stores
UNION ALL
SELECT 'stores' AS tbl, 'city' AS col, SUM(city IS NULL) AS null_count, COUNT(DISTINCT city) AS distinct_count
FROM clean.stores
UNION ALL
SELECT 'stores' AS tbl, 'state' AS col, SUM(state IS NULL) AS null_count, COUNT(DISTINCT state) AS distinct_count
FROM clean.stores;

/* 5. Summary Stats on key numeric columns
	5a. list_price range & average */
SELECT 
    MIN(list_price) AS min_price,
    MAX(list_price) AS max_price,
    ROUND(AVG(list_price), 2) AS avg_price
FROM
    clean.order_items;
    
-- 5b Discount tiers (breakdown discount column by distinct discounts values) --
SELECT 
    discount, COUNT(*) AS cnt
FROM
    clean.order_items
GROUP BY discount
ORDER BY discount;

-- 5c Model_year range  --
SELECT 
    MIN(model_year) AS min_year, 
    MAX(model_year) AS max_year
FROM
    clean.products;

-- 5d Stock quantity min, max & avg  --
SELECT 
    MIN(quantity) AS min_stock,
    MAX(quantity) AS max_stock,
    ROUND(AVG(quantity), 0)AS avg_stock
FROM
    clean.stocks;