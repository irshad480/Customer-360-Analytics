/*
=========================================================
Project : Customer 360 Analytics
Author  : Muhammed Irshad
Database: customer360_db
Schema  : analytics
Purpose : Validate imported staging data
=========================================================
*/

SET search_path TO analytics;

-- =====================================================
-- Row Count Validation
-- =====================================================

SELECT 'stg_transaction_data' AS table_name, COUNT(*) AS total_rows
FROM stg_transaction_data

UNION ALL

SELECT 'stg_product', COUNT(*)
FROM stg_product

UNION ALL

SELECT 'stg_hh_demographic', COUNT(*)
FROM stg_hh_demographic

UNION ALL

SELECT 'stg_campaign_desc', COUNT(*)
FROM stg_campaign_desc

UNION ALL

SELECT 'stg_campaign_table', COUNT(*)
FROM stg_campaign_table

UNION ALL

SELECT 'stg_coupon', COUNT(*)
FROM stg_coupon

UNION ALL

SELECT 'stg_coupon_redempt', COUNT(*)
FROM stg_coupon_redempt

UNION ALL

SELECT 'stg_causal_data', COUNT(*)
FROM stg_causal_data

ORDER BY table_name;


SELECT *
FROM analytics.stg_transaction_data
LIMIT 10;

SELECT *
FROM analytics.stg_product
LIMIT 10;

SELECT *
FROM analytics.stg_hh_demographic
LIMIT 10;

SELECT
    COUNT(*) AS transaction_rows
FROM analytics.stg_transaction_data;