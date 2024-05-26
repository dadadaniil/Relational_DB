--  Create the following staging tables:
CREATE TABLE staging_order_details
(
    orderid     INT NOT NULL,
    productid   INT NOT NULL,
    unitprice   DECIMAL(10, 2) NOT NULL,
    qty         SMALLINT NOT NULL,
    discount    DECIMAL(10, 2) NOT NULL

);

CREATE TABLE staging_customers
(
    custid       SERIAL PRIMARY KEY NOT NULL,
    companyname  VARCHAR(40) NOT NULL,
    contactname  VARCHAR(30) NULL,
    contacttitle VARCHAR(30) NULL,
    address      VARCHAR(60) NULL,
    city         VARCHAR(15) NULL,
    region       VARCHAR(15) NULL,
    postalcode   VARCHAR(10) NULL,
    country      VARCHAR(15) NULL,
    phone        VARCHAR(24) NULL,
    fax          VARCHAR(24) NULL
);

CREATE TABLE staging_employees
(
     empid      SERIAL  PRIMARY KEY NOT NULL, 
     lastname        VARCHAR (20) NOT NULL, 
     firstname       VARCHAR (10) NOT NULL, 
     title           VARCHAR (30) NULL, 
     titleofcourtesy VARCHAR (25) NULL, 
     birthdate       TIMESTAMP NULL, 
     hiredate        TIMESTAMP NULL, 
     address         VARCHAR (60) NULL, 
     city            VARCHAR (15) NULL, 
     region          VARCHAR (15) NULL, 
     postalcode      VARCHAR (10) NULL, 
     country         VARCHAR (15) NULL, 
     phone       VARCHAR (24) NULL, 
     extension       VARCHAR (4) NULL, 
     photo           BYTEA NULL, 
     notes           TEXT NULL, 
     mgrid       INT NULL, 
     photopath       VARCHAR (255) NULL
 
);



CREATE TABLE staging_products
(
    productid       SERIAL PRIMARY KEY NOT NULL,
    productname     VARCHAR(40) NOT NULL,
    supplierid      INT NULL,
    categoryid      INT NULL,
    quantityperunit VARCHAR(20) NULL,
    unitprice       DECIMAL(10, 2) NULL,
    unitsinstock    SMALLINT NULL,
    unitsonorder    SMALLINT NULL,
    reorderlevel    SMALLINT NULL,
    discontinued    CHAR(1) NOT NULL
);


CREATE TABLE staging_categories
(
    categoryid   SERIAL PRIMARY KEY NOT NULL,
    categoryname VARCHAR(15) NOT NULL,
    description  TEXT NULL,
    picture      BYTEA NULL
);



CREATE TABLE staging_shippers
(
    shipperid   SERIAL PRIMARY KEY NOT NULL,
    companyname VARCHAR(40) NOT NULL,
    phone       VARCHAR(44) NULL
);



CREATE TABLE staging_suppliers
(
    supplierid   SERIAL PRIMARY KEY NOT NULL,
    companyname  VARCHAR(40) NOT NULL,
    contactname  VARCHAR(30) NULL,
    contacttitle VARCHAR(30) NULL,
    address      VARCHAR(60) NULL,
    city         VARCHAR(15) NULL,
    region       VARCHAR(15) NULL,
    postalcode   VARCHAR(10) NULL,
    country      VARCHAR(15) NULL,
    phone        VARCHAR(24) NULL,
    fax          VARCHAR(24) NULL,
    homepage     TEXT NULL
);


CREATE TABLE staging_orders
(
    orderid        SERIAL PRIMARY KEY NOT NULL,
    custid         VARCHAR(15) NULL,
    empid          INT NULL,
    orderdate      TIMESTAMP NULL,
    requireddate   TIMESTAMP NULL,
    shippeddate    TIMESTAMP NULL,
    shipperid      INT NULL,
    freight        DECIMAL(10, 2) NULL,
    shipname       VARCHAR(40) NULL,
    shipaddress    VARCHAR(60) NULL,
    shipcity       VARCHAR(15) NULL,
    shipregion     VARCHAR(15) NULL,
    shippostalcode VARCHAR(10) NULL,
    shipcountry    VARCHAR(15) NULL
);



-- 2. Use the proposed set of dimension tables and their respective columns.
-- DimDate table
CREATE TABLE DimDate (
    DateID SERIAL PRIMARY KEY,
    Date DATE,
    Day INT,
    Month INT,
    Year INT,
    Quarter INT,
    WeekOfYear INT
);

-- DimCustomer table
CREATE TABLE DimCustomer (
    CustomerID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(40),
    ContactName VARCHAR(30),
    ContactTitle VARCHAR(30),
    Address VARCHAR(60),
    City VARCHAR(15),
    Region VARCHAR(15),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    Phone VARCHAR(24)
);

-- DimProduct table
CREATE TABLE DimProduct (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(40),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit VARCHAR(20),
    UnitPrice DECIMAL(10, 2),
    UnitsInStock SMALLINT
);

-- DimEmployee table
CREATE TABLE DimEmployee (
    EmployeeID SERIAL PRIMARY KEY,
    LastName VARCHAR(20),
    FirstName VARCHAR(10),
    Title VARCHAR(30),
    BirthDate TIMESTAMP,
    HireDate TIMESTAMP,
    Address VARCHAR(60),
    City VARCHAR(15),
    Region VARCHAR(15),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    HomePhone VARCHAR(24),
    Extension VARCHAR(4)
);

-- DimCategory table
CREATE TABLE DimCategory (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(15),
    Description TEXT
);

-- DimShipper table
CREATE TABLE DimShipper (
    ShipperID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(40),
    Phone VARCHAR(44)
);

-- DimSupplier table
CREATE TABLE DimSupplier (
    SupplierID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(40),
    ContactName VARCHAR(30),
    ContactTitle VARCHAR(30),
    Address VARCHAR(60),
    City VARCHAR(15),
    Region VARCHAR(15),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    Phone VARCHAR(24)
);

-- The table FactSales with the columns below
CREATE TABLE FactSales (
    SalesID SERIAL PRIMARY KEY,
    DateID INT,
    CustomerID INT,
    ProductID INT,
    EmployeeID INT,
    CategoryID INT,
    ShipperID INT,
    SupplierID INT,
    QuantitySold SMALLINT,
    UnitPrice DECIMAL(10, 2),
    Discount DECIMAL(10, 2),
    TotalAmount DECIMAL(10, 2),
    TaxAmount DECIMAL(10, 2),
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (EmployeeID) REFERENCES DimEmployee(EmployeeID),
    FOREIGN KEY (CategoryID) REFERENCES DimCategory(CategoryID),
    FOREIGN KEY (ShipperID) REFERENCES DimShipper(ShipperID),
    FOREIGN KEY (SupplierID) REFERENCES DimSupplier(SupplierID)
);

--Load Data Into Staging, Transformation, and Star Schema

INSERT INTO staging_customers 
SELECT * FROM Customer;

INSERT INTO staging_categories 
SELECT * FROM Category;

INSERT INTO staging_order_details
SELECT * FROM orderdetail;

INSERT INTO staging_products
SELECT * FROM product;

INSERT INTO staging_shippers
SELECT * FROM shipper;

INSERT INTO staging_suppliers
SELECT * FROM supplier;

INSERT INTO staging_employees
SELECT * FROM employee;

INSERT INTO staging_orders
SELECT * FROM salesorder ;


INSERT INTO staging_employees
SELECT * FROM employee ;


--- . Transform the data from the staging tables and load it into the respective dimension tables

INSERT INTO DimProduct (ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock)
SELECT ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock
FROM staging_products;


INSERT INTO DimCustomer (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone) 
SELECT custid, companyname, contactname, contacttitle, address, city, region, postalcode, country, phone 
FROM staging_customers;


INSERT INTO DimCategory (CategoryID, CategoryName, Description)
SELECT categoryid, categoryname, description
FROM staging_categories;

INSERT INTO DimEmployee (EmployeeID, LastName, FirstName, Title, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension)
SELECT empid, lastname, firstname, title, birthdate, hiredate, address, city, region, postalcode, country, phone, extension
FROM staging_employees;

INSERT INTO DimShipper (ShipperID, CompanyName, Phone)
SELECT shipperid, companyname, phone
FROM staging_shippers;

INSERT INTO DimSupplier (SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone)
SELECT supplierid, companyname, contactname, contacttitle, address, city, region, postalcode, country, phone
FROM staging_suppliers;

INSERT INTO DimDate (Date, Day, Month, Year, Quarter, WeekOfYear)
SELECT
    DISTINCT DATE(orderdate) AS Date,
    EXTRACT(DAY FROM DATE(orderdate)) AS Day,
    EXTRACT(MONTH FROM DATE(orderdate)) AS Month,
    EXTRACT(YEAR FROM DATE(orderdate)) AS Year,
    EXTRACT(QUARTER FROM DATE(orderdate)) AS Quarter,
    EXTRACT(WEEK FROM DATE(orderdate)) AS WeekOfYear
FROM
    staging_orders;

-- Load data  into the fact table

INSERT INTO FactSales (DateID, CustomerID, ProductID, EmployeeID, CategoryID, ShipperID, SupplierID, QuantitySold, UnitPrice, Discount, TotalAmount, TaxAmount) 
SELECT
    d.DateID,   
    c.custid,  
    p.ProductID,  
    e.empid,  
    cat.CategoryID,  
    s.ShipperID,  
    sup.SupplierID, 
    od.qty, 
    od.UnitPrice, 
    od.Discount,    
    (od.qty * od.UnitPrice - od.Discount) AS TotalAmount,
    (od.qty * od.UnitPrice - od.Discount) * 0.1 AS TaxAmount     
FROM staging_order_details od 
JOIN staging_orders o ON od.OrderID = o.OrderID 
JOIN staging_customers c ON o.custid = c.custid::varchar 
JOIN staging_products p ON od.ProductID = p.ProductID  
LEFT JOIN staging_employees e ON o.empid = e.empid  
LEFT JOIN staging_categories cat ON p.CategoryID = cat.CategoryID 
LEFT JOIN staging_shippers s ON o.shipperid = s.ShipperID  
LEFT JOIN staging_suppliers sup ON p.SupplierID = sup.SupplierID
LEFT JOIN DimDate d ON o.orderdate = d.Date;

SELECT * FROM FactSales


-- 6) After loading data into the fact and dimension tables, you should validate the data to ensure it is accurate and complete. 
--This process typically involves
--1 
SELECT 'DimDate' AS Table_Name, COUNT(*) AS Record_Count FROM DimDate
UNION ALL
SELECT 'DimCustomer', COUNT(*) FROM DimCustomer
UNION ALL
SELECT 'DimProduct', COUNT(*) FROM DimProduct
UNION ALL
SELECT 'DimEmployee', COUNT(*) FROM DimEmployee
UNION ALL
SELECT 'DimCategory', COUNT(*) FROM DimCategory
UNION ALL
SELECT 'DimShipper', COUNT(*) FROM DimShipper
UNION ALL
SELECT 'DimSupplier', COUNT(*) FROM DimSupplier
UNION ALL
SELECT 'FactSales', COUNT(*) FROM FactSales
UNION ALL
SELECT 'staging_customers', COUNT(*) FROM staging_customers
UNION ALL
SELECT 'staging_products', COUNT(*) FROM staging_products
UNION ALL
SELECT 'staging_categories', COUNT(*) FROM staging_categories
UNION ALL
SELECT 'staging_employees', COUNT(*) FROM staging_employees
UNION ALL
SELECT 'staging_shippers', COUNT(*) FROM staging_shippers
UNION ALL
SELECT 'staging_suppliers', COUNT(*) FROM staging_suppliers
UNION ALL
SELECT 'staging_order_details', COUNT(*) FROM staging_order_details
UNION ALL
SELECT 'staging_orders_unique_orderdates', COUNT(DISTINCT orderdate) FROM staging_orders;


SELECT COUNT(*) AS Broken_Record_Count 
FROM FactSales 
WHERE DateID NOT IN (SELECT DateID FROM DimDate)
   OR CustomerID NOT IN (SELECT CustomerID FROM DimCustomer)
   OR ProductID NOT IN (SELECT ProductID FROM DimProduct)
   OR EmployeeID NOT IN (SELECT EmployeeID FROM DimEmployee)
   OR CategoryID NOT IN (SELECT CategoryID FROM DimCategory)
   OR ShipperID NOT IN (SELECT ShipperID FROM DimShipper)
   OR SupplierID NOT IN (SELECT SupplierID FROM DimSupplier);



-- 2) Display the top (worst) five products by number of transactions, total sales, and tax (add category section). This involves querying the FactSales table

SELECT 
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    COUNT(*) AS NumTransactions,
    SUM(fs.TotalAmount) AS TotalSales,
    SUM(fs.TaxAmount) AS TotalTax
FROM 
    FactSales fs
JOIN 
    DimProduct p ON fs.ProductID = p.ProductID
JOIN 
    DimCategory c ON fs.CategoryID = c.CategoryID
GROUP BY 
    p.ProductID, p.ProductName, c.CategoryName
ORDER BY 
    NumTransactions ASC, TotalSales ASC, TotalTax ASC
LIMIT 5;

-- 3) Display the top (worst) five customers by number of transactions and purchase amount (add gender section, region, country, product categories, age group). T
--his involves querying the FactSales table.

SELECT
    c.CustomerID,
    c.ContactName,
    c.Region,
    c.Country,
    COUNT(fs.SalesID) AS TotalTransactions,
    SUM(fs.TotalAmount) AS TotalPurchaseAmount
FROM
    FactSales fs
JOIN
    DimCustomer c ON fs.CustomerID = c.CustomerID
GROUP BY
    c.CustomerID,
    c.ContactName,
    c.Region,
    c.Country
ORDER BY
    TotalTransactions ASC,
    TotalPurchaseAmount ASC
LIMIT 5;

-- 4) Display a sales chart (with the total amount of sales and the quantity of items sold) for the first week of each month.
--This involves querying the FactSales and DimDate tables.
SELECT 
    Month,
    SUM(TotalAmount) AS TotalSalesAmount,
    SUM(QuantitySold) AS TotalQuantitySold
FROM 
    FactSales
JOIN 
    DimDate ON FactSales.DateID = DimDate.DateID
WHERE 
    Day BETWEEN 1 AND 7
GROUP BY 
    Month
ORDER BY 
    Month;

-- 1) we don’t do that because there is no correct  data


--5)Display a weekly sales report (with monthly totals) by product category (period: one year). 
--This involves querying the FactSales, DimDate, and DimProduct tables.
SELECT 
    DP.CategoryID,
    DC.CategoryName,
    EXTRACT(WEEK FROM DD.Date) AS Week,
    EXTRACT(MONTH FROM DD.Date) AS Month,
    SUM(FS.QuantitySold) AS WeeklyQuantitySold,
    SUM(FS.TotalAmount) AS WeeklyTotalAmount,
    SUM(SUM(FS.TotalAmount)) OVER (PARTITION BY EXTRACT(MONTH FROM DD.Date)) AS MonthlyTotalAmount
FROM 
    FactSales FS
JOIN 
    DimDate DD ON FS.DateID = DD.DateID
JOIN 
    DimProduct DP ON FS.ProductID = DP.ProductID
JOIN 
    DimCategory DC ON DP.CategoryID = DC.CategoryID
GROUP BY 
    DP.CategoryID, DC.CategoryName, EXTRACT(WEEK FROM DD.Date), EXTRACT(MONTH FROM DD.Date)
ORDER BY 
    EXTRACT(MONTH FROM DD.Date), EXTRACT(WEEK FROM DD.Date), DP.CategoryID;


-- 7)Display sales rankings by product category (with the best-selling categories at the top). 
--This involves querying the FactSales and DimProduct tables.
SELECT 
    DP.CategoryID,
    DC.CategoryName,
    SUM(FS.QuantitySold) AS TotalQuantitySold
FROM 
    FactSales FS
JOIN 
    DimProduct DP ON FS.ProductID = DP.ProductID
JOIN 
    DimCategory DC ON DP.CategoryID = DC.CategoryID
GROUP BY 
    DP.CategoryID, DC.CategoryName
ORDER BY 
    TotalQuantitySold DESC;


-- 6) Display the median monthly sales value by product category and country. 
--This involves querying the FactSales, DimProduct, and DimCustomer tables 
--and requires a more complex query or a custom function to calculate the median.
 SELECT
	EXTRACT(month FROM d.Date) AS Month,
    p.CategoryID AS productcategory,
    c.Country,
    FLOOR(AVG(fs.TotalAmount)) AS MonthlySales
 FROM
        FactSales fs
 JOIN
        DimProduct p ON fs.ProductID = p.ProductID
 JOIN
        DimCustomer c ON fs.CustomerID = c.CustomerID
 JOIN
        DimDate d ON fs.DateID = d.DateID
 GROUP BY
		EXTRACT(month FROM d.Date),
        p.CategoryID,
        c.Country
ORDER BY
		Month ASC


