--SQL Retail Sales Analysis by Kennedy Holifield

--CREATE TABLE

CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT, 
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);
---LIMIT 10
SELECT * FROM retail_sales
LIMIT 10;
--CHECKING DATA RECORDS
SELECT COUNT (*)
FROM retail_sales;
---DATA CLEANING
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE customer_id IS NULL;
----------
SELECT * FROM retail_sales --- NULL
WHERE age IS NULL;
---------
SELECT * FROM retail_sales
WHERE category IS NULL;
------------
SELECT * FROM retail_sales --- NULL
WHERE quantiy IS NULL;
---------------

SELECT * FROM retail_sales ----- NULL
WHERE price_per_unit IS NULL;

SELECT * FROM retail_sales ---NULL
WHERE cogs IS NULL;

SELECT * FROM retail_sales ---NULL
WHERE total_sale IS NULL;
--DELETE NULL DATA
DELETE FROM retail_sales
WHERE quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

--DATA EXPLORATION
--How many sales do we have?

SELECT COUNT(*) as total_sales 
FROM retail_sales;

--How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) as customers
FROM retail_sales;

--How many unique categories do we have?
SELECT COUNT(DISTINCT category) as categories
FROM retail_sales;

--What categories do we have?
SELECT DISTINCT category 
as categories
FROM retail_sales;

--DATA ANALYSIS

--All columns for sales made on '2022-11-05
SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05';



--All transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
	AND quantiy >= 4


--Total sales for each category.
SELECT category,
SUM(total_sale) as net_sales,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;


--Average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(age), 2) as Avg_Age
FROM retail_sales
WHERE category = 'Beauty';


--All transactions where the total sales is greater than 1000.
SELECT transactions_id
FROM retail_sales
WHERE total_sale >1000;

--Total number of transactions made by each gender in each category.
SELECT category, gender,
COUNT(*) as total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

--Average sale for each month & best selling month in each year
SELECT * FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(month FROM sale_date) as month,
	AVG(total_sale) as total_sale,
	RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1 
	WHERE rank = 1
	
--Top 5 customers based on the highest total sales 
SELECT
	category,
	SUM(total_sale) as total_sales
	FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Unique customers who purchased items from each category
SELECT 
	category,
	COUNT(DISTINCT customer_id) as Unqiue_Customers
	FROM retail_sales
	GROUP BY category;

--Time shift and number of orders based on shift
WITH hourly_sales
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales)
SELECT 
	shift,
	COUNT(transactions_id) as total_orders
FROM hourly_sales
GROUP BY shift;

--End of Analysis