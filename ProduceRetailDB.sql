/* Script prepared by: Tara Stevens
   Course: CIS269 - SQL 11
   Assignment: Final Project
   Instructor: Professor Gaspard Mucundanyi
   Institution: Pierce College
   Quarter: Spring 2026
   
   Title: ProduceRetailDB
   Purpose: A simple database for a fruits & veggies retail business.
            The database includes five core tables (Customers, Products,
            Orders, OrderItems, and Inventory) and is populated with realistic
            sample data. The schema follows best practices, including IDENTITY
            primary keys, NOT NULL constraints, and properly defined foreign key
            relationships.*/

/* Create database if it does not exist. */
IF DB_ID('ProduceRetailDB') IS NULL
    BEGIN
        CREATE DATABASE ProduceRetailDB;
    END
GO

/* Switch to ProduceRetailDB */
USE ProduceRetailDB;
GO

/* Drop existing tables if they already exist, necessary to re-run script */
IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Inventory', 'U') IS NOT NULL DROP TABLE dbo.Inventory;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

/* Table Design Notes:
   • All primary keys use IDENTITY to auto-generate unique values.
   • Columns have been defined with NOT NULL to enforce data integrity.
   • Table-level foreign keys are used to maintain referential integrity between tables.
   • DECIMAL was chosen as a more precise datatype for currency rather than MONEY to 
     reduce rounding errors.
   • Only essential constraints are included. I wanted to keep the design a simple 
     introductory SQL project.
   • The default collation is used and indexing was kept minimal focusing
     only on foreign keys.   Tara S. */

/* Create Customers table. */
CREATE TABLE dbo.Customers ( 
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    EmailAddress VARCHAR(100) NOT NULL UNIQUE
);

/* Create Products table. */
CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    Category VARCHAR(50) NOT NULL DEFAULT 'Fruit',
    Unit VARCHAR(20) NOT NULL DEFAULT 'each',
    ListPrice DECIMAL(10,2) NOT NULL
);

/* Create Orders table. */
CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL, /* Only a date as I didn't think time was a necessary inclusion. */
    DeliveryFee DECIMAL(10,2) NOT NULL DEFAULT 0.00, /* Orders can be placed in person or online */
    Subtotal DECIMAL(10,2) NOT NULL, /* 2 decimal places. */
    TotalAmount AS (Subtotal + DeliveryFee),
        CONSTRAINT FK_Orders_Customers /* This is an optional name given to the foreign key below. Decided to keep foreign keys at table-level rather than in-line for best practice. */
            FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);

/* Create OrderItems table. */
CREATE TABLE dbo.OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL, /* Did not chose money datatype. */
        CONSTRAINT FK_OrderItems_Orders /* Same as above, table‑level foreign key constraint with a custom name. */
            FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
        CONSTRAINT FK_OrderItems_Products
            FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);

/* Create Inventory table. */
CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    QuantityInStock INT NOT NULL CHECK (QuantityInStock >= 0), /* CHECK added as part of step 4 to ensure that quantity cannot be negative. */
    LastRestockDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

/* Note Step 2: The ProduceRetailDB diagram is stored locally within my database instance.
   Because this script only creates the database if it does not already exist, the diagram
   will not appear automatically when someone runs it for the first time. All table relationships
   are defined above, so you can recreate the same diagram by opening Database Diagrams → New Database Diagram
   after executing this script. I have also included a screenshot in the project folder of the diagram.  — Tara S.*/

/* Create Indexes */
/* Orders foreign key indexes */
CREATE INDEX IX_Orders_CustomerID 
    ON dbo.Orders(CustomerID);

CREATE INDEX IX_Orders_OrderDate 
    ON dbo.Orders(OrderDate);

/* OrderItems foreign key indexes */
CREATE INDEX IX_OrderItems_OrderID 
    ON dbo.OrderItems(OrderID);

CREATE INDEX IX_OrderItems_ProductID 
    ON dbo.OrderItems(ProductID);

/* Products foreign key index */
CREATE INDEX IX_Products_ProductName
    ON dbo.Products(ProductName);

/* Inventory foreign key index */
CREATE INDEX IX_Inventory_ProductID 
    ON dbo.Inventory(ProductID);
GO

/* Insert values into tables */
/* Insert 75 customers into Customers table. */
INSERT INTO dbo.Customers
    (FirstName, LastName, EmailAddress)
VALUES 
    ('John', 'Doe', 'john.doe@example.com'),
    ('Jane', 'Smith', 'jane.smith@example.com'),
    ('Alice', 'Johnson', 'alice.johnson@example.com'),
    ('Olivia', 'Hartman', 'olivia.hartman@example.com'),
    ('Marcus', 'Delaney', 'marcus.delaney@example.com'),
    ('Priya', 'Shah', 'priya.shah@example.com'),
    ('Ethan', 'Caldwell', 'ethan.caldwell@example.com'),
    ('Sofia', 'Ramirez', 'sofia.ramirez@example.com'),
    ('Daniel', 'Whitaker', 'daniel.whitaker@example.com'),
    ('Amina', 'Yusuf', 'amina.yusuf@example.com'),
    ('Lucas', 'Brenner', 'lucas.brenner@example.com'),
    ('Naomi', 'Fletcher', 'naomi.fletcher@example.com'),
    ('Gabriel', 'Montes', 'gabriel.montes@example.com'),
    ('Hannah', 'Kimura', 'hannah.kimura@example.com'),
    ('Julian', 'Price', 'julian.price@example.com'),
    ('Talia', 'Nguyen', 'talia.nguyen@example.com'),
    ('Xavier', 'Brooks', 'xavier.brooks@example.com'),
    ('Lila', 'Sorenson', 'lila.sorenson@example.com'),
    ('Andre', 'Baptiste', 'andre.baptiste@example.com'),
    ('Mei', 'Zhang', 'mei.zhang@example.com'),
    ('Rowan', 'Pierce', 'rowan.pierce@example.com'),
    ('Selene', 'Vargas', 'selene.vargas@example.com'),
    ('Carter', 'Ellison', 'carter.ellison@example.com'),
    ('Jasmine', 'Patel', 'jasmine.patel@example.com'),
    ('Owen', 'Gallagher', 'owen.gallagher@example.com'),
    ('Bianca', 'Costa', 'bianca.costa@example.com'),
    ('Hiro', 'Tanaka', 'hiro.tanaka@example.com'),
    ('Elena', 'Markovic', 'elena.markovic@example.com'),
    ('Caleb', 'Jennings', 'caleb.jennings@example.com'),
    ('Fatima', 'Al-Sayed', 'fatima.alsayed@example.com'),
    ('Noah', 'Stein', 'noah.stein@example.com'),
    ('Ruby', 'O''Connell', 'ruby.oconnell@example.com'),
    ('Jorge', 'Castillo', 'jorge.castillo@example.com'),
    ('Amara', 'Okafor', 'amara.okafor@example.com'),
    ('Declan', 'Murphy', 'declan.murphy@example.com'),
    ('Sienna', 'Blake', 'sienna.blake@example.com'),
    ('Tobias', 'Richter', 'tobias.richter@example.com'),
    ('Maya', 'Kapoor', 'maya.kapoor@example.com'),
    ('Zane', 'Holloway', 'zane.holloway@example.com'),
    ('Isabella', 'Duarte', 'isabella.duarte@example.com'),
    ('Rafael', 'Mendes', 'rafael.mendes@example.com'),
    ('Chloe', 'Armstrong', 'chloe.armstrong@example.com'),
    ('Darius', 'Coleman', 'darius.coleman@example.com'),
    ('Helena', 'Fischer', 'helena.fischer@example.com'),
    ('Arjun', 'Mehta', 'arjun.mehta@example.com'),
    ('Vivian', 'Cross', 'vivian.cross@example.com'),
    ('Miles', 'Harrington', 'miles.harrington@example.com'),
    ('Keiko', 'Mori', 'keiko.mori@example.com'),
    ('Sergio', 'Alvarez', 'sergio.alvarez@example.com'),
    ('Tessa', 'Monroe', 'tessa.monroe@example.com'),
    ('Brandon', 'Holt', 'brandon.holt@example.com'),
    ('Nadia', 'Petrova', 'nadia.petrova@example.com'),
    ('Elliot', 'Chambers', 'elliot.chambers@example.com'),
    ('Loren', 'Hayes', 'loren.hayes@example.com'),
    ('Camila', 'Reyes', 'camila.reyes@example.com'),
    ('Dante', 'Morales', 'dante.morales@example.com'),
    ('Ivy', 'Nguyen', 'ivy.nguyen@example.com'),
    ('Grayson', 'Lee', 'grayson.lee@example.com'),
    ('Nora', 'Bennett', 'nora.bennett@example.com'),
    ('Silas', 'Turner', 'silas.turner@example.com'),
    ('Elise', 'Garcia', 'elise.garcia@example.com'),
    ('Theo', 'Martinez', 'theo.martinez@example.com'),
    ('Amira', 'Hassan', 'amira.hassan@example.com'),
    ('Jonas', 'Wright', 'jonas.wright@example.com'),
    ('Clara', 'Hughes', 'clara.hughes@example.com'),
    ('Ronan', 'Foster', 'ronan.foster@example.com'),
    ('Layla', 'Adams', 'layla.adams@example.com'),
    ('Mateo', 'Silva', 'mateo.silva@example.com'),
    ('Hazel', 'Parker', 'hazel.parker@example.com'),
    ('Ezekiel', 'Ross', 'ezekiel.ross@example.com'),
    ('Mila', 'Carter', 'mila.carter@example.com'),
    ('Finn', 'Anderson', 'finn.anderson@example.com'),
    ('Zara', 'Lopez', 'zara.lopez@example.com'),
    ('Callum', 'Diaz', 'callum.diaz@example.com'),
    ('Esme', 'Watson', 'esme.watson@example.com');
GO

/* Insert 50 fruits and vegetables into the Products table.
   Each product includes a name, category (Fruit or Vegetable),
   unit of sale, and list price */
INSERT INTO dbo.Products
    (ProductName, Category, Unit, ListPrice)
VALUES
    ('Apple', 'Fruit', 'each', 0.89),
    ('Banana', 'Fruit', 'each', 0.59),
    ('Orange', 'Fruit', 'each', 0.79),
    ('Pear', 'Fruit', 'each', 0.99),
    ('Peach', 'Fruit', 'each', 1.09),
    ('Plum', 'Fruit', 'each', 0.95),
    ('Grapes', 'Fruit', 'lb', 2.99),
    ('Strawberries', 'Fruit', 'lb', 3.49),
    ('Blueberries', 'Fruit', 'pint', 3.99),
    ('Raspberries', 'Fruit', 'pint', 4.29),
    ('Watermelon', 'Fruit', 'each', 5.99),
    ('Cantaloupe', 'Fruit', 'each', 3.49),
    ('Honeydew', 'Fruit', 'each', 3.79),
    ('Pineapple', 'Fruit', 'each', 2.99),
    ('Mango', 'Fruit', 'each', 1.49),
    ('Kiwi', 'Fruit', 'each', 0.89),
    ('Lemon', 'Fruit', 'each', 0.69),
    ('Lime', 'Fruit', 'each', 0.59),
    ('Avocado', 'Fruit', 'each', 1.29),
    ('Cherry', 'Fruit', 'lb', 4.99),
    ('Tomato', 'Vegetable', 'each', 0.79),
    ('Cucumber', 'Vegetable', 'each', 0.99),
    ('Bell Pepper', 'Vegetable', 'each', 1.29),
    ('Carrot', 'Vegetable', 'lb', 1.49),
    ('Celery', 'Vegetable', 'bunch', 1.99),
    ('Broccoli', 'Vegetable', 'lb', 2.29),
    ('Cauliflower', 'Vegetable', 'each', 2.79),
    ('Spinach', 'Vegetable', 'bag', 2.49),
    ('Lettuce', 'Vegetable', 'head', 1.59),
    ('Kale', 'Vegetable', 'bunch', 2.19),
    ('Zucchini', 'Vegetable', 'each', 0.99),
    ('Squash', 'Vegetable', 'each', 1.29),
    ('Potato', 'Vegetable', 'lb', 0.89),
    ('Sweet Potato', 'Vegetable', 'lb', 1.09),
    ('Onion', 'Vegetable', 'lb', 0.79),
    ('Garlic', 'Vegetable', 'each', 0.69),
    ('Green Beans', 'Vegetable', 'lb', 2.49),
    ('Corn', 'Vegetable', 'each', 0.99),
    ('Eggplant', 'Vegetable', 'each', 1.79),
    ('Cabbage', 'Vegetable', 'head', 2.49),
    ('Beet', 'Vegetable', 'lb', 1.59),
    ('Radish', 'Vegetable', 'bunch', 1.29),
    ('Asparagus', 'Vegetable', 'lb', 3.49),
    ('Brussels Sprouts', 'Vegetable', 'lb', 3.29),
    ('Green Onion', 'Vegetable', 'bunch', 1.19),
    ('Parsley', 'Vegetable', 'bunch', 1.09),
    ('Cilantro', 'Vegetable', 'bunch', 0.99),
    ('Pumpkin', 'Vegetable', 'each', 4.99),
    ('Turnip', 'Vegetable', 'lb', 1.39),
    ('Romaine Lettuce', 'Vegetable', 'head', 1.79);
GO

/* Generate 100 Randomized Orders
   • CustomerIDs 1–75 with at least one order.
   • Randomized dates between Jan–Apr 2026
   • Randomized delivery fees (0 for in-store, 4.99–9.99 for online)
   • Randomized subtotals between $9.99–$39.99
   • Fixed seed (12345) ensures identical results every run. */

DECLARE @Seed INT = 12345;

INSERT INTO dbo.Orders (CustomerID, OrderDate, DeliveryFee, Subtotal)
SELECT
    c.CustomerID,
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 120, '2026-01-01') AS OrderDate,
    CASE WHEN RAND(@Seed + ABS(CHECKSUM(NEWID()))) < 0.5 THEN 0.00
         ELSE ROUND((RAND(@Seed + ABS(CHECKSUM(NEWID()))) * 5) + 4.99, 2) END AS DeliveryFee,
    ROUND((RAND(@Seed + ABS(CHECKSUM(NEWID()))) * 30) + 9.99, 2) AS Subtotal
FROM dbo.Customers AS c;

INSERT INTO dbo.Orders (CustomerID, OrderDate, DeliveryFee, Subtotal)
SELECT TOP 150
    ABS(CHECKSUM(NEWID())) % 53 + 1 AS CustomerID,
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 120, '2026-01-01') AS OrderDate,
    CASE WHEN RAND(@Seed + ABS(CHECKSUM(NEWID()))) < 0.5 THEN 0.00
         ELSE ROUND((RAND(@Seed + ABS(CHECKSUM(NEWID()))) * 5) + 4.99, 2) END AS DeliveryFee,
    ROUND((RAND(@Seed + ABS(CHECKSUM(NEWID()))) * 30) + 9.99, 2) AS Subtotal
FROM sys.objects;
GO

/* Order Items */
DECLARE @Seed INT = 12345;

/* Generate ~200 randomized sales records
   • Each record links an OrderID to a ProductID with realistic quantities and prices.
   • Uses a fixed random seed (12345) so results are repeatable across runs. */
INSERT INTO dbo.OrderItems (OrderID, ProductID, Quantity, Price)
SELECT TOP 200
    o.OrderID,
    p.ProductID,
    FLOOR(RAND(@Seed + CHECKSUM(NEWID())) * 10) + 1 AS Quantity,  -- 1–10 units
    p.ListPrice
FROM dbo.Orders AS o
    CROSS JOIN dbo.Products AS p
ORDER BY NEWID();

/* Guarantee full product coverage
   • Identifies any ProductID that did NOT appear in the first insert.
   • Inserts at least one sale for each missing product.
   • Ensures every product has at least one OrderItem record.
   • Utilized to prevent reporting gaps for stored procedures */
INSERT INTO dbo.OrderItems (OrderID, ProductID, Quantity, Price)
SELECT
    (SELECT TOP 1 OrderID FROM dbo.Orders ORDER BY NEWID()) AS OrderID,
    p.ProductID,
    FLOOR(RAND(@Seed + CHECKSUM(NEWID())) * 5) + 1 AS Quantity,  -- 1–5 units
    p.ListPrice
FROM dbo.Products AS p
WHERE p.ProductID NOT IN (SELECT DISTINCT ProductID FROM dbo.OrderItems);

/* Inserted sample inventory data for all products.
   Each product receives a random stock quantity (20–200 units)
   and a recent restock date within the past 90 days. */
INSERT INTO dbo.Inventory
    (ProductID, QuantityInStock, LastRestockDate)
SELECT 
    ProductID,
        FLOOR(RAND(CHECKSUM(NEWID())) * 181) + 20 AS QuantityInStock,  -- 20–200 units
        DATEADD(DAY, -FLOOR(RAND(CHECKSUM(NEWID())) * 90), GETDATE()) AS LastRestockDate
FROM dbo.Products;
GO

/* STEP 5: Create a view which generates a total amount on a receipt.
   The view calculates the total cost per order for the receipt by
   summing the product quantity and list price for each item.
   SUM() aggregate function is required in Step 5. */
IF OBJECT_ID('vw_OrderReceiptTotals', 'V') IS NOT NULL
    DROP VIEW vw_OrderReceiptTotals;
GO

CREATE VIEW vw_OrderReceiptTotals AS
SELECT 
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    FORMAT(SUM(oi.Quantity * p.ListPrice), 'C2') AS TotalAmount
FROM Orders o
    JOIN Customers c
        ON o.CustomerID = c.CustomerID
    JOIN OrderItems oi
        ON o.OrderID = oi.OrderID
    JOIN Products p
        ON oi.ProductID = p.ProductID
GROUP BY o.OrderID, c.FirstName, c.LastName;
GO

/* Test view */
SELECT * FROM vw_OrderReceiptTotals;
GO

/* Step 7: Part 1 Capitalize all existing customer last names
           This transaction will ensure every record in the Customers table follows
           the uppercase rule for LastName.*/
BEGIN TRANSACTION;

UPDATE dbo.Customers
SET LastName = UPPER(LastName);

SELECT CustomerID, FirstName, LastName
FROM dbo.Customers
ORDER BY CustomerID;

COMMIT TRANSACTION;
GO

/* Step 7: Part 2 Trigger automatically runs whenever a new customer is added or
       an existing customer's last name is updated to ensure customer last names
       are stored in uppercase. */
CREATE TRIGGER CapitalizeCustomerLastName
    ON dbo.Customers
AFTER INSERT, UPDATE AS /* Uses an inserted pseudo‑table to find the affected rows. */
BEGIN
    SET NOCOUNT ON; /* prevents extra “rows affected” messages.*/

    UPDATE c
    SET c.LastName = UPPER(i.LastName) /* updates the LastName column to uppercase */
    FROM dbo.Customers AS c
        INNER JOIN inserted AS i
            ON c.CustomerID = i.CustomerID;
END;
GO

/* Test trigger and rollback changes so it can be re-tested */
BEGIN TRANSACTION;

INSERT INTO dbo.Customers (FirstName, LastName, EmailAddress)
VALUES ('Mike', 'myers', 'mike.myers@example.com');

SELECT CustomerID, FirstName, LastName
FROM dbo.Customers
WHERE EmailAddress = 'mike.myers@example.com';

ROLLBACK TRANSACTION;
GO

/* Step 8: Transaction to ensure item availability before purchase.
           Prevents orders from being placed for items not in stock
           by checking inventory quantity before inserting into Orders table. */
BEGIN TRANSACTION;

DECLARE @ProductID INT = 1; /* Example product */
DECLARE @OrderQuantity INT = 3; /* Example quantity */
DECLARE @AvailableQty INT;

SELECT @AvailableQty = QuantityInStock /* Check current inventory */
FROM dbo.Inventory
WHERE ProductID = @ProductID;

IF @AvailableQty >= @OrderQuantity /* If product is in stock than proceed with order */
    BEGIN
        INSERT INTO dbo.Orders (CustomerID, OrderDate, DeliveryFee, Subtotal)
        VALUES (1, GETDATE(), 4.99, 19.99);

        INSERT INTO dbo.OrderItems (OrderID, ProductID, Quantity, Price)
        VALUES (SCOPE_IDENTITY(), @ProductID, @OrderQuantity, 6.66);

        UPDATE dbo.Inventory /* Update inventory */
        SET QuantityInStock = QuantityInStock - @OrderQuantity
        WHERE ProductID = @ProductID;

        COMMIT TRANSACTION;
        PRINT 'Order placed successfully.'; /* print statement for confirmation */
    END
ELSE
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Transaction canceled: insufficient stock.'; /* print statement for incomplete transaction */
    END;
GO

/* Step 9: Create two users (Admin and Staff) with different permissions
           Demonstrates database security and role-based access control.
           Admin has full control, Staff has limited access of read-only. */

/* Part 1: Create login and user for Admin */
IF NOT EXISTS (SELECT 1
               FROM sys.server_principals
               WHERE name = 'AdminLogin')
CREATE LOGIN AdminLogin WITH PASSWORD = 'Admin@123';

IF NOT EXISTS (SELECT 1
               FROM sys.database_principals
               WHERE name = 'AdminUser')
CREATE USER AdminUser FOR LOGIN AdminLogin;

/* Add AdminUser to db_owner if not already a member */
IF NOT EXISTS (SELECT 1 
               FROM sys.database_role_members drm
                    JOIN sys.database_principals dp
                        ON drm.member_principal_id = dp.principal_id
               WHERE dp.name = 'AdminUser' AND drm.role_principal_id = USER_ID('db_owner')
)

ALTER ROLE db_owner ADD MEMBER AdminUser; /* Full control */

/* Part 2: Create login and user for Staff */
IF NOT EXISTS (SELECT 1
               FROM sys.server_principals
               WHERE name = 'StaffLogin')
CREATE LOGIN StaffLogin WITH PASSWORD = 'Staff@123';

IF NOT EXISTS (SELECT 1
               FROM sys.database_principals
               WHERE name = 'StaffUser')
CREATE USER StaffUser FOR LOGIN StaffLogin;

/* Add StaffUser to db_datareader if not already a member */
IF NOT EXISTS (SELECT 1 
               FROM sys.database_role_members drm
                    JOIN sys.database_principals dp
                        ON drm.member_principal_id = dp.principal_id
               WHERE dp.name = 'StaffUser' AND drm.role_principal_id = USER_ID('db_datareader')
)

ALTER ROLE db_datareader ADD MEMBER StaffUser; /* Read-only access */
GO

/* Confirm logins exist at server level */
SELECT name AS LoginName, type_desc AS LoginType, create_date
FROM sys.server_principals
WHERE name IN ('AdminLogin', 'StaffLogin');

/* Confirm database users and their role (database level) */
SELECT 
    dp.name AS UserName,
    dp.type_desc AS UserType,
    rp.name AS RoleName
FROM sys.database_principals dp
    LEFT JOIN sys.database_role_members drm 
        ON dp.principal_id = drm.member_principal_id
    LEFT JOIN sys.database_principals rp 
        ON drm.role_principal_id = rp.principal_id
WHERE dp.name IN ('AdminUser', 'StaffUser');
GO

/* Step 10: Backup the ProduceRetailDB database */
BACKUP DATABASE ProduceRetailDB
TO DISK = 'C:\SQLBackups\ProduceRetailDB.bak'
WITH FORMAT,
     NAME = 'ProduceRetailDB_FullBackup';
GO

/* How to restore
RESTORE DATABASE ProduceRetailDB
FROM DISK = 'C:\SQLBackups\ProduceRetailDB.bak'
WITH REPLACE;
GO */