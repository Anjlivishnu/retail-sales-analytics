-- ============================================================================
-- BUSINESS QUESTION 1
-- Overall Business Performance
--
-- Objective:
-- Analyze the overall performance of the retail business by calculating
-- total sales, total profit and the total number of unique orders.
-- ============================================================================

SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT "Order ID") AS Total_Orders
FROM retail_sales;

-- --------------------------------------------------------------------------
-- Business Insight:
--
-- The company generated a total sales revenue of $2.30 million and a total
-- profit of approximately $286 thousand from 5,009 unique orders.
--
-- This provides a high-level overview of the business performance and serves
-- as the baseline for deeper analysis in the following sections.
-- --------------------------------------------------------------------------
-- ============================================================================
-- BUSINESS QUESTION 2
-- Sales Performance by Product Category
--
-- Objective:
-- Identify which product categories generate the highest sales revenue
-- to understand the major contributors to the company's revenue.
-- ============================================================================

SELECT
    Category,
    SUM(Sales) AS Total_Sales
FROM retail_sales
GROUP BY Category
ORDER BY Total_Sales DESC;

-- --------------------------------------------------------------------------
-- Business Insight:
--
-- Technology generated the highest sales revenue, followed by Furniture
-- and Office Supplies.
--
-- The result indicates that Technology is the company's strongest
-- revenue-generating product category and it should remain a strategic focus for 
--inventory planning and marketing campaigns.
-- --------------------------------------------------------------------------
-- ============================================================================
-- BUSINESS QUESTION 3
-- Profitability by Product Category
--
-- Objective:
-- Analyze the profitability of each product category to identify
-- which categories contribute the most and least to the company's profit.
-- ============================================================================

SELECT
    Category,
    SUM(Profit) AS Total_Profit
FROM retail_sales
GROUP BY Category
ORDER BY Total_Profit DESC;

-- --------------------------------------------------------------------------
-- Business Insight:
--
-- Technology generated the highest total profit, whereas Furniture
-- generated the lowest profit despite having comparable sales.
--
-- This indicates that high sales do not necessarily translate into
-- high profitability. Further analysis of pricing, discounts, and
-- costs within the Furniture category is recommended.
-- --------------------------------------------------------------------------
-- ============================================================================
-- BUSINESS QUESTION 4
-- Profit Margin by Product Category
--
-- Objective:
--Analyze the profit margin of each product category to evaluate
--how efficiently each category converts sales into profit.
-- ============================================================================

SELECT
    Category,
	SUM(Sales) AS Total_Sales,
	SUM(Profit) AS Total_Profit,
    (SUM(Profit)/SUM(Sales))*100 AS Profit_Margin
FROM retail_sales
GROUP BY Category
ORDER BY Profit_Margin DESC;

-- --------------------------------------------------------------------------
-- Business Insight:
--
-- Technology achieved the highest profit margin of approximately 17%, 
-- while Furniture achieved the lowest profit margin of  approximately
--  2% despite having comparable sales to Office Supplies.
--
-- This indicates that high sales do not necessarily translate into
-- high profitability. Further analysis of pricing, discounts, and
-- costs within the Furniture category is recommended.
------------------------------------------------------------------------------------
-- ============================================================================
-- BUSINESS QUESTION 5
-- Profit and Sales Analysis by Product Sub-Category
--
-- Objective:
--Analyze the sales performance, profitability and profit margin of each product sub-category 
-- to identify high-performing and underperforming products.
-- ============================================================================

SELECT
    "Sub-Category", 
	SUM(Sales) AS Total_Sales,
	SUM(Profit) AS Total_Profit,
    (SUM(Profit)/SUM(Sales))*100 AS Profit_Margin,
	COUNT(*) AS No_of_Order_Lines
FROM retail_sales
GROUP BY "Sub-Category"
ORDER BY Profit_Margin DESC;

-- --------------------------------------------------------------------------
--Business Insight:

-- Observation:
-- Labels and Paper achieved the highest profit margins of approximately 44% and 43%, respectively.
--Supplies, Bookcases and Tables recorded negative profit margins.

-- Business Interpretation:
-- High order volume does not necessarily translate into higher profitability.
--Some sub-categories with relatively few order-lines (such as Copiers) achieved strong margins.

-- Recommendation:
-- Investigate discounts, pricing strategy, regional demand and seasonal purchasing patterns 
-- for low-performing sub-categories before making pricing decisions.

------------------------------------------------------------------------------------
-- ============================================================================
-- BUSINESS QUESTION 6
--Identifying High-Value Customers
--
-- Objective:
--To analyze customer purchasing behaviour and identify high-value customers based 
-- on their sales, profitability, and purchasing frequency.
-- ============================================================================

SELECT
    "Customer Name", 
	SUM(Sales) AS Total_Sales,
	SUM(Profit) AS Total_Profit,
	COUNT(DISTINCT "Order ID") AS No_of_Orders
FROM retail_sales
GROUP BY "Customer Name"
ORDER BY Total_Profit DESC
LIMIT 10;
-- --------------------------------------------------------------------------
--Business Insight:

-- Observation:
-- Tamara Chand, Raymond Buch and Sanjit Chand contributed to high profit of around $8900, $6900
-- and $5700 across 5, 6 and 9 distinct orders. 

-- Business Interpretation:
-- High order volume does not necessarily translate into higher profitability.
--Some customers with relatively higher no.of orders (such as Keith Dawkins) contributed to 
--relatively less profit.

-- Recommendation:
-- Analyze the purchasing behaviour of high-value customers and design targeted loyalty programs or
-- personalized offers to improve retention and maximize lifetime value. 

------------------------------------------------------------------------------------
-- ============================================================================
-- BUSINESS QUESTION 7
--Geographical profitability analysis
--
-- Objective:
--To analyze the profitability of different states and identify loss-making regions 
--requiring management attention.
-- ============================================================================
SELECT State,
       SUM(Sales) AS Total_Sales,
       SUM(Profit) AS Total_Profit,
	   COUNT(*) AS No_of_Order_Lines
FROM retail_sales
GROUP BY State
HAVING Total_Profit < 0
ORDER BY Total_Profit ASC;
-- --------------------------------------------------------------------------
--Business Insight:

-- Observation:
-- Texas is the worst performing state with a loss of around $25700 followed by Ohio and 
-- Pennsylvania with a loss of around $17000 and $15500, respectively.

-- Business Interpretation:
-- Despite making high sales and a high transaction volume, some states (such as  Texas,
-- Ohio and Pennsylvania) failed to convert sales into profit,
--indicating inefficiencies in pricing, discounting, product mix, or operational costs.

-- Recommendation:
-- Investigate high-discount transactions, optimize logistics, and refine pricing strategies 
--to improve profitability while maintaining sales performance.

------------------------------------------------------------------------------------
-- ============================================================================
-- BUSINESS QUESTION 8
-- Monthly Sales Trend Analysis
--
-- Objective:
-- To analyze monthly sales trends, identify seasonal purchasing patterns, and 
-- provide insights for demand forecasting, inventory planning, and marketing campaigns.
-- ============================================================================

-- --------------------------------------------------------------------------
-- Data Cleaning:
--
-- The "Order Date" column contains multiple date formats:
-- • DD-MM-YYYY
-- • M/DD/YYYY
-- • MM/DD/YYYY
--
-- Since SQLite's strftime() function requires a recognized date format,
-- the dates are standardized to YYYY-MM-DD before analysis.
-- --------------------------------------------------------------------------
SELECT
    "Order Date",

    CASE
        WHEN INSTR("Order Date", '-') > 0 THEN
            SUBSTR("Order Date",7,4) || '-' ||
            SUBSTR("Order Date",4,2) || '-' ||
            SUBSTR("Order Date",1,2)

        WHEN LENGTH("Order Date") = 10 THEN
            SUBSTR("Order Date",7,4) || '-' ||
            SUBSTR("Order Date",1,2) || '-' ||
            SUBSTR("Order Date",4,2)

        ELSE
            SUBSTR("Order Date",6,4) || '-' ||
            '0' || SUBSTR("Order Date",1,1) || '-' ||
            SUBSTR("Order Date",3,2)
    END AS Standardized_Date

FROM retail_sales
LIMIT 30;
-- --------------------------------------------------------------------------
-- Monthly Sales Trend Analysis
-- --------------------------------------------------------------------------
SELECT
    strftime('%Y-%m', Standardized_Date) AS Month_Year,
    SUM(Sales) AS Total_Sales,
	COUNT(*) AS No_of_Order_Lines
FROM
(
    SELECT
        Sales,

        CASE
            WHEN INSTR("Order Date", '-') > 0 THEN
                SUBSTR("Order Date",7,4) || '-' ||
                SUBSTR("Order Date",4,2) || '-' ||
                SUBSTR("Order Date",1,2)

            WHEN LENGTH("Order Date") = 10 THEN
                SUBSTR("Order Date",7,4) || '-' ||
                SUBSTR("Order Date",1,2) || '-' ||
                SUBSTR("Order Date",4,2)

            ELSE
                SUBSTR("Order Date",6,4) || '-' ||
                '0' || SUBSTR("Order Date",1,1) || '-' ||
                SUBSTR("Order Date",3,2)
        END AS Standardized_Date

    FROM retail_sales
)

GROUP BY Month_Year
ORDER BY Month_Year;
-- --------------------------------------------------------------------------
--Business Insight:

-- Observation:
-- Highest sales of approximately $89300 was observed in November 2017 across 375 orderlines and 
-- 2014 February showed the lowest sales of around $12700 across just 86 order-lines. 

-- Business Interpretation:
-- The sales showed an increasing trend over the years along with an increase in order-lines 
-- over the years indicating improved purchase patterns over the years.

-- Recommendation:
-- The company should leverage historical sales patterns for demand forecasting by increasing 
-- inventory, marketing efforts, and operational capacity ahead of peak periods such as November. 
--Conversely, targeted promotions and customer engagement initiatives should be implemented 
--during historically weaker months, such as February, to improve sales consistency. 

------------------------------------------------------------------------------------
-- ============================================================================
-- BUSINESS QUESTION 9
-- Impact of Discounts on Profitability
--
-- Objective:
--To analyze the relationship between discounts and profitability across product sub-categories.
-- ============================================================================

SELECT
    "Sub-Category", 
	 AVG(discount) AS Average_Discount,
	SUM(Sales) AS Total_Sales,
	SUM(Profit) AS Total_Profit,
   (SUM(Profit)/SUM(Sales))*100 AS Profit_Margin
FROM retail_sales
GROUP BY "Sub-Category"
ORDER BY Average_Discount DESC;
-- --------------------------------------------------------------------------
--Business Insight:

-- Observation:
-- Binders received highest average discount of 0.37 with a good profit margin of 15%
-- whereas Tables and Bookcases also received an average discount of 0.26 and 0.21, respectively.
--But both of them has negative profit margin.

-- Business Interpretation:
-- Higher discounts do not necessarily result in lower profitability. It can be one of the 
-- contributing factors for low profitability along with other factors such as customer
-- purchasing behaviour, product demand, inefficiency in pricing, etc.


-- Recommendation:
-- Evaluate pricing strategies, product costs, operational expenses, and 
-- market dynamics alongside discount policies to improve overall profitability.
 ------------------------------------------------------------------------------------

 -- ============================================================================
-- END OF RETAIL SALES ANALYSIS
-- ============================================================================



