# Week 7 — Conditional Logic: CASE Statements

**SQL & AI Bootcamp · Session 7 of 14 · Saturday, 2 May 2026**
**Instructor:** Stephen · **Environment:** GitHub Codespaces · BootcampDB

---

## Learning Objectives

By the end of this session, you will be able to:

- Write a **Simple CASE** expression to map exact values to labels
- Write a **Searched CASE** expression for range and conditional logic
- Use CASE inside `SELECT` to create new derived columns
- Combine CASE with aggregate functions like `SUM` and `COUNT`
- Apply CASE inside `ORDER BY` to control custom sort order
- Nest CASE expressions to handle multi-level categorisation
- Handle `NULL` values correctly inside CASE logic
- Spot and fix the most common CASE mistakes

---

## Contents

1. [Setup — vw_orders](#1-setup--vw_orders)
2. [What is a CASE expression?](#2-what-is-a-case-expression)
3. [Simple CASE — mapping exact values](#3-simple-case--mapping-exact-values)
4. [Searched CASE — evaluating conditions](#4-searched-case--evaluating-conditions)
5. [CASE inside aggregate functions](#5-case-inside-aggregate-functions)
6. [CASE inside ORDER BY](#6-case-inside-order-by)
7. [Nested CASE](#7-nested-case)
8. [NULL handling inside CASE](#8-null-handling-inside-case)
9. [Common mistakes](#9-common-mistakes)
10. [Classwork exercises](#10-classwork-exercises)
11. [Key takeaways](#11-key-takeaways)

---

## 1. Setup — vw_orders

We are reusing the `vw_orders` view built in Session 6. Run the block below to drop and recreate it so everyone starts from the same data. No tables needed — everything lives inside the view.

> **To update values live:** edit any row inside `VALUES(...)`, then re-run the full `DROP VIEW` + `CREATE VIEW` block.

```sql
-- Drop and recreate — run both blocks together
DROP VIEW IF EXISTS vw_orders;
GO

CREATE VIEW vw_orders AS
SELECT *
FROM (
    VALUES
    --  order_id  customer   product        order_date     qty  unit_price  promo_code
        (1,  'Alice',  'Latte',       '2024-01-05',   2,   3.50, 'SAVE10'),
        (2,  'Bob',    'Espresso',    '2024-01-12',   1,   2.00,  NULL   ),
        (3,  'Clara',  'Cappuccino',  '2024-02-03',   3,   3.20, 'SAVE10'),
        (4,  'David',  'Latte',       '2024-02-18',   1,   3.50,  NULL   ),
        (5,  'Eve',    'Tea',         '2024-03-07',   4,   1.80,  NULL   ),
        (6,  'Frank',  'Espresso',    '2024-03-22',   2,   2.00, 'VIP20' ),
        (7,  'Grace',  'Cappuccino',  '2024-04-10',   1,   3.20,  NULL   ),
        (8,  'Henry',  'Latte',       '2024-04-25',   5,   3.50, 'VIP20' ),
        (9,  'Isla',   'Tea',         '2024-05-01',   2,   1.80,  NULL   ),
        (10, 'James',  'Espresso',    '2024-05-14',   3,   2.00, 'SAVE10')
) AS t(order_id, customer, product, order_date, qty, unit_price, promo_code);
GO

-- Quick sanity check — you should see 10 rows
SELECT * FROM vw_orders;
```

> ✅ If you see 10 rows with all columns above, you are good to go. Every query in today's session runs against this view.

---

## 2. What is a CASE expression?

CASE is SQL's built-in way to apply if–then–else logic directly inside a query. It always returns a single value — a label, a number, or a NULL — and can appear almost anywhere in a SELECT statement: in a column list, inside an aggregate function, or inside ORDER BY.

There are two forms. They look different but do the same job — use whichever reads most naturally for the problem.

**Simple CASE** — match exact values:

```sql
CASE column
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE             fallback
END
```

**Searched CASE** — evaluate conditions:

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE                 fallback
END
```

> ⚠️ **Important:** SQL evaluates WHEN branches top-to-bottom and stops at the first match. Order your conditions from most specific to least specific — if two conditions could both be true, only the first one fires.

---

## 3. Simple CASE — mapping exact values

Use Simple CASE when you are matching a single column against a known list of values. It is clean and readable for lookups and label replacements.

### 3.1 Friendly product labels

```sql
SELECT
    customer,
    product,
    CASE product
        WHEN 'Latte'      THEN 'Latte (Hot)'
        WHEN 'Espresso'   THEN 'Espresso Shot'
        WHEN 'Cappuccino' THEN 'Cappuccino (Frothy)'
        WHEN 'Tea'        THEN 'Tea (Herbal)'
        ELSE                   'Other'
    END AS display_name
FROM vw_orders;
```

### 3.2 Promo code descriptions

```sql
SELECT
    customer,
    promo_code,
    CASE promo_code
        WHEN 'SAVE10' THEN '10% Saver Discount'
        WHEN 'VIP20'  THEN 'VIP 20% Off'
        ELSE               'No Promotion'
    END AS promotion_description
FROM vw_orders;
```

> 💡 Notice the `ELSE` clause handles `NULL` automatically here — `NULL` does not match any `WHEN`, so it falls through to `ELSE` and gets labelled 'No Promotion'. This is often cleaner than a separate `IS NULL` check.

---

## 4. Searched CASE — evaluating conditions

Use Searched CASE when your logic involves ranges, comparisons, or combinations — anything more complex than a straight equality match. This is the form you will use most often in practice.

### 4.1 Price tier — categorising by unit_price

```sql
SELECT
    customer,
    product,
    unit_price,
    CASE
        WHEN unit_price < 2.00                    THEN 'Budget'
        WHEN unit_price BETWEEN 2.00 AND 2.99     THEN 'Standard'
        WHEN unit_price >= 3.00                   THEN 'Premium'
        ELSE                                           'Unknown'
    END AS price_tier
FROM vw_orders;
```

### 4.2 Order size — categorising by qty

```sql
SELECT
    customer,
    product,
    qty,
    CASE
        WHEN qty = 1             THEN 'Small'
        WHEN qty BETWEEN 2 AND 3 THEN 'Medium'
        WHEN qty >= 4            THEN 'Large'
    END AS order_size
FROM vw_orders;
```

### 4.3 Revenue flag — calculated expression inside CASE

CASE can evaluate any valid expression — not just raw column values.

```sql
SELECT
    customer,
    product,
    qty,
    unit_price,
    qty * unit_price AS line_total,
    CASE
        WHEN qty * unit_price >= 10 THEN 'High Value'
        WHEN qty * unit_price >= 5  THEN 'Mid Value'
        ELSE                             'Low Value'
    END AS value_band
FROM vw_orders;
```

> ⚠️ You cannot reference an alias (like `line_total`) inside the same SELECT's CASE — SQL hasn't computed it yet. Always repeat the full expression: `qty * unit_price`.

---

## 5. CASE inside aggregate functions

This is one of the most powerful patterns in SQL. Wrapping a CASE inside `SUM` or `COUNT` lets you pivot row-level data into columns — summing or counting only the rows that meet a condition, while ignoring the rest.

### 5.1 Conditional COUNT — promo vs non-promo orders per product

```sql
SELECT
    product,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN promo_code IS NOT NULL THEN 1 END) AS promo_orders,
    COUNT(CASE WHEN promo_code IS NULL     THEN 1 END) AS non_promo_orders
FROM vw_orders
GROUP BY product;
```

### 5.2 Conditional SUM — revenue split by price tier

```sql
SELECT
    SUM(CASE WHEN unit_price < 2.00                  THEN qty * unit_price ELSE 0 END) AS budget_revenue,
    SUM(CASE WHEN unit_price BETWEEN 2.00 AND 2.99   THEN qty * unit_price ELSE 0 END) AS standard_revenue,
    SUM(CASE WHEN unit_price >= 3.00                 THEN qty * unit_price ELSE 0 END) AS premium_revenue
FROM vw_orders;
```

### 5.3 Pivot-style report — qty by product across order size bands

```sql
SELECT
    product,
    SUM(CASE WHEN qty = 1              THEN qty ELSE 0 END) AS small_qty,
    SUM(CASE WHEN qty BETWEEN 2 AND 3  THEN qty ELSE 0 END) AS medium_qty,
    SUM(CASE WHEN qty >= 4             THEN qty ELSE 0 END) AS large_qty
FROM vw_orders
GROUP BY product
ORDER BY product;
```

> 🔑 **Pattern to remember:**
> - For `SUM`: use `ELSE 0` so non-matching rows add zero rather than NULL.
> - For `COUNT`: omit `ELSE` so non-matching rows return NULL, which COUNT ignores automatically.

> 🔍 **Live demo:** Stephen adds a new row to the view with qty = 6. Watch the `large_qty` column update instantly when you re-run — no query changes needed.

---

## 6. CASE inside ORDER BY

CASE in `ORDER BY` lets you define a custom sort sequence that doesn't follow alphabetical or numeric order. Useful when you want a priority ordering — e.g. Premium first, then Standard, then Budget.

```sql
SELECT
    customer,
    product,
    unit_price,
    CASE
        WHEN unit_price >= 3.00                  THEN 'Premium'
        WHEN unit_price BETWEEN 2.00 AND 2.99    THEN 'Standard'
        ELSE                                          'Budget'
    END AS price_tier
FROM vw_orders
ORDER BY
    CASE
        WHEN unit_price >= 3.00                  THEN 1
        WHEN unit_price BETWEEN 2.00 AND 2.99    THEN 2
        ELSE                                          3
    END,
    customer ASC;
```

> 💡 The CASE in ORDER BY returns numbers (1, 2, 3). SQL sorts those numbers ascending, so 1 appears first. These sort numbers are invisible in the result set — they only control row order.

---

## 7. Nested CASE

You can place a CASE expression inside the `THEN` or `ELSE` of another CASE. Use this sparingly — it becomes hard to read quickly. If nesting goes beyond two levels, a CTE or WHERE-based split is usually cleaner.

```sql
SELECT
    customer,
    product,
    qty,
    promo_code,
    CASE
        WHEN promo_code = 'VIP20'
            THEN CASE
                WHEN qty >= 4 THEN 'VIP — Large Order'
                ELSE               'VIP — Standard Order'
            END
        WHEN promo_code IS NOT NULL
            THEN 'Promo — Non-VIP'
        ELSE         'No Promo'
    END AS customer_segment
FROM vw_orders;
```

---

## 8. NULL handling inside CASE

`NULL` never matches a WHEN condition using `=` or `<>`. If you need to catch NULLs in a CASE, you must use `IS NULL` explicitly in a Searched CASE, or rely on the `ELSE` fallback.

| Pattern | What happens with NULL input | Verdict |
|---|---|---|
| `CASE col WHEN NULL THEN ...` | Never matches — `NULL = NULL` is false in SQL | ❌ Wrong |
| `CASE WHEN col IS NULL THEN ...` | Correctly catches NULL values | ✅ Correct |
| `CASE col WHEN ... ELSE 'Unknown' END` | NULLs fall through to ELSE | ✅ Often fine |
| `CASE WHEN col = 'X' THEN ... END` (no ELSE) | Returns NULL for all non-matching rows | ⚠️ Intended? |

### Correctly flagging promo_code NULLs

```sql
SELECT
    customer,
    promo_code,
    CASE
        WHEN promo_code IS NULL     THEN 'No code used'
        WHEN promo_code = 'VIP20'  THEN 'VIP customer'
        WHEN promo_code = 'SAVE10' THEN 'Saver customer'
        ELSE                            'Unknown code'
    END AS promo_status
FROM vw_orders;
```

---

## 9. Common mistakes

| Mistake | What goes wrong | Fix |
|---|---|---|
| Forgetting `END` | Syntax error — the parser keeps looking for more CASE content | Every CASE needs a matching END |
| Overlapping WHEN ranges, wrong order | First matching WHEN fires — later ones are silently skipped | Put the most specific condition first |
| No `ELSE` clause | Unmatched rows return NULL — often invisible until downstream | Always add ELSE, or know you want NULL |
| Using alias in same SELECT's CASE | Alias doesn't exist yet when CASE evaluates | Repeat the full expression |
| `CASE col WHEN NULL` | Never matches — NULL comparison with `=` is always false | Use `CASE WHEN col IS NULL` |
| Mixing data types in THEN/ELSE | Implicit conversion errors or unexpected results | Keep all THEN/ELSE values the same data type |
| `SUM(CASE...)` without `ELSE 0` | NULL rows can corrupt the total | Always add `ELSE 0` inside `SUM(CASE...)` |

---

## 10. Classwork exercises

Work individually or in pairs. Write your SQL in Codespaces, run it, and be ready to share your screen.

---

**Exercise 1**

Add a column called `drink_category` that labels each product as `'Hot Drink'` (Latte or Cappuccino), `'Coffee Shot'` (Espresso), or `'Cold Drink'` (Tea). Return customer, product, and your new column.

> Hint: Simple CASE on the product column.

---

**Exercise 2**

Create a column called `spend_band` based on the total line value (`qty × unit_price`): `'Under £5'`, `'£5–£10'`, or `'Over £10'`. Show customer, product, the calculated total, and your band.

> Hint: Searched CASE using `qty * unit_price` in the WHEN conditions.

---

**Exercise 3**

Write a GROUP BY query that shows, for each product: total orders, the count of orders with a promo code, and the count without one. Name your columns clearly.

> Hint: `COUNT(CASE WHEN ... THEN 1 END)` — remember no ELSE for COUNT.

---

**Exercise 4**

Return all orders sorted so that VIP20 promo orders appear first, then SAVE10 orders, then orders with no promo code. Within each group, sort by customer name A–Z.

> Hint: CASE in ORDER BY returning numeric priorities.

---

**Exercise 5 — stretch**

Build a single summary row (no GROUP BY) showing total revenue split into three columns: `premium_revenue` (unit_price ≥ £3.00), `standard_revenue` (£2.00–£2.99), and `budget_revenue` (below £2.00).

> Hint: `SUM(CASE ... ELSE 0 END)` — three separate SUM/CASE expressions in one SELECT.

---

## 11. Key takeaways

- **Simple CASE** matches exact values — use it for clean lookup-style replacements
- **Searched CASE** evaluates conditions — use it for ranges, comparisons, and combinations
- SQL evaluates WHEN branches **top-to-bottom** — first match wins, put most specific conditions first
- CASE inside `SUM`/`COUNT` pivots row data into columns — a fundamental reporting pattern
- Use `ELSE 0` with `SUM` and **no ELSE** with `COUNT` to handle non-matching rows correctly
- CASE in `ORDER BY` returns sort numbers — lets you define priority sequences beyond A–Z
- `NULL` never matches a WHEN using `=` — always use `IS NULL` explicitly to catch it
- Always close every CASE with `END` — and add an `ELSE` unless you deliberately want NULLs

---

## Further reading

- *Learning SQL* — Alan Beaulieu, Chapter 11 (Conditional Logic)
- [T-SQL CASE expression docs — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/case-transact-sql)
- [IIF() — T-SQL shorthand for simple two-branch CASE](https://learn.microsoft.com/en-us/sql/t-sql/functions/logical-functions-iif-transact-sql)

---

*The AI Workshop CIC · theaiworkshop.co.uk · Session 7 of 14 · Week beginning 2 May 2026*
