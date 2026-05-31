# Data Cleaning Notes — OmniRetail Sales Analysis

## Overview

The raw data came in a messy, unusable state. Before any analysis could begin, two rounds of cleaning were needed — first in Excel, then in SQL. This document walks through exactly what was wrong and how it was fixed.

---

## The Raw Data

The original file (`Sales_Data_csv.xlsx`) had two major structural problems:

**Problem 1 — Transposed layout**
The data was stored sideways. Instead of each row being one transaction, each column was one transaction and each row was a field (Sale_ID, Sale_Date, Product_ID, etc.). This is the opposite of how a database or any analysis tool expects data to look.

**Problem 2 — All unit prices were identical**
Every single transaction had the same unit price of $200.59, regardless of what product was sold. A Smart TV and a pack of coffee beans had the same price. This made the revenue figures completely meaningless.

---

## Stage 1 — Excel Cleaning

Before loading anything into SQL, the Excel file needed to be restructured manually.

**What was done:**
- Transposed the entire dataset so that each row represents one transaction
- Ensured all 12 columns were properly labeled: Sale_ID, Sale_Date, Customer_ID, Product_ID, Product_Category, Store_ID, Region, Quantity_Sold, Unit_Price, Payment_Method, Returned, Total_Sale_Amount
- Verified data consistency across all 500 rows

The result was `sales.csv` — a clean, properly structured file ready to load into PostgreSQL.

**Why not fix the unit prices in Excel?**
The correct unit prices lived in a separate file — `products.csv` — which contained all 50 products with their proper prices. Rather than doing a manual VLOOKUP for 500 rows, this was handled properly in SQL using a JOIN, which is the correct approach for relational data.

---

## Stage 2 — SQL Cleaning

After loading `sales.csv` into PostgreSQL, one more issue was discovered:

**Problem — Serial date format**
The `Sale_Date` column contained numbers like `45394` instead of real dates. These are Excel serial numbers — Excel stores dates as the number of days since January 1, 1900. PostgreSQL does not understand this format and cannot perform any date-based analysis on it.

**Fix — Added a converted date column**

Rather than overwriting the original data, a new column was added to preserve the raw values while making the dates usable:

```sql
alter table sales add column date_converted date

update sales
set date_converted = date '1899-12-30' + sale_date::integer
```

This converts the serial number to a proper date. For example, `45394` becomes `2024-03-15`. All date-based queries in this project use `date_converted`.

---

## The Two-Table Structure

The final database uses two tables:

| Table | Rows | Purpose |
|-------|------|---------|
| `sales` | 500 | All transaction records |
| `products` | 50 | Product names and correct unit prices |

These are linked by `Product_ID`. Any query that needs a product name or correct unit price uses a JOIN:

```sql
select p.product_name, sum(s.total_sale_amount) as total_revenue
from sales as s
join products as p on s.product_id = p.product_id
group by 1
order by 2 desc
```

This structure is cleaner, more scalable, and reflects how real retail databases are designed.

---

## Summary

| Stage | Tool | Problem Fixed |
|-------|------|---------------|
| 1 | Excel | Transposed layout restructured into proper rows and columns |
| 2 | SQL | Serial dates converted to real dates using date arithmetic |
| 2 | SQL | Unit prices corrected by joining the products lookup table |

After these three fixes, the data was clean, consistent, and ready for the full 30-query analysis.
