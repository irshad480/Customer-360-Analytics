/*
=========================================================
Project : Customer 360 Analytics
Author  : Muhammed Irshad
Database: customer360_db
Schema  : analytics
Purpose : Exploratory Data Analysis (EDA)
=========================================================
*/

SET search_path TO analytics;

-- =====================================================
-- 1. DATASET OVERVIEW
-- =====================================================

SELECT
    (SELECT COUNT(*) FROM fact_sales) AS total_transactions,
    (SELECT COUNT(DISTINCT household_key) FROM fact_sales) AS total_customers,
    (SELECT COUNT(DISTINCT product_id) FROM fact_sales) AS total_products,
    (SELECT COUNT(DISTINCT basket_id) FROM fact_sales) AS total_orders,
    (SELECT COUNT(DISTINCT store_id) FROM fact_sales) AS total_stores;

---------------------------------------------------------
-- 2. SALES SUMMARY
---------------------------------------------------------

SELECT
    ROUND(SUM(sales_value),2) AS total_revenue,
    ROUND(AVG(sales_value),2) AS avg_transaction_value,
    ROUND(MIN(sales_value),2) AS min_sale,
    ROUND(MAX(sales_value),2) AS max_sale
FROM fact_sales;

---------------------------------------------------------
-- 3. ORDER SUMMARY
---------------------------------------------------------

SELECT

    COUNT(DISTINCT basket_id) AS total_orders,

    ROUND(
        SUM(sales_value) /
        COUNT(DISTINCT basket_id),
        2
    ) AS average_order_value

FROM fact_sales;

---------------------------------------------------------
-- 4. CUSTOMER SUMMARY
---------------------------------------------------------

SELECT

    COUNT(DISTINCT household_key) AS customers,

    ROUND(
        SUM(sales_value) /
        COUNT(DISTINCT household_key),
        2
    ) AS revenue_per_customer

FROM fact_sales;

---------------------------------------------------------
-- 5. TOP 10 CUSTOMERS
---------------------------------------------------------

SELECT

    household_key,

    ROUND(SUM(sales_value),2) AS revenue

FROM fact_sales

GROUP BY household_key

ORDER BY revenue DESC

LIMIT 10;

---------------------------------------------------------
-- 6. TOP 10 PRODUCTS
---------------------------------------------------------

SELECT

    p.product_id,

    p.commodity_desc,

    ROUND(SUM(f.sales_value),2) AS revenue

FROM fact_sales f

JOIN dim_product p
ON f.product_id = p.product_id

GROUP BY
    p.product_id,
    p.commodity_desc

ORDER BY revenue DESC

LIMIT 10;

---------------------------------------------------------
-- 7. REVENUE BY DEPARTMENT
---------------------------------------------------------

SELECT

    department,

    ROUND(SUM(sales_value),2) AS revenue

FROM fact_sales f

JOIN dim_product p
ON f.product_id = p.product_id

GROUP BY department

ORDER BY revenue DESC;

---------------------------------------------------------
-- 8. REVENUE BY BRAND
---------------------------------------------------------

SELECT

    brand,

    ROUND(SUM(sales_value),2) AS revenue

FROM fact_sales f

JOIN dim_product p
ON f.product_id = p.product_id

GROUP BY brand

ORDER BY revenue DESC

LIMIT 15;

---------------------------------------------------------
-- 9. WEEKLY SALES TREND
---------------------------------------------------------

SELECT

    week_no,

    ROUND(SUM(sales_value),2) AS revenue

FROM fact_sales

GROUP BY week_no

ORDER BY week_no;

---------------------------------------------------------
-- 10. MONTHLY SALES TREND
---------------------------------------------------------

SELECT

    d.month_no,

    ROUND(SUM(f.sales_value),2) AS revenue

FROM fact_sales f

JOIN dim_date d
ON f.day = d.day

GROUP BY d.month_no

ORDER BY d.month_no;

---------------------------------------------------------
-- 11. YEARLY SALES
---------------------------------------------------------

SELECT

    d.year_no,

    ROUND(SUM(f.sales_value),2) AS revenue

FROM fact_sales f

JOIN dim_date d
ON f.day = d.day

GROUP BY d.year_no

ORDER BY d.year_no;

---------------------------------------------------------
-- 12. PURCHASE QUANTITY DISTRIBUTION
---------------------------------------------------------

SELECT

    quantity,

    COUNT(*) AS transactions

FROM fact_sales

WHERE quantity <= 20

GROUP BY quantity

ORDER BY quantity;

---------------------------------------------------------
-- 13. STORE PERFORMANCE
---------------------------------------------------------

SELECT

    store_id,

    ROUND(SUM(sales_value),2) AS revenue

FROM fact_sales

GROUP BY store_id

ORDER BY revenue DESC

LIMIT 20;

---------------------------------------------------------
-- 14. CUSTOMER PURCHASE FREQUENCY
---------------------------------------------------------

SELECT

    household_key,

    COUNT(DISTINCT basket_id) AS orders

FROM fact_sales

GROUP BY household_key

ORDER BY orders DESC

LIMIT 20;

---------------------------------------------------------
-- 15. DATA QUALITY CHECK
---------------------------------------------------------

SELECT

    COUNT(*) FILTER (WHERE sales_value < 0) AS negative_sales,

    COUNT(*) FILTER (WHERE quantity <= 0) AS zero_or_negative_quantity,

    COUNT(*) FILTER (WHERE quantity > 100) AS outlier_quantity

FROM fact_sales;