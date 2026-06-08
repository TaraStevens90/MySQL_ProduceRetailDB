/* Procedure 3: ASCII‑Style Printed Receipt Output — ProduceRetailDB
   Script produces a single result set formatted as a printed receipt.
   MUST RUN IN "RESULTS TO TEXT" MODE for proper alignment.
   Author: Tara S. */

DROP PROCEDURE IF EXISTS GetReceiptPaperASCII;
GO

CREATE PROCEDURE GetReceiptPaperASCII
    @OrderID INT
AS
BEGIN
    WITH ReceiptData AS (
        SELECT 
            c.FirstName + ' ' + c.LastName AS CustomerName,
            c.EmailAddress,
            o.OrderID,
            o.OrderDate,
            o.Subtotal,
            o.DeliveryFee,
            p.ProductName,
            p.Category,
            oi.Quantity,
            oi.Price
        FROM Orders o
            JOIN Customers c
                ON o.CustomerID = c.CustomerID
            JOIN OrderItems oi
                ON o.OrderID = oi.OrderID
            JOIN Products p ON
                oi.ProductID = p.ProductID
        WHERE o.OrderID = @OrderID
    )

    /* The SELECT/UNION ALL chain constructs a single ASCII‑formatted
       receipt output instead of multiple relational result sets.
       This builds a vertically structured, printer‑style receipt
       similar to what a customer would receive at checkout. */

    SELECT '=========================================='
        UNION ALL SELECT '          Produce Retail Receipt'
        UNION ALL SELECT '=========================================='
        UNION ALL SELECT 'Customer:  ' + rd.CustomerName FROM ReceiptData rd GROUP BY rd.CustomerName
        UNION ALL SELECT 'Email:     ' + rd.EmailAddress FROM ReceiptData rd GROUP BY rd.EmailAddress
        UNION ALL SELECT 'Order ID:  ' + CAST(rd.OrderID AS VARCHAR) FROM ReceiptData rd GROUP BY rd.OrderID
        UNION ALL SELECT 'Date:      ' + FORMAT(rd.OrderDate, 'yyyy-MM-dd') FROM ReceiptData rd GROUP BY rd.OrderDate
        UNION ALL SELECT '------------------------------------------'
        UNION ALL SELECT 'Qty   Product Name    Category       Total'
        UNION ALL SELECT '------------------------------------------'
       UNION ALL SELECT
                    LEFT(CAST(rd.Quantity AS VARCHAR(3)) + REPLICATE(' ', 3), 3) +
                    '   ' +
                    LEFT(rd.ProductName + REPLICATE(' ', 16), 16) +
                    LEFT(rd.Category + REPLICATE(' ', 12), 12) +
                    RIGHT(REPLICATE(' ', 8) + FORMAT(rd.Quantity * rd.Price, 'C2'), 8)
                 FROM ReceiptData rd
        UNION ALL SELECT '------------------------------------------'
        UNION ALL SELECT
                    LEFT('Subtotal:' + REPLICATE(' ', 32), 32) +
                    RIGHT(REPLICATE(' ', 10) + FORMAT(rd.Subtotal, 'C2'), 10)
                  FROM ReceiptData rd
                  GROUP BY rd.Subtotal
        UNION ALL SELECT
                    LEFT('Delivery Fee:' + REPLICATE(' ', 32), 32) +
                    RIGHT(REPLICATE(' ', 10) + FORMAT(rd.DeliveryFee, 'C2'), 10)
                  FROM ReceiptData rd
                  GROUP BY rd.DeliveryFee
        UNION ALL SELECT
                    LEFT('Total Amount:' + REPLICATE(' ', 32), 32) +
                    RIGHT(REPLICATE(' ', 10) + FORMAT(rd.Subtotal + rd.DeliveryFee, 'C2'), 10)
                  FROM ReceiptData rd
                  GROUP BY rd.Subtotal, rd.DeliveryFee
        UNION ALL SELECT '=========================================='
        UNION ALL SELECT 'Printed on:            ' + FORMAT(GETDATE(), 'yyyy-MM-dd hh:mm tt');
END;
GO

/* Example execution */
EXEC GetReceiptPaperASCII @OrderID = 18;
GO

