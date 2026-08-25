# Retail_Analysis_project1
# Retail & E-Commerce Sales Analysis — SQL
## 1. 🎯 Objective
### Analyze retail and e-commerce sales data to transform raw transactions into actionable business insights around revenue, customer behavior, product performance, and growth opportunities. Key business questions include:
  -Which products/categories generate the highest revenue?
  -Who are the most valuable and loyal customers?
  -What are the monthly and yearly sales trends?
  -How does spending vary across customer segments?
  -Which areas require business attention?


## 2. 📊 Key Insights
   -Identified top-performing and underperforming products/categories.
   -Analyzed revenue and sales trends across different time periods.
   -Identified high-value, repeat, and loyal customers based on spending and transaction frequency.
   -Compared customer spending across different segments.
   -Evaluated product contribution to overall sales.
   -Identified customers exceeding defined spending and transaction benchmarks.
   -Generated insights to support customer retention, revenue growth, and product strategy.

## 3. 🔄 Steps Taken
   -Data Cleaning & Transformation — prepared raw transactional data for analysis.
   -Sales Analysis — evaluated revenue, transaction volume, and product performance.
   -Customer Analysis — identified high-value, repeat, and loyal customers.
   -Product Analysis — compared product/category performance.
   -Time-Series Analysis — analyzed monthly and yearly sales patterns.
   -Customer Segmentation — grouped customers based on spending and purchase behavior.
   -Advanced Analysis — used CTEs, subqueries, and window functions to identify customers meeting business benchmarks.
   -Business Interpretation — converted SQL results into actionable recommendations.
## 4. 🛠️ Functions & SQL Skills Used
   SELECT, WHERE, GROUP BY, HAVING
   CASE WHEN
   SUM(), COUNT(), AVG(), MIN(), MAX()
   INNER JOIN, LEFT JOIN
   Subqueries
   CTEs
   Window Functions
   RANK(), DENSE_RANK(), ROW_NUMBER()
   LAG(), LEAD()
   Date & Time Functions
   Conditional Aggregation
   Customer Segmentation
   KPI Calculation
### “I don’t just analyze data; I tell the story behind it.”
#### Business Approach: Data → Analysis → Insight → Business Decision.

##SQL Analysis and Queries
### -- Q1. Handling Null values-- Data Cleaning
```sql
DESCRIBE sales;
-- to know which column contains null values

<img width="406" height="229" alt="Screenshot 2026-08-20 at 3 23 34 PM" src="https://github.com/user-attachments/assets/1e2204ce-c849-4f66-9659-395ddcd49de4" />

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
-- to derive the rows containing null values
<img width="702" height="241" alt="Screenshot 2026-08-20 at 5 37 21 PM" src="https://github.com/user-attachments/assets/7cb22e89-60d4-4dd2-bedc-d4bf05f6e9de" />

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
```
## Data Exploration
### Q2. how many transactions are done in the department
```sql
SELECT count(*) as Total_sales
from sales;
-- The total transactions are 1987
```

### Q3.count unique customers who ordered from each category?
```sql
SELECT COUNT(DISTINCT customer_id) AS unique_customer_id
FROM sales;
-- there are 155 unique customers who ordered from each category
```
  
### Q4. how many distinct categories?
```sql
SELECT COUNT(DISTINCT category) AS unique_category
FROM sales;
-- there are 3 distinct categories
```

## data Analysis- business problems and answers 
### Q5. write a sql query to retrieve all columns for sales made on '2022-11-05'?
```sql
Select * from sales
where SALE_date = '2022-11-05';
```
<img width="694" height="152" alt="Screenshot 2026-08-25 at 7 34 45 PM" src="https://github.com/user-attachments/assets/ded7dfae-f19b-443b-aba5-580bdc552026" />

### Q6. write a SQL query to retrieve all the transactions where category is Clothing and the month of November-2022
```sql
SELECT *
FROM sales
WHERE category = 'Clothing'
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```
<img width="681" height="160" alt="Screenshot 2026-08-25 at 7 35 33 PM" src="https://github.com/user-attachments/assets/83c17678-d6af-4b3d-97b8-0b5600bd2f0f" />

### Q7. write a SQL query to calculate the total sales for each category?
```sql
select category,sum(total_sale) from sales
group by category;
```
<img width="208" height="94" alt="Screenshot 2026-08-25 at 7 22 08 PM" src="https://github.com/user-attachments/assets/7ad8a45a-94bc-41a2-8669-0abc02ca9a0d" />


### Q8. write a SQL query to calculate the average age of the customers who purchased items from 'Beauty' category?
```sql
SELECT round(AVG(age)) AS avg_age
FROM sales
WHERE category = 'Beauty';
-- the average age of customer who purchased items from beauty category is 40.
```

### Q9. write a SQL query to find all the transactions where the total sale is greater than 1000?
```sql
SELECT transactions_id, total_sale
FROM sales
WHERE total_sale > 1000 OR total_sale IS NULL;
```
<img width="203" height="215" alt="Screenshot 2026-08-25 at 7 24 25 PM" src="https://github.com/user-attachments/assets/201cc076-df2b-48f6-b607-0f3ac5f8b083" />

### Q10.  write a SQL query to find the total no. of transaction(transactions_id) made by each gender in each category?
```sql
SELECT GENDER, CATEGORY, COUNT(TRANSACTIONS_ID) AS TOTAL_TRANSACTIONS FROM SALES
GROUP BY CATEGORY,GENDER;
```
<img width="291" height="138" alt="Screenshot 2026-08-25 at 7 26 52 PM" src="https://github.com/user-attachments/assets/77dfbe72-7a6c-4cbc-9f3d-43d63181131a" />


### Q11. write a SQL query to calculate the average sale for each month.Find out the best selling month in each year?
```sql
SELECT 
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    AVG(total_sale) AS avg_sale
FROM sales
GROUP BY sale_year, sale_month
ORDER BY avg_sale desc;
--July is the best selling month
```
<img width="238" height="205" alt="Screenshot 2026-08-25 at 7 27 48 PM" src="https://github.com/user-attachments/assets/5b1bf50a-085c-42aa-a403-daffd7ccf951" />



### Q12. write a SQL query to find the top 5 customers based on highest total sales.
```sql
SELECT customer_id, SUM(total_sale) AS total_spend
FROM sales
GROUP BY customer_id
ORDER BY total_spend DESC
LIMIT 5;
```

### Q13. Write a SQL query to create each shift and number of orders(example morning<=12, afternoon between 12 & 17, evening> 17)
```sql
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
-- the order_count in morning shift is 548, afternoon shift is 377 and evening shift is 1062.
```

### Q14. Total revenue, total cost, and gross profit by category
```sql
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
```
<img width="321" height="85" alt="Screenshot 2026-08-25 at 7 31 48 PM" src="https://github.com/user-attachments/assets/2d30713c-690b-46e8-b007-fe07d9f9188a" />

### Q15. Calculate year-over-year sales growth by category (2022 vs 2023).
```sql
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
```

<img width="306" height="86" alt="Screenshot 2026-08-25 at 7 42 41 PM" src="https://github.com/user-attachments/assets/88a824f4-f7f6-49b3-83ae-c8bc2ab114e2" />


### Q16. Create a query to find each category's contribution to total revenue as a percentage, using window functions (no GROUP BY)
```sql
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
```
<img width="267" height="91" alt="Screenshot 2026-08-25 at 7 42 53 PM" src="https://github.com/user-attachments/assets/a476b70d-27d7-4dbd-af37-fd5d03e5f975" />


### Q17. Rank customers within each category by their total spend using RANK() or DENSE_RANK().
```sql
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
) customer_totals                                                                                                                                               order by category, spend_rank;
```
<img width="289" height="146" alt="Screenshot 2026-08-25 at 7 44 45 PM" src="https://github.com/user-attachments/assets/20cea2c1-136b-4e64-83d6-0b694fb0c0e7" />


### Q18. Calculate a running (cumulative) total of sales ordered by date for each category.
```sql
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
```
<img width="308" height="245" alt="Screenshot 2026-08-25 at 7 45 02 PM" src="https://github.com/user-attachments/assets/1356bda4-55e7-4824-9af8-8327a9da0bff" />

       
### Q19. Find, for each customer, their most recent transaction and the number of days since their previous one (LAG/LEAD).
```sql
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
```
<img width="428" height="190" alt="Screenshot 2026-08-25 at 7 46 14 PM" src="https://github.com/user-attachments/assets/517c9a46-7336-4bd5-9fd8-52e76e7262eb" />


### Q20. CASE Statements & Segmentation-- Segment customers into age groups (e.g., 18–25, 26–35, 36–45, 46+) and calculate total sales and average order value per group using CASE WHEN.
```sql
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
```
<img width="265" height="96" alt="Screenshot 2026-08-25 at 7 46 31 PM" src="https://github.com/user-attachments/assets/b925b7cb-09fc-40a8-a5c8-bdd6e763c24f" />


### Q21. Profitability / Business Metrics-- Calculate gross profit (total_sale - cogs) and profit margin % by category, then rank categories by margin.
```sql
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
```
<img width="334" height="87" alt="Screenshot 2026-08-25 at 7 47 22 PM" src="https://github.com/user-attachments/assets/d3db6571-a680-458b-bc95-f1c39df7a850" />

 
### Q22. Advanced / Capstone -- Identify "loyal" customers — those with more than 3 transactions and total spend above the overall average customer spend — using a CTE or subquery, and rank them by total spend using a window function.
```sql
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
```
 <img width="436" height="104" alt="Screenshot 2026-08-25 at 7 47 42 PM" src="https://github.com/user-attachments/assets/02cb6d4f-0ba4-490b-92a7-cce6dc9dd961" />

