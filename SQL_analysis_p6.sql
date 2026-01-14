select * from superstore WHERE CUSTOMER_ID ='DP-13390'


--1. sales by category

select Category, sum(sales) sales_amount 
	from superstore
	group by Category
	order by 2 desc

--2. top 5 customers by profit

select customer_id, customer_name, sum(profit) total_profit
	from superstore
	group by customer_id, customer_name
	order by 2 desc limit 5

--3. month wise sales trend

select DATE_TRUNC('month', order_date) as month, round(sum(sales)::numeric,2) total_sales
	from superstore
	group by month
	order by 1 
--- 4. Average Discount by Sub-Category
select sub_category, round(avg(discount)::numeric, 2) average
	from  superstore
	group by 1
	order by 2

--5.Year-over-Year Sales Growth
with yearly_sales as (
	select extract(year from order_date) sale_year,
	sum(sales) total_sales
	from superstore
	group by 1
	)
select round(total_sales::numeric,2) as current_year_sale,
	round(lag(total_sales)over(order by sale_year)::numeric,2)  prev_year_sale,
	round
	(
	case
		when lag(total_sales)over(order by sale_year) = 0 then null
		else 100*(total_sales - lag(total_sales)over(order by sale_year))/ lag(total_sales)over(order by sale_year)
	end::numeric, 2	)as YOY_sales_growth,
	case 
		when 100*(total_sales -lag(total_sales)over(order by sale_year))/lag(total_sales)over(order by sale_year) = 0 then 'no growth'
		when 100*(total_sales -lag(total_sales)over(order by sale_year))/lag(total_sales)over(order by sale_year) > 0 then 'positive growth'
		else 'negative growth'
	end growth_trend		
from yearly_sales
order by sale_year

--6. Most Profitable Product in Each Region
with cte as (
	select product_name, region, sum(profit) total_profit,
	row_number() over(partition by region order by sum(profit) desc ) ranking
	
	from superstore
	--where region <>'Central'
	group by product_name, region
	order by 2 
)

select * from cte
where ranking = 1

-- 7.Customer Lifetime Value (CLV) vs customer acquisition cost (CAC)
WITH CTE AS (
	SELECT CUSTOMER_ID,CUSTOMER_NAME, EXTRACT(YEAR FROM ORDER_DATE) PURCHASE_YEAR, COUNT(ORDER_ID) TOTAL_PURCHASE, round(sum(SALES)::numeric,2) TOTAL_sales,
	round(sum(profit)::numeric,2) total_profit, round(sum(discount)::numeric,2) total_discount_avl
	FROM superstore
	group by 1,2,3
	),
CUSTOMER AS (
	SELECT CUSTOMER_ID,CUSTOMER_NAME,PURCHASE_YEAR,
		CASE
		WHEN 
		(LAG(TOTAL_PURCHASE)OVER(PARTITION BY CUSTOMER_ID) < TOTAL_PURCHASE )
			OR 
				(LAG(TOTAL_SALES)OVER(PARTITION BY CUSTOMER_ID)<TOTAL_SALES 
				AND LAG(total_profit)OVER(PARTITION BY CUSTOMER_ID)< total_profit 
					AND LAG(total_discount_avl)OVER(PARTITION BY CUSTOMER_ID)> total_discount_avl ) THEN 'HIGH VALUE CUSTOMER' 
		ELSE 'LOW VALUE CUSTOMER'
		END CUSTOMER_VALUE_S ,
		CASE
			WHEN LAG(PURCHASE_YEAR)OVER(PARTITION BY PURCHASE_YEAR) IS NULL THEN 'NEW CUSTOMER'
			ELSE 'EXISTING CUSTOMER'
		END CUSTOMER_TYPE
	
		FROM CTE
)
SELECT CUSTOMER_ID,CUSTOMER_NAME,PURCHASE_YEAR, CUSTOMER_TYPE,
	CASE
		WHEN CUSTOMER_TYPE ='NEW CUSTOMER' AND CUSTOMER_VALUE_S = 'HIGH VALUE CUSTOMER' THEN 'N/A'
		ELSE CUSTOMER_VALUE_S
	END CUSTOMER_VALUE
FROM CUSTOMER ,CTE






--
-- 7.Customer Lifetime Value (CLV) vs customer acquisition cost (CAC)
WITH CTE AS (
	SELECT CUSTOMER_ID,CUSTOMER_NAME, EXTRACT(YEAR FROM ORDER_DATE) PURCHASE_YEAR, COUNT(ORDER_ID) TOTAL_PURCHASE, round(sum(SALES)::numeric,2) TOTAL_sales,
	round(sum(profit)::numeric,2) total_profit, round(sum(discount)::numeric,2) total_discount_avl
	FROM superstore
	group by 1,2,3
	),
LAG_CTE AS (
	SELECT *,
		LAG(TOTAL_PURCHASE)OVER(PARTITION BY CUSTOMER_ID ORDER BY PURCHASE_YEAR) PRV_PURCHASE,
		LAG(TOTAL_SALES) OVER (PARTITION BY CUSTOMER_ID ORDER BY PURCHASE_YEAR) AS PREV_SALES,
		LAG(TOTAL_PROFIT) OVER (PARTITION BY CUSTOMER_ID ORDER BY PURCHASE_YEAR) AS PREV_PROFIT,
		LAG(TOTAL_DISCOUNT_AVL) OVER (PARTITION BY CUSTOMER_ID ORDER BY PURCHASE_YEAR) AS PREV_DISCOUNT,
		ROW_NUMBER() OVER (PARTITION BY CUSTOMER_ID ORDER BY PURCHASE_YEAR DESC) AS RN
    FROM CTE
)
	SELECT CUSTOMER_ID,CUSTOMER_NAME,
		CASE
		WHEN 		
		(LAG(TOTAL_PURCHASE)OVER(PARTITION BY CUSTOMER_ID ORDER BY PURCHASE_YEAR) < TOTAL_PURCHASE )
			OR 
				(LAG(TOTAL_SALES)OVER(PARTITION BY CUSTOMER_ID ORDER BY PURCHASE_YEAR)<TOTAL_SALES 
				AND LAG(total_profit)OVER(PARTITION BY CUSTOMER_ID ORDER BY PURCHASE_YEAR)< total_profit 
					AND LAG(total_discount_avl)OVER(PARTITION BY CUSTOMER_ID ORDER BY PURCHASE_YEAR)> total_discount_avl ) THEN 'HIGH VALUE CUSTOMER' 
		ELSE 'LOW VALUE CUSTOMER'
		END CUSTOMER_VALUE_S ,
		CASE
			WHEN PRV_PURCHASE IS NULL THEN 'NEW CUSTOMER'
			--WHEN LAG(PURCHASE_YEAR)OVER(PARTITION BY PURCHASE_YEAR ORDER BY PURCHASE_YEAR) IS NULL THEN 'NEW CUSTOMER'
			ELSE 'EXISTING CUSTOMER'
		END CUSTOMER_TYPE
FROM  LAG_CTE
WHERE RN = 1  
AND CUSTOMER_ID ='DP-13390'

--8. Shipping Delay Analysis

SELECT ORDER_ID, ORDER_DATE,
	SHIP_DATE, SHIP_MODE, (SHIP_DATE - ORDER_DATE) SHIPPING_DAYS
	FROM superstore
	WHERE (SHIP_DATE - ORDER_DATE)> interval '5 days'


--9. Profit Contribution % by Sub-Category
select sub_category,
	round(sum(profit) ::numeric,2) total_profit,
	round(
	(100 * sum(profit) / sum(sum(profit))over())::numeric,2) total_profit_percentage
from superstore
group by sub_category
order by 3 desc
	
-- 10. RFM (Recency, Frequency, Monetary) Segmentation
select customer_id, customer_name,
	max(order_date) recent_purchase,
	count(distinct order_id) frequency_order,
	round(sum(sales)::numeric,2) monetary
from superstore
group by 1, 2
order by 1

--- 11. Detect Loss-Making Products

select product_id, product_name, 
	round(sum(sales)::numeric,2) total_sales, round(sum(profit)::numeric,2) total_profit
from superstore
group by 1,2 
having sum(profit)>0
order by 4 desc





--- 12. Rolling 3-Month Sales Average
select DATe_TRUNC('MONTH', order_date ) AS month,
	SUM(SALES) TOTAL_SALES,
	AVG(SUM(SALES))OVER(ORDER BY DATe_TRUNC('MONTH', order_date )	ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
	 ROLLING_AVG

FROM SUPERSTORE
GROUP BY 1

--13.CUMULATIVE AVG PER ORDER
select order_id, avg(sales) over(partition by order_id order by extract(month from order_date)
rows between unbounded PRECEDING and current row) running_total
from superstore;