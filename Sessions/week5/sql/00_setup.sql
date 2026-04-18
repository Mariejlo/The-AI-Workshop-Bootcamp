-- =============================================================
-- 00_setup.sql
-- Creates the seven tables used in the session and loads data
-- from the CSV files in the data/ folder.
--
-- HOW TO RUN (psql):
--   1. Open a terminal in the folder ai-workshop-sql that contains folders like sql/ and data/
--   2. Connect to Postgres:
--        psql -h <host> -p 5432 -U <username> -d <database_name>
--      For example, if you have Postgres running locally with the default user and database called dataeng_db:
--        psql -h localhost -p 5432 -U postgres -d dataeng_db 
--   3. Run this file:
--        \i sql/00_setup.sql
--
-- If you use pgAdmin or DBeaver instead of psql, the \COPY
-- commands at the bottom will not work. See the notes at the
-- end of this file for alternatives.
--
-- Safe to re-run: everything is dropped and recreated.
-- =============================================================


-- Drop in reverse dependency order so FKs do not complain
DROP TABLE IF EXISTS delivery_trips CASCADE;
DROP TABLE IF EXISTS order_details  CASCADE;
DROP TABLE IF EXISTS orders         CASCADE;
DROP TABLE IF EXISTS products       CASCADE;
DROP TABLE IF EXISTS customers      CASCADE;
DROP TABLE IF EXISTS drivers        CASCADE;
DROP TABLE IF EXISTS departments    CASCADE;


-- -------------------------------------------------------------
-- 1. departments  (parent table, no dependencies)
-- -------------------------------------------------------------
CREATE TABLE departments (
    department_id   INT PRIMARY KEY,
    department_name TEXT NOT NULL
);


-- -------------------------------------------------------------
-- 2. drivers  (no dependencies)
-- -------------------------------------------------------------
CREATE TABLE drivers (
    driver_id      INT PRIMARY KEY,
    name           TEXT,
    license_number TEXT,
    phone          TEXT
);


-- -------------------------------------------------------------
-- 3. customers  (no dependencies)
-- -------------------------------------------------------------
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name        TEXT,
    email       TEXT,
    phone       TEXT,
    address     TEXT
);


-- -------------------------------------------------------------
-- 4. products  (depends on departments)
-- -------------------------------------------------------------
CREATE TABLE products (
    product_id    INT PRIMARY KEY,
    product_name  TEXT,
    price         NUMERIC(10, 2),
    department_id INT REFERENCES departments (department_id)
);


-- -------------------------------------------------------------
-- 5. orders  (depends on customers)
-- -------------------------------------------------------------
CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT REFERENCES customers (customer_id),
    order_date  DATE
);


-- -------------------------------------------------------------
-- 6. order_details  (depends on orders and products)
-- No primary key: the raw data contains 51 duplicate (order_id,
-- product_id) pairs. We leave them in so you can see real-world
-- messy data, and so aggregation behaviour matches what you would
-- get in production. Data quality is covered in Week 10.
-- -------------------------------------------------------------
CREATE TABLE order_details (
    order_id   INT NOT NULL REFERENCES orders   (order_id),
    product_id INT NOT NULL REFERENCES products (product_id),
    quantity   INT NOT NULL
);


-- -------------------------------------------------------------
-- 7. delivery_trips  (depends on orders and drivers)
-- -------------------------------------------------------------
CREATE TABLE delivery_trips (
    trip_id       INT PRIMARY KEY,
    order_id      INT REFERENCES orders  (order_id),
    driver_id     INT REFERENCES drivers (driver_id),
    delivery_date DATE,
    status        TEXT
);


-- =============================================================
-- LOAD DATA
-- Column order in each CREATE TABLE matches column order in the
-- CSV file, so \COPY with HEADER true works positionally.
-- =============================================================

\COPY departments    FROM 'data/Departments.csv'   WITH (FORMAT csv, HEADER true);
\COPY drivers        FROM 'data/Drivers.csv'       WITH (FORMAT csv, HEADER true);
\COPY customers      FROM 'data/Customers.csv'     WITH (FORMAT csv, HEADER true);
\COPY products       FROM 'data/Products.csv'      WITH (FORMAT csv, HEADER true);
\COPY orders         FROM 'data/Orders.csv'        WITH (FORMAT csv, HEADER true);
\COPY order_details  FROM 'data/OrderDetails.csv'  WITH (FORMAT csv, HEADER true);
\COPY delivery_trips FROM 'data/DeliveryTrips.csv' WITH (FORMAT csv, HEADER true);


-- =============================================================
-- QUICK SANITY CHECK
-- Expected row counts:
--   departments     6
--   drivers        50
--   customers     500
--   products    1,000
--   orders     10,000
--   order_details 29,727
--   delivery_trips 10,000
-- =============================================================

SELECT 'departments'    AS table_name, COUNT(*) AS rows FROM departments
UNION ALL SELECT 'drivers',        COUNT(*) FROM drivers
UNION ALL SELECT 'customers',      COUNT(*) FROM customers
UNION ALL SELECT 'products',       COUNT(*) FROM products
UNION ALL SELECT 'orders',         COUNT(*) FROM orders
UNION ALL SELECT 'order_details',  COUNT(*) FROM order_details
UNION ALL SELECT 'delivery_trips', COUNT(*) FROM delivery_trips
ORDER BY table_name;


-- =============================================================
-- NOTES FOR NON-PSQL USERS
--
-- pgAdmin:
--   Right-click each table > Import/Export Data. Set Header = Yes,
--   Delimiter = comma, Encoding = UTF8. Load in the order listed
--   above (parents before children).
--
-- DBeaver:
--   Right-click the table > Import Data > CSV. Same settings as
--   above. Same load order.
--
-- Server-side COPY (if your CSVs are on the database server):
--   COPY departments FROM '/absolute/path/Departments.csv'
--     WITH (FORMAT csv, HEADER true);
--   Repeat for each table. Requires superuser or pg_read_server_files.
-- =============================================================
