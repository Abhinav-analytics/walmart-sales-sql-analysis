-- --------------------------------------------------------------------------
--  SOME QUESTION'S
-- --------------------------------------------------------------------------
-- Q1.  List every branch with its city and region, sorted by region.
select  branch_name,city,region from branches order by region; 

-- Q2.  How many customers are 'Member' vs 'Normal'?
select customer_type,count(*) AS Count_of_customer from customers group by customer_type;

-- Q3.  Show all product lines priced above 40, most expensive first.
select * from products where unit_price>40 order by unit_price desc;

-- Q4.  How many sales were paid with each payment method?
select payment_method,count(*) as sales_count from sales group by payment_method;

-- Q5.  What is the total quantity of items sold across all transactions?
select sum(quantity) Total_Quantity_sales from sales;

-- Q6.  Find the 5 highest-rated transactions.
select * from sales order by rating desc limit 5;

-- -------------------------------------------
-- ---------- LEVEL 2: INTERMEDIATE ----------
-- -------------------------------------------

-- Q7.  Total revenue by product line (revenue = quantity * unit_price).
select product_line,sum(quantity*unit_price) as Total_revenue from sales as s
inner join products as p on s.product_id=p.product_id 
group by product_line
order by total_revenue desc;

-- Q8.  Total revenue and number of transactions per branch.
select b.branch_name, b.city, sum(s.quantity*p.unit_price) as Total_revenue, count(*) num_of_Transactions from sales as s
left join products as p on s.product_id=p.product_id
left join branches as b on s.branch_id=b.branch_id
group by b.branch_name,b.city
order by Total_revenue desc;

-- Q9.  Monthly revenue trend for 2023 (one row per month).
select date_format(sale_date, "%Y-%m") as month_date ,sum(quantity*unit_price) as Monthly_revenue from sales as s
left join products as p on s.product_id=p.product_id
group by month_date
order by month_date;

-- Q10. Which weekday brings the most revenue?
select dayname(sale_date) as Days,sum(quantity*unit_price) as Weekly_revenue from sales as s
left join products as p on s.product_id=p.product_id
group by Days
order by Weekly_revenue desc;

-- Q11. Average customer rating per branch, only branches averaging above 6.5.
select branch_name,avg(rating) as Avg_Rating from sales as s
left join branches as b on s.branch_id=b.branch_id
group by branch_name
having avg(s.rating) > 6.5
order by Avg_Rating ;


-- Q12. Revenue split by customer gender and type.
select c.gender,c.customer_type,sum(s.quantity*p.unit_price) as Revenue from sales as s
left join products as p on s.product_id=p.product_id
left join customers as c on s.customer_id=c.customer_id
group by c.gender,c.customer_type
order by revenue desc;


-- Q13. Peak selling hours: revenue by hour of the day.
select hour(sale_time) as Peek_hours,sum(quantity* unit_price) as total_revenue from sales as s
left join products as p on s.product_id=p.product_id
group by peek_hours
order by Total_revenue desc;
-- Q14. Top 10 customers by lifetime spend.
select s.customer_id,c.city, sum(s.quantity*p.unit_price) as Top_Lifetime_spend from sales as s
left join products as p on s.product_id=p.product_id
left join customers as c on s.customer_id=c.customer_id
group by s.customer_id
order by Top_Lifetime_spend desc
limit 10;


-- ---------------------------------------
-- ---------- LEVEL 3: ADVANCED ----------
-- ---------------------------------------


-- Q15. For each branch, show revenue AND its % share of total revenue.
with Table_1 as(
select branch_name,sum(quantity*unit_price) as Total_revenue from sales as s
left join products as p on s.product_id=p.product_id
left join branches as b on s.branch_id=b.branch_id
group by branch_name),

Table_2 as(select sum(Total_Revenue) as Grand_Total from Table_1)
select branch_name,Total_revenue,round((Total_revenue/Grand_Total)*100,2) as Revenue_percatage from Table_1
cross join Table_2
;

-- Q16. Rank the product lines by revenue WITHIN each branch.
with Table_1 as (
  select b.branch_name, p.product_line, sum(s.quantity*p.unit_price) as revenue
  from sales s
  left join products p on s.product_id=p.product_id
  left join branches b on s.branch_id=b.branch_id
  group by b.branch_name, p.product_line
)
select *, rank() over (partition by branch_name order by revenue desc) as rank_in_branch
from Table_1
order by branch_name, rank_in_branch;

-- Q17. Month-over-month revenue growth (show previous month, change, % growth).
with monthly as (
  select date_format(sale_date,'%Y-%m') as months, sum(quantity*unit_price) as revenue
  from sales s
  left join products p on s.product_id=p.product_id
  group by months
)
select months, revenue,
       lag(revenue) over (order by months) as previous_month_revenue,
       revenue - lag(revenue) over (order by months) as change_of_revenue,
       round(100*(revenue - lag(revenue) over (order by months))
             / lag(revenue) over (order by months), 2) as growth_percentage
from monthly;


-- Q18. Classify each transaction as High (>=300) / Medium (>=100) / Low value,
--      then count how many fall in each band.
SELECT value_band, COUNT(*) AS num_transactions
FROM (
    SELECT s.sale_id,
           s.quantity * p.unit_price AS txn_value,
           CASE
               WHEN s.quantity * p.unit_price >= 300 THEN 'High'
               WHEN s.quantity * p.unit_price >= 100 THEN 'Medium'
               ELSE 'Low'
           END AS value_band
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
) t
GROUP BY value_band
ORDER BY FIELD(value_band, 'High', 'Medium', 'Low');
-- Q19. List customers whose total spend is above the average customer spend.
with Tablw_1 as(
select c.customer_id,sum((quantity*unit_price)) as revenue from sales as s
left join products as p on s.product_id=p.product_id
left join customers as c on s.customer_id=c.customer_id
group by c.customer_id order by customer_id)
select * from Tablw_1 where revenue >(select avg(revenue) from Tablw_1); 


-- Q20. Show the running (cumulative) monthly revenue across the year.

WITH monthly AS (
SELECT DATE_FORMAT(s.sale_date, '%Y-%m') AS sale_month,SUM(s.quantity * p.unit_price) AS Monthly_revenue FROM sales s
left JOIN products p ON s.product_id = p.product_id
GROUP BY sale_month
)
SELECT sale_month,Monthly_revenue,SUM(Monthly_revenue) OVER (ORDER BY sale_month
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM monthly
ORDER BY sale_month