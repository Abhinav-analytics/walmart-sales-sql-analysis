# 🛒 Walmart Retail Sales Analysis (SQL)

A MySQL project that answers 20 business questions on Walmart retail sales data, progressing from basic queries to advanced analytics.

## 📌 Project Overview
The dataset covers **5 branches, 6 product lines, 120 customers and 1,000 transactions** for calendar year 2023. The goal is to analyse revenue, customer behaviour, branch performance and sales trends using SQL.

## 🗂️ Database Schema

| Table | Type | Key Columns |
|-------|------|-------------|
| `branches` | Dimension | branch_id, branch_name, city, region |
| `products` | Dimension | product_id, product_line, unit_price |
| `customers` | Dimension | customer_id, customer_type, gender, city |
| `sales` | Fact | sale_id, branch_id, customer_id, product_id, quantity, sale_date, sale_time, payment_method, rating |

`sales` links to the three dimension tables through foreign keys.
**Revenue = `quantity × unit_price`**

## 📁 Files
| File | Description |
|------|-------------|
| `walmart_sales_setup.sql` | Creates the database, tables and loads sample data |
| `My_Solution.sql` | My solutions to all 20 questions |

## 🚀 How to Run
1. Open MySQL Workbench / DBeaver / MySQL CLI.
2. Run `walmart_sales_setup.sql` to create and populate the database.
3. Run `My_Solution.sql` to see the queries and results.

## 🧠 Questions Covered

### Level 1 – Easy (Q1–Q6)
Sorting, filtering, `GROUP BY`, `COUNT`, `SUM`, `LIMIT`.

### Level 2 – Intermediate (Q7–Q14)
`INNER/LEFT JOIN`, multi-table joins, date functions (`DATE_FORMAT`, `DAYNAME`, `HOUR`), `HAVING`.
- Revenue by product line, branch, gender and customer type
- Monthly revenue trend, best weekday, peak selling hours
- Average rating per branch, top customers by lifetime spend

### Level 3 – Advanced (Q15–Q20)
CTEs, window functions (`RANK`, `LAG`, running `SUM() OVER`), `CASE WHEN`, subqueries.
- Branch revenue share (%)
- Month-over-month growth
- Transaction value bands (High / Medium / Low)
- Customers spending above average
- Cumulative monthly revenue

## 🛠️ Skills Demonstrated
- Joins across a star-schema
- Aggregations and grouping
- Date & time analysis
- CTEs and subqueries
- Window functions
- Conditional logic with `CASE`

## 🧰 Tools
MySQL 8.0+ · MySQL Workbench

## 👤 Author
**Your Name** – [LinkedIn](your-link) · [GitHub](your-link)
