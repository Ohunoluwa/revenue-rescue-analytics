
SELECT *
FROM RawTransactions
---======================
   -- Data Check
--======================


 --====================================
  -- 1.Check for missing Customer IDs
--=====================================
  SELECT customer_id,
         COUNT(*) 
  FROM RawTransactions
  GROUP BY customer_id
  HAVING COUNT(*) > 1 OR customer_id IS NULL 

  --OR Just playing around ykk.... 

 SELECT 
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS MissingCustomerIDs,
    SUM(CASE WHEN churn_risk IS NULL THEN 1 ELSE 0 END) AS MissingChurns
FROM RawTransactions;

--==================================
 --2.  Check for inconsistent texts
--==================================

       SELECT gender, COUNT(*) Total_genders
        FROM RawTransactions
       GROUP BY gender

       SELECT DISTINCT gender
       FROM RawTransactions

       SELECT DISTINCT region
       FROM RawTransactions

       SELECT DISTINCT preferred_channel
       FROM RawTransactions

--=====================================
  --3. Checking for impossible values
--=====================================
       SELECT COUNT(*) Impossible_values
       FROM RawTransactions 
       WHERE total_spent < 0
       OR purchase_frequency < 0
       OR avg_order_value < 0
       OR recency_days < 0

-- Checking boundaries

       SELECT 
        MIN(email_open_rate) AS min_email_rate,
        MAX(email_open_rate) AS max_email_rate,
        MIN(cart_abandonment_rate) AS min_cart_rate,
        MAX(cart_abandonment_rate) AS max_cart_rate,
        MIN(loyalty_score) AS min_loyalty,
        MAX(loyalty_score) AS max_loyalty
       FROM RawTransactions;

       

--==============================
--CONCLUSION: Data is perfect.
--=============================