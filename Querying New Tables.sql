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
  
