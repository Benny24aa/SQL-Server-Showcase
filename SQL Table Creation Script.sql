-- Selecting Data from Northwind Database from Employees Table

Select Northwind.dbo.Employees.EmployeeID, CONCAT(Northwind.dbo.Employees.FirstName , ' ' , Northwind.dbo.Employees.Lastname) as name
INTO Northwind.dbo.Test
FROM Northwind.dbo.Employees;

--- Creating a table which counts columns for each individual order ID prior to detecting duplication
SELECT SUM(Northwind.dbo.OrderDetails.Quantity) OVER(PARTITION BY Northwind.dbo.OrderDetails.OrderID) AS Total, Northwind.dbo.OrderDetails.OrderID
INTO Northwind.dbo.OrderCount
FROM Northwind.dbo.OrderDetails;


--- Removing duplicate rows from counting of quantity
SELECT DISTINCT Northwind.dbo.OrderCount.OrderID, Northwind.dbo.OrderCount.Total
INTO Northwind.dbo.OrderCount_Cleaned
FROM Northwind.dbo.OrderCount


--- Left Joining numerous Tables from Northwind Database to create a table which includes key information regaring orders
SELECT  Northwind.dbo.Orders.OrderID,  Northwind.dbo.Test.name, Northwind.dbo.Orders.OrderDate, Northwind.dbo.Shippers.ShipperName, Northwind.dbo.Customers.CustomerName, Northwind.dbo.OrderCount_Cleaned.Total
INTO Northwind.dbo.OrderFullDetail
FROM Northwind.dbo.Test
LEFT JOIN Northwind.dbo.Orders
ON Northwind.dbo.Test.EmployeeID = Northwind.dbo.Orders.EmployeeID
LEFT JOIN Northwind.dbo.Shippers
ON Northwind.dbo.Orders.ShipperID = Northwind.dbo.Shippers.ShipperID
LEFT JOIN Northwind.dbo.Customers
ON Northwind.dbo.Customers.CustomerID = Northwind.dbo.Orders.CustomerID 
LEFT JOIN Northwind.dbo.OrderCount_Cleaned 
ON Northwind.dbo.OrderCount_Cleaned.OrderID = Northwind.dbo.Orders.OrderID
;

