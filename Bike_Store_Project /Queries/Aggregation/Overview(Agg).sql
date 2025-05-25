/* 	AGGREAGATIONS (1)
OVERVIEW */
    
-- 1. Total Sales --
SELECT 
    ROUND(SUM(s.sale_price * s.quantity), 2) AS Total_Sales
FROM
    finalBK.sales AS s;

-- 2. Total Units Sold --
SELECT 
    SUM(sales.quantity) AS Total_Units_Sold
FROM
    finalBK.sales;
    
-- 3. Average Order --
SELECT 
    ROUND(SUM(s.sale_price * s.quantity) / COUNT(DISTINCT s.order_id), 2) AS Avg_Order
FROM
    finalBK.sales AS s;

-- 4. Order Fulfilment Percentage --
SELECT 
    ROUND(
		COUNT(DISTINCT 
			CASE 
				WHEN s.shipped_date_key 
				IS NOT NULL THEN s.order_id 
			END) 
		/ COUNT(DISTINCT s.order_id), 2) AS Fulfillment_Rate
FROM
    finalBK.sales s;

-- 5. Customer Count -- 
SELECT 
    COUNT(DISTINCT c.customer_id) as Cust_Count
FROM
    finalBK.customers AS c;
    
-- 6. Discount rank count --
SELECT
    s.discount,
    COUNT(s.discount) AS discount_count
FROM
    finalBK.ssales AS s
GROUP BY
    s.discount
ORDER BY
    s.discount;



    









