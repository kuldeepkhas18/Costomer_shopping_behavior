
USE data_analysis_project

SELECT * FROM customer_shopping_behavior

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Business Insights question
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--1. which category generates highest revenue?

SELECT
     category,
    ROUND(SUM(purchase_amount),2) AS highest_revenue
    FROM customer_shopping_behavior
    GROUP BY category
    ORDER BY highest_revenue DESC

--? Business Problem :- Company does not know which category contributes most to revenue

-- impact :- 
          --helps prioritize high-performing categories
          -- optimizes inventory plannig
          -- Improves marketing ROI
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--2.Are discounts actually incrasing purchase value?

SELECT 
    discount_applied,
    ROUND(SUM(purchase_amount),2) AS total_revenue,
    ROUND(AVG(purchase_amount),2) AS avg_purchase
    FROM customer_shopping_behavior
    GROUP BY discount_applied

--?Business Problem :- Discount may reduce profit without increasing sale.
  
-- Impact:- 
          --Identify effectiveness of discounts
          -- Reduce unnecessary discount costs
          -- Imporve profit margins

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--3. What is the total revenue generate by male and female customer?
SELECT
     gender,
     ROUND(SUM(purchase_amount),2) AS highest_revenue
     FROM customer_shopping_behavior
     GROUP BY gender
     ORDER BY highest_revenue DESC

--? Business Problem :- Lack of understanding of revenue contribution by gender segments.

--Impact :-
    -- Helps design targeted marketing campaigns
    -- Improves customer segmentation strategy
    -- Enhances personalization efforts

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--4.Which customer used a discount but still spent more than the average purchase amaount?

SELECT  TOP 10
     customer_id,
     purchase_amount,
     discount_applied
   FROM customer_shopping_behavior
   WHERE discount_applied='yes' AND purchase_amount > (SELECT AVG(purchase_amount) FROM customer_shopping_behavior)

-- Business Problem :- Company cannot identify high-spending customers who are also discount users

--Impact :-
-- Identifies premium discount-sensitive customers
-- Enables targeted discount campaigns
-- Improves customer retention and revenue

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--5. which are the top/bottom 5 product with the highest average review rating.
SELECT * FROM customer_shopping_behavior
SELECT TOP 5
    item_purchased,
    ROUND(AVG(review_rating),2) AS Avg_ratings
    FROM customer_shopping_behavior
    GROUP BY item_purchased
    ORDER BY Avg_ratings DESC

SELECT TOP 5
    item_purchased,
    ROUND(AVG(review_rating),2) AS Avg_ratings
    FROM customer_shopping_behavior
    GROUP BY item_purchased
    ORDER BY Avg_ratings ASC

--? Business Problem :- No visibility into product performance based on customer satisfaction.

--Impact :-

-- Promotes high-performing products
-- Improves low-rated products
-- Enhances customer experience

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--6.Average purchase: Standard vs Express shipping
SELECT * FROM customer_shopping_behavior

SELECT 
    shipping_type,
    COUNT(DISTINCT customer_id) as order_placed,
    ROUND(AVG(purchase_amount),2) as avg_purchase,
    ROUND(SUM(purchase_amount),2) as revenue
FROM customer_shopping_behavior 
GROUP BY shipping_type
ORDER BY revenue DESC

--? Business Problem :- Unclear if faster shipping leads to higher spending.

-- Impact

-- Helps optimize shipping pricing strategy
-- Encourages premium shipping adoption
-- Increases average order value

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--7.DO subscribed customers spend more ? compare average speed and total revenued between subscribes and non-subscribes.

SELECT 
     subscription_status,
     ROUND(AVG(purchase_amount),2) as avg_revenue,
     ROUND(SUM(purchase_amount),2) as total_revenue
FROM customer_shopping_behavior
GROUP BY subscription_status

-- Validates subscription model performance
-- Improves customer loyalty programs I
-- Increases customer lifetime value (CLV)

--? Business Problem :- The effectiveness of subscription programs is unknown.

-- Impact
         --Validates subcription model performance 
         --Improves customer loyalty programs
         --Increases customer lifetime value (CLV)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--8.TOP 5 proucts with highest discound usage%

SELECT TOP 5
     item_purchased,
     COUNT(item_purchased) as total_number_of_times_sold,
     COUNT(CASE WHEN discount_applied='yes' THEN 1 END ) as Number_of_times_sold_when_discount_applied,
     COUNT(CASE WHEN discount_applied='yes' THEn 1 END ) *100.0 / COUNT(*) as discount_percent
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY discount_percent DESC

-- ? Business Problem :- Some products may be overly dependent on discounts.

-- Impact :-
-- Identifies discount-driven products
-- Helps optimize pricing strategy
-- Reduces profit margin loss

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 9. Segment customer into new, returning and loyal based on their total number of previous purchase,
-- and show the count of each segment.

SELECT
   CASE
       WHEN previous_purchases= '0' THEN 'New Customer'
       WHEN previous_purchases BETWEEN 1 AND 15 THEN 'Returning Customer'
     ELSE 'Loyal Customers'
END AS customer_segment,
COUNT(*) AS customer_count
FROM customer_shopping_behavior
GROUP BY CASE
         WHEN previous_purchases= '0' THEN 'New Customer'
         WHEN previous_purchases BETWEEN 1 AND 15 THEN 'Returning Customer'
     ELSE 'Loyal Customers'
END

--? Business Problem :- Lack of customer segmentation leads to generic strategies.

--Impact :-
-- Enables personalized marketing
-- Improves retention strategies
-- Increases conversion rates

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--10. What are the top 3 most purchased products within each category?

WITH CTE AS
(
SELECT
     category,
     item_purchased,
     COUNT(item_purchased) AS most_purchased,
     RANK() OVER(PARTITION BY category ORDER BY COUNT(item_purchased) DESC) AS RNK
FROM customer_shopping_behavior
GROUP BY category, item_purchased
)
SELECT * FROM CTE
WHERE RNK <=3

--? Business Problem :- The company doesn't know top-performing products within categories.

-- Impact

-- Helps inventory optimization
-- Increases sales through best-sellers|
-- Improves product placement & recommendations
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 11. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe ?
SELECT
    CASE
       WHEN previous_purchases > 5 THEN 'Repeat Buyers'
       ELSE 'Normal Buyers'
    END AS customer_type,
    subscription_status,
    COUNT(*) AS customer_count,
   
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (
        PARTITION BY CASE
            WHEN previous_purchases > 5 THEN 'Repeat Buyers'
            ELSE 'Normal Buyers' 
        END
    ) AS percents
FROM customer_shopping_behavior
GROUP BY 
    CASE
         WHEN previous_purchases > 5 THEN 'Repeat Buyers'
         ELSE 'Normal Buyers'
    END,
    subscription_status;

-- 1047

--? Business Problem :- Unclear relationship between loyalty and subscription.

-- Impact :-
-- Improves subscription targeting
-- Increases conversion to paid programs
-- increase customer retention strategy

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 

 SELECT
     CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 50 THEN '35-50'
        ELSE '51+'
   END AS age_group,
   ROUND(SUM(purchase_amount) , 2) AS total_revenue
FROM customer_shopping_behavior
GROUP BY CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 50 THEN '35-50'
        ELSE '51+'
END
ORDER BY total_revenue DESC

--? Business Problem :- No visibility into which age group contributes most to revenue.

-- Impact :-
     -- Enables age-based targeting
     -- Enhances marketing efficiencyl



