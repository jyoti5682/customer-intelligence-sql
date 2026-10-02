USE customer_intelligence;

-- Days between purchases
WITH purchases AS (
    SELECT customer_id, order_date,
           LAG(order_date) OVER (
               PARTITION BY customer_id ORDER BY order_date
           ) AS previous_purchase
    FROM orders
    WHERE order_status = 'Completed'
)
SELECT customer_id, order_date, previous_purchase,
       DATEDIFF(order_date, previous_purchase) AS days_between_purchases
FROM purchases
WHERE previous_purchase IS NOT NULL
ORDER BY customer_id, order_date;

-- Second purchase within 30 days
WITH purchases AS (
    SELECT customer_id, order_date,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id ORDER BY order_date
           ) AS purchase_number
    FROM orders
    WHERE order_status = 'Completed'
),
first_two AS (
    SELECT customer_id,
           MAX(CASE WHEN purchase_number = 1 THEN order_date END) AS first_purchase,
           MAX(CASE WHEN purchase_number = 2 THEN order_date END) AS second_purchase
    FROM purchases
    GROUP BY customer_id
)
SELECT customer_id, first_purchase, second_purchase,
       DATEDIFF(second_purchase, first_purchase) AS days_to_second_purchase
FROM first_two
WHERE second_purchase IS NOT NULL
  AND DATEDIFF(second_purchase, first_purchase) <= 30;

-- Customers inactive for more than 90 days
SELECT c.customer_id, c.customer_name, MAX(o.order_date) AS latest_purchase
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING MAX(o.order_date) < (
    SELECT MAX(order_date) FROM orders WHERE order_status = 'Completed'
) - INTERVAL 90 DAY
ORDER BY latest_purchase;
