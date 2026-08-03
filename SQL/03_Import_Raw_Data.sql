/*
=========================================================
Project : Customer 360 Analytics
Author  : Muhammed Irshad
Database: customer360_db
Schema  : analytics
Purpose : Import raw CSV files into staging tables
=========================================================

Import Method:
    pgAdmin Import/Export Wizard

Files to Import:

transaction_data.csv  -> stg_transaction_data
product.csv           -> stg_product
hh_demographic.csv    -> stg_hh_demographic
campaign_desc.csv     -> stg_campaign_desc
campaign_table.csv    -> stg_campaign_table
coupon.csv            -> stg_coupon
coupon_redempt.csv    -> stg_coupon_redempt
causal_data.csv       -> stg_causal_data

Import Settings:
----------------
Format      : CSV
Header      : Yes
Delimiter   : ,
Encoding    : UTF-8

After importing, run:
04_Data_Validation.sql
*/