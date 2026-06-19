
import pandas as pd
import urllib.parse
from sqlalchemy import create_engine
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
from datetime import datetime

def main():
    print("1. Connecting to SQL Server...")
    server_name = r'OHUNOLUWA\SQLEXPRESS' 
    database_name = 'RevenueRescue'

    params = urllib.parse.quote_plus(
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={server_name};"
        f"DATABASE={database_name};"
        f"Trusted_Connection=yes;"
    )
    engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

    print("2. Pulling clean data from the Analytics view...")

    query = "SELECT * FROM Analytics.CustomerChurnData"
    df = pd.read_sql(query, engine)
    
    print(f"Data loaded successfully: {len(df)} customers found.")

    print("3. Preprocessing the data for Machine Learning...")
    # saving the ids before we drop them so we know who is who.
    customer_ids = df['customer_id']

    # Droping ids and prevent Data Leakage by dropping the pre-calculated 'churn_risk'
    df = df.drop(['customer_id', 'churn_risk'], axis=1)

    # Separating our features (X) from our target (y)

    X = df.drop('churn_flag', axis=1)
    y = df['churn_flag']

    # Machine Learning models can't read text like "Male" or "North", so pd.get-dummiew converts the text col into 1s and 0s. 
    X_encoded = pd.get_dummies(X, drop_first=True)

    print("4. Splitting data into Training and Testing sets...")

    # We use 80% of the data to teach the model, and hide 20% to test it later
    X_train, X_test, y_train, y_test = train_test_split(X_encoded, y, test_size=0.2, random_state=42)

    print("5. Training the Random Forest Classifier (This might take a few seconds)...")
    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)

    print("6. Evaluating the Model's Performance...")
    # Now we ask the model to predict churn on the 20% of data it has never seen
    predictions = model.predict(X_test)
    accuracy = accuracy_score(y_test, predictions)
    print("\n" + "="*40)
    print(f"MODEL ACCURACY: {accuracy * 100:.2f}%")
    print("="*40)
    
    print("\nDetailed Classification Report:")
    print(classification_report(y_test, predictions))

    print("\nDetailed Classification Report:")
    print(classification_report(y_test, predictions))

    print("\n" + "="*40)
    print("7. Extracting Top Churn Drivers (Feature Importance)...")
    print("="*40)
    
    # Getting the feature names and their importance scores
    feature_names = X_encoded.columns
    importances = model.feature_importances_
    
    # Creating a DataFrame to make it look nice, and sort it
    feature_df = pd.DataFrame({
        'Feature': feature_names,
        'Importance': importances
    }).sort_values(by='Importance', ascending=False)
    
    # Printing the top 10 reasons customers are leaving
    print(feature_df.head(10).to_string(index=False))

    print("\n" + "="*40)
    print("8. Pushing Predictions back to SQL for Tableau...")
    print("="*40)
    
    # Predicting the exact percentage risk (0% to 100%) for EVERY customer
    probabilities = model.predict_proba(X_encoded)[:, 1] 
    
    # Creating a new clean table with just the Customer ID and their Risk Score
    predictions_df = pd.DataFrame({
        'customer_id': customer_ids,
        'Churn_Probability': probabilities
    })
    
    # Saving this table directly into SQL Server database!
    predictions_df.to_sql(
        name='ChurnPredictions', 
        con=engine, 
        schema='Analytics', 
        if_exists='replace', 
        index=False
    )
    print("Success! ML predictions are now waiting in SQL Server for Tableau.")

    # ---CODE FOR TABLEAU PUBLIC ---

    print("\n" + "="*40)
    print("9. Exporting CSV files for Tableau Public...")
    print("="*40)
    
    # Getting the exact current date and time
    current_time = datetime.now().strftime("%Y-%m-%d %I:%M %p")

    # 1. Exporting the predictions
    predictions_df['Last_Refreshed'] = current_time
    predictions_df.to_csv('Churn_Predictions.csv', index=False)
    
    # 2. Exporting the high-level report data we made in SQL earlier
    report_df = pd.read_sql("SELECT * FROM ReportData", engine)
    report_df['Last_Refreshed'] = current_time
    report_df.to_csv('Report_Data.csv', index=False)
    
    # 3. Exporting the customer details so we know who to email
    customer_df = pd.read_sql("SELECT * FROM Analytics.CustomerChurnData", engine)
    customer_df.to_csv('Customer_Details.csv', index=False)
    
    print("Done.....")

if __name__ == "__main__":
    main()

##===================================================================================
  ## CONCLUSION: The main reason we lose customers is becasue its been too long
  #   they made their last purchase. To fix this, we can set up automatic emails that
  #   reach out once they have not purchased anything after a long while.
##=====================================================================================  