# OmniRetail Sales Analysis

End-to-end data analytics project covering data cleaning, SQL analysis, and Power BI visualization on a simulated retail dataset.


## Project Overview

OmniRetail Pvt. Ltd. is a multi-region retail company operating across 10 stores in 4 regions. This project analyzes 500 sales transactions across 50 products to uncover revenue trends, customer behavior, product performance, and store efficiency.

**Total Revenue Analyzed: $602,640**


## Tools Used

| Tool | Purpose |
|------|---------|
| Microsoft Excel | Data cleaning & restructuring |
| PostgreSQL | Data loading, cleaning & analysis |
| Power BI | Dashboard & visualization |


## Project Files

| File | Description |
|------|-------------|
| `Sales_Data_Messy.xlsx` | Raw messy data (transposed layout, serial dates) |
| `sales.csv` | Cleaned data after Excel processing |
| `products.csv` | Product lookup table (50 products with prices) |
| `SQL Data.sql` | All 30 SQL queries with results |
| `BI Sales Project.pbix` | Power BI dashboard (5 pages) |
| `data_cleaning_notes.md` | Full data cleaning walkthrough |
| `omniretail_presentation.html` | Client-facing project presentation |


## Data Cleaning

### Stage 1 - Excel Cleaning
The raw data (`Sales_Data_Messy.xlsx`) had several issues:
-  Data stored in rows instead of columns (transposed layout)
- Fields not properly structured for database import

**Fix:** Restructured the entire dataset into proper tabular format where each row represents one transaction with 12 columns.

### Stage 2 - SQL Cleaning
After loading into PostgreSQL, a further issue was found:
- `Sale_Date` stored as Excel serial numbers (e.g. `45394` instead of a real date)

**Fix:** Added a new `date_converted` column and converted using:
```sql
alter table sales add column date_converted date

update sales
set date_converted = date '1899-12-30' + sale_date::integer
```


## SQL Analysis - 30 Questions

| # | Question | Answer |
|---|----------|--------|
| 1 | Highest revenue region? | **West** - $178,746 |
| 2 | Highest avg revenue category? | **Electronics** - $2,630.71 |
| 3 | Return rate per category? | Home 12.4%, Electronics 10.5%, Toys 10.4% |
| 4 | Top 5 products by quantity? | Card Game (113), Toy Train (85), Pasta Pack (82) |
| 5 | Lowest revenue, highest sales store? | **S006** - 215 sales, $35,099 revenue |
| 6 | Payment method impact? | Credit Card leads at $162,672 |
| 7 | Top 10 customers by spend? | C0145 leads at $20,165 |
| 8 | Highest sales quarter? | **Q3** — $162,068 |
| 9 | Avg unit price per category? | Electronics $555, Home $464, Clothing $87 |
| 10 | Highest return % category? | **Home** - 12.4% |
| 11 | Highest revenue product? | **Smart Watch** - $48,906 |
| 12 | Highest revenue month? | **December** - $67,724 |
| 13 | Highest return rate store? | **S006** - 18.0% |
| 14 | Revenue by region & category? | West-Home leads at $86,132 |
| 15 | Most popular payment per region? | East: Cash, North: UPI, South: Cash, West: Credit Card |
| 16 | Avg order value per store? | S008 leads at $1,479 |
| 17 | Products never returned? | 19 products with zero returns |
| 18 | Top 5 by revenue? | Smart Watch, Recliner Chair, Smart TV, Tablet, Bluetooth Speaker |
| 19 | Highest return rate quarter? | **Q4** - 12.0% |
| 20 | Unique customers per region? | West (97), South (96), North (92), East (89) |
| 21 | Rank stores by revenue within region | S002 #1 in North ($36,492), S009 #1 in West ($31,576) |
| 22 | Running total of revenue over time | Grew from $246 (Jan 1) to $602,639 (Dec 31) |
| 23 | Month-over-month revenue growth | February saw biggest jump (+$36,343 vs January) |
| 24 | Top 5 products by return rate | Bed Frame (30.8%), Stuffed Animal (28.6%), Monitor (25.0%) |
| 25 | Revenue by product & category | Smart Watch (Electronics) tops at $48,906 |
| 26 | Top selling product per region | East: Tablet, North & South: Smart Watch, West: Recliner Chair |
| 27 | Customer segmentation | 8 High spenders, 70 Mid spenders, 108 Low spenders |
| 28 | Store performance tiers | S009 & S002: Top, S010/S004/S001/S003/S005/S008: Mid |
| 29 | Best & worst quarter per region | West best in Q2 ($69,238), worst in Q1 ($20,959) |
| 30 | Highest avg order value region? | **West** - $1,285.9 |



## Power BI Dashboard

The dashboard has **5 pages:**

1. **Sales Overview** - Total revenue, revenue by region, return rates, payment methods, quarterly & monthly trends
2. **Product Analysis** - Top products by quantity and revenue, category breakdown, average unit prices
3. **Store Analysis** - Revenue by store, transactions, return rates, average order value
4. **Customer & Payments** - Customer segmentation, top 10 customers, payment analysis
5. **Overview** - Executive summary combining key metrics



## Key Business Insights

- **West region dominates** with $178K revenue and highest avg order value ($1,286)
- **Electronics is the premium category** with highest avg unit price ($555) and avg revenue per sale ($2,631)
- **Store 6 needs attention** - lowest revenue ($35K) despite 215 transactions and highest return rate at 18%
- **December is peak month** at $67.7K - more than double January
- **Bed Frame has a 30.8% return rate** - well above the 9.8% company average
- **Only 8 out of 186 customers are high spenders** - a key retention opportunity
- **Credit Card leads revenue** at $162.7K with the highest avg transaction value of $1,251



## Author

**Mahil Joarder**
Data Analyst | SQL • Excel • Power BI

**GitHub:** github.com/mahiljoarder 
