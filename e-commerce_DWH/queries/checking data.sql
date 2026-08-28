-- ============================================
-- БЛОК 1: КОЛИЧЕСТВО ЗАПИСЕЙ
-- ============================================
SELECT 'customers' as tbl, COUNT(*) as cnt FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'events', COUNT(*) FROM events;

-- ============================================
-- БЛОК 2: REFERENTIAL INTEGRITY (должно быть везде 0)
-- ============================================

-- Заказы без клиента
SELECT 'orphaned_orders' as check_name,
       COUNT(*) as cnt
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

-- Платежи без заказа
SELECT 'orphaned_payments',
       COUNT(*)
FROM payments p
LEFT JOIN orders o ON p.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

-- События без клиента
SELECT 'events_without_customer',
       COUNT(*)
FROM events e
LEFT JOIN customers c ON e.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

-- События без товара
SELECT 'events_without_product',
       COUNT(*)
FROM events e
LEFT JOIN products p ON e.product_id = p.product_id
WHERE p.product_id IS NULL;

-- ============================================
-- БЛОК 3: ФИНАНСОВАЯ СХОДИМОСТЬ
-- ============================================
SELECT 
    (SELECT SUM(total_amount) FROM orders WHERE status != 'cancelled') as active_orders,
    (SELECT SUM(amount) FROM payments) as payments,
    ABS((SELECT SUM(total_amount) FROM orders WHERE status != 'cancelled') - 
        (SELECT SUM(amount) FROM payments)) as difference;

-- ============================================
-- БЛОК 4: СУРРОГАТНЫЙ КЛИЕНТ
-- ============================================
SELECT customer_id, full_name, email, phone 
FROM customers 
WHERE customer_id = 0;

-- ============================================
-- БЛОК 5: СТАТУСЫ ЗАКАЗОВ ( sanity check )
-- ============================================
SELECT status, COUNT(*) as cnt, SUM(total_amount) as total
FROM orders
GROUP BY status
ORDER BY cnt DESC;


-- ============================================
-- УДАЛЯЕМ ЛИШНЕЕ ВО ИЗБЕЖАНИИ ОШИБОК В АНАЛИЗЕ
-- ============================================
-- 1. События без клиента или товара
DELETE FROM events 
WHERE customer_id NOT IN (SELECT customer_id FROM customers)
   OR product_id NOT IN (SELECT product_id FROM products);

-- 2. Платежи за "висящие" заказы (иначе нельзя будет удалить сами заказы)
DELETE FROM payments 
WHERE order_id IN (
    SELECT order_id FROM orders 
    WHERE customer_id NOT IN (SELECT customer_id FROM customers)
);

-- 3. Заказы без клиентов
DELETE FROM orders 
WHERE customer_id NOT IN (SELECT customer_id FROM customers);

-- ============================================
-- ПЕРЕПРОВЕРКА ПОСЛЕ УДАЛЕНИЯ
-- ============================================
-- Сколько записей осталось в таблицах
SELECT 'customers' as tbl, COUNT(*) as cnt FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'events', COUNT(*) FROM events;

-- Целостность связей (везде должно быть 0)
SELECT 'orphaned_orders' as check_name, COUNT(*) as cnt FROM orders o LEFT JOIN customers c ON o.customer_id = c.customer_id WHERE c.customer_id IS NULL
UNION ALL SELECT 'orphaned_payments', COUNT(*) FROM payments p LEFT JOIN orders o ON p.order_id = o.order_id WHERE o.order_id IS NULL
UNION ALL SELECT 'events_no_customer', COUNT(*) FROM events e LEFT JOIN customers c ON e.customer_id = c.customer_id WHERE c.customer_id IS NULL
UNION ALL SELECT 'events_no_product', COUNT(*) FROM events e LEFT JOIN products p ON e.product_id = p.product_id WHERE p.product_id IS NULL;

-- Финансовая сходимость
SELECT 
    (SELECT SUM(total_amount) FROM orders WHERE status != 'cancelled') as active_orders_sum,
    (SELECT SUM(amount) FROM payments) as payments_sum,
    ABS((SELECT SUM(total_amount) FROM orders WHERE status != 'cancelled') - (SELECT SUM(amount) FROM payments)) as difference;
