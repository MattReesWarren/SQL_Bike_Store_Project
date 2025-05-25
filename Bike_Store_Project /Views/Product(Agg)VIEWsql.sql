/* 	AGGREGATION(2) 
	Products */

-- State schema -- 
USE finalBk;

/* 1. Top 10 products by sales and quantity */
CREATE OR REPLACE VIEW finalBK.pr_top_products_sales_quantity AS
SELECT 
    p.product_name,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Total_Sales,
    SUM(s.quantity) as Units_Sold
FROM
    finalBk.sales AS s
JOIN
	finalBk.products AS p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY Total_Sales DESC
LIMIT 10;

-- 2. Bottom 5 products by sales --
CREATE OR REPLACE VIEW finalBK.pr_bottom_products_by_sales AS
SELECT 
    p.product_name,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Total_Sales
FROM
    finalBk.sales AS s
JOIN
	finalBk.products AS p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY Total_Sales
LIMIT 5;

-- 3. Highest (top 7) products by units sold --
CREATE OR REPLACE VIEW finalBK.pr_top_products_by_units AS
SELECT 
    p.product_name, 
    SUM(s.quantity) AS Units_Sold
FROM
    finalBk.sales AS s
JOIN
    finalBk.products AS p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC
LIMIT 7;

-- 4. Revenue by product category -- 
CREATE OR REPLACE VIEW finalBK.pr_revenue_by_category AS
SELECT 
    c.category_name, 
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Revenue
FROM
    finalBk.sales AS s
JOIN
    finalBk.products AS p ON s.product_id = p.product_id
JOIN
    categories AS c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY Revenue DESC;

-- 5. Average purchase by product brand --
CREATE OR REPLACE VIEW finalBK.pr_avg_purchase_by_brand AS
SELECT 
    b.brand_name,
    ROUND(AVG(s.sale_price * s.quantity), 2) AS Avg_Purchase
FROM
    finalBk.sales AS s
JOIN
    finalBk.products AS p ON s.product_id = p.product_id
JOIN
    brands AS b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY Avg_Purchase DESC;

-- 6. Average discount by product brand (%) --
CREATE OR REPLACE VIEW finalBK.pr_avg_discount_by_brand AS
SELECT 
    b.brand_name, 
    ROUND(AVG(s.discount), 2) AS Avg_Discount
FROM
    finalBk.sales AS s
JOIN
    finalBk.products AS p ON s.product_id = p.product_id
JOIN
    finalBk.brands AS b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY Avg_Discount DESC; 
    
-- 7. Stock on hand per product --
CREATE OR REPLACE VIEW finalBK.pr_stock_on_hand_per_product AS
SELECT 
    p.product_name, 
    SUM(st.quantity) AS Stk_level
FROM
    finalBk.stocks AS st
JOIN
    finalBk.products AS p ON st.product_id = p.product_id
GROUP BY product_name
ORDER BY stk_level DESC;
    
-- 8. Percentage (fraction) of stock held by brand --
CREATE OR REPLACE VIEW finalBK.pr_brand_stock_fraction AS
SELECT 
    b.brand_name,
    SUM(st.quantity) AS Brand_Stk,
    SUM(st.quantity) / (
		SELECT 
            SUM(s2.quantity)
        FROM
            stocks as s2) AS Pct_Stock
FROM
    finalBk.stocks AS st
JOIN
    finalBk.products AS p ON st.product_id = p.product_id
JOIN
    finalBk.brands AS b ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY brand_stk DESC;

-- 9. Top selling women's products --
CREATE OR REPLACE VIEW finalBK.pr_top_womens_products AS
SELECT 
    p.product_name,
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Revenue_F
FROM
    finalBk.sales AS s
JOIN
    finalBk.products AS p ON s.product_id = p.product_id
WHERE
    p.product_name LIKE '%women%'
GROUP BY product_name
ORDER BY revenue_f DESC;

-- 10. Top selling product by each category --
CREATE OR REPLACE VIEW finalBK.pr_top_product_by_category AS
SELECT
	category_name,
	product_name,
	total_sales
FROM (
-- 10a. Inner query begins (derived-table subquery) --
	SELECT
		c.category_name,
		p.product_name,
		ROUND(SUM(s.sale_price * s.quantity), 2) AS total_sales,
        -- 10b. Window function --
			RANK() OVER (
            PARTITION BY 
				c.category_name
			ORDER BY 
				SUM(s.sale_price * s.quantity) DESC) AS rnk
	FROM finalBk.sales AS s
	JOIN finalBk.products AS p ON s.product_id = p.product_id
	JOIN finalBk.categories AS c ON p.category_id = c.category_id
	GROUP BY c.category_name, p.product_name) AS ranked
-- 10c. Inner query ends --
WHERE rnk = 1
ORDER BY 
    total_sales DESC;

-- 11. All units sold (does not inc non-sold items) in last 6 months of 2018 with static stock count --
CREATE OR REPLACE VIEW finalBK.pr_units_stock_last6m_2018 AS
SELECT 
    p.product_name,
    d.year_num,
    d.month_num,
    SUM(s.quantity) AS Units_sold,
    SUM(st.quantity) AS Stock_level
FROM
    finalBk.sales AS s
JOIN
    finalBk.products AS p ON s.product_id = p.product_id
JOIN
    finalBk.dates AS d ON s.order_date_key = d.date_key
JOIN
    finalBk.stocks AS st ON p.product_id = st.product_id
WHERE
    d.year_num = 2018 AND d.month_num BETWEEN 06 AND 12
GROUP BY 
	p.product_name, 
	d.year_num, 
	d.month_num;