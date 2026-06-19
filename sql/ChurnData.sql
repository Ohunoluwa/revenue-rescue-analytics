

/* =========================================================================
   VIEW: Analyitics.CustomerChurnData
   AUTHOR: Ohunoluwa
   PROJECT: RevenueRescue
   
   PURPOSE: 
    This view cleans and prepares our raw customer data so it is ready 
    for analysis. It combines basic customer details (like age and region) 
    with shopping habits and shopping history into one single table. 
    This makes it easy to run reports, build the Tableau dashboard, 
    and find out exactly why customers are leaving.
    
    KEY METRICS/TRANSFORMATIONS:
    * Selects customer profile data (Age, Gender, Region, Segment).
    * Pulls in financial history (Total Spent, Average Order Value).
    * Tracks customer habits (Recency Days, Cart Abandonment, Email Opens).
    * Includes the final prediction results (Churn Risk, Churn Flag).
========================================================================= */


CREATE VIEW Analytics.CustomerChurnData AS
  SELECT customer_id,
         age_group,
         gender,
         region,
         customer_segment,
         preferred_channel,
         purchase_frequency,
         avg_order_value,
         total_spent,
         recency_days,
         website_visits,
         discount_usage_rate,
         email_open_rate,
         cart_abandonment_rate,
         loyalty_score,
         engagement_score,
         churn_risk,
         churn_flag
FROM RawTransactions;

--================
 --Data Check
--============
SELECT *
FROM Analytics.CustomerChurnData