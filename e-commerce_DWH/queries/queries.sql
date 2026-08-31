-- Топ 10 клиентов по сумме заказов
SELECT 
	c.customer_id, c.full_name,
	COUNT(o.order_id) AS total_orders,
	ROUND(SUM(o.total_amount)::numeric, 2) as total_spent
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status != 'cancelled' AND c.customer_id != 0
GROUP BY c.full_name, c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Выручка по месяцам
SELECT 
	TO_CHAR(p.payment_timestamp, 'YYYY-MM') AS month,
	COUNT(o.order_id) AS orders_by_month,
	ROUND(SUM(o.total_amount)::numeric, 2) as total_spent
FROM payments p
JOIN orders o ON p.order_id = o.order_id
WHERE o.status != 'cancelled' AND o.customer_id != 0
GROUP BY month
ORDER BY MONTH;

-- Самые популярные товары по покупкам и просмотрам
-- Примечание: В синтетических данных возможны покупки без просмотров.
-- Запрос технически корректен, но отражает ограничения данных.
SELECT 
    p.product_name,
    p.category,
    COUNT(CASE WHEN e.event_type = 'view' THEN 1 END) AS views,
    COUNT(CASE WHEN e.event_type = 'purchase' THEN 1 END) AS purchases
FROM products p
JOIN events e ON p.product_id = e.product_id
WHERE e.event_type IN ('view', 'purchase')
GROUP BY p.product_name, p.category
ORDER BY purchases DESC
LIMIT 10;

-- Пользователи без заказов
SELECT 
	c.customer_id, c.full_name
FROM customers c
WHERE c.customer_id NOT IN (SELECT c.customer_id FROM orders o) AND c.customer_id != 0;

-- Распределение методов оплаты
-- Задержка междду заказом и оплатой
SELECT 
	payment_method,
	COUNT(p.payment_id) AS amount,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage,
	ROUND(EXTRACT(EPOCH FROM AVG(p.payment_timestamp - o.order_timestamp)) / 3600, 2) as avg_delay_hours
FROM payments p 
JOIN orders o ON p.order_id = o.order_id
WHERE o.status != 'cancelled'
GROUP BY payment_method
ORDER BY amount DESC

-- Конверсия между этапами воронки
WITH funnel AS (
    SELECT 
        event_type,
        COUNT(DISTINCT customer_id) as unique_users,
        CASE event_type
            WHEN 'view' THEN 1
            WHEN 'click' THEN 2
            WHEN 'login' THEN 3
            WHEN 'purchase' THEN 4
        END as funnel_order
    FROM events
    WHERE event_type IN ('view', 'click', 'login', 'purchase')
    GROUP BY event_type
),
funnel_with_conversion AS (
    SELECT 
        event_type,
        unique_users,
        funnel_order,  
        LAG(unique_users) OVER (ORDER BY funnel_order) as prev_stage_users,
        ROUND(
            unique_users::numeric / LAG(unique_users) OVER (ORDER BY funnel_order) * 100,
            2
        ) as conversion_rate
    FROM funnel
)
SELECT * FROM funnel_with_conversion
ORDER BY funnel_order;