/* 1. Validation: Structural consistency checks
(Expect no errors (all tables report OK) */
CHECK TABLE finalBK.dates;
CHECK TABLE finalBK.geo;
CHECK TABLE finalBK.brands;
CHECK TABLE finalBK.categories;
CHECK TABLE finalBK.customers;
CHECK TABLE finalBK.stores;
CHECK TABLE finalBK.staff;
CHECK TABLE finalBK.products;
CHECK TABLE finalBK.order_status;
CHECK TABLE finalBK.sales;
CHECK TABLE finalBK.stocks;

/* 2. Orphan-row checks: checks every 'child' record in relationship points to valid row in 'parent' table 
	LEFT JOIN from 'child table'(counts should be zero (no orphaned rows)) */

-- 2.a Sales to Customers
SELECT COUNT(*) AS missing_customers
FROM finalBK.sales AS s
    LEFT JOIN finalBK.customers AS c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 2.b Sales to Stores
SELECT COUNT(*) AS missing_stores
FROM finalBK.sales AS s
    LEFT JOIN finalBK.stores AS st ON s.store_id = st.store_id
WHERE st.store_id IS NULL;

-- 2.c Sales to Staff
SELECT COUNT(*) AS missing_staff
FROM finalBK.sales AS s
    LEFT JOIN finalBK.staff AS f ON s.staff_id = f.staff_id
WHERE f.staff_id IS NULL;

-- 2.d Sales to Dates (i) (order_date_key)
SELECT COUNT(*) AS missing_order_dates
FROM finalBK.sales AS s
    LEFT JOIN finalBK.dates AS d ON s.order_date_key = d.date_key
WHERE d.date_key IS NULL;

-- 2.e Sales to Dates (ii) (required_date_key)
SELECT COUNT(*) AS missing_required_dates
FROM finalBK.sales AS s
    LEFT JOIN finalBK.dates AS d2 ON s.required_date_key = d2.date_key
WHERE d2.date_key IS NULL;

-- 2.f Sales to Dates (iii) (shipped_date_key)
SELECT COUNT(*) AS missing_shipped_dates
FROM finalBK.sales AS s
    LEFT JOIN finalBK.dates AS d3 ON s.shipped_date_key = d3.date_key
-- shipped_date_key has valid NULL's --
WHERE s.shipped_date_key IS NOT NULL AND d3.date_key IS NULL;

-- 2.g Sales to Order_Status
SELECT COUNT(*) AS missing_status
FROM finalBK.sales AS s
    LEFT JOIN finalBK.order_status AS os ON s.status_id = os.status_id
WHERE os.status_id IS NULL;

-- 2.h Sales to Products
SELECT COUNT(*) AS missing_products
FROM finalBK.sales AS s
    LEFT JOIN finalBK.products AS p ON s.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 2.i Customers to Geo
SELECT COUNT(*) AS invalid_customer_geo
FROM finalBK.customers AS c
    LEFT JOIN finalBK.geo AS g ON c.geo_id = g.geo_id
WHERE g.geo_id IS NULL;

-- 2.j Stores to Geo
SELECT COUNT(*) AS invalid_store_geo
FROM finalBK.stores AS st
    LEFT JOIN finalBK.geo AS g2 ON st.geo_id = g2.geo_id
WHERE g2.geo_id IS NULL;

-- 2.k Products to Brands
SELECT COUNT(*) AS invalid_product_brands
FROM finalBK.products p
    LEFT JOIN finalBK.brands b ON p.brand_id = b.brand_id
WHERE b.brand_id IS NULL;

-- 2.l Products to Categories
SELECT COUNT(*) AS invalid_product_categories
FROM finalBK.products AS p
    LEFT JOIN finalBK.categories AS c ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

-- 2.m Staff to Stores
SELECT COUNT(*) AS invalid_staff_stores
FROM finalBK.staff AS f
    LEFT JOIN finalBK.stores AS s ON f.store_id = s.store_id
WHERE s.store_id IS NULL;

-- 2.n Staff to Manager (self reference)
SELECT COUNT(*) AS invalid_staff_manager
FROM finalBK.staff AS f
    LEFT JOIN finalBK.staff AS m ON f.manager_id = m.staff_id
-- staff has known NULL in highest position --
WHERE f.manager_id IS NOT NULL AND m.staff_id IS NULL;

-- 2.o Stocks to Stores
SELECT COUNT(*) AS invalid_stocks_stores
FROM finalBK.stocks AS st
    LEFT JOIN finalBK.stores AS s2 ON st.store_id = s2.store_id
WHERE s2.store_id IS NULL;

-- 2.p Stocks to Products
SELECT COUNT(*) AS invalid_stocks_products
FROM finalBK.stocks AS st
    LEFT JOIN finalBK.products AS p2 ON st.product_id = p2.product_id
WHERE p2.product_id IS NULL;

/* 3. Sample joins. Viusal check on multiple joins 
   (expect no NULL's) */
SELECT
    s.order_id,
    c.first_name,
    c.last_name,
    g.state,
    p.product_name,
    b.brand_name,
    s.quantity,
    s.list_price
FROM finalBK.sales AS s
    LEFT JOIN finalBK.customers AS c ON s.customer_id = c.customer_id
    LEFT JOIN finalBK.geo AS g ON c.geo_id = g.geo_id
    LEFT JOIN finalBK.products AS p ON s.product_id = p.product_id
    LEFT JOIN finalBK.brands AS b ON p.brand_id = b.brand_id
ORDER BY RAND() -- random 5 rows at each query --
LIMIT 5;

/* 4. Date checks (expect no missing months) */
SELECT
    d.year_num,
    d.month_num,
    COUNT(*) AS sales_rows
FROM finalBK.sales AS s
    LEFT JOIN finalBK.dates AS d ON s.order_date_key = d.date_key
GROUP BY d.year_num, d.month_num
ORDER BY d.year_num, d.month_num;

/* 5. Aggregation check 
   (expect valid revenue values by status for recent months) */
SELECT
    d.year_num,
    d.month_num,
    os.status_name,
    SUM(s.quantity * s.sale_price) AS revenue
FROM finalBK.sales AS s
    LEFT JOIN finalBK.dates AS d ON s.order_date_key = d.date_key
    LEFT JOIN finalBK.order_status AS os ON s.status_id = os.status_id
GROUP BY d.year_num, d.month_num, os.status_name
ORDER BY 
	d.year_num DESC, 
	d.month_num DESC;

