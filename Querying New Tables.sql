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

  SELECT *
  FROM dbo.OrderFullDetail