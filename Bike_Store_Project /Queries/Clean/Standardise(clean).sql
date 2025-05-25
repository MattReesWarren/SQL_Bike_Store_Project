
/* STANDARDISE 
1. Trim whitespace */

UPDATE clean.brands 
SET 
    brand_name = TRIM(brand_name);

UPDATE clean.categories 
SET 
    category_name = TRIM(category_name);
    
UPDATE clean.customers 
SET 
    first_name = TRIM(first_name),
    last_name = TRIM(last_name),
    city = TRIM(city),
    state = TRIM(state);

UPDATE clean.products 
SET 
    product_name = TRIM(product_name);
    
UPDATE clean.staffs 
SET 
    first_name = TRIM(first_name),
    last_name = TRIM(last_name);

UPDATE clean.stores 
SET 
    store_name = TRIM(store_name),
    city = TRIM(city),
    state = TRIM(state);

-- 2. Syntax --

-- 2a(i). Cleaning product_name column (visual check) --
/* SELECT 
    TRIM(REGEXP_REPLACE(product_name,
                '(2015|2016|2017|2018|2019|Trek|Electra|Haro|Heller|Pure Cycles|Ritchey|Strider|Sun Bicycles|Surly|-|/)',
                '')) AS mod_col
FROM
    clean.products;*/

-- 2a(ii). Cleaning product_name column --
UPDATE clean.products
SET product_name = TRIM(
  REGEXP_REPLACE(
    product_name,
    '(2015|2016|2017|2018|2019|Trek|Electra|Haro|Heller|Pure Cycles|Ritchey|Strider|Sun Bicycles|Surly|-|/)',
    ''
  )
);

-- 2b. Cleaning category_name column - repetition of words "bikes and bicycles"
UPDATE clean.categories 
SET 
    category_name = SUBSTRING_INDEX(category_name, ' ', 1);



