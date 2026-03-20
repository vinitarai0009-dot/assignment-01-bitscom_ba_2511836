-- Q1: List all customers from Mumbai along with their total order value
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_email,
    SUM(od.quantity * od.unit_price_at_time) AS total_order_value
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN OrderDetails od ON o.order_id = od.order_id
WHERE c.customer_city = 'Mumbai'
GROUP BY c.customer_id, c.customer_name, c.customer_email
ORDER BY total_order_value DESC;

-- Q2: Find the top 3 products by total quantity sold
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(od.quantity) AS total_quantity_sold
FROM Products p
INNER JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- Q3: List all sales representatives and the number of unique customers they have handled
SELECT 
    sr.sales_rep_id,
    sr.sales_rep_name,
    COUNT(DISTINCT o.customer_id) AS unique_customers_handled
FROM SalesRepresentatives sr
LEFT JOIN Orders o ON sr.sales_rep_id = o.sales_rep_id
GROUP BY sr.sales_rep_id, sr.sales_rep_name
ORDER BY unique_customers_handled DESC;

-- Q4: Find all orders where the total value exceeds 10,000, sorted by value descending
SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    c.customer_city,
    SUM(od.quantity * od.unit_price_at_time) AS total_order_value
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY o.order_id, o.order_date, c.customer_name, c.customer_city
HAVING total_order_value > 10000
ORDER BY total_order_value DESC;

-- Q5: Identify any products that have never been ordered
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price
FROM Products p
LEFT JOIN OrderDetails od ON p.product_id = od.product_id
WHERE od.order_detail_id IS NULL;