USE customer_intelligence;

-- RFM-style customer metrics
WITH customer_metrics AS (
    SELECT c.customer_id, c.customer_name,
           DATEDIFF(
               (SELECT MAX(order_date) FROM orders WHERE order_status = 'Completed'),
               MAX(o.order_date)
           ) AS recency_days,
           COUNT(DISTINCT o.order_id) AS frequency,
           ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS monetary_value
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT *,
       CASE
           WHEN recency_days <= 30 AND frequency >= 4 AND monetary_value >= 25000 THEN 'High Value'
           WHEN recency_days <= 60 AND frequency >= 2 THEN 'Repeat Active'
           WHEN recency_days > 120 THEN 'At Risk'
           ELSE 'Regular'
       END AS customer_segment
FROM customer_metrics;
