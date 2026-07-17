import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://root:password@localhost:3306/project"
)

# tables = [
#     "DimDate",
#     "DimCustomer",
#     "DimProduct",
#     "DimStore",
#     "DimLoyaltyProgram",
#     "FactOrders"
# ]

# for table in tables:
query='SELECT * FROM DimLoyaltyProgram'
df = pd.read_sql(query, engine)
df.to_csv('DimLoyaltyProgram.csv', index=False)
print('DimLoyaltyProgram.csv')

print("All CSV files exported successfully!")