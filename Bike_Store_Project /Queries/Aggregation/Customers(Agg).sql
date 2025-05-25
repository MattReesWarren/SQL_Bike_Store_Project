/* AGGREAGATION(3)
  Customers */

-- select schema --
use finalbk;

-- 1. Top 5 customers by spend --
SELECT 
    c.full_name,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Cust_Spend
FROM
    finalbk.sales AS s
JOIN
    finalbk.customers AS c ON s.customer_id = c.customer_id
GROUP BY c.full_name
ORDER BY cust_spend DESC
LIMIT 5;

-- 2. Top 5 customers by quantity of total items bought --
SELECT 
    c.full_name,
    SUM(s.quantity) AS Cust_Total_Items
FROM
    finalbk.sales AS s
JOIN
    finalbk.customers AS c ON s.customer_id = c.customer_id
GROUP BY 
	c.customer_id,
	c.full_name
ORDER BY cust_total_items DESC
LIMIT 5;

-- 3. Top 5 average customer spend  --
SELECT 
    c.full_name,
    COUNT(DISTINCT s.quantity) as Orders,
    ROUND(SUM(s.sale_price * s.quantity) / COUNT(DISTINCT s.order_id), 2) AS Cust_Avg_Spend
FROM
    finalbk.sales AS s
JOIN
    finalbk.customers AS c ON s.customer_id = c.customer_id
GROUP BY full_name
ORDER BY Cust_Avg_Spend DESC
LIMIT 5;

-- 4. Spend by family --
SELECT 
    c.last_name,
    COUNT(DISTINCT c.customer_id) as Family_Num,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Cust_Fam_Spend
FROM
    finalbk.sales AS s
JOIN
    finalbk.customers AS c ON s.customer_id = c.customer_id
GROUP BY c.last_name
ORDER BY cust_fam_spend DESC
LIMIT 5;

-- 5. Top 10 customers by total orders -- 
SELECT
	s.customer_id,
	COUNT(s.order_id) AS order_count
FROM
	finalbk.sales AS s
GROUP BY
	s.customer_id
ORDER BY
	order_count DESC
LIMIT 10;

-- 6. Customer order frequncy rank --
SELECT
    freq2.freq_seg AS freq,
    COUNT(*) AS customer_count,
    SUM(freq2.order_count) AS total_orders
	-- 6a. Inner table-derived query --
FROM (
    SELECT
		s.customer_id,
        COUNT(s.order_id) AS order_count,
        -- Case statment --
        CASE
            WHEN COUNT(s.order_id) > 7 THEN 'Regular'
            WHEN COUNT(s.order_id) BETWEEN 2 AND 7 THEN 'Occasional'
            ELSE 'New'
        END AS freq_seg
    FROM
        finalbk.sales AS s
    GROUP BY
        s.customer_id) AS freq2
GROUP BY
    freq2.freq_seg;
    
-- 7. Top 10 customers by quantity of 20% discount purchases --
SELECT
    c.full_name,
    COUNT(*) as dist_line_amount,
    SUM(s.quantity) AS qty_20pct_dist  
FROM
    finalbk.sales AS s
join
	finalbk.customers as c on s.customer_id = c.customer_id
WHERE
    s.discount = 0.20
GROUP BY
    c.full_name
ORDER BY
    qty_20pct_dist DESC
LIMIT 10;

-- 8. Top 10 customers by quantity of 5% discount purchases --
SELECT
    c.full_name,
    COUNT(*) as dist_line_amount,
    SUM(s.quantity) AS qty_at_5  
FROM
    finalbk.sales AS s
join
	finalbk.customers as c on s.customer_id = c.customer_id
WHERE
    s.discount = 0.05
GROUP BY
    c.full_name
ORDER BY
    qty_at_5 DESC
LIMIT 10;

