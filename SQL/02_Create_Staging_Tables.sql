/*
=========================================================
Project : Customer 360 Analytics
Author  : Muhammed Irshad
Database: customer360_db
Schema  : analytics
Purpose : Create Raw Staging Tables
=========================================================
*/

SET search_path TO analytics;

-- =====================================================
-- Staging Table : Transaction Data
-- =====================================================

CREATE TABLE stg_transaction_data
(
    household_key          INTEGER,
    basket_id              BIGINT,
    day                    INTEGER,
    product_id             INTEGER,
    quantity               INTEGER,
    sales_value            NUMERIC(12,2),
    store_id               INTEGER,
    retail_disc            NUMERIC(12,2),
    trans_time             INTEGER,
    week_no                INTEGER,
    coupon_disc            NUMERIC(12,2),
    coupon_match_disc      NUMERIC(12,2)
);

-- =====================================================
-- Staging Table : Product
-- =====================================================

CREATE TABLE stg_product
(
    product_id             INTEGER,
    manufacturer           INTEGER,
    department             VARCHAR(100),
    brand                  VARCHAR(50),
    commodity_desc         VARCHAR(150),
    sub_commodity_desc     VARCHAR(150),
    curr_size_of_product   VARCHAR(50)
);

-- =====================================================
-- Staging Table : Household Demographic
-- =====================================================

CREATE TABLE stg_hh_demographic
(
    classification_1       VARCHAR(50),
    classification_2       VARCHAR(50),
    classification_3       VARCHAR(50),
    homeowner_desc         VARCHAR(100),
    classification_5       VARCHAR(50),
    classification_4       VARCHAR(50),
    kid_category_desc      VARCHAR(100),
    household_key          INTEGER
);

-- =====================================================
-- Staging Table : Campaign Description
-- =====================================================

CREATE TABLE stg_campaign_desc
(
    description            VARCHAR(20),
    campaign               INTEGER,
    start_day              INTEGER,
    end_day                INTEGER
);

-- =====================================================
-- Staging Table : Campaign Table
-- =====================================================

CREATE TABLE stg_campaign_table
(
    description            VARCHAR(20),
    household_key          INTEGER,
    campaign               INTEGER
);

-- =====================================================
-- Staging Table : Coupon
-- =====================================================

CREATE TABLE stg_coupon
(
    coupon_upc             BIGINT,
    product_id             INTEGER,
    campaign               INTEGER
);

-- =====================================================
-- Staging Table : Coupon Redemption
-- =====================================================

CREATE TABLE stg_coupon_redempt
(
    household_key          INTEGER,
    day                    INTEGER,
    coupon_upc             BIGINT,
    campaign               INTEGER
);

-- =====================================================
-- Staging Table : Causal Data
-- =====================================================

CREATE TABLE stg_causal_data
(
    product_id             INTEGER,
    store_id               INTEGER,
    week_no                INTEGER,
    display                VARCHAR(50),
    mailer                 VARCHAR(50)
);