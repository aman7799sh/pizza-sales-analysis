


CREATE TABLE pizza_sales (
    pizza_id INT PRIMARY KEY,
    order_id INT,
    pizza_name_id VARCHAR(100),
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price NUMERIC(6,2),
    total_price NUMERIC(8,2),
    pizza_size VARCHAR(5),
    pizza_category VARCHAR(50),
    pizza_ingredients VARCHAR(500),
    pizza_name VARCHAR(150)
);


--- SQL Queries for KPI's.

SELECT * FROM pizza_sales;


--1) Total revenue .

SELECT SUM(total_price) AS total_revenue
FROM pizza_sales;


--2)Average order value .

SELECT SUM(total_price)/COUNT (DISTINCT order_id)AS avg_order_value
FROM pizza_sales;


--3)total pizza sold.

SELECT SUM(quantity)AS total_pizza_sold
FROM pizza_sales;


--4)total orders .

SELECT SUM(DISTINCT order_id) AS total_orders
FROM pizza_sales ;


--5)average pizza per-order.

SELECT 
    ROUND(SUM(quantity)::DECIMAL / COUNT(DISTINCT order_id),2)AS avg_pizzas_per_order
FROM pizza_sales;

-- SQL Queries for Daily and Monthly Trend.

--6)Daily trend for total sales .

SELECT 
    TRIM(TO_CHAR(order_date, 'Day')) AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY TRIM(TO_CHAR(order_date, 'Day'))
ORDER BY total_orders DESC ;

--7)monthly trend for total sales .


SELECT
    TRIM(TO_CHAR(order_date ,'month')) AS order_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY TRIM(TO_CHAR(order_date ,'month'))
ORDER BY total_orders DESC;

--8)percentage of sales by pizza category .

SELECT
    pizza_category,SUM(total_price) AS total_sale,
    ROUND(
        100.0 * SUM(total_price) / SUM(SUM(total_price)) OVER (),
        2
    ) AS sales_percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY sales_percentage DESC;


--9)percentage of sales by pizza size .

SELECT
    pizza_size,SUM(total_price) AS total_sale,
    ROUND(
        100.0 * SUM(total_price) / SUM(SUM(total_price)) OVER (),
        2
    ) AS sales_percentage
FROM pizza_sales
GROUP BY pizza_size
ORDER BY sales_percentage DESC;

--10) total pizza sold by pizza category.

SELECT
    pizza_category,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_pizzas_sold DESC;


--11)top 5 best sellers revenue,total quantity and total orders.

SELECT
    pizza_name_id AS pizza_name,
    SUM(total_price) AS total_revenue,
    SUM(quantity) AS total_quantity_sold,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY total_revenue DESC
LIMIT 5;


--12)bottom 5 best sellers revenue,total quantity and total orders.

SELECT
    pizza_name_id AS pizza_name,
    SUM(total_price) AS total_revenue,
    SUM(quantity) AS total_quantity_sold,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY total_revenue ASC
LIMIT 5;
