drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR (150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightIngms INTEGER,
outPfStock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows
select count (*) from zepto;

--sample data
select * from zepto
limit 10;

--null values
select * from zepto
where name IS NULL
OR 
category IS NULL
OR 
mrp IS NULL
OR 
discountPercent IS NULL
OR 
weightIngms IS NULL
OR 
outPfStock IS NULL
OR 
quantity IS NULL;

--diffrent product categories
select distinct category
from zepto
order by category;

--product in stock vs ot of stock
select outPfStock, count (sku_id)
from zepto
group by outPfStock;

--produvt names present multiple times
select name, count (sku_id) as "Number od SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

--data cleaning 

--products with price=0
select * from zepto
where mrp = 0 or discountedSellingPrice = 0;

delete from zepto
where mrp = 0;

--convert paise to rupees
update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto

--Q1. find the top 10 best value product based on the descount percentage
select distinct name , mrp, discountPercent
from zepto
order by discountPercent desc
limit 10;

--Q2. what are the products with high MRP but out of stock
select distinct name , mrp
from zepto
where outPfStock = TRUE and mrp > 300
order by  mrp desc;

--Q3.calculate estimated revenue for each caegory
select category,
sum(discountedsellingPrice * availableQuantity )as total_revenue
from zepto
group by category
order by total_revenue;

--Q4. find all products where mrp is greater than ru500 and discount  is less than 10%
select distinct name, mrp,discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc;

--Q5. identify the top 5 categories offering the highest avg discount percentage
select category,
round(avg(discountPercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--Q6. find the price per gram for products above 100g and sort by best value.
select distinct name weightIngms, discountedSellingPrice,
round(discountedSellingPrice/weightIngms,2) as price_per_gram
from zepto
where weightIngms >= 100
order by price_per_gram;

--Q7. group the products into categories like low,medium,bulk.
select distinct name, weightInGms,
case when weightInGms < 1000 then 'low'
	when weightInGms < 1000 then 'Medium'
	else 'Bulk'
	end as weight_category
from zepto;

--Q8. what is the total inventory weight per category
select category,
sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;




