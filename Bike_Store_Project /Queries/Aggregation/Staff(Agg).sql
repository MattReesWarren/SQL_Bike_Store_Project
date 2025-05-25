-- STAFF --

USE finalBK;

-- 1. Highest selling staff by revenue and units (non-manager) --
SELECT 
    sf.last_name,
    st.store_name,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Staff_Sales,
    SUM(s.quantity) AS Units_Sold
FROM
    sales AS s
JOIN
    staff AS sf ON s.staff_id = sf.staff_id
JOIN
	stores as st on s.store_id = st.store_id
WHERE
    sf.manager_id <> 1
GROUP BY 
	sf.last_name, 
	st.store_name
ORDER BY Staff_Sales DESC;

-- 2. Highest selling manager by sales and units --
SELECT 
    sf.last_name,
    st.store_name,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Mng_Sales,
    SUM(s.quantity) AS Units_Sold
FROM
    sales AS s
JOIN
    staff AS sf ON s.staff_id = sf.staff_id
JOIN
    stores AS st ON s.store_id = st.store_id
WHERE
    sf.manager_id = 1
GROUP BY 
	sf.last_name, 
	st.store_name
ORDER BY Mng_Sales DESC;
 
-- 3. Staff ranked by sales of 'trek' brand --
SELECT 
    sf.last_name,
    b.brand_name,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Mng_Sales_Brands
FROM
    sales AS s
JOIN
    staff AS sf ON s.staff_id = sf.staff_id
JOIN
    products AS p ON s.product_id = p.product_id
JOIN
    brands AS b ON p.brand_id = b.brand_id
WHERE
    b.brand_name = 'trek'
GROUP BY 
	sf.last_name
ORDER BY 
	Mng_Sales_Brands DESC;

-- 
    
-- 4. Top ranked staff member by sales at each category level --
-- CTE --
WITH staff_cat_sales AS (
	-- Inner select sub query --
    SELECT
        sf.last_name,
        c.category_name,
        SUM(s.sale_price * s.quantity) AS total_sales
    FROM sales AS s
    JOIN staff AS sf ON s.staff_id = sf.staff_id
    JOIN products AS p ON s.product_id  = p.product_id
    JOIN categories AS c ON p.category_id = c.category_id
    GROUP BY
        sf.last_name,
        c.category_name)
-- outer main query --
SELECT
    last_name,
    category_name,
    total_sales
FROM (
	-- table-derived subquery --
    SELECT
        last_name,
        category_name,
        total_sales,
        -- window function --
        ROW_NUMBER() OVER (
            PARTITION BY category_name
            ORDER BY total_sales DESC
		) AS rn
	FROM staff_cat_sales
	) AS ranked
WHERE rn = 1
ORDER BY
    total_sales desc;


