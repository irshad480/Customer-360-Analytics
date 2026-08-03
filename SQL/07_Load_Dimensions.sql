/*
=========================================================
Project : Customer 360 Analytics
Author  : Muhammed Irshad
Database: customer360_db
Schema  : analytics
Purpose : Load Dimension Tables
=========================================================
*/

SET search_path TO analytics;

-- =====================================================
-- LOAD DIM_PRODUCT
-- =====================================================

INSERT INTO dim_product
(
    product_id,
    manufacturer,
    department,
    brand,
    commodity_desc,
    sub_commodity_desc,
    curr_size_of_product
)

SELECT DISTINCT

    product_id,
    manufacturer,
    department,
    brand,
    commodity_desc,
    sub_commodity_desc,
    curr_size_of_product

FROM stg_product

ON CONFLICT (product_id)
DO NOTHING;

---------------------------------------------------------
-- Validation
---------------------------------------------------------

SELECT
    'dim_product' AS table_name,
    COUNT(*) AS total_rows
FROM dim_product;

-- =====================================================
-- LOAD DIM_HOUSEHOLD
-- =====================================================

INSERT INTO dim_household
(
    household_key,
    classification_1,
    classification_2,
    classification_3,
    classification_4,
    classification_5,
    homeowner_desc,
    kid_category_desc
)

SELECT DISTINCT

    household_key,
    classification_1,
    classification_2,
    classification_3,
    classification_4,
    classification_5,
    homeowner_desc,
    kid_category_desc

FROM stg_hh_demographic

ON CONFLICT (household_key)
DO NOTHING;
-- =====================================================
-- ADD MISSING HOUSEHOLDS
-- =====================================================

INSERT INTO dim_household
(
    household_key,
    classification_1,
    classification_2,
    classification_3,
    classification_4,
    classification_5,
    homeowner_desc,
    kid_category_desc
)

SELECT DISTINCT

    t.household_key,

    'Unknown',

    'Unknown',

    'Unknown',

    'Unknown',

    'Unknown',

    'Unknown',

    'Unknown'

FROM stg_transaction_data t

LEFT JOIN dim_household h
ON t.household_key = h.household_key

WHERE h.household_key IS NULL

ON CONFLICT (household_key)
DO NOTHING;

---------------------------------------------------------
-- Validation
---------------------------------------------------------

SELECT
    'dim_household' AS table_name,
    COUNT(*) AS total_rows
FROM dim_household;

-- =====================================================
-- LOAD DIM_CAMPAIGN
-- =====================================================

INSERT INTO dim_campaign
(
    campaign,
    description,
    start_day,
    end_day
)

SELECT DISTINCT

    campaign,
    description,
    start_day,
    end_day

FROM stg_campaign_desc

ON CONFLICT (campaign)
DO NOTHING;

---------------------------------------------------------
-- Validation
---------------------------------------------------------

SELECT
    'dim_campaign' AS table_name,
    COUNT(*) AS total_rows
FROM dim_campaign;

-- =====================================================
-- LOAD DIM_DATE
-- =====================================================

INSERT INTO dim_date
(
    day,
    week_no,
    month_no,
    quarter_no,
    year_no
)

SELECT DISTINCT

    day,

    week_no,

    CEILING(day / 30.0)::SMALLINT AS month_no,

    CEILING(CEILING(day / 30.0) / 3.0)::SMALLINT AS quarter_no,

    CASE
        WHEN day <= 365 THEN 1
        ELSE 2
    END AS year_no

FROM stg_transaction_data

ORDER BY day

ON CONFLICT (day)
DO NOTHING;

---------------------------------------------------------
-- Validation
---------------------------------------------------------

SELECT
    'dim_date' AS table_name,
    COUNT(*) AS total_rows
FROM dim_date;

-- =====================================================
-- FINAL VALIDATION
-- =====================================================

SELECT 'dim_product' AS table_name, COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_household', COUNT(*) FROM dim_household
UNION ALL
SELECT 'dim_campaign', COUNT(*) FROM dim_campaign
UNION ALL
SELECT 'dim_date', COUNT(*) FROM dim_date
ORDER BY table_name;