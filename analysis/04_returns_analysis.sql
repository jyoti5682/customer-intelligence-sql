USE customer_intelligence;

-- Return count and refund amount
SELECT COUNT(*) AS return_count, ROUND(SUM(refund_amount), 2) AS refund_amount
FROM returns;

-- Returns by reason
SELECT return_reason, COUNT(*) AS return_count, ROUND(SUM(refund_amount), 2) AS refund_amount
FROM returns
GROUP BY return_reason
ORDER BY return_count DESC;

-- Products with most returned units
SELECT p.product_name, SUM(r.quantity_returned) AS units_returned,
       ROUND(SUM(r.refund_amount), 2) AS refund_amount
FROM returns r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_returned DESC
LIMIT 10;

-- Return rate by category
SELECT p.category,
       SUM(oi.quantity) AS units_sold,
       COALESCE(SUM(r.quantity_returned), 0) AS units_returned,
       ROUND(COALESCE(SUM(r.quantity_returned),0) * 100.0 /
             NULLIF(SUM(oi.quantity),0), 2) AS return_rate
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN returns r ON oi.order_item_id = r.order_item_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY return_rate DESC;
