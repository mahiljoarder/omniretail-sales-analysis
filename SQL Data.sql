-- ============================================================
-- OMNIRETAIL PORTFOLIO PROJECT
-- Mahil Joarder 
-- ============================================================

-- DATA CLEANING
-- Convert serial dates to real dates
alter table sales add column date_converted date

update sales
set date_converted = date '1899-12-30' + sale_date::integer

-- ============================================================
-- 1. Which region has the highest total revenue?

select region, sum(total_sale_amount) as total_revenue
from sales 
group by 1
order by 2 desc
limit 1

-- 2. Which product category generates the highest average revenue per sale?

select product_category, round(avg(total_sale_amount),2) as avg_rev_per_sale
from sales 
group by 1 
order by 2 desc
limit 1

-- 3. What is the return rate per product category?
select * 
from public.sales

select product_category, 
round((sum(
case 
	when returned = 'Yes' then 1 else 0 end)*100.0 / count(*)),1) as return_rate

from sales 
group by 1


-- 4. Top 5 products by quantity sold 

select p.product_name, sum(quantity_sold) as quantity_sold
from sales as s
join products as p
	on s.product_id = p.product_id 
group by 1
order by 2 desc
limit 5

-- 5. Which store has the lowest revenue but highest number of sales?

select store_id, sum(quantity_sold) as number_od_sales, sum(total_sale_amount) as total_revenue
from sales 
group by 1
order by 3 asc, 2 desc
limit 1

-- 6. How do different payment methods impact total revenue?

select payment_method, count(*) as number_of_transaction, 
sum(total_sale_amount) as total_revenue, 
round(avg(total_sale_amount),2) as avg_transaction_value
from sales
group by 1
order by 3 desc 



-- 7. Top 10 customers by total amount spent?
select customer_id, sum(total_sale_amount) as total_money_spent
from sales 
group by 1 
order by 2 desc 
limit 10

-- 8. Which quarter sees the highest sales?

select extract(quarter from date_converted) as quarter, 
sum(total_sale_amount) as revenue
from sales 
group by 1
order by 2 desc 
limit 1



-- 9. What is the average unit price per product category?


select product_category, round(avg(unit_price),2) as avg_unit_price
from sales
group by 1
order by 2 desc

-- 10. Which product categories have the highest return percentage?

select product_category, 
round((sum(
case 
	when returned = 'Yes' then 1 else 0 end)*100.0 / count(*)),1) as return_rate

from sales 
group by 1
order by 2 desc 
limit 1


-- 11. Which product name has the highest total sales revenue?

select product_name, sum(total_sale_amount) as total_revenue
from sales as s
join products as p 
	on s.product_id = p.product_id
group by product_name 
order by 2 desc 
limit 1

-- 12. Which month has the highest revenue?
select to_char(date_converted, 'Month') as month, sum(total_sale_amount) as total_revenue
from sales 
group by 1
order by 2 desc 
limit 1

-- 13. Which store has the highest return rate?
select store_id, 
round((sum(
case
	when returned = 'Yes' then 1 else 0 end) * 100.0 / count(*)),1) as return_rate 
from sales 
group by 1
order by 2 desc 
limit 1

-- 14. Revenue breakdown by region and category combined


select region, product_category, sum(total_sale_amount) as revenue 
from sales 
group by 1, 2
order by 1 desc, 3 desc 


-- 15. Most popular payment method per region

select region, payment_method,
rank() over (partition by region order by count(*))
from sales 
group by 1, 2



with cte_1 as (
select region, payment_method,
rank() over (partition by region order by count(*)) as rnk
from sales 
group by 1, 2
)
select region, payment_method
from cte_1 
where rnk = 1

-- 16. Average order value per store


select store_id, round(avg(total_sale_amount),2) as rev_per_transaction 
from sales 
group by 1
order by 2 desc 

-- 17. Which products have never been returned?
select product_id
from sales 
where returned = 'Yes'

select distinct(product_name)
from sales as s
join products as p
	on s.product_id = p.product_id 
where s.product_id not in (
select product_id
from sales 
where returned = 'Yes'
)
order by 1

-- 18. Top 5 best selling products by revenue
select * 
from sales 


select product_name, sum(s.total_sale_amount) as total_revenue 
from sales as s 
join products as p 
	on s.product_id = p.product_id 
group by 1 
order by 2 desc 
limit 5 




-- 19. Which quarter has the highest return rate?
select extract(quarter from date_converted) as quarter, 
round((sum(
case 
	when returned = 'Yes' then 1 else 0 end)*100.0 / count(*)),1) as return_rate
from sales 
group by 1 
order by 2 desc 

-- 20. How many unique customers per region?
select region, count(distinct(customer_id)) as number_od_customers 
from sales 
group by 1
order by 2 desc 

-- 21. Rank stores by revenue within each region
select region, store_id, sum(total_sale_amount) as revenue, 
rank() over(partition by region order by sum(total_sale_amount)desc) as store_rank_by_region
from sales 
group by 1, 2
order by 1 asc


-- 22. Running total of revenue over time

select date_converted, total_sale_amount,
   sum(total_sale_amount) over (order by date_converted) as running_total
from sales


-- 23. Month over month revenue growth

with cte_1 as(
select to_char(date_converted, 'Month') as month, 
extract (month from date_converted) as month_number, 
sum(total_sale_amount) as revenue
from sales 
group by 1, 2)

select month, revenue,
    lag(revenue, 1) over (order by month_number) as growth
from cte_1
order by month_number



-- 24. top 5 products with highest return rate 
select product_name, 
round((sum(
case 
	when returned = 'Yes' then 1 else 0 end)*100.0 / count(*)),1) as return_rate
from sales as s
join products as p 
	on s.product_id = p.product_id 
group by 1 
order by 2 desc 
limit 5

-- 25. Revenue by product name and category combined 


select product_name, p.product_category, sum(total_sale_amount) as revenue 
from sales as s
join products as p
	on s.product_id = p.product_id 
group by 1,2 
order by 3 desc 



-- 26. Top selling product per region 

select region, p.product_name, sum(quantity_sold) as total_quantity_sold, 
sum(total_sale_amount) as revenue, 
rank() over( partition by region order by sum(total_sale_amount) desc)
from sales as s
join products as p
	on s.product_id = p.product_id
group by 1, 2



with cte_1 as (
select region, p.product_name, sum(quantity_sold) as total_quantity_sold, 
sum(total_sale_amount) as revenue, 
rank() over( partition by region order by sum(total_sale_amount) desc) as rnk
from sales as s
join products as p
	on s.product_id = p.product_id
group by 1, 2
)
select region, product_name, total_quantity_sold, revenue
from cte_1 
where rnk = 1


-- 27. Customer segmentation - high, medium, low spenders 
select * 
from sales 


select customer_id, 
case 
	when sum(total_sale_amount) >= 3000 then 'High_Spender' 
	when sum(total_sale_amount) between 1500 and 3000 then 'Mid_Spender'
	when sum(total_sale_amount) <1500 then 'Low_Spender'
	else 'Unknown'
end as Customer_segmentation 
from sales 
group by 1 

-- 28. Store performance tier - top, mid, bottom 
select store_id, 
case 
	when sum(total_sale_amount) >= 70000 then 'Top' 
	when sum(total_sale_amount) between 50000 and 70000 then 'Mid'
	when sum(total_sale_amount) <50000 then 'Low'
	else 'Unknown'
end as Store_performance_tier
from sales 
group by 1


-- 29. Best and worst performing quarter per region
select region, extract(quarter from date_converted) as quarter, sum(total_sale_amount) as revenue,
rank() over(partition by region order by sum(total_sale_amount) desc)
from sales 
group by 1,2 


with cte_1 as (
select region, extract(quarter from date_converted) as quarter, sum(total_sale_amount) as revenue,
rank() over(partition by region order by sum(total_sale_amount) desc) as rnk
from sales 
group by 1,2
)
select region, quarter, revenue, 
case when rnk = 1 then 'Best'
when rnk = 4 then 'Worst'
else 'Rank_it'
end as Quarter_Performance
from cte_1
where rnk = 1 or rnk = 4




-- 30. Which region has highest average order value

select region, round(avg(total_sale_amount),1) as highest_avg_order_value
from sales 
group by 1
order by 2 desc 
limit 1
