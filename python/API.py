import os
import urllib.parse
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

# --- 1. Authenticate with Kaggle ---
# Loading the hidden environment variables
load_dotenv() 

# Setting the token into the environment so the Kaggle library can find it
os.environ['KAGGLE_API_TOKEN'] = os.getenv("KAGGLE_API_TOKEN")

import kaggle
def main():
    # --- 2. Downloading the Dataset via API ---

    print("Downloading dataset from Kaggle...")
    
    # Dataset identifier
    dataset_name = 'noopurbhatt/retail-intelligence-customer-churn-dataset'

    # API Repository
    kaggle.api.dataset_download_files(dataset_name, path='.', unzip=True)
    print("Download complete.")

    # --- 3. Locate and Read the CSV ---
    
    csv_files = [f for f in os.listdir('.') if f.endswith('.csv')]
    
    if not csv_files:
        print("Error: No CSV file found. Please check the dataset link.")
        return
        
    csv_file = csv_files[0]
    print(f"Reading '{csv_file}' into memory. This might take a moment...")
    
    # Loading it into pandas.frame

    df_raw = pd.read_csv(csv_file)
  
    # --- 4. Configure SQL Server Connection ---
    print("Preparing SQL Server connection...")
    
    server_name = r'OHUNOLUWA\SQLEXPRESS' 
    database_name = 'RevenueRescue'

    # Using Windows Authentication (Trusted_Connection=yes)
    params = urllib.parse.quote_plus(
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={server_name};"
        f"DATABASE={database_name};"
        f"Trusted_Connection=yes;"
    )
    
    db_connection_string = f"mssql+pyodbc:///?odbc_connect={params}"
    engine = create_engine(db_connection_string)

    # --- 5. Push RAW Data to SQL Server ---
    print(f"Pushing {len(df_raw)} rows to SQL Server table 'RawTransactions'...")
    
    try:
        # Uploading the dataframe to SQL
        df_raw.to_sql(
            name='RawTransactions', 
            con=engine, 
            schema='dbo', 
            if_exists='replace', # If the table already exists, drop it and recreate it
            index=False,
            chunksize=5000       # Uploads in batches to prevent memory overload
        )
        print("Success! The raw data is now safely in SQL Server.")
    except Exception as e:
        print("An error occurred while uploading to SQL Server:")
        print(e)

if __name__ == "__main__":
    main()



