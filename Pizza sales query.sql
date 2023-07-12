/*
PIZZA SALES DATA
The data is a collection of pizzas sold in a store.
We will run queries to find several KPIs from this data
*/

--KPIs
--Total Revenue
SELECT SUM(total_price) as Total_Revenue
FROM [PizzaDB].[dbo].[pizza_sales]

--Average order value
SELECT SUM(total_price)/ COUNT(DISTINCT order_id)  AS Avg_Order
FROM [PizzaDB].[dbo].[pizza_sales]

--Total pizzas sold
SELECT SUM(quantity) AS Total_Pizzas
FROM [PizzaDB].[dbo].[pizza_sales]


--total orders
SELECT COUNT(DISTINCT order_id)
FROM [PizzaDB].[dbo].[pizza_sales]

--Average pizzas per order
SELECT CAST(CAST(SUM(quantity) AS decimal(10,2)) /
		CAST(COUNT(DISTINCT order_id) AS decimal(10,2)) AS decimal(10,2)) AS avg_pizzas_per_order
FROM [PizzaDB].[dbo].[pizza_sales]


--Daily trend for total orders
SELECT DATENAME(DW, order_date) as order_day, COUNT(DISTINCT order_id) as total_orders
FROM [PizzaDB].[dbo].[pizza_sales]
Group by DATENAME(DW, order_date)

--Hourly trend for orders
SELECT DATEPART(HOUR, order_time) as Order_hour, COUNT(DISTINCT order_id) as total_orders
FROM [PizzaDB].[dbo].[pizza_sales]
GROUP BY DATEPART(HOUR, order_time) 
ORDER BY DATEPART(HOUR, order_time) 


--% of sales by pizza category
select pizza_category, CAST(SUM(total_price) as decimal(10,2)) as total_revenue,
CAST(SUM(total_price) *100 / (SELECT SUM(total_price) from [PizzaDB].[dbo].[pizza_sales]) AS decimal(10,2)) as PCT
from [PizzaDB].[dbo].[pizza_sales]
group by pizza_category


--% of sales per pizza size

select pizza_size, CAST(sum(total_price) as decimal(10,2)) AS total_revenue,
CAST(SUM(total_price) *100/ (select sum(total_price) from [PizzaDB].[dbo].[pizza_sales]) AS decimal(10,2)) as PCT_by_size
from [PizzaDB].[dbo].[pizza_sales]
group by pizza_size


---total pizzas sold by pizza category
select pizza_category, COUNT(quantity) as number_sold
from [PizzaDB].[dbo].[pizza_sales]
group by pizza_category



--top 5 bestsellers by pizzas sold

select TOP 5 pizza_name, COUNT(quantity) as number_sold
from [PizzaDB].[dbo].[pizza_sales]
group by pizza_name
order by COUNT(quantity) desc


--bottom 5 bestsellers by pizzas sold
select TOP 5 pizza_name, COUNT(quantity) as number_sold
from [PizzaDB].[dbo].[pizza_sales]
group by pizza_name
order by COUNT(quantity) ASC
