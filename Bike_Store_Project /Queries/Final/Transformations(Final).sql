-- TRANSFORMATIONS --

/* 1. Add calculated sale price column 

 1a. Alter table */
ALTER TABLE
	finalbk.sales
ADD COLUMN
	sale_price DECIMAL(10,2);

-- 1b. Update column --
UPDATE finalbk.sales 
SET 
    sale_price = list_price * (1 - discount);

/* 2. Add concat name column

2a. alter table */
ALTER TABLE 
	finalbk.customers
ADD COLUMN 
	full_name VARCHAR(255) NOT NULL;

-- 2b. update column --
UPDATE finalbk.customers 
SET 
    full_name = CONCAT(last_name, ', ', first_name);
	
