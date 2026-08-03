/*
=========================================================
Project : Customer 360 Analytics
Author  : Muhammed Irshad
Database: customer360_db
Schema  : analytics
Purpose : Create Analytics Warehouse Tables
=========================================================
*/

SET search_path TO analytics;

-- =====================================================
-- DROP FACT TABLES
-- =====================================================

DROP TABLE IF EXISTS fact_coupon_redemption CASCADE;
DROP TABLE IF EXISTS fact_promotions CASCADE;
DROP TABLE IF EXISTS fact_sales CASCADE;

-- =====================================================
-- DROP DIMENSION TABLES
-- =====================================================

DROP TABLE IF EXISTS dim_campaign CASCADE;
DROP TABLE IF EXISTS dim_household CASCADE;
DROP TABLE IF EXISTS dim_product CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;

-- =====================================================
-- DIM_PRODUCT
-- =====================================================

CREATE TABLE dim_product
(
    product_id              INTEGER PRIMARY KEY,

    manufacturer            INTEGER,

    department              VARCHAR(100),

    brand                   VARCHAR(50),

    commodity_desc          VARCHAR(150),

    sub_commodity_desc      VARCHAR(150),

    curr_size_of_product    VARCHAR(50),

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- DIM_HOUSEHOLD
-- =====================================================

CREATE TABLE dim_household
(
    household_key           INTEGER PRIMARY KEY,

    classification_1        VARCHAR(50),

    classification_2        VARCHAR(50),

    classification_3        VARCHAR(50),

    classification_4        VARCHAR(50),

    classification_5        VARCHAR(50),

    homeowner_desc          VARCHAR(100),

    kid_category_desc       VARCHAR(100),

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- DIM_CAMPAIGN
-- =====================================================

CREATE TABLE dim_campaign
(
    campaign                INTEGER PRIMARY KEY,

    description             VARCHAR(30),

    start_day               SMALLINT,

    end_day                 SMALLINT,

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- DIM_DATE
-- =====================================================

CREATE TABLE dim_date
(
    day                     SMALLINT PRIMARY KEY,

    week_no                 SMALLINT,

    month_no                SMALLINT,

    quarter_no              SMALLINT,

    year_no                 SMALLINT,

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- FACT_SALES
-- =====================================================

CREATE TABLE fact_sales
(
    sales_id                BIGSERIAL PRIMARY KEY,

    household_key           INTEGER NOT NULL,

    product_id              INTEGER NOT NULL,

    basket_id               BIGINT NOT NULL,

    day                     SMALLINT NOT NULL,

    week_no                 SMALLINT,

    trans_time              SMALLINT,

    store_id                INTEGER,

    quantity                INTEGER,

    sales_value             NUMERIC(12,2),

    retail_disc             NUMERIC(12,2),

    coupon_disc             NUMERIC(12,2),

    coupon_match_disc       NUMERIC(12,2),

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sales_household
        FOREIGN KEY (household_key)
        REFERENCES dim_household (household_key),

    CONSTRAINT fk_sales_product
        FOREIGN KEY (product_id)
        REFERENCES dim_product (product_id),

    CONSTRAINT fk_sales_date
        FOREIGN KEY (day)
        REFERENCES dim_date (day)
);

-- =====================================================
-- FACT_COUPON_REDEMPTION
-- =====================================================

CREATE TABLE fact_coupon_redemption
(
    redemption_id           BIGSERIAL PRIMARY KEY,

    household_key           INTEGER NOT NULL,

    coupon_upc              BIGINT NOT NULL,

    campaign                INTEGER NOT NULL,

    day                     SMALLINT NOT NULL,

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_redemption_household
        FOREIGN KEY (household_key)
        REFERENCES dim_household (household_key),

    CONSTRAINT fk_redemption_campaign
        FOREIGN KEY (campaign)
        REFERENCES dim_campaign (campaign),

    CONSTRAINT fk_redemption_day
        FOREIGN KEY (day)
        REFERENCES dim_date (day)
);

-- =====================================================
-- FACT_PROMOTIONS
-- =====================================================

CREATE TABLE fact_promotions
(
    promotion_id            BIGSERIAL PRIMARY KEY,

    product_id              INTEGER NOT NULL,

    store_id                INTEGER,

    week_no                 SMALLINT,

    display                 VARCHAR(50),

    mailer                  VARCHAR(50),

    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_promotion_product
        FOREIGN KEY (product_id)
        REFERENCES dim_product (product_id)
);

-- =====================================================
-- VERIFY TABLES
-- =====================================================

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'analytics'
AND table_name IN
(
'dim_product',
'dim_household',
'dim_campaign',
'dim_date',
'fact_sales',
'fact_coupon_redemption',
'fact_promotions'
)
ORDER BY table_name;