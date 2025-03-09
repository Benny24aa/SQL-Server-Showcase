USE [Northwind]
GO
-- Finding Top 5 Orders in terms of Item Quantity
SELECT TOP (5) [OrderID]
      ,[name]
      ,[OrderDate]
      ,[ShipperName]
      ,[CustomerName]
      ,[Total]
  FROM [dbo].[OrderFullDetail]
  ORDER BY Total DESC
  

  -- Finding 5 Oldest Order Dates

 SELECT TOP (5) [OrderID]
      ,[name]
      ,[OrderDate]
      ,[ShipperName]
      ,[CustomerName]
      ,[Total]
  FROM [dbo].[OrderFullDetail]
  ORDER BY OrderDate, OrderID -- Added in Order ID 

  
  -- Finding Null OrderID (Done on purpose with left join)
  Select *
  FROM dbo.OrderFullDetail
  Where OrderID is NULL

  -- Number of Orders by Shipper Company
  SELECT ShipperName, count(ShipperName) AS NumberOrders
  FROM dbo.OrderFullDetail
  group by ShipperName
  Having count(ShipperName) > 0

  -- Number of Orders by Each Order Date
  SELECT count(OrderDate) as Count, OrderDate
  FROM dbo.OrderFullDetail
  group by OrderDate
  Having count(OrderDate) > 0
  Order BY count(OrderDate) DESC

  ALTER TABLE dbo.OrderFullDetail
  ADD Category AS
  CASE
  WHEN (Total > 200) THEN 'Good Amount'
  WHEN (Total > 150) THEN 'Average Amount'
  WHEN (Total > 100) THEN 'Ok Amount'
  ELSE 'No Merit'
  End

  -- Calculating Number of Orders by ShipperName for each Category preallocated in the query above
  SELECT ShipperName, Category, Count(Category) as Count
  FROM dbo.OrderFullDetail
  group by ShipperName, Category
  HAVING count(Category) >0
  ORDER BY ShipperName, count(Category) DESC



   Select Northwind.dbo.Employees.EmployeeID, CONCAT(Northwind.dbo.Employees.FirstName , ' ' , Northwind.dbo.Employees.Lastname) as EmployeeName, BirthDate, DATEDIFF(year, BirthDate, '2025-09-03')AS Age
INTO Northwind.dbo.SalaryReference
FROM Northwind.dbo.Employees;

ALTER TABLE dbo.SalaryReference
ADD SalaryRecommend AS
CASE
WHEN (Age > 70) THEN '25000'
WHEN (Age > 60) THEN '20000'
WHEN (Age > 50) THEN '15000'
WHEN (Age > 40) THEN '10000'
ELSE '50000'
END

