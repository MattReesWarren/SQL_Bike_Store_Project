-- TIME SERIES --

USE finalBK;

-- 1. Yearly Revenue --
SELECT
    d.year_num,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Yearly_Rev
FROM
    finalBK.sales AS s
JOIN
    finalBK.dates AS d ON s.order_date_key = d.date_key
GROUP BY
    d.year_num
ORDER BY
    d.year_num;

-- 2. Monthly Revenue --
SELECT
    d.year_num,
    d.month_num,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Monthly_Rev
FROM
    finalBK.sales AS s
JOIN
    finalBK.dates AS d ON s.order_date_key = d.date_key
GROUP BY
    d.year_num, d.month_num
ORDER BY
    d.year_num, d.month_num;
    
-- 3. Yearly sales by store --
SELECT
    d.year_num,
    st.store_name,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Yearly_Rev
FROM
    finalBK.sales AS s
JOIN
    finalBK.dates AS d ON s.order_date_key = d.date_key
JOIN 
	finalBK.stores AS st ON s.store_id = st.store_id
GROUP BY
    d.year_num, st.store_name
ORDER BY
    st.store_name,  d.year_num;

-- 4. Yearly sales and quantity by category --
SELECT 
    c.category_name,
    d.year_num,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Cat_Sales_Yearly,
    SUM(s.quantity) AS units_sold
FROM
    finalBK.sales AS s
JOIN
    finalBK.products AS p ON s.product_id = p.product_id
JOIN
    finalBK.categories AS c ON p.category_id = c.category_id
JOIN
    finalBK.dates AS d ON s.order_date_key = d.date_key
GROUP BY d.year_num , c.category_name
ORDER BY c.category_name;
    
-- 5. YoY percentage (as fraction) increase/decrease in revenue --
-- 5a. CTE table to produce yearly sales result --
WITH yearly_sales AS (
	SELECT
		d.year_num,
		SUM(s.sale_price * s.quantity) AS yearly_rev
	FROM 
		finalBK.sales AS s
	JOIN 
		finalBK.dates AS d ON s.order_date_key = d.date_key
	GROUP BY 
		d.year_num)
-- 5b. main outer query --
SELECT
	ys.year_num,
    ys.yearly_rev,
    -- 5c. window function to provide previous year comparison --
		ROUND((
			ys.yearly_rev - LAG(ys.yearly_rev) OVER (ORDER BY ys.year_num))
			/ LAG(ys.yearly_rev) OVER (ORDER BY ys.year_num), 4) AS frac_change
FROM 
	yearly_sales AS ys
ORDER BY 
	ys.year_num;

-- 6. MoM percentage (as fraction) increase/decrease in revenue --
-- 6a. CTE table to produce montly sales result --
WITH monthly_sales AS (
	SELECT
		DATE_FORMAT(d.date_key, '%Y-%m') AS yr_mth,
		SUM(s.sale_price * s.quantity) AS monthly_rev
	FROM 
		finalBK.sales AS s
	JOIN 
		finalBK.dates AS d ON s.order_date_key = d.date_key
	GROUP BY 
		yr_mth)
-- 6b. main outer query --
SELECT
	ms.yr_mth,
	ms.monthly_rev,
    -- 6c. window function to provide previous year comparison --
	ROUND((
		ms.monthly_rev 
		- LAG(ms.monthly_rev) 
			OVER (ORDER BY ms.yr_mth))
		/ LAG(ms.monthly_rev) 
			OVER (ORDER BY ms.yr_mth), 4) AS frac_change
FROM 
	monthly_sales AS ms
ORDER BY 
	ms.yr_mth;

-- 7. YoY Percentage (in fracrtion) change in revenue by brands --
-- 7a. CTE table for brand/year revenue --
WITH brand_yearly AS (
	SELECT
		d.year_num,
		b.brand_name,
		ROUND(SUM(s.sale_price * s.quantity), 2) AS brand_year_rev
	FROM 
		finalBK.sales AS s
	JOIN 
		finalBK.dates AS d ON s.order_date_key = d.date_key
	JOIN
		finalBK.products AS p ON s.product_id = p.product_id 
	JOIN 
		finalBK.brands AS b ON p.brand_id = b.brand_id 
	GROUP BY 
		d.year_num,
		b.brand_name
	ORDER BY
		b.brand_name,
		d.year_num,
		brand_year_rev)
-- 7b. Main outer query --
SELECT 
	bry.year_num,
	bry.brand_name,
	bry.brand_year_rev,
	ROUND((
		bry.brand_year_rev 
		- LAG(bry.brand_year_rev) 
        -- window function(s) for YoY comparison fraction calculation --
			OVER(
				PARTITION BY bry.brand_name
                ORDER BY bry.year_num))
		/ LAG(bry.brand_year_rev) 
			OVER(
				PARTITION BY bry.brand_name
                ORDER BY bry.year_num), 4) AS frac_change
FROM
	brand_yearly AS bry
ORDER BY
	bry.brand_name,
	bry.year_num;