```
## 📁 Структура проекта

e-commerce_DWH/
│
├── README.md # Описание проекта
├── DWH_Pipeline.ipynb # Основной ноутбук (ETL пайплайн)
│
├── data/
│ ├── raw/ # Исходные данные
│ │ ├── customers.csv
│ │ ├── orders.json
│ │ ├── payments.csv
│ │ ├── products.xlsx
│ │ └── events.xml
│ │
│ └── processed/ # Очищенные данные
│ ├── clean_customers.csv
│ ├── clean_orders.csv
│ ├── clean_payments.csv
│ ├── clean_products.csv
│ └── clean_events.csv
│
└── sql/
├── create_tables.sql # Скрипт создания таблиц в PostgreSQL
└── validation_queries.sql # Проверочные запросы
```
