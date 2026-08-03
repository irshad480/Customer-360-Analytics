/*
=========================================================
Project : Customer 360 Analytics
Author  : Muhammed Irshad
Purpose : Data Quality Assessment
=========================================================
*/

SET search_path TO analytics;

----------------------------------------------------------
-- 1. Check NULL Values
----------------------------------------------------------

SELECT
    COUNT(*) FILTER (WHERE household_key IS NULL) AS null_household,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product,
    COUNT(*) FILTER (WHERE basket_id IS NULL) AS null_basket,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantity,
    COUNT(*) FILTER (WHERE sales_value IS NULL) AS null_sales
FROM stg_transaction_data;

----------------------------------------------------------
-- 2. Negative Sales
----------------------------------------------------------

SELECT COUNT(*) AS negative_sales
FROM stg_transaction_data
WHERE sales_value < 0;

----------------------------------------------------------
-- 3. Zero Quantity
----------------------------------------------------------

SELECT COUNT(*) AS zero_quantity
FROM stg_transaction_data
WHERE quantity = 0;

----------------------------------------------------------
-- 4. Duplicate Products
----------------------------------------------------------

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM stg_product
GROUP BY product_id
HAVING COUNT(*) > 1;

----------------------------------------------------------
-- 5. Duplicate Households
----------------------------------------------------------

SELECT
    household_key,
    COUNT(*) AS duplicate_count
FROM stg_hh_demographic
GROUP BY household_key
HAVING COUNT(*) > 1;

----------------------------------------------------------
-- 6. Missing Product References
----------------------------------------------------------

SELECT COUNT(*) AS missing_products
FROM stg_transaction_data t
LEFT JOIN stg_product p
ON t.product_id = p.product_id
WHERE p.product_id IS NULL;

----------------------------------------------------------
-- 7. Missing Household References
----------------------------------------------------------

SELECT COUNT(*) AS missing_households
FROM stg_transaction_data t
LEFT JOIN stg_hh_demographic h
ON t.household_key = h.household_key
WHERE h.household_key IS NULL;

SELECT *
FROM analytics.stg_transaction_data
LIMIT 5;