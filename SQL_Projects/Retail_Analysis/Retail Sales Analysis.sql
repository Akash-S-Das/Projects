-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;

-- CREATE TABLE

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

-- Identifying NULL Values

SELECT * FROM retail_sales
WHERE
transactions_id IS NULL
OR
sale_date IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL
;

-- Data Cleaning

DELETE FROM retail_sales
WHERE
transactions_id IS NULL
OR
sale_date IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL
;

/* Data Exploratory Analysis*/
-- How many sales did we had?
SELECT SUM(quantiy) FROM retail_sales;

-- How many customers do we have?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- How many categories does our company deals with?
SELECT DISTINCT category FROM retail_sales;

-- Business Key Problems & Solutions.
-- Q.1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022:
SELECT * FROM retail_sales
WHERE
category='Clothing'
AND
quantiy>3
AND
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q.3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY category;

-- Q.4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT CEILING(AVG(age)) AS average_age FROM retail_sales
WHERE
category='Beauty';

-- Q.5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale>1000;

-- Q.6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(transactions_id) FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY COUNT(transactions_id) DESC;

-- Q.7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SElECT YEAR, MONTH, avg_sale FROM
(SELECT AVG(total_sale) AS avg_sale,
EXTRACT(YEAR FROM sale_date) AS YEAR,
EXTRACT(MONTH FROM sale_date) AS MONTH,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY (AVG(total_sale)))
FROM retail_sales
GROUP BY YEAR, MONTH) AS sub_one
WHERE rank=1;

-- Q.8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id, SUM(total_sale) AS sales FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Q.9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) FROM retail_sales
GROUP BY category;

-- Q.10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(SElECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales)

SELECT
shift,
COUNT(transactions_id) AS total_orders
FROM hourly_sale
GROUP BY SHIFT;