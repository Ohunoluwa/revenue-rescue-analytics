## Revenue Rescue: Customer Churn & Sales Intelligence Platform

## Overview
  Revenue Rescue is an end-to-end business analytics project designed to help organizations identify declining sales patterns and predict customer churn using SQL,  Python, Machine Learning, and Tableau.The system transforms raw retail transaction data into actionable business insights through data engineering, analytics, predictive modeling, and interactive dashboards.
  
## Business Problem
 Many organizations struggle with two major challenges:
  1) Declining sales performance
  2) Increasing customer churn
 High customer churn directly affects revenue growth, profitability, and long-term customer retention.
 This project answers critical business questions such as:
  1) What is the current churn rate?
  2) Which customer segments are at the highest risk?
  3) What behaviors indicate churn?
  4) What factors are driving customer loss?
  5) How can businesses proactively retain customers?

## Tech Stack
 Python
 SQL Server
 Pandas
 Scikit-Learn
 Tableau
 Kaggle API
 
## Project Architecture
  Raw Dataset (Kaggle)
  Python API Pipeline
  SQL Server Database
  Data Cleaning & Validation
  SQL Analytics
  Machine Learning Model
  Tableau Dashboard

## Workflow

## 1. Data Ingestion
 Download retail churn dataset from Kaggle API
 Load dataset into SQL Server
 
## 2. Data Validation
 Performed checks for:

 Missing customer IDs
 Missing churn records
 Duplicate rows
 Invalid numerical values
 Inconsistent categorical values
 
## . SQL Analytics

 Business reports generated:

 Overall churn rate
 Revenue loss analysis
 Customer segment analysis
 Customer behavioral patterns
 
## 4. Machine Learning

 A Random Forest Classifier was used to predict customer churn risk with 94.24% accuracy 

 Outputs:

 Churn probability score
 High-risk customer identification
 Top churn drivers
 
## 5. Tableau Dashboard

 Interactive dashboard featuring:

 Executive KPI cards
 Churn rate analysis
 Revenue breakdown
 Customer segmentation
 High-risk customer insights

## Key Insights

 ## Overall Churn Rate:

   46.22% of customers have churned, indicating significant customer retention issues.

 ## Revenue Impact

  Retained customers spend significantly more than churned customers.

 ## Behavioral Drivers of Churn

  Top churn indicators include:

1) High recency days
2) Low engagement score
3) High cart abandonment rate
4) Low email open rate

## Business Recommendation

 The primary churn driver is customer inactivity.

## Recommended actions:

 1) Automated re-engagement campaigns
 2) Personalized retention offers
 3) Customer loyalty incentives
 4) Email remarketing campaigns

Author

Oba-Adeleke Ohunluwa Elias
Data Analyst | SQL | Python | Tableau
