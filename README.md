```
## 📁 Структура проекта

e-commerce_DWH/
│
├── README.md # Описание проекта
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
├── init/
│ ├── 01_create_tables.sql
│ └── 02_load_data.sql
│
├── notebooks/
│ ├── DWH_Pipeline.ipynb # Очистка данных
│
└── queries/
├── create tables.sql # Скрипт создания таблиц в PostgreSQL
└── cheking data.sql # Проверочные запросы
└── queries # Аналитические запросы
│
└──docker-compose.yml
```
