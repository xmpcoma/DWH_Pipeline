-- Таблица клиентов (Корень)
CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    city VARCHAR(100),
    created_at TIMESTAMP
);

-- Таблица товаров (Корень)
CREATE TABLE products (
    product_id BIGINT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    price DECIMAL(10, 2), 
    currency VARCHAR(10),
    is_active BOOLEAN
);

-- Таблица заказов (Зависит от customers)
CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY,
    customer_id BIGINT,
    order_timestamp TIMESTAMP,
    status VARCHAR(50),
    currency VARCHAR(10),
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Таблица платежей (Зависит от orders)
CREATE TABLE payments (
    payment_id BIGINT PRIMARY KEY,
    order_id BIGINT,
    payment_method VARCHAR(50),
    amount DECIMAL(10, 2),
    currency VARCHAR(10),
    payment_timestamp TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Таблица событий (Зависит от customers и products)
CREATE TABLE events (
    event_id BIGINT PRIMARY KEY,
    customer_id BIGINT,
    event_type VARCHAR(50),
    event_timestamp TIMESTAMP,
    product_id BIGINT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);