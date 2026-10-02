# Customer Intelligence & Revenue Analytics (SQL)

A practical SQL portfolio project built around a simulated e-commerce business.

## What this project does

The project looks at sales, customers, products, payments, returns and inventory and answers common business questions a junior Data Analyst might receive.

The focus is on writing useful SQL rather than using complicated SQL just to make the project look advanced.

## Business areas

- Sales and revenue
- Customer purchasing behaviour
- Repeat customers
- Acquisition channels
- Product performance
- Estimated profitability
- Returns and refunds
- Customer inactivity
- RFM-style customer grouping
- Month-over-month revenue

## Database

```text
customers
    |
    +---- orders
              |
              +---- order_items ---- products
              |
              +---- payments

order_items ---- returns

products ---- inventory
```

## Dataset

The data is synthetic and created only for this portfolio project.


tableRowsCustomers1000Products100Orders5000Order items9097Payment4649Inventory1200Returns650  
## SQL skills shown

The project uses the kind of SQL expected from a Data Analyst fresher:

- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- COUNT, SUM, AVG
- CASE
- INNER JOIN
- LEFT JOIN
- COALESCE
- NULLIF
- Subqueries
- CTEs
- Date functions
- ROW_NUMBER
- RANK
- DENSE_RANK
- LAG

The window functions are used for specific questions such as purchase gaps, rankings and month-over-month revenue.

## Selected project numbers

- Completed orders: **4,423**
- Active customers: **891**
- Repeat customers: **743**
- Average order value: **₹22,074.36**
- Completed-order revenue: **₹97,634,912.50**
- Refund amount: **₹6,215,262.50**
- Highest-revenue category: **Electronics**
- Highest-revenue product: **TechNova Laptop 01**

## How to run

1. Start MySQL in XAMPP.
2. Open phpMyAdmin.
3. Run `database/01_schema.sql`.
4. Run `database/02_seed_data.sql`.
5. Run `database/03_data_quality.sql`.
6. Run the files in `analysis/`.

CSV copies of the generated tables are also included in `data/`.

## Project workflow

```text
Database design
      ↓
Load data
      ↓
Data quality checks
      ↓
Sales analysis
      ↓
Customer analysis
      ↓
Product & profitability analysis
      ↓
Returns analysis
      ↓
Retention / RFM
      ↓
Business insights
```

## Portfolio note

This is a simulated dataset. The numbers and customer records do not represent a real company or real customers.

