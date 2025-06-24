---sql retail sales analysis--p1
create database sql_project_p1;

drop table if exists retail_sales;


create table retail_sales (
transactions_id	int primary key,
sale_date date,
sale_time time,
customer_id int ,
gender varchar(15),
age int,	
category varchar(25),	
quantity	int,
price_per_unit float,	
cogs float,
total_sale int
);

select * from retail_sales
limit 10;

select count(*) from retail_sales

--find null values---

select * from retail_sales              
where 
transactions_id is null 
or
 sale_date is null 
or
 sale_time is null 
or
 customer_id is null
or
 gender is null
or
  age is null
  or
  category is null
  or
   quantity is null
   or
    price_per_unit is null
	or
	 cogs is null
	 or
	  total_sale is null

--delete null values---

delete from retail_sales
where 
transactions_id is null 
or
 sale_date is null 
or
 sale_time is null 
or
 customer_id is null
or
 gender is null
or
  age is null
  or
  category is null
  or
   quantity is null
   or
    price_per_unit is null
	or
	 cogs is null
	 or
	  total_sale is null

---retrieve all columns for sales made on '2022-11-05:

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

---retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM retail_sales
WHERE category = 'Clothing' AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

---calculate the total sales (total_sale) for each category.:
select category ,sum(total_sale),
count(*) as total_orders from retail_sales
group by "category"

---find the average age of customers who purchased items from the 'Beauty' category.:
select round(avg(age),2) as avg_age from retail_sales
where category= 'Beauty'

---find all transactions where the total_sale is greater than 1000.:

select * from retail_sales
where total_sale >1000

---find the total number of transactions (transaction_id) made by each gender in each category.:

select category,gender, count(transactions_id) as total_count from retail_sales
group by category,gender
order by category

---calculate the average sale for each month. Find out best selling month in each year:

select year,month,avg_sale
from
(
select 
   extract(year from sale_date)as year,
   extract(month from sale_date)as month,
   avg(total_sale)as avg_sale,
   rank()over(partition by extract(year from sale_date)
   order by avg(total_sale) desc)as rank
   from retail_sales
   group by year,month
   ) 
   where rank =1

   ---find the top 5 customers based on the highest total sales :
   select customer_id, category,sum(total_sale)as total_sales
   from retail_sales
   group by customer_id,category
   order by total_sales desc
   limit 5 
---find the number of unique customers who purchased items from each category.:

    select category ,count(distinct customer_id)as unique_cus
	from retail_sales
	group by category

---create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sale
as(
select *,
 case 
 when extract(hour from sale_time)<12 then 'morning'
 when extract(hour from sale_time) between 12 and 17 then 'afternoon'
 else 'evening'

 end as shift
 from retail_sales
   )
   select shift,count(*)as total_orders from hourly_sale
   group by shift

---end of project---