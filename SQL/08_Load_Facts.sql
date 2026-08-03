/*
=========================================================
Project : Customer 360 Analytics
Author  : Muhammed Irshad
Database: customer360_db
Schema  : analytics
Purpose : Load Fact Tables
=========================================================
*/

----------------------------------------------------------
-- RESET FACT TABLES
----------------------------------------------------------

TRUNCATE TABLE analytics.fact_coupon_redemption RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.fact_promotions RESTART IDENTITY CASCADE;
TRUNCATE TABLE analytics.fact_sales RESTART IDENTITY CASCADE;

----------------------------------------------------------
-- LOAD FACT SALES
----------------------------------------------------------

INSERT INTO analytics.fact_sales
(
    household_key,
    product_id,
    basket_id,
    day,
    week_no,
    trans_time,
    store_id,
    quantity,
    sales_value,
    retail_disc,
    coupon_disc,
    coupon_match_disc
)

SELECT

    t.household_key,
    t.product_id,
    t.basket_id,
    t.day,
    t.week_no,
    t.trans_time,
    t.store_id,
    t.quantity,
    t.sales_value,
    t.retail_disc,
    t.coupon_disc,
    t.coupon_match_disc

FROM analytics.stg_transaction_data t

INNER JOIN analytics.dim_product p
    ON t.product_id = p.product_id

LEFT JOIN analytics.dim_household h
    ON t.household_key = h.household_key

INNER JOIN analytics.dim_date d
    ON t.day = d.day;

----------------------------------------------------------
-- VERIFY FACT SALES
----------------------------------------------------------

SELECT
    COUNT(*) AS fact_sales_rows
FROM analytics.fact_sales;

----------------------------------------------------------
-- LOAD FACT COUPON REDEMPTION
----------------------------------------------------------

INSERT INTO analytics.fact_coupon_redemption
(
    household_key,
    coupon_upc,
    campaign,
    day
)

SELECT

    household_key,
    coupon_upc,
    campaign,
    day

FROM analytics.stg_coupon_redempt;

----------------------------------------------------------
-- VERIFY FACT COUPON REDEMPTION
----------------------------------------------------------

SELECT
    COUNT(*) AS coupon_redemption_rows
FROM analytics.fact_coupon_redemption;

----------------------------------------------------------
-- LOAD FACT PROMOTIONS
----------------------------------------------------------

INSERT INTO analytics.fact_promotions
(
    product_id,
    store_id,
    week_no,
    display,
    mailer
)

SELECT

    product_id,
    store_id,
    week_no,
    display,
    mailer

FROM analytics.stg_causal_data;

----------------------------------------------------------
-- VERIFY FACT PROMOTIONS
----------------------------------------------------------

SELECT
    COUNT(*) AS promotion_rows
FROM analytics.fact_promotions;

----------------------------------------------------------
-- FINAL LOAD SUMMARY
----------------------------------------------------------

SELECT 'Fact Sales' AS table_name, COUNT(*) AS total_rows
FROM analytics.fact_sales

UNION ALL

SELECT 'Fact Coupon Redemption', COUNT(*)
FROM analytics.fact_coupon_redemption

UNION ALL

SELECT 'Fact Promotions', COUNT(*)
FROM analytics.fact_promotions;