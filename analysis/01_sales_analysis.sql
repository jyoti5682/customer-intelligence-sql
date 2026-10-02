USE customer_intelligence;

-- Total revenue from completed orders
SELECT ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';

-- Order status breakdown
SELECT order_status, COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- Average order value
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT o.order_id,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY o.order_id
) x;

-- Monthly revenue
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY month
ORDER BY month;

-- Revenue by city
SELECT c.city,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.city
ORDER BY revenue DESC;

-- Cancellation rate
SELECT ROUND(
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
) AS cancellation_rate
FROM orders;
