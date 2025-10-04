import pandas as pd
from sqlalchemy import create_engine

# MySQL connection details
user = 'finance'
password = 'root'  # replace with your MySQL root password
host = 'localhost'
port = 3306
database = 'personal_finance'

# Path to your CSV
csv_file = "PhonePe_spends_aug.csv"

# Load CSV
df = pd.read_csv(csv_file)

# Optional: auto-categorize vendors
category_map = {
    'Swiggy': 'Food',
    'Zomato': 'Food',
    'Zepto': 'Groceries',
    'BigBasket': 'Groceries',
    'Uber': 'Transport',
    'Ola': 'Transport',
    'Amazon': 'Shopping',
    'Blinkit': 'Groceries'
}

def categorize_vendor(vendor_name):
    for key, category in category_map.items():
        if key.lower() in vendor_name.lower():
            return category
    return 'Other'

df['category'] = df['vendor'].apply(categorize_vendor)

# Connect to MySQL
engine = create_engine(f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}")

# Insert into spends table
df.to_sql('spends', con=engine, if_exists='append', index=False)

print("CSV data successfully migrated to MySQL!")

