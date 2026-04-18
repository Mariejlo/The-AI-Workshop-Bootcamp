-- =============================================================
-- SQL Aggregation, Grouping & Query Optimisation
-- Companion runnable snippets
-- AI Workshop SQL Bootcamp | Week 3 Guest Session
-- Instructor: Chukwuebuka Akwiwu-Uzoma
-- Target: PostgreSQL 12+
--
-- Before running these queries, load the data using 00_setup.sql.
-- See README.md for step-by-step instructions.
-- =============================================================


-- =============================================================
-- PART 2  |  AGGREGATE FUNCTIONS
-- =============================================================

-- Example 1: counting things
-- How many orders are in the system?
SELECT COUNT(*) AS total_orders
FROM orders;

-- How many customers have actually placed an order?
SELECT COUNT(DISTINCT customer_id) AS active_customers
FROM orders;




-- =============================================================



-- Example 2: measuring value
-- Price spread across the catalogue
SELECT
    MIN(price)                         AS cheapest,
    MAX(price)                         AS most_expensive,
    ROUND(AVG(price), 3)      AS average_price,
    ROUND(SUM(price), 3)      AS total_catalog_value
FROM products;





-- =============================================================
-- PART 3  |  GROUP BY
-- GROUP BY collapses rows that share a value into a single summary row. That is the whole idea.
-- What is the Golden Rule of GROUP BY?
-- =============================================================

-- Example 3: one group column
-- How many products does each department have?
SELECT department_id, COUNT(*) AS product_count
FROM products
GROUP BY department_id
ORDER BY product_count DESC;


-- Department IDs are numbers though, so the result is readable but not meaningful. Join to departments to fix that:
-- With a readable department name via JOIN
-- Product count and average price per department
SELECT
    d.department_name,
    COUNT(p.product_id)                  AS product_count,
    ROUND(AVG(p.price), 2)      AS avg_price
FROM products p
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_price DESC;



-- =============================================================

-- Example 4: grouping by more than one column
-- Orders per customer per month
SELECT
    customer_id,
    DATE_TRUNC('month', order_date)::date AS month,
    COUNT(*)                              AS order_count
FROM orders
GROUP BY customer_id, DATE_TRUNC('month', order_date)
ORDER BY customer_id, month;


-- Exercise: provide the grouping by customer name instead of customer_id
-- Answer below

--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--

SELECT
    c.name,
    DATE_TRUNC('month', o.order_date)::date AS month,
    COUNT(*)                              AS order_count
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name, DATE_TRUNC('month', o.order_date)
ORDER BY c.name, month;

-- =============================================================


-- Example 5: aggregation with WHERE
-- Count of orders made in 2024 per month
SELECT
    DATE_TRUNC('month', order_date)::date AS month,
    COUNT(*)                              AS orders_placed
FROM orders
WHERE order_date >= '2024-01-01'
  AND order_date <  '2025-01-01'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;


-- =============================================================
-- PART 4  |  HAVING and SUMMARY ANALYTICS
-- What is difference between HAVING AND WHERE?
-- =============================================================

-- Example 6: HAVING
-- Drivers who have completed more than 20 deliveries
SELECT
    driver_id,
    COUNT(*) AS completed_trips
FROM delivery_trips
WHERE status = 'Delivered'
GROUP BY driver_id
HAVING COUNT(*) > 20
ORDER BY completed_trips DESC;



-- =============================================================



-- Example 7: revenue by product
-- Top 10 highest-revenue products
SELECT
    p.product_name,
    SUM(od.quantity)                                AS units_sold,
    ROUND(SUM(od.quantity * p.price)::numeric, 2)   AS revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;
-- This is the bread and butter of analytics. 
-- Join facts (order_details) to dimensions (products), aggregate the measure (quantity times price), 
-- group by the thing you want a row per.



-- =============================================================



-- Example 8: FILTER clause (Postgres specific). Can be likened to SUM(CASE WHEN ... THEN 1 END) in SQL Server/MySQL
-- Trip status breakdown per driver in a single row
SELECT
    driver_id,
    COUNT(*) FILTER (WHERE status = 'Delivered') AS delivered,
    COUNT(*) FILTER (WHERE status = 'Pending')   AS pending,
    COUNT(*) FILTER (WHERE status = 'Cancelled') AS cancelled,
    COUNT(*)                                     AS total_trips,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE status = 'Cancelled') / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM delivery_trips
GROUP BY driver_id
ORDER BY cancellation_rate_pct DESC;



-- =============================================================


--(Discusss)
--
--
--
--
-- Example 9: ROLLUP (Discusss)
-- Orders per department per month, with department totals and a grand total
SELECT
    d.department_name,
    DATE_TRUNC('month', o.order_date)::date AS month,
    COUNT(DISTINCT o.order_id)              AS orders,
    SUM(od.quantity)                        AS units
FROM orders o
JOIN order_details od ON o.order_id    = od.order_id
JOIN products p       ON od.product_id = p.product_id
JOIN departments d    ON p.department_id = d.department_id
GROUP BY ROLLUP (d.department_name, DATE_TRUNC('month', o.order_date))
ORDER BY d.department_name NULLS LAST, month NULLS LAST;


-- =============================================================

-- Example 10: WINDOW FUNCTIONS

-- Daily order count plus a running total over time
SELECT
    order_date,
    COUNT(*) AS orders_today,
    SUM(COUNT(*)) OVER (ORDER BY order_date) AS running_total
FROM orders
GROUP BY order_date
ORDER BY order_date;


-- =============================================================


-- Shows: LAG() — accessing values from neighbouring rows. Sample Usag - comparing each day to the previous day
-- Day-over-day change in order volume
SELECT
    order_date,
    COUNT(*) AS orders_today,
    LAG(COUNT(*)) OVER (ORDER BY order_date) AS orders_yesterday,
    COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY order_date) AS change_vs_yesterday
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- What's happening: LAG(x) returns the value of x from the previous row in the window. 
-- So LAG(COUNT(*)) gives you yesterday's count alongside today's. 
-- Subtract the two and you have day-over-day change. LEAD() works the same way but looks forward instead of backward



-- =============================================================

--Ranking customers by spend
-- Top customers by lifetime spend, with rank
SELECT
    c.name,
    ROUND(SUM(od.quantity * p.price), 2) AS lifetime_spend,
    ROW_NUMBER() OVER (ORDER BY SUM(od.quantity * p.price) DESC) AS row_num,
    RANK()       OVER (ORDER BY SUM(od.quantity * p.price) DESC) AS rank_pos,
    DENSE_RANK() OVER (ORDER BY SUM(od.quantity * p.price) DESC) AS dense_rank_pos
FROM customers c
JOIN orders o         ON o.customer_id = c.customer_id
JOIN order_details od ON od.order_id   = o.order_id
JOIN products p       ON p.product_id  = od.product_id
GROUP BY c.name
ORDER BY lifetime_spend DESC
LIMIT 20;

-- What's happening: Three different ways of numbering rows. If two customers have identical spend:
-- ROW_NUMBER gives them 1 and 2 (arbitrary tie-break)
-- RANK gives them both 1, then skips to 3
-- DENSE_RANK gives them both 1, then 2 (no skip)


-- =============================================================


-- Top 3 highest-revenue products within each department
SELECT *
FROM (
    SELECT
        d.department_name,
        p.product_name,
        ROUND(SUM(od.quantity * p.price), 2) AS revenue,
        RANK() OVER (
            PARTITION BY d.department_name
            ORDER BY SUM(od.quantity * p.price) DESC
        ) AS rank_in_dept
    FROM order_details od
    JOIN products p    ON od.product_id  = p.product_id
    JOIN departments d ON p.department_id = d.department_id
    GROUP BY d.department_name, p.product_name
) ranked
WHERE rank_in_dept <= 3
ORDER BY department_name, rank_in_dept;

-- PARTITION BY d.department_name means "restart the ranking for each department". 
-- The outer query then filters to just the top 3 per partition.



-- =============================================================
-- PART 5  |  AI-ASSISTED QUERY OPTIMISATION
-- =============================================================

-- EXPLAIN ANALYZE on a simple aggregation join
EXPLAIN ANALYZE
SELECT
    c.name,
    COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY order_count DESC;

-- Worked example: the slow query
EXPLAIN (ANALYZE, BUFFERS)
SELECT c.name, SUM(od.quantity * p.price) AS lifetime_spend
FROM customers c
JOIN orders o         ON o.customer_id = c.customer_id
JOIN order_details od ON od.order_id   = o.order_id
JOIN products p       ON p.product_id  = od.product_id
WHERE o.order_date >= '2024-01-01'
GROUP BY c.name
ORDER BY lifetime_spend DESC
LIMIT 20;

-- Candidate indexes to try (run one at a time, re-check EXPLAIN each time)
-- CREATE INDEX idx_orders_order_date       ON orders (order_date);
-- CREATE INDEX idx_orders_customer_date    ON orders (customer_id, order_date);
-- CREATE INDEX idx_order_details_order_id  ON order_details (order_id);
-- CREATE INDEX idx_order_details_product   ON order_details (product_id);


-- =============================================================
-- EXERCISES
-- =============================================================

-- 1. Revenue by department in 2024
-- 2. Drivers with cancellation rate > 10% and at least 100 trips
-- 3. Top 5 customers by lifetime spend with order count and AOV
-- 4. Days where order count was more than double the previous day
-- 5. Pick a query, run EXPLAIN ANALYZE, ask an AI tool what to change,
--    record the suggestion and whether it helped.
