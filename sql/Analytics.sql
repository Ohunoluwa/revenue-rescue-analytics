
-- =====================================================================
-- REPORT 1: Calculating the high-level summary metrics for
--  corporate customer retention, specifically focusing on the company's 
--  Overall Churn Rate.
-- Objective: Overall churn rate
-- =====================================================================

        SELECT COUNT(customer_id) TotalCustomers,
               SUM(churn_flag) TotalLostCustomers,
               ROUND((CAST(SUM(churn_flag) AS FLOAT) / COUNT(customer_id)) * 100, 2) AS Churn_Rate_Percentage
        FROM Analytics.CustomerChurnData;


/* ======================================================================================
    Conclusion: The business is experiencing a high customer churn rate of 46.22% which
     signifies that nearly half of its customer have ended their relationship with the
     business. This signifies that the business may have negative impack on revenue growh
     and profit.        
  ======================================================================================= */



-- =====================================================================
-- REPORT 2:  Financial breakdown designed to isolate and quantify the 
-- Lost Revenue caused by customer churn by contrasting it directly
-- against retained revenue.
-- Objective: Lost Revenue
-- =====================================================================


    SELECT CASE WHEN churn_flag = 1 THEN 'Churned' ELSE 'Retained' END Customer_Status,
       COUNT(customer_id) AS Customer_Count,
       SUM(total_spent) AS Total_Revenue,
       AVG(total_spent) AS Average_Spend_Per_Customer
    FROM Analytics.CustomerChurnData
    GROUP BY churn_flag;

/* ======================================================================================
    Conclusion: Retained customers spend more on avg than churned customers, this 
     suggests that higher-spending customers are more likely to remian in business.        
  ======================================================================================= */


-- =====================================================================
-- REPORT 3: Risk Segementation Matrix designed to isolate exactly which
-- types of customers are leaving by analyzing churn behavior across
-- different customer attributes.
-- Objective: Leaving customers
-- =====================================================================

SELECT customer_segment,
       COUNT(customer_id) segement_size,
       SUM(churn_flag)churned_customers,
      ROUND((CAST(SUM(churn_flag) AS FLOAT) / COUNT(customer_id)) * 100, 2) AS segment_churn_rate
FROM Analytics.CustomerChurnData
GROUP BY customer_segment, age_group;

-- =====================================================================
-- REPORT 4: This report looks at customer behavior to find clues
-- about why people leave the company.
-- Objective: Behavioural pattern before leaving
-- =====================================================================

SELECT 
    CASE WHEN churn_flag = 1 THEN 'Churned' ELSE 'Retained' END AS customer_status,
    AVG(recency_days) AS avg_says_since_last_purchase,
    AVG(cart_abandonment_rate) AS avg_cart_abandonment_rate,
    AVG(email_open_rate) AS avg_email_open_rate,
    AVG(engagement_score) AS avg_engagement_score
FROM Analytics.CustomerChurnData
GROUP BY churn_flag;

/* ======================================================================================
    Conclusion: Retained customers are more enaged and make frequent purchases than 
     churned customers. increasing enagement rate may reduce churn rate.       
  ======================================================================================= */

--==============================
 -- Combined data report table
--=============================

  CREATE VIEW ReportData AS
    SELECT 
     customer_segment,
     CASE WHEN churn_flag = 1 THEN 'Churned' ELSE 'Retained' END AS Customer_Status,
    
     -- 1. Volume Metrics
     COUNT(customer_id) AS Total_Customers,
    
     -- 2. Financial Metrics
     SUM(total_spent) AS Total_Revenue,
     ROUND(AVG(total_spent), 2) AS Average_Spend_Per_Customer,
     ROUND(AVG(avg_order_value), 2) AS Average_Order_Value,
    
     -- 3. Behavioral Metrics
     ROUND(AVG(recency_days), 0) AS Avg_Recency_Days,
     ROUND(AVG(cart_abandonment_rate), 4) AS Avg_Cart_Abandonment_Rate,
     ROUND(AVG(email_open_rate), 4) AS Avg_Email_Open_Rate,
     ROUND(AVG(engagement_score), 2) AS Avg_Engagement_Score

  FROM Analytics.CustomerChurnData
  GROUP BY 
    customer_segment,
    CASE WHEN churn_flag = 1 THEN 'Churned' ELSE 'Retained' END;

/* ======================================================================================
    Conclusion: Reatained customers generate higher revenue, spend more on avg, make more
      purchases than churned customers. Business is safe, but can do better.
    Recommendation: More enagements should reduce churn rate.     
  ======================================================================================= */

