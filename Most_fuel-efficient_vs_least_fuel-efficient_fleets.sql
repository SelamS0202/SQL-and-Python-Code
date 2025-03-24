-----*********Top 10 most fuel-efficient fleets vs. least fuel-efficient fleets**********-
---- Top 10 Fuel-efficient Trucks-max Kilometres per Liter
Select [Truck],[Average_Kpl],[Average_FuelCost], Rank_num_Kpl
From
(SELECT [Truck]
      ,[Month_Num]
      ,[Month_Name]
      ,[Average_Kpl]
      ,[Average_FuelCost]
	  , DENSE_RANK() over (order by Average_Kpl desc) as Rank_num_Kpl
  FROM [FuelStageETL].[dbo].[View_Avg_Kpl_FuelCost]
  WHERE [Average_FuelCost] > 0 and Average_Kpl > 0 and Average_Kpl <=14) T
  Where Rank_num_Kpl <= 10
  order by Rank_num_Kpl;

------ Top 10 less Fuel-efficient Trucks-max Kilometres per Liter
Select *
From(
Select [Truck],[Average_Kpl],[Average_FuelCost], Rank_num_Kpl
From
(SELECT [Truck]
      ,[Month_Num]
      ,[Month_Name]
      ,[Average_Kpl]
      ,[Average_FuelCost]
	  , DENSE_RANK() over (order by Average_Kpl asc) as Rank_num_Kpl
  FROM [FuelStageETL].[dbo].[View_Avg_Kpl_FuelCost]
  WHERE [Average_FuelCost] > 0 and Average_Kpl > 0 and Average_Kpl <=14) T
  ) T
  Where Rank_num_Kpl <= 10
  order by Rank_num_Kpl asc

