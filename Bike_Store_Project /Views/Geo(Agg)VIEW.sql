-- GEO --

-- Select schema --
USE finalBK;

-- 1. Sales by store -- 
CREATE OR REPLACE VIEW finalBK.GEO_sales_by_store AS
SELECT 
    st.store_name,
    ROUND(SUM(s.sale_price * s.quantity)) AS Store_Sales
FROM
    finalBK.sales AS s
JOIN
    finalBK.stores AS st ON s.store_id = st.store_id
GROUP BY 
	st.store_name
ORDER BY 
	store_sales DESC;

-- 2. Units sold per store --
CREATE OR REPLACE VIEW finalBK.GEO_units_sold_by_store AS
SELECT 
    st.store_name,
    ROUND(SUM(s.quantity)) AS Units_Sold
FROM
    finalBK.sales AS s
JOIN
    finalBK.stores AS st ON s.store_id = st.store_id
GROUP BY 
	st.store_name
ORDER BY 
	units_sold DESC;

-- 3. Hightest sales by city and customer count (over complete timeline) --
CREATE OR REPLACE VIEW finalBK.GEO_top_cities_sales_customers AS
SELECT 
    g.city,
    count(distinct c.customer_id) as Cust_Count,
    ROUND(SUM(s.sale_price * s.quantity)) AS City_Sales
FROM
    finalBK.sales AS s
JOIN
    finalBK.customers AS c ON s.customer_id = c.customer_id
JOIN
    finalBK.geo AS g ON c.geo_id = g.geo_id
GROUP BY 
	g.city
ORDER BY 
	City_Sales DESC
LIMIT 10;

-- 4. Highest average spend and count by city (over complete timeline) --
CREATE OR REPLACE VIEW finalBK.GEO_top_cities_avg_spend AS
SELECT 
    g.city,
	count(distinct c.customer_id) as Cust_Count,
    ROUND(SUM(s.sale_price * s.quantity) / COUNT(DISTINCT c.customer_id), 2) AS AVG_City_Spend
FROM
    finalBK.sales AS s
JOIN
    finalBK.customers AS c ON s.customer_id = c.customer_id
JOIN
    finalBK.geo AS g ON c.geo_id = g.geo_id
GROUP BY 
	g.city
ORDER BY 
	AVG_City_Spend DESC
LIMIT 10;

-- 5. Percentage (as fraction) of customer sales by state --
CREATE OR REPLACE VIEW finalBK.GEO_state_sales_fraction AS
SELECT 
    g.state,
    ROUND(SUM(s.sale_price * s.quantity) / (
		SELECT 
			SUM(s2.sale_price * s2.quantity)
		FROM
			finalBK.sales AS s2), 4) AS Frac_State_Sales
FROM
    finalBK.sales AS s
JOIN
    finalBK.customers AS c ON s.customer_id = c.customer_id
JOIN
    finalBK.geo AS g ON c.geo_id = g.geo_id
GROUP BY 
	g.state
ORDER BY 
	Frac_State_Sales DESC;

-- 6. Top selling cites in NY --
CREATE OR REPLACE VIEW finalBK.GEO_top_cities_NY AS
SELECT 
    g.city,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS City_Sales_NY
FROM
    finalBK.sales AS s
JOIN
    finalBK.customers AS c ON s.customer_id = c.customer_id
JOIN
    finalBK.geo AS g ON c.geo_id = g.geo_id
WHERE
    g.state = 'NY'
GROUP BY 
	g.city
ORDER BY 
	City_Sales_NY DESC
LIMIT 7;

-- 7. Average line item purchase by store --
CREATE OR REPLACE VIEW finalBK.GEO_avg_line_item_by_store AS
SELECT 
    st.store_name, 
    ROUND(AVG(s.sale_price * quantity), 2) AS Avg_Line_Item
FROM 
	finalBK.sales AS s
JOIN
    finalBK.stores AS st ON s.store_id = st.store_id
GROUP BY 
	st.store_name
ORDER BY 
	Avg_line_item DESC;

-- 8. Average order value by state -- 
CREATE OR REPLACE VIEW finalBK.GEO_avg_order_value_by_state AS
SELECT
	g.state,
	ROUND(
		SUM(s.sale_price * s.quantity)/ 
		COUNT(DISTINCT s.order_id), 2) AS avg_order_value
FROM 
	finalBK.sales AS s
JOIN 
	finalBK.customers AS c ON s.customer_id = c.customer_id
JOIN 
	finalBK.geo AS g ON c.geo_id = g.geo_id
GROUP BY
	g.state
ORDER BY
	avg_order_value DESC;

-- 9. Percentage (fraction) of brand sales per store --
CREATE OR REPLACE VIEW finalBK.GEO_brand_sales_fraction_by_store AS
SELECT 
    st.store_name,
    b.brand_name,
    ROUND(
		SUM(s.sale_price * s.quantity) / 
        SUM(SUM(s.sale_price * s.quantity)) 
		-- window function --
			OVER(PARTITION BY st.store_id), 4) AS Brand_Sales
FROM
    finalBK.sales AS s
JOIN
    finalBK.stores AS st ON s.store_id = st.store_id
JOIN
    finalBK.products AS p ON s.product_id = p.product_id
JOIN
    finalBK.brands AS b ON p.brand_id = b.brand_id
GROUP BY 
	b.brand_name, 
    st.store_id,
    st.store_name
ORDER BY 
	st.store_name,
    Brand_Sales DESC,
    b.brand_name;
    

    
    
	
    
