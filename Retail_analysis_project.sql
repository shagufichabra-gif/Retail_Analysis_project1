-- create database
create database Project1_retail_sale_analysis;

USE Project1_retail_sale_analysis;

 
-- creating Table
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    transactions_id INT,
    sale_date DATE NULL,
    sale_time TIME NULL,
    customer_id INT NULL,
    gender VARCHAR(10) NULL,
    age INT NULL,
    category VARCHAR(50),
    quantity INT NULL,
    price_per_unit DECIMAL(10,2) NULL,
    cogs DECIMAL(10,2) NULL,
    total_sale DECIMAL(10,2) NULL
);

-- null values error handling
SHOW GLOBAL VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

SHOW SESSION VARIABLES LIKE 'local_infile';
-- to get path- option+ right click on file in finder/desktop- copy path
LOAD DATA LOCAL INFILE '/Users/solarc/SQL_Retail_Sales_Analysis_MySQL_Ready.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    transactions_id,
    sale_date,
    sale_time,
    customer_id,
    gender,
    @age,
    category,
    @quantity,
    @price_per_unit,
    @cogs,
    @total_sale
)
SET
    age = NULLIF(@age, ''),
    quantity = NULLIF(@quantity, ''),
    price_per_unit = NULLIF(@price_per_unit, ''),
    cogs = NULLIF(@cogs, ''),
    total_sale = NULLIF(@total_sale, '');


-- Handling Null values-- Data Cleaning
DESCRIBE sales;

SELECT * from sales
WHERE 
  transactions_id	IS NULL
  OR
  sale_time IS NULL
  or
  customer_id IS NULL
  or
  gender IS NULL
  or
  age IS NULL
  or
  category IS NULL
  or
  quantity IS NULL
  or
  price_per_unit IS NULL
  or
  cogs IS NULL
  or
  total_sale IS NULL;

DELETE from sales
WHERE
   transactions_id	IS NULL
  OR
  sale_time IS NULL
  or
  customer_id IS NULL
  or
  gender IS NULL
  or
  age IS NULL
  or
  category IS NULL
  or
  quantity IS NULL
  or
  price_per_unit IS NULL
  or
  cogs IS NULL
  or
  total_sale IS NULL;
  
  -- Data Exploration
  -- count rows
SELECT count(*) as Total_sales
from sales;

-- count distinct rows
SELECT COUNT(DISTINCT customer_id) AS unique_customer_id
FROM sales;
  
-- how many distinct categories
SELECT COUNT(DISTINCT category) AS unique_category
FROM sales;

-- retrieve all columns
SELECT * FROM Sales
LIMIT 20;

-- data Analysis- business problems and answers 
-- write a sql query to retrieve all columns for sales made on '2022-11-05'?
Select * from sales
where SALE_date = '2022-11-05';


-- write a SQL query to retrieve all the transactions where category is Clothing and the month of November-2022
SELECT *
FROM sales
WHERE category = 'Clothing'
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


-- write a SQL query to calculate the total sales for each category?
select category,sum(total_sale) from sales
group by category;

-- write a SQL query to calculate the average age of the customers who purchased items from 'Beauty' category?
SELECT round(AVG(age)) AS avg_age
FROM sales
WHERE category = 'Beauty';

-- write a SQL query to find all the transactions where the total sale is greater than 1000?
SELECT transactions_id, total_sale
FROM sales
WHERE total_sale > 1000 OR total_sale IS NULL;

-- write a SQL query to find the total no. of transaction(transactions_id) made by each gender in each category?
SELECT GENDER, COUNT(TRANSACTIONS_ID) AS TOTAL_TRANSACTIONS FROM SALES
GROUP BY CATEGORY,GENDER;

-- write a SQL query to calculate the average sale for each month.Find out the best selling month in each year?
SELECT 
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    AVG(total_sale) AS avg_sale
FROM sales
GROUP BY sale_year, sale_month
ORDER BY avg_sale desc; 


-- write a SQL query to find the top 5 customers based on highest total sales.
SELECT customer_id, SUM(total_sale) AS total_spend
FROM sales
GROUP BY customer_id
ORDER BY total_spend DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM sales
GROUP BY category
ORDER BY unique_customers DESC;

-- Write a SQL query to create each shift and number of orders(example morning<=12, afternoon between 12 & 17, evening> 17)
SELECT 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(transactions_id) AS order_count
FROM sales
GROUP BY shift
ORDER BY FIELD(shift, 'Morning', 'Afternoon', 'Evening');

-- Total revenue, total cost, and gross profit by category
select 
    category,
    revenue,
    total_cost,
    revenue - total_cost as gross_profit
from (
    select 
        category,
        sum(total_sale) as revenue,
        sum(cogs*quantity) as total_cost
    from sales
    group by category
) t;

-- Calculate year-over-year sales growth by category (2022 vs 2023).
select 
    y23.category,
    y22.revenue as sales_2022,
    y23.revenue as sales_2023,
    round((y23.revenue - y22.revenue) / nullif(y22.revenue,0) * 100, 2) as yoy_growth_pct
from
    (select category, sum(total_sale) as revenue
     from sales
     where extract(year from sale_date) = 2022
     group by category) y22
join
    (select category, sum(total_sale) as revenue
     from sales
     where extract(year from sale_date) = 2023
     group by category) y23
    on y22.category = y23.category;

-- 14. Create a query to find each category's contribution to total revenue as a percentage, using window functions (no GROUP BY)
select 
    category,
    sum(total_sale) as category_revenue,
    round(
        sum(total_sale) * 100.0 / (select sum(total_sale) from sales), 
        2
    ) as revenue_pct
from sales
group by category
order by revenue_pct desc;

-- no group by
select distinct
    category,
    sum(total_sale) over (partition by category) as category_revenue,
    round(
        sum(total_sale) over (partition by category) * 100.0 
        / sum(total_sale) over (), 
        2
    ) as revenue_pct
from sales
order by revenue_pct desc;

--  Rank customers within each category by their total spend using RANK() or DENSE_RANK().
select customer_id,
category,
total_spend,
Rank()over (partition by category order by total_spend desc) as spend_rank
from(
select customer_id,
        category,
        sum(total_sale) as total_spend
    from sales
    group by customer_id, category
) customer_totals                                                                                                                                                                               
order by category, spend_rank;

--  Calculate a running (cumulative) total of sales ordered by date for each category.
select sale_date,
       category,
       total_sale,
       Sum(total_sale) Over 
       (Partition by category
        order by sale_date
        rows between unbounded preceding and current row)
        as cumulative_sales
from sales
order by category, sale_date;
       
--  Find, for each customer, their most recent transaction and the number of days since their previous one (LAG/LEAD).
WITH RANKED_TRANSACTIONS AS (
    SELECT
        CUSTOMER_ID,
        TRANSACTIONS_ID,
        SALE_DATE,
        SALE_DATE - LAG(SALE_DATE) OVER (
            PARTITION BY CUSTOMER_ID
            ORDER BY SALE_DATE
        ) AS DAYS_SINCE_PREV,
        ROW_NUMBER() OVER (
            PARTITION BY CUSTOMER_ID
            ORDER BY SALE_DATE DESC
        ) AS RN
    FROM SALES
)
SELECT
    CUSTOMER_ID,
    TRANSACTIONS_ID,
    SALE_DATE,
    DAYS_SINCE_PREV
FROM RANKED_TRANSACTIONS
WHERE RN = 1;

-- CASE Statements & Segmentation-- Segment customers into age groups (e.g., 18–25, 26–35, 36–45, 46+) and calculate total sales and average order value per group using CASE WHEN.
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN 'Young'
        WHEN age BETWEEN 26 AND 35 THEN 'Adult'
        WHEN age BETWEEN 36 AND 45 THEN 'Older Adult'
        ELSE 'Elder'
    END AS age_segment,
    SUM(total_sale) AS total_sales,
    SUM(total_sale) / COUNT(transactions_id) AS avg_order_value
FROM sales
GROUP BY
    CASE
        WHEN age BETWEEN 18 AND 25 THEN 'Young'
        WHEN age BETWEEN 26 AND 35 THEN 'Adult'
        WHEN age BETWEEN 36 AND 45 THEN 'Older Adult'
        ELSE 'Elder'
    END
ORDER BY total_sales DESC;

-- Profitability / Business Metrics-- Calculate gross profit (total_sale - cogs) and profit margin % by category, then rank categories by margin.
SELECT
    category,
    SUM(total_sale - cogs) AS gross_profit,
    SUM(total_sale - cogs) / SUM(total_sale) * 100 AS profit_margin_pct,
    RANK() OVER (
        ORDER BY SUM(total_sale - cogs) / SUM(total_sale) DESC
    ) AS rank_profit
FROM sales
GROUP BY category
ORDER BY profit_margin_pct DESC;
 
-- Advanced / Capstone -- Identify "loyal" customers — those with more than 3 transactions and total spend above the overall average customer spend — using a CTE or subquery, and rank them by total spend using a window function.
WITH CUSTOMER_SPEND AS (
    SELECT
        CUSTOMER_ID,
        COUNT(TRANSACTIONS_ID) AS TOTAL_TRANSACTIONS,
        SUM(TOTAL_SALE) AS TOTAL_SPEND
    FROM SALES
    GROUP BY CUSTOMER_ID
),
LOYAL_CUSTOMERS AS (
    SELECT *
    FROM CUSTOMER_SPEND
    WHERE TOTAL_TRANSACTIONS > 3
      AND TOTAL_SPEND > (SELECT AVG(TOTAL_SPEND) FROM CUSTOMER_SPEND)
)
SELECT
    CUSTOMER_ID,
    TOTAL_TRANSACTIONS,
    TOTAL_SPEND,
    RANK() OVER (ORDER BY TOTAL_SPEND DESC) AS SPEND_RANK
FROM LOYAL_CUSTOMERS
ORDER BY SPEND_RANK;
 
