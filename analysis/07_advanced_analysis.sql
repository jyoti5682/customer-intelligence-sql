USE customer_intelligence;

-- Month-over-month revenue
WITH monthly_revenue AS (
    SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY month
),
with_previous AS (
    SELECT month, revenue,
           LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT month,
       ROUND(revenue,2) AS revenue,
       ROUND(previous_month_revenue,2) AS previous_month_revenue,
       ROUND((revenue-previous_month_revenue)*100.0 /
             NULLIF(previous_month_revenue,0),2) AS mom_growth_percent
FROM with_previous
ORDER BY month;

-- Customer spending rank
WITH customer_sales AS (
    SELECT c.customer_id, c.customer_name,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS spending
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id, customer_name,
       ROUND(spending,2) AS spending,
       RANK() OVER (ORDER BY spending DESC) AS spending_rank
FROM customer_sales
ORDER BY spending_rank;
