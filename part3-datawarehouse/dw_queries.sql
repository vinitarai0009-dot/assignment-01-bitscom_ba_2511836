-- Use the data warehouse database
USE retail_dw;

-- Q1: Total sales revenue by product category for each month
SELECT 
    d.year,
    d.month,
    d.month_name,
    p.category,
    SUM(f.total_revenue) AS total_revenue,
    SUM(f.units_sold) AS total_units_sold
FROM fact_sales f
INNER JOIN dim_date d ON f.date_id = d.date_id
INNER JOIN dim_product p ON f.product_id = p.product_id
GROUP BY d.year, d.month, d.month_name, p.category
ORDER BY d.year, d.month, total_revenue DESC;

-- Q2: Top 2 performing stores by total revenue
SELECT 
    s.store_name,
    s.store_city,
    SUM(f.total_revenue) AS total_revenue,
    SUM(f.units_sold) AS total_units_sold,
    COUNT(DISTINCT f.sale_id) AS number_of_transactions
FROM fact_sales f
INNER JOIN dim_store s ON f.store_id = s.store_id
GROUP BY s.store_id, s.store_name, s.store_city
ORDER BY total_revenue DESC
LIMIT 2;

-- Q3: Month-over-month sales trend across all stores
WITH monthly_sales AS (
    SELECT 
        d.year,
        d.month,
        d.month_name,
        SUM(f.total_revenue) AS total_revenue,
        SUM(f.units_sold) AS total_units_sold
    FROM fact_sales f
    INNER JOIN dim_date d ON f.date_id = d.date_id
    GROUP BY d.year, d.month, d.month_name
)
SELECT 
    year,
    month,
    month_name,
    total_revenue,
    total_units_sold,
    LAG(total_revenue) OVER (ORDER BY year, month) AS previous_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year, month)) / 
        LAG(total_revenue) OVER (ORDER BY year, month) * 100, 
        2
    ) AS revenue_mom_percentage_change,
    LAG(total_units_sold) OVER (ORDER BY year, month) AS previous_month_units,
    ROUND(
        (total_units_sold - LAG(total_units_sold) OVER (ORDER BY year, month)) / 
        LAG(total_units_sold) OVER (ORDER BY year, month) * 100, 
        2
    ) AS units_mom_percentage_change
FROM monthly_sales
ORDER BY year, month;

-- Additional Analytical Query: Store performance by category
SELECT 
    s.store_name,
    p.category,
    SUM(f.total_revenue) AS category_revenue,
    SUM(f.units_sold) AS category_units
FROM fact_sales f
INNER JOIN dim_store s ON f.store_id = s.store_id
INNER JOIN dim_product p ON f.product_id = p.product_id
GROUP BY s.store_id, s.store_name, p.category
ORDER BY s.store_name, category_revenue DESC;

-- Additional Analytical Query: Top 5 products by revenue
SELECT 
    p.product_name,
    p.category,
    SUM(f.total_revenue) AS total_revenue,
    SUM(f.units_sold) AS total_units_sold,
    AVG(f.unit_price) AS avg_selling_price
FROM fact_sales f
INNER JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 5;