/*
=========================================================
Project : Customer 360 Analytics
Author  : Muhammed Irshad
Database: customer360_db
Schema  : analytics
Purpose : Create Reporting Views for Power BI
=========================================================
*/

----------------------------------------------------------
-- Drop Existing Views
----------------------------------------------------------

DROP VIEW IF EXISTS analytics.vw_sales_summary;
DROP VIEW IF EXISTS analytics.vw_customer_orders;
DROP VIEW IF EXISTS analytics.vw_product_performance;
DROP VIEW IF EXISTS analytics.vw_store_performance;

----------------------------------------------------------
-- SALES SUMMARY
----------------------------------------------------------

CREATE VIEW analytics.vw_sales_summary AS

SELECT

    fs.sales_id,
    fs.household_key,
    fs.product_id,
    fs.basket_id,
    fs.day,
    dd.week_no,
    dd.month_no,
    dd.quarter_no,
    dd.year_no,
    fs.store_id,
    fs.quantity,
    fs.sales_value,
    fs.retail_disc,
    fs.coupon_disc,
    fs.coupon_match_disc

FROM analytics.fact_sales fs

INNER JOIN analytics.dim_date dd
    ON fs.day = dd.day;

----------------------------------------------------------
-- CUSTOMER ORDERS
----------------------------------------------------------

CREATE VIEW analytics.vw_customer_orders AS

SELECT

    household_key,

    COUNT(DISTINCT basket_id) AS total_orders,

    COUNT(*) AS total_transactions,

    SUM(quantity) AS total_quantity,

    ROUND(SUM(sales_value),2) AS total_revenue,

    ROUND(AVG(sales_value),2) AS average_transaction_value

FROM analytics.fact_sales

GROUP BY household_key;

----------------------------------------------------------
-- PRODUCT PERFORMANCE
----------------------------------------------------------

CREATE VIEW analytics.vw_product_performance AS

SELECT

    dp.product_id,

    dp.department,

    dp.commodity_desc,

    dp.sub_commodity_desc,

    dp.brand,

    dp.manufacturer,

    COUNT(DISTINCT fs.basket_id) AS total_orders,

    SUM(fs.quantity) AS total_quantity,

    ROUND(SUM(fs.sales_value),2) AS total_revenue,

    ROUND(AVG(fs.sales_value),2) AS average_sales_value

FROM analytics.fact_sales fs

INNER JOIN analytics.dim_product dp
    ON fs.product_id = dp.product_id

GROUP BY

    dp.product_id,
    dp.department,
    dp.commodity_desc,
    dp.sub_commodity_desc,
    dp.brand,
    dp.manufacturer;

----------------------------------------------------------
-- STORE PERFORMANCE
----------------------------------------------------------

CREATE VIEW analytics.vw_store_performance AS

SELECT

    store_id,

    COUNT(DISTINCT basket_id) AS total_orders,

    COUNT(DISTINCT household_key) AS total_customers,

    SUM(quantity) AS total_quantity,

    ROUND(SUM(sales_value),2) AS total_revenue,

    ROUND(AVG(sales_value),2) AS average_sales_value

FROM analytics.fact_sales

GROUP BY store_id;

----------------------------------------------------------
-- VERIFY VIEWS
----------------------------------------------------------

SELECT
    table_name

FROM information_schema.views

WHERE table_schema = 'analytics'

ORDER BY table_name;