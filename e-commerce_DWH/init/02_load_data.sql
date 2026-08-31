-- Загрузка данных из CSV
COPY customers FROM '/data/clean_customers.csv' DELIMITER ',' CSV HEADER;
COPY products FROM '/data/clean_products.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM '/data/clean_orders.csv' DELIMITER ',' CSV HEADER;
COPY payments FROM '/data/clean_payments.csv' DELIMITER ',' CSV HEADER;
COPY events FROM '/data/clean_events.csv' DELIMITER ',' CSV HEADER;