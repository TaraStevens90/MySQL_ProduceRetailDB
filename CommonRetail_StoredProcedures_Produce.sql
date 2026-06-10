/* Common Retail Stored Procedures
   Includes:
     • GetDailySalesSummary – Daily totals and averages
     • GetWeeklySalesSummary – Weekly totals with date ranges
     • GetMonthlySalesSummary – Monthly totals and averages
     • GetProductSalesSummary – Units sold and revenue per product
     • GetTotalSalesByCategory – All-time sales by category (Fruit vs. Vegetable)
     • GetTop5BestSellingProducts – Top five products by units sold
     • GetCustomerSpendSummary – Total and average spending per customer
     • GetCustomerPurchaseHistory – Individual customer order history
     • GetProductSalesByCategoryAndQuantity – Filtered product sales by category and quantity
     • CheckInventoryAvailability – Current stock and last restock date
     • UpdateInventoryAfterRestock – Adjust stock levels and restock date */

USE ProduceRetailDB;
GO

/* Daily Sales Summary: Returns total orders, total sales, and
   average order amount for a specific date. */
DROP PROCEDURE IF EXISTS GetDailySalesSummary;
GO

CREATE PROCEDURE GetDailySalesSummary
    @Date DATE
AS
BEGIN
    SELECT
        FORMAT(@Date, 'MMM dd, yyyy') AS SalesDate,
        COUNT(*) AS TotalOrders,
        FORMAT(SUM(Subtotal + DeliveryFee), 'C2') AS TotalSales,
        FORMAT(AVG(Subtotal + DeliveryFee), 'C2') AS AverageOrderAmount
    FROM Orders
    WHERE CAST(OrderDate AS DATE) = @Date;
END;
GO

/* Example with random date: */
EXEC GetDailySalesSummary '2026-03-21';
GO

/* Weekly Sales Summary: Returns total orders, total sales, and
   average order amount grouped by week range. */
DROP PROCEDURE IF EXISTS GetWeeklySalesSummary;
GO

CREATE PROCEDURE GetWeeklySalesSummary
AS
BEGIN
    SELECT
        CONCAT(
            FORMAT(DATEADD(DAY, -DATEPART(WEEKDAY, MIN(OrderDate)) + 1, MIN(OrderDate)), 'MMM dd'),
            ' - ',
            FORMAT(DATEADD(DAY, 7 - DATEPART(WEEKDAY, MIN(OrderDate)), MIN(OrderDate)), 'MMM dd, yyyy')
        ) AS WeekRange,
        COUNT(*) AS TotalOrders,
        FORMAT(SUM(Subtotal + DeliveryFee), 'C2') AS TotalSales,
        FORMAT(AVG(Subtotal + DeliveryFee), 'C2') AS AverageOrderAmount
    FROM Orders
    GROUP BY DATEPART(WEEK, OrderDate)
    ORDER BY MIN(OrderDate);
END;
GO

/* Generate weekly summary report */
EXEC GetWeeklySalesSummary;
GO

/* Monthly Sales Summary: Returns total orders, total sales, and
   average order amount grouped by month in 2026. */
DROP PROCEDURE IF EXISTS GetMonthlySalesSummary;
GO

CREATE PROCEDURE GetMonthlySalesSummary
AS
BEGIN
    SELECT
        CONCAT(DATENAME(MONTH, MIN(OrderDate)), ' ', YEAR(MIN(OrderDate))) AS SalesMonth,
        COUNT(*) AS TotalOrders,
        FORMAT(SUM(Subtotal + DeliveryFee), 'C2') AS TotalSales,
        FORMAT(AVG(Subtotal + DeliveryFee), 'C2') AS AverageOrderAmount
    FROM Orders
    GROUP BY MONTH(OrderDate)
    ORDER BY MONTH(OrderDate);
END;
GO

/* Generate monthly summary report */
EXEC GetMonthlySalesSummary;
GO

/* Product Sales Summary: Shows total units sold and total revenue per product. */
DROP PROCEDURE IF EXISTS GetProductSalesSummary;
GO

CREATE PROCEDURE GetProductSalesSummary
AS
BEGIN
    SELECT
        p.ProductName,
        p.Category,
        ISNULL(SUM(oi.Quantity), 0) AS TotalUnitsSold,
        FORMAT(ISNULL(SUM(oi.Quantity * oi.Price), 0), 'C2') AS TotalRevenue
    FROM Products p
        LEFT JOIN OrderItems oi
            ON p.ProductID = oi.ProductID
    GROUP BY p.ProductName, p.Category
    ORDER BY ISNULL(SUM(oi.Quantity * oi.Price), 0) DESC;
END;
GO

/* Generate product sales summary */
EXEC GetProductSalesSummary;
GO

/* Total All‑Time Sales by Category: Returns total revenue and
   average order amount grouped by product category (Fruit vs. Vegetable). */
DROP PROCEDURE IF EXISTS GetTotalSalesByCategory;
GO

CREATE PROCEDURE GetTotalSalesByCategory
AS
BEGIN
    SELECT
        p.Category,
        FORMAT(SUM(oi.Quantity * oi.Price), 'C2') AS AllTimeTotalSales,
        FORMAT(AVG(oi.Quantity * oi.Price), 'C2') AS AverageItemRevenue
    FROM OrderItems oi
        JOIN Products p ON oi.ProductID = p.ProductID
    GROUP BY p.Category
    ORDER BY SUM(oi.Quantity * oi.Price) DESC;
END;
GO

/* Generate total sales by category report */
EXEC GetTotalSalesByCategory;
GO

/* Top 5 Best‑Selling Products: Returns the five products with the highest units sold. */
DROP PROCEDURE IF EXISTS GetTop5BestSellingProducts;
GO

CREATE PROCEDURE GetTop5BestSellingProducts
AS
BEGIN
    SELECT TOP 5
        p.ProductName,
        p.Category,
        SUM(oi.Quantity) AS TotalUnitsSold,
        FORMAT(SUM(oi.Quantity * oi.Price), 'C2') AS TotalRevenue
    FROM OrderItems oi
        JOIN Products p
            ON oi.ProductID = p.ProductID
    GROUP BY p.ProductName, p.Category
    ORDER BY SUM(oi.Quantity) DESC;
END;
GO

/* Generate top 5 report */
EXEC GetTop5BestSellingProducts;
GO


/* Customer Spend Summary: Shows total and average spending per customer. */
DROP PROCEDURE IF EXISTS GetCustomerSpendSummary;
GO

CREATE PROCEDURE GetCustomerSpendSummary
AS
BEGIN
    SELECT
        c.CustomerID,
        c.FirstName + ' ' + c.LastName AS CustomerName,
        c.EmailAddress,
        COUNT(o.OrderID) AS OrderCount,
        FORMAT(SUM(o.Subtotal + o.DeliveryFee), 'C2') AS TotalSpent,
        FORMAT(AVG(o.Subtotal + o.DeliveryFee), 'C2') AS AvgOrderAmount
    FROM Orders o
        JOIN Customers c
            ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName, c.EmailAddress
    ORDER BY SUM(o.Subtotal + o.DeliveryFee) DESC;
END;
GO

/* Generate customer spend summary */
EXEC GetCustomerSpendSummary;
GO

/* Customer Purchase History: Returns all orders for a specific customer */
DROP PROCEDURE IF EXISTS GetCustomerPurchaseHistory;
GO

CREATE PROCEDURE GetCustomerPurchaseHistory
    @CustomerID INT
AS
BEGIN
    SELECT
        c.FirstName + ' ' + c.LastName AS CustomerName,
        c.EmailAddress,
        o.OrderID,
        FORMAT(o.OrderDate, 'MMM dd, yyyy') AS OrderDate,
        FORMAT(o.Subtotal + o.DeliveryFee, 'C2') AS TotalAmount
    FROM Orders o
        JOIN Customers c
            ON o.CustomerID = c.CustomerID
    WHERE o.CustomerID = @CustomerID
    ORDER BY o.OrderDate;
END;
GO

/* Example random customer */
EXEC GetCustomerPurchaseHistory 12;
GO

/* Step 6 - Procedure with Two Parameters: Returns product sales filtered by category and minimum quantity.
           - @Category: limits results to one product category (e.g., 'Fruit' or 'Vegetable')
           - @MinQuantity: includes only order items with quantity >= this value.*/
DROP PROCEDURE IF EXISTS GetProductSalesByCategoryAndQuantity;
GO

CREATE PROCEDURE GetProductSalesByCategoryAndQuantity
    @Category NVARCHAR(50),
    @MinQuantity INT
AS
BEGIN
    SELECT
        p.ProductName,
        p.Category,
        SUM(oi.Quantity) AS TotalUnitsSold,
        FORMAT(SUM(oi.Quantity * oi.Price), 'C2') AS TotalRevenue
    FROM OrderItems oi
        JOIN Products p
            ON oi.ProductID = p.ProductID
    WHERE p.Category = @Category
        AND oi.Quantity >= @MinQuantity
    GROUP BY p.ProductName, p.Category
    ORDER BY SUM(oi.Quantity * oi.Price) DESC;
END;
GO

/* Generate product sales report that shows only fruit products with at least one order of 5 or more units. */
EXEC GetProductSalesByCategoryAndQuantity 'Fruit', 5;
GO


/* Inventory Availability Check: Returns current stock level and restock date for a product. */
DROP PROCEDURE IF EXISTS CheckInventoryAvailability;
GO

CREATE PROCEDURE CheckInventoryAvailability
    @ProductID INT
AS
BEGIN
    SELECT
        p.ProductName,
        p.Category,
        i.QuantityInStock,
        FORMAT(i.LastRestockDate, 'MMM dd, yyyy') AS LastRestockDate
    FROM Inventory i
        JOIN Products p
            ON i.ProductID = p.ProductID
    WHERE i.ProductID = @ProductID;
END;
GO

/* Example inventory check for random product */
EXEC CheckInventoryAvailability 3;
GO


/* Update Inventory After Restock: Updates stock quantity and restock date for a product. */
DROP PROCEDURE IF EXISTS UpdateInventoryAfterRestock;
GO

CREATE PROCEDURE UpdateInventoryAfterRestock
    @ProductID INT,
    @AddedQuantity INT,
    @RestockDate DATE
AS
BEGIN
    UPDATE Inventory
    SET QuantityInStock = QuantityInStock + @AddedQuantity,
        LastRestockDate = @RestockDate
    WHERE ProductID = @ProductID;

    SELECT
        p.ProductName,
        FORMAT(@AddedQuantity, 'N0') AS QuantityAdded,
        FORMAT(i.QuantityInStock, 'N0') AS NewStockLevel,
        FORMAT(@RestockDate, 'MMM dd, yyyy') AS UpdatedRestockDate
    FROM Inventory i
        JOIN Products p
            ON i.ProductID = p.ProductID
    WHERE i.ProductID = @ProductID;
END;
GO

/* Example random product inventory update */
EXEC UpdateInventoryAfterRestock 3, 25, '2026-06-04';
GO
