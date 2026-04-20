# SQL Aggregation Session — Setup Guide

**AI Workshop SQL Bootcamp | Week 3 Guest Session**

## What's in this folder

| File | Purpose |
|------|---------|
| `notes/sql_aggregation_session.docx` | The main teaching handout. Follow along during the session. |
| `sql/sql_aggregation_snippets.sql` | All SQL examples from the session, ready to run. |
| `sql/00_setup.sql` | Creates the seven tables and loads the data. **Run this first.** |
| `data/` | The CSV files used by the setup script. |

## Before the session

Make sure you have a PostgreSQL database you can connect to. If you did Week 1 of the bootcamp you already have this. Any empty database will do.

## Loading the data

### Option A: psql (easiest)

Open a terminal in the folder ai-workshop-sql that contains folders like sql/ and data/, and connect to DB:
 psql -h <host> -p 5432 -U <username> -d <database_name>
--      For example, if you have Postgres running locally with the default user and database called dataeng_db:
--        psql -h localhost -p 5432 -U postgres -d dataeng_db 

```bash
psql -h <host> -p 5432 -U <username> -d <database_name> 
```
For example, if you have Postgres running locally with the default user and database called dataeng_db:

```bash
psql -h localhost -p 5432 -U postgres -d dataeng_db 
```


```sql
\i sql/00_setup.sql
```

You should see row counts at the end confirming:

```
departments         6
drivers            50
customers         500
products        1,000
orders         10,000
order_details  29,727
delivery_trips 10,000
```

### Option B: pgAdmin or DBeaver

The `\COPY` commands in `00_setup.sql` are psql-specific and won't run in GUI tools. You have two choices:

1. Run the CREATE TABLE statements from `00_setup.sql` in the GUI, then use the GUI's CSV import feature on each table. Load in this order so foreign keys don't complain: departments, drivers, customers, products, orders, order_details, delivery_trips.
2. Install psql (it's tiny) and use Option A. This is what I'd recommend.

## Running the session queries

Once data is loaded, open `sql_aggregation_snippets.sql` and work through it. Every example runs against the tables you just created.

## About the data

This is an e-commerce and delivery dataset: customers place orders, orders contain products, trips deliver orders. The numbers are realistic but synthetic, so don't try to trace any real company.

One thing worth knowing: `order_details` contains 51 duplicate (order_id, product_id) pairs. That's deliberate. It's what real source data looks like before it gets cleaned. Data quality is covered properly in Week 10.

## If something goes wrong

- **"permission denied" on \COPY** — you're probably trying to use server-side `COPY` instead of psql's client-side `\COPY`. The leading backslash matters.
- **"relation does not exist"** — setup didn't run cleanly. Run `00_setup.sql` again; it's safe to re-run.
- **"could not open file"** — your working directory isn't the folder containing `data/`. cd into this folder before starting psql.
