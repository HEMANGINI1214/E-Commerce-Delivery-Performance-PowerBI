CREATE DATABASE ecommerce_db;
USE ecommerce_db;

show tables;
SELECT * FROM ecommerce_shipping_data;

# Cleaning the data(EDA)
SELECT 
COUNT(*) AS total_rows,
SUM(Customer_rating IS NULL) as null_ratings
FROM ecommerce_shipping_data;

# Totalorders
SELECT COUNT(*) AS total_orders
FROM ecommerce_shipping_data;

# Shippment Mode
SELECT Mode_of_Shipment, Count(*) AS orders
FROM ecommerce_shipping_data
GROUP BY Mode_of_Shipment;

# Average Product Cost
SELECT AVG(Cost_of_the_Product) AS avg_cost
From ecommerce_shipping_data;

# ANALYTICS 
# On time vs Delayed Deliveries Percentage
describe ecommerce_shipping_data;

ALTER TABLE ecommerce_shipping_data
CHANGE `Reached.on.Time_Y.N` reached_on_time INT;

SELECT reached_on_time,
Count(*) AS Total_Orders,
Round(100.0*Count(*) / Sum(Count(*)) OVER() , 2) AS percentage
From ecommerce_shipping_data
Group by reached_on_time;

# Which Shippment most has most delays?
SELECT Mode_of_Shipment,
Count(*) As delayed_orders
From ecommerce_shipping_data
Where reached_on_time = 0
Group by Mode_of_Shipment
Order By delayed_orders;

# Warehouse with Most Delays?
SELECT Warehouse_block ,
Count(*) AS delayed_orders
From ecommerce_shipping_data
Where reached_on_time=0
Group by Warehouse_block
Order by delayed_orders DESC;

# Impact of customer rating on Delivery
Select Customer_rating, Count(*) AS total_orders,
Sum(reached_on_time) AS on_time_orders
From ecommerce_shipping_data
Group by Customer_rating
Order by Customer_rating;

# Discount vs Delivery Delay
Select Discount_offered, Count(*) AS delayed_orders
From ecommerce_shipping_data
Where reached_on_time = 0
Group by Discount_offered
Order by Discount_offered DESC;

# Customer Rating : ON TIME VS DELAYED
Select reached_on_time,
Round(AVG(Customer_rating),2) As avg_rating
From ecommerce_shipping_data
Group By reached_on_time;


# CUSTOMER & PRODUCT INSIGHTS

# High Value Customers 
Select Gender, 
Round(Avg(Cost_of_the_Product),2) As avg_product_cost,
Round(Avg(Prior_purchases),2) As avg_prior_purchases
From ecommerce_shipping_data
Group by Gender;

# Product Importance vs Delivery
Select Product_importance,
Count(*) AS delayed_orders
From ecommerce_shipping_data
Where reached_on_time = 0
Group by Product_importance;

# Gender-wise Spending Analysis
Select Gender, 
Round(Avg(Cost_of_the_Product), 2) AS avg_spending
From ecommerce_shipping_data
Group by Gender;

# Customer Care Calls vs Delays
Select Customer_care_calls, 
Count(*) AS delayed_orders
From ecommerce_shipping_data
Where reached_on_time = 0
Group by Customer_care_calls
Order by Customer_care_calls;


# Ranking Shipment Delays
Select Warehouse_block,
Count(*) AS delayed_orders,
Rank() OVER (Order by Count(*) DESC) AS delay_rank
From ecommerce_shipping_data
Where reached_on_time = 0
Group by Warehouse_block;

# Top 5% Most Expensive Orders
SELECT *
FROM ecommerce_shipping_data
WHERE Cost_of_the_product >= (
    SELECT PERCENTILE_CONT(0.95) 
    WITHIN GROUP (ORDER BY Cost_of_the_product)
    FROM ecommerce_shipping_data
);

# Repeat Customer with Delays
ALTER TABLE ecommerce_shipping_data
CHANGE `ï»¿ID` ID INT;

Select ID, Prior_purchases,
Count(*) AS delayed_orders
From ecommerce_shipping_data
Where reached_on_time = 0
And Prior_purchases >1
Group by  ID, Prior_purchases;

# Delay Rate(%) per shipment mode
Select Mode_of_Shipment,
Count(*) As total_oders,
Sum(Case When reached_on_time = 0 Then 1 Else 0 End) As delayed_orders,
Round(
100.0 * Sum(Case When reached_on_time = 0 Then 1 Else 0 End) / Count(*), 2 ) As delay_percentage
From ecommerce_shipping_data
Group by Mode_of_Shipment;