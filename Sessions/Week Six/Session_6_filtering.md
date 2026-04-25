# Session 04 — Filtering Data
### WHERE, HAVING, and Filtering Strategies · Building Precise Analytical Queries

> **Instructor:** Stephen  
> **Format:** Live Online · SQL & AI Bootcamp  
> **Dataset:** BootcampDB (NHS-inspired)  
> **Pre-requisite:** Session 03 — Query Primer

---

## 🎯 Learning Objectives

By the end of this session, you will be able to:

- Use `WHERE` to filter rows before aggregation
- Use `HAVING` to filter groups after aggregation
- Combine `AND`, `OR`, and `NOT` with parentheses for precise filtering
- Apply range, membership, and pattern-matching conditions
- Handle `NULL` values correctly in filter logic
- Build and query reusable **views** to test and observe filtering behaviour live

---

## 🏗️ Setup — Create Your Views

> 💡 **How this works:** We have two views below. Each view has its own `INSERT` statements.  
> Stephen will **update the inserted values live** during the session so you can watch the filter results change in real time.  
> You only need to re-run the `INSERT` block and then re-query the view — no need to recreate the view itself.

---

### View 1 — `vw_patient_appointments`

This view represents outpatient appointment data. We'll use it to explore `WHERE`, range conditions, `BETWEEN`, `IN`, `LIKE`, and `NULL` handling.

```sql
-- ============================================================
-- DROP (run this first if you're resetting)
-- ============================================================
DROP VIEW IF EXISTS vw_patient_appointments;
DROP TABLE IF EXISTS patient_appointments;

-- ============================================================
-- CREATE TABLE
-- ============================================================
CREATE TABLE patient_appointments (
    appointment_id   INT           PRIMARY KEY,
    patient_name     VARCHAR(100)  NOT NULL,
    department       VARCHAR(50)   NOT NULL,
    appointment_date DATE          NOT NULL,
    attended         CHAR(1),          -- 'Y', 'N', or NULL (unknown)
    wait_days        INT,              -- days waited for appointment
    referral_source  VARCHAR(50)
);

-- ============================================================
-- INSERT — Stephen will update these values live in class
-- ============================================================
INSERT INTO patient_appointments VALUES
(1,  'James Okafor',      'Cardiology',    '2024-01-10', 'Y', 12,  'GP'),
(2,  'Amara Patel',       'Neurology',     '2024-02-14', 'Y', 28,  'A&E'),
(3,  'Linda Thornton',    'Cardiology',    '2024-03-05', 'N', 5,   'GP'),
(4,  'David Mensah',      'Orthopaedics',  '2024-03-20', 'Y', 45,  'GP'),
(5,  'Sophie Williams',   'Dermatology',   '2024-04-01', 'N', 7,   'Self'),
(6,  'Ravi Sharma',       'Neurology',     '2024-04-15', 'Y', 33,  'GP'),
(7,  'Fatima Al-Hassan',  'Cardiology',    '2024-05-02', NULL,18,  'A&E'),
(8,  'Tom Briggs',        'Orthopaedics',  '2024-05-18', 'Y', 60,  'GP'),
(9,  'Ngozi Eze',         'Dermatology',   '2024-06-01', 'Y', 3,   NULL),
(10, 'Marcus Reid',       'Cardiology',    '2024-06-22', 'N', 22,  'Self');

-- ============================================================
-- CREATE VIEW
-- ============================================================
CREATE VIEW vw_patient_appointments AS
SELECT
    appointment_id,
    patient_name,
    department,
    appointment_date,
    attended,
    wait_days,
    referral_source
FROM patient_appointments;
```

---

### View 2 — `vw_ward_referrals`

This view represents ward-level referral summaries. We'll use it to explore `GROUP BY`, `HAVING`, and aggregate filtering — showing the difference between `WHERE` and `HAVING` clearly.

```sql
-- ============================================================
-- DROP (run this first if you're resetting)
-- ============================================================
DROP VIEW IF EXISTS vw_ward_referrals;
DROP TABLE IF EXISTS ward_referrals;

-- ============================================================
-- CREATE TABLE
-- ============================================================
CREATE TABLE ward_referrals (
    referral_id      INT           PRIMARY KEY,
    ward_name        VARCHAR(50)   NOT NULL,
    referral_source  VARCHAR(50)   NOT NULL,
    wait_days        INT           NOT NULL,
    outcome          VARCHAR(20)   NOT NULL   -- 'Admitted', 'Discharged', 'DNA'
);

-- ============================================================
-- INSERT — Stephen will update these values live in class
-- ============================================================
INSERT INTO ward_referrals VALUES
(1,  'Cardiac Ward',     'GP',    14, 'Admitted'),
(2,  'Cardiac Ward',     'A&E',   2,  'Admitted'),
(3,  'Cardiac Ward',     'GP',    20, 'Discharged'),
(4,  'Neurology Ward',   'GP',    30, 'Admitted'),
(5,  'Neurology Ward',   'Self',  5,  'DNA'),
(6,  'Neurology Ward',   'A&E',   1,  'Admitted'),
(7,  'Orthopaedic Ward', 'GP',    45, 'Admitted'),
(8,  'Orthopaedic Ward', 'GP',    50, 'Admitted'),
(9,  'Orthopaedic Ward', 'A&E',   3,  'Discharged'),
(10, 'Dermatology Ward', 'Self',  8,  'DNA'),
(11, 'Dermatology Ward', 'GP',    12, 'Admitted'),
(12, 'Dermatology Ward', 'GP',    9,  'Discharged');

-- ============================================================
-- CREATE VIEW
-- ============================================================
CREATE VIEW vw_ward_referrals AS
SELECT
    referral_id,
    ward_name,
    referral_source,
    wait_days,
    outcome
FROM ward_referrals;
```

---

## 📖 Part 1 — WHERE Clause Fundamentals

The `WHERE` clause filters **rows** before any grouping or aggregation happens. Think of it as a bouncer at the door — rows that don't meet the condition never get in.

---

### 1.1 Equality and Inequality

```sql
-- All Cardiology appointments
SELECT * FROM vw_patient_appointments
WHERE department = 'Cardiology';

-- Everyone except Cardiology
SELECT * FROM vw_patient_appointments
WHERE department <> 'Cardiology';
```

> 🔍 **Watch:** Update the INSERT to change a department and re-run — the results shift instantly.

---

### 1.2 AND, OR — Combining Conditions

```sql
-- Cardiology AND attended
SELECT * FROM vw_patient_appointments
WHERE department = 'Cardiology'
AND attended = 'Y';

-- Cardiology OR Neurology
SELECT * FROM vw_patient_appointments
WHERE department = 'Cardiology'
OR department = 'Neurology';
```

---

### 1.3 Using Parentheses — Controlling Evaluation Order

> ⚠️ Without parentheses, `AND` binds more tightly than `OR` — just like multiplication before addition in maths. Always use parentheses when mixing both.

```sql
-- (Cardiology OR Neurology) AND attended = 'Y'
SELECT * FROM vw_patient_appointments
WHERE (department = 'Cardiology' OR department = 'Neurology')
AND attended = 'Y';

-- Compare: without parentheses — this means something different!
SELECT * FROM vw_patient_appointments
WHERE department = 'Cardiology'
OR department = 'Neurology'
AND attended = 'Y';
```

---

### 1.4 NOT Operator

```sql
-- Everyone who did NOT attend
SELECT * FROM vw_patient_appointments
WHERE NOT attended = 'Y';

-- More readable equivalent
SELECT * FROM vw_patient_appointments
WHERE attended <> 'Y';
```

---

### 1.5 Range Conditions — BETWEEN

```sql
-- Appointments in Q1 2024 (inclusive)
SELECT * FROM vw_patient_appointments
WHERE appointment_date BETWEEN '2024-01-01' AND '2024-03-31';

-- Wait times between 10 and 30 days
SELECT * FROM vw_patient_appointments
WHERE wait_days BETWEEN 10 AND 30;
```

> 💡 `BETWEEN` is always **inclusive** on both ends. Lower value must come first.

---

### 1.6 Membership Conditions — IN and NOT IN

```sql
-- Cardiology or Neurology (cleaner than two OR conditions)
SELECT * FROM vw_patient_appointments
WHERE department IN ('Cardiology', 'Neurology');

-- Everyone except GP referrals
SELECT * FROM vw_patient_appointments
WHERE referral_source NOT IN ('GP', 'Self');
```

---

### 1.7 Pattern Matching — LIKE

```sql
-- Patients whose name starts with 'A'
SELECT * FROM vw_patient_appointments
WHERE patient_name LIKE 'A%';

-- Patients whose name contains 'a' anywhere
SELECT * FROM vw_patient_appointments
WHERE patient_name LIKE '%a%';

-- Departments ending in 'ology'
SELECT * FROM vw_patient_appointments
WHERE department LIKE '%ology';
```

| Wildcard | Meaning |
|---|---|
| `%` | Any number of characters (including zero) |
| `_` | Exactly one character |

---

### 1.8 NULL — The Special Case

> ⚠️ `NULL` means *unknown*. You **cannot** test for NULL with `=`. You must use `IS NULL` or `IS NOT NULL`.

```sql
-- Appointments where attendance status is unknown
SELECT * FROM vw_patient_appointments
WHERE attended IS NULL;

-- Appointments with a known referral source
SELECT * FROM vw_patient_appointments
WHERE referral_source IS NOT NULL;

-- ❌ This will NOT work — returns 0 rows even if NULLs exist
SELECT * FROM vw_patient_appointments
WHERE attended = NULL;
```

> 🔍 **Watch:** Notice what happens when we try the broken `= NULL` version vs `IS NULL`.

---

### 1.9 NULL in Range Queries — A Common Trap

```sql
-- ⚠️ This misses rows where attended IS NULL
SELECT * FROM vw_patient_appointments
WHERE attended <> 'Y';

-- ✅ Correct — explicitly include NULLs
SELECT * FROM vw_patient_appointments
WHERE attended <> 'Y'
OR attended IS NULL;
```

---

## 📖 Part 2 — HAVING Clause

`HAVING` filters **groups** after `GROUP BY` has run — it works on aggregate results, not individual rows.

| | WHERE | HAVING |
|---|---|---|
| Filters | Rows | Groups |
| Runs | Before GROUP BY | After GROUP BY |
| Can use aggregates? | ❌ No | ✅ Yes |

---

### 2.1 Basic GROUP BY Without Filtering

```sql
-- How many referrals per ward?
SELECT ward_name, COUNT(*) AS total_referrals
FROM vw_ward_referrals
GROUP BY ward_name;
```

---

### 2.2 WHERE Before Grouping

```sql
-- Only count GP referrals per ward
SELECT ward_name, COUNT(*) AS gp_referrals
FROM vw_ward_referrals
WHERE referral_source = 'GP'
GROUP BY ward_name;
```

---

### 2.3 HAVING After Grouping

```sql
-- Only show wards with more than 2 referrals total
SELECT ward_name, COUNT(*) AS total_referrals
FROM vw_ward_referrals
GROUP BY ward_name
HAVING COUNT(*) > 2;

-- Wards where average wait time exceeds 15 days
SELECT ward_name, AVG(wait_days) AS avg_wait
FROM vw_ward_referrals
GROUP BY ward_name
HAVING AVG(wait_days) > 15;
```

---

### 2.4 WHERE and HAVING Together

```sql
-- Among GP referrals only, show wards with avg wait > 10 days
SELECT ward_name,
       COUNT(*)        AS gp_referrals,
       AVG(wait_days)  AS avg_wait_days
FROM vw_ward_referrals
WHERE referral_source = 'GP'
GROUP BY ward_name
HAVING AVG(wait_days) > 10
ORDER BY avg_wait_days DESC;
```

> 🔍 **Watch:** Stephen will change the `wait_days` values in the INSERT and re-run — watch which wards cross the threshold.

---

## ✏️ Classwork

Work individually or in pairs. Write the SQL, run it against the views, and be ready to share your screen.

---

### Classwork 1 — Querying the Views

Answer each question using `vw_patient_appointments` or `vw_ward_referrals`.

**Q1.** Find all patients referred by `'A&E'` who waited more than 10 days. Return their name, department, and wait time.

**Q2.** Find all appointments in Cardiology or Orthopaedics where the patient attended (`'Y'`). Use parentheses correctly.

**Q3.** List all patients whose name starts with the letter `'R'` or ends with the letter `'n'`. *(Hint: two LIKE conditions with OR)*

**Q4.** Find all appointments where the referral source is unknown (`NULL`) **or** the attendance status is unknown (`NULL`).

**Q5.** Using `vw_ward_referrals`, show only the wards where the **total number of admissions** (outcome = `'Admitted'`) is **2 or more**. *(Hint: WHERE + GROUP BY + HAVING)*

---

### Classwork 2 — Build Your Own View

Your turn to create a view from scratch.

**Scenario:** You are an analyst at an NHS trust. Create a table and view called `vw_my_ward_data` that represents a ward or department of your choice (real or fictional). Your view must include:

| Requirement | Detail |
|---|---|
| At least 5 columns | Include at least one date, one numeric, one text, and one nullable column |
| At least 8 rows | Mix the data so filters return interesting results |
| DROP + CREATE + INSERT | Structure it exactly as shown in the session setup above |

Once your view is created, write **three queries** against it that use at least one each of:

- A `WHERE` clause with `AND` / `OR`
- `BETWEEN` or `IN`
- `IS NULL` or `IS NOT NULL`

Be ready to demo your view and queries to the group.

---

## 📝 Key Takeaways

- `WHERE` filters rows **before** grouping — it cannot reference aggregate functions
- `HAVING` filters groups **after** `GROUP BY` — it works on aggregated results
- Always use **parentheses** when mixing `AND` and `OR` to make your intent explicit
- `NULL` means *unknown* — always test with `IS NULL` / `IS NOT NULL`, never `= NULL`
- `BETWEEN` is inclusive on both ends — always put the lower value first
- `IN` keeps your code clean when filtering against multiple values
- `LIKE` with `%` and `_` wildcards handles partial string matches

---

## 📚 Further Reading

- *Learning SQL* — Alan Beaulieu, Chapter 4 (Filtering) & Chapter 8 (Grouping and Aggregates)
- [SQL Server WHERE clause docs](https://learn.microsoft.com/en-us/sql/t-sql/queries/where-transact-sql)
- [SQL Server HAVING clause docs](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-having-transact-sql)

---

*The AI Workshop CIC · theaiworkshop.co.uk*
