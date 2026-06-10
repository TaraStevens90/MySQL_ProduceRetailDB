/* Stored Procedures to Generate a Receipt — ProduceRetailDB
   Adapted from ElectronicsRetailDB for produce‑specific data.
   Includes both a traditional join output and a readable format.
   Author: Tara S. */

USE ProduceRetailDB;
GO

/* Procedure 1: Traditional SQL join receipt output
   Produces one row per product purchased with customer info,
   product details, unit price, and total amount.*/
DROP PROCEDURE IF EXISTS GetReceiptTraditional;
GO

CREATE PROCEDURE GetReceiptTraditional
    @OrderID INT
AS
BEGIN
    SELECT 
        c.FirstName + ' ' + c.LastName AS CustomerName,
        c.EmailAddress,
        o.OrderID,
        o.OrderDate,
        p.ProductName,
        p.Category,
        oi.Quantity,
        FORMAT(oi.Price, 'C2') AS UnitPrice,
        FORMAT(oi.Quantity * oi.Price, 'C2') AS LineTotal,
        FORMAT(SUM(oi.Quantity * oi.Price) OVER (PARTITION BY o.OrderID), 'C2') AS Subtotal,
        FORMAT(o.DeliveryFee, 'C2') AS DeliveryFee,
        FORMAT(SUM(oi.Quantity * oi.Price) OVER (PARTITION BY o.OrderID) + o.DeliveryFee, 'C2') AS TotalAmount
    FROM Orders o
        JOIN Customers c
            ON o.CustomerID = c.CustomerID
        JOIN OrderItems oi
            ON o.OrderID = oi.OrderID
        JOIN Products p
            ON oi.ProductID = p.ProductID
    WHERE o.OrderID = @OrderID
    ORDER BY p.ProductName;
END;
GO

/* Example execution: */
EXEC GetReceiptTraditional 45;
GO

/* Procedure 2: Readable receipt output
   Uses three SELECT statements for:
     1) Customer + order info
     2) Product list with quantities and line totals
     3) Subtotal, delivery fee, and total amount */
DROP PROCEDURE IF EXISTS GetReceiptReadable;
GO

CREATE PROCEDURE GetReceiptReadable
    @OrderID INT
AS
BEGIN
    /* Customer and Order Info */
    SELECT 
        c.FirstName + ' ' + c.LastName AS CustomerName,
        c.EmailAddress,
        o.OrderID,
        o.OrderDate
    FROM Orders o
        JOIN Customers c
            ON o.CustomerID = c.CustomerID
    WHERE o.OrderID = @OrderID;

    /* Product List */
    SELECT
        p.ProductName,
        p.Category,
        oi.Quantity,
        FORMAT(oi.Price, 'C2') AS UnitPrice,
        FORMAT(oi.Quantity * oi.Price, 'C2') AS LineTotal
    FROM OrderItems oi
        JOIN Products p
            ON oi.ProductID = p.ProductID
    WHERE oi.OrderID = @OrderID
    ORDER BY p.ProductName;

    /* Totals */
    SELECT
        FORMAT(o.Subtotal, 'C2') AS Subtotal,
        FORMAT(o.DeliveryFee, 'C2') AS DeliveryFee,
        FORMAT(o.Subtotal + o.DeliveryFee, 'C2') AS TotalAmount
    FROM Orders o
    WHERE o.OrderID = @OrderID;
END;
GO

/* Example execution: */
EXEC GetReceiptReadable 45;
GO
