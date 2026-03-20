-- Create the data warehouse database
CREATE DATABASE IF NOT EXISTS retail_dw;
USE retail_dw;

-- Drop existing tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_customer;
-- Create Date Dimension Table
CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    day INT NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(20) NOT NULL,
    week_of_year INT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

-- Create Store Dimension Table
CREATE TABLE dim_store (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    store_city VARCHAR(50) NOT NULL,
    store_region VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Product Dimension Table
CREATE TABLE dim_product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Customer Dimension Table (optional but useful for analytics)
CREATE TABLE dim_customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Sales Fact Table
CREATE TABLE fact_sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    date_id INT NOT NULL,
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    customer_id VARCHAR(20),
    units_sold INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_revenue DECIMAL(15, 2) GENERATED ALWAYS AS (units_sold * unit_price) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id)
);

-- Create indexes for query performance
CREATE INDEX idx_fact_date ON fact_sales(date_id);
CREATE INDEX idx_fact_store ON fact_sales(store_id);
CREATE INDEX idx_fact_product ON fact_sales(product_id);

-- ============================================
-- Populate Dimension Tables with Cleaned Data
-- ============================================

-- Populate dim_date (generate dates for 2023)
DELIMITER $$
CREATE PROCEDURE populate_dim_date()
BEGIN
    DECLARE start_date DATE DEFAULT '2023-01-01';
    DECLARE end_date DATE DEFAULT '2023-12-31';
    DECLARE current_dt DATE;
    
    SET current_dt = start_date;
    
    WHILE current_dt <= end_date DO
        INSERT INTO dim_date (
            date_id,
            full_date,
            year,
            quarter,
            month,
            month_name,
            day,
            day_of_week,
            day_name,
            week_of_year,
            is_weekend
        ) VALUES (
            YEAR(current_dt) * 10000 + MONTH(current_dt) * 100 + DAY(current_dt),
            current_dt,
            YEAR(current_dt),
            QUARTER(current_dt),
            MONTH(current_dt),
            MONTHNAME(current_dt),
            DAY(current_dt),
            DAYOFWEEK(current_dt),
            DAYNAME(current_dt),
            WEEKOFYEAR(current_dt),
            DAYOFWEEK(current_dt) IN (1, 7)
        );
        SET current_dt = DATE_ADD(current_dt, INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

CALL populate_dim_date();
DROP PROCEDURE populate_dim_date;