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


------ 
-- Showcase of creating new tables 

CREATE TABLE northwind.dbo.bonuses
(EmployeeID INT PRIMARY Key,
EmployeeName varchar(50),
SalaryRecommend INT ,
UnitsSold INT );

-- Inserting Data from other table to another
INSERT INTO Northwind.dbo.bonuses (EmployeeID, EmployeeName, SalaryRecommend)
SELECT Northwind.dbo.SalaryReference.EmployeeID, Northwind.dbo.SalaryReference.EmployeeName, Northwind.dbo.SalaryReference.SalaryRecommend FROM Northwind.dbo.SalaryReference

-- Calculate total units in order to left join onto bonuses table
SELECT distinct sum(Northwind.dbo.OrderFullDetail.Total) OVER(PARTITION by Northwind.dbo.OrderFullDetail.name) AS Total, Northwind.dbo.OrderFullDetail.name
INTO Northwind.dbo.testas
FROM Northwind.dbo.OrderFullDetail;


SELECT Northwind.dbo.testas.name, Northwind.dbo.bonuses.EmployeeID, Northwind.dbo.bonuses.SalaryRecommend AS Salary,  Northwind.dbo.testas.Total, Northwind.dbo.SalaryReference.Age, Northwind.dbo.bonuses.SalaryRecommend/Northwind.dbo.testas.Total AS Ratio,
case 
when(Northwind.dbo.bonuses.SalaryRecommend/Northwind.dbo.testas.Total  > 20) then 'Salary Reducation'
when(Northwind.dbo.bonuses.SalaryRecommend/Northwind.dbo.testas.Total  > 10 ) then 'Salary Maintain'
when(Northwind.dbo.bonuses.SalaryRecommend/Northwind.dbo.testas.Total > 3) then 'Salary Increase'
when(Northwind.dbo.bonuses.SalaryRecommend/Northwind.dbo.testas.Total > 0) then 'Praise'
ELSE 'Null Detected'
END AS Recommendation_Info,
case
when(Northwind.dbo.bonuses.SalaryRecommend/Northwind.dbo.testas.Total  > 20 AND Age > 60) then 'Decision 1'
when(Northwind.dbo.bonuses.SalaryRecommend/Northwind.dbo.testas.Total  > 10 AND Age > 70) then 'Decision 2'
when(Northwind.dbo.bonuses.SalaryRecommend/Northwind.dbo.testas.Total >0 ) then 'Nothing to Determined'
ELSE 'Investigate'
END AS Decision
FROM Northwind.dbo.testas
LEFT JOIN Northwind.dbo.bonuses
ON Northwind.dbo.bonuses.EmployeeName = Northwind.dbo.testas.name
LEFT JOIN Northwind.dbo.SalaryReference
ON Northwind.dbo.bonuses.EmployeeID = Northwind.dbo.SalaryReference.EmployeeID
ORDER BY (Ratio)
