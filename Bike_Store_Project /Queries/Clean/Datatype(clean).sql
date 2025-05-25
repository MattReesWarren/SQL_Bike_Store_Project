/* DATATYPE
1. Reformatting dates - string dates to correct date datatype */

UPDATE clean.orders 
SET 
    order_date = STR_TO_DATE(order_date, '%d/%m/%Y'),
    required_date = STR_TO_DATE(required_date, '%d/%m/%Y'),
    shipped_date = STR_TO_DATE(NULLIF(shipped_date, ''), '%d/%m/%Y');

ALTER TABLE clean.orders
	MODIFY COLUMN order_date DATE,
	MODIFY COLUMN required_date DATE,
	MODIFY COLUMN shipped_date DATE;