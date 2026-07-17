-- Dimension Table: DimDate
CREATE TABLE DimDate (
    DateID INT PRIMARY KEY,
    Date DATE,
    DayOfWeek VARCHAR(10),
    Month VARCHAR(10),
    Quarter INT,
    Year INT,
    IsWeekend BOOLEAN
);

-- Dimension Table: DimCustomer
CREATE or replace TABLE DimCustomer (
    CustomerID INT PRIMARY KEY autoincrement start 1 increment 1,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Gender VARCHAR(100),
    DateOfBirth DATE,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(100),
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    ZipCode VARCHAR(100),
    Country VARCHAR(200),
    LoyaltyProgramID INT
);

-- Dimension Table: DimProduct
CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY autoincrement start 1 increment 1,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Brand VARCHAR(50),
    UnitPrice DECIMAL(10, 2)
);

-- Dimension Table: DimStore
CREATE or replace TABLE DimStore (
    StoreID INT PRIMARY KEY autoincrement start 1 increment 1,
    StoreName VARCHAR(200),
    StoreType VARCHAR(100),
	StoreOpeningDate DATE,
    Address VARCHAR(255),
    City VARCHAR(200),
    State VARCHAR(200),
    Country VARCHAR(200),
    Region VARCHAR(200),
    ManagerName VARCHAR(100)
);

-- Dimension Table: DimLoyaltyProgram
CREATE TABLE DimLoyaltyProgram (
    LoyaltyProgramID INT PRIMARY KEY,
    ProgramName VARCHAR(100),
    ProgramTier VARCHAR(50),
    PointsAccrued INT
);

-- Fact Table: FactOrders
CREATE TABLE FactOrders (
    OrderID INT PRIMARY KEY autoincrement start 1 increment 1,
    DateID INT,
    CustomerID INT,
    ProductID INT,
    StoreID INT,
    QuantityOrdered INT,
    OrderAmount DECIMAL(10, 2),
    DiscountAmount DECIMAL(10, 2),
    ShippingCost DECIMAL(10, 2),
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (StoreID) REFERENCES DimStore(StoreID)
);
select * from DimCustomer;

-- importing data from stage layer

-- CREATE OR REPLACE FILE FORMAT CSV_SOURCE_FILE_FORMAT
-- TYPE='CSV'
-- SKIP_HEADER=1
-- FIELD_OPTIONALLY_ENCLOSED_BY='"'
-- DATE_FORMAT='YYYY-MM-DD';
copy into DimDate (
    DateID,
    Date,
    DayOfWeek,
    Month,
    Quarter,
    Year,
    IsWeekend)
    from @util_db.public.my_stage2/DimDate.csv
    file_format=(format_name='CSV_SOURCE_FILE_FORMAT');
   
   copy into DimCustomer (
    FirstName,
    LastName,
    Gender,
    DateOfBirth,
    Email,
    PhoneNumber,
    Address,
    City,
    State,
    ZipCode,
    Country,
    LoyaltyProgramID
)
    from @util_db.public.my_stage2/data.csv
    file_format=(format_name='CSV_SOURCE_FILE_FORMAT');

    copy into DimProduct (
    ProductName,
    Category,
    Brand,
    UnitPrice)
    from @util_db.public.my_stage2/DimProductData.csv
    file_format=(format_name='CSV_SOURCE_FILE_FORMAT');

  copy into DimStore (
    StoreName,
    StoreType,
	StoreOpeningDate,
    Address,
    City,
    State,
    Country,
    Region,
    ManagerName
)
    from @util_db.public.my_stage2/DimStoreData.csv
    file_format=(format_name='CSV_SOURCE_FILE_FORMAT');

    copy into DimLoyaltyProgram 
    from @util_db.public.my_stage2/DimLoyaltyProgram.csv
    file_format=(format_name='CSV_SOURCE_FILE_FORMAT');

  copy into FactOrders (
    DateID,
    CustomerID,
    ProductID,
    StoreID,
    QuantityOrdered,
    OrderAmount,
    DiscountAmount,
    ShippingCost,
    TotalAmount)
    from @util_db.public.my_stage2/factorders.csv
    file_format=(format_name='CSV_SOURCE_FILE_FORMAT');

-- creating new user
 CREATE OR REPLACE USER Test_PowerBI_User
 PASSWORD='Test_PowerBI_User'
 LOGIN_NAME='PowerBI User'
 DEFAULT_ROLE= 'ACCOUNTADMIN'
 DEFAULT_WAREHOUSE= 'COMPUTE_WH'
 MUST_CHANGE_PASSWORD=TRUE;
 grant role accountadmin to user Test_PowerBI_User;

 