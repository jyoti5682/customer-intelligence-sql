USE customer_intelligence;

-- Top products by units sold
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC
LIMIT 10;

-- Top products by revenue
SELECT p.product_id, p.product_name, p.category,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC
LIMIT 10;

-- Revenue by category
SELECT p.category,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY revenue DESC;

-- Estimated product profit
SELECT p.product_name,
       ROUND(SUM((p.selling_price - p.cost_price) * oi.quantity), 2) AS estimated_profit
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY estimated_profit DESC
LIMIT 10;

-- Top 3 products within each category
WITH product_sales AS (
    SELECT p.category, p.product_id, p.product_name,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.category, p.product_id, p.product_name
),
ranked AS (
    SELECT *, DENSE_RANK() OVER (
        PARTITION BY category ORDER BY revenue DESC
    ) AS category_rank
    FROM product_sales
)
SELECT *
FROM ranked
WHERE category_rank <= 3
ORDER BY category, category_rank;
