USE customer_intelligence;

-- Active customers
SELECT COUNT(DISTINCT customer_id) AS active_customers
FROM orders
WHERE order_status = 'Completed';

-- Top customers by spending
SELECT c.customer_id, c.customer_name,
       COUNT(DISTINCT o.order_id) AS completed_orders,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 10;

-- Repeat customers
SELECT customer_id, COUNT(*) AS order_count
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC;

-- One-time customers
SELECT customer_id, COUNT(*) AS order_count
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id
HAVING COUNT(*) = 1;

-- Revenue by acquisition channel
SELECT c.acquisition_channel,
       COUNT(DISTINCT c.customer_id) AS customers,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.acquisition_channel
ORDER BY revenue DESC;

-- First and latest purchase
SELECT customer_id, MIN(order_date) AS first_purchase, MAX(order_date) AS latest_purchase
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id;
