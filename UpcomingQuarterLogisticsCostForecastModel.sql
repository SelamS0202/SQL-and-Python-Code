WITH growth_rates as ( -- calculates Growth rate for each cost group by market and Logistics_Provider 
SELECT  [Date]
     ,Datepart(QUARTER, [Date]) as Quarter
	 ,Datepart(Year, [Date]) as Year
      ,[Market]
      ,[Logistics_Provider]
      ,[Currency]
      ,[Total_Inbound_Cost]
      ,[Total_Storage_Cost]
      ,[Total_Delivery_Cost]
      ,[Other_Costs]
	  --,LAG(Total_Inbound_Cost) OVER (Partition by Market,Logistics_Provider ORDER BY Datepart(QUARTER, [Date])) as Prev
	  ,((Total_Inbound_Cost - LAG(Total_Inbound_Cost) OVER (Partition by Market,Logistics_Provider ORDER BY Datepart(QUARTER, [Date]))) / NullIf (LAG(Total_Inbound_Cost) OVER (Partition by Market,Logistics_Provider ORDER BY Datepart(QUARTER, [Date])),0) )*[ExRate] AS Inbound_Growth_Rate_EUR,
      ((Total_Storage_Cost - LAG(Total_Storage_Cost) OVER (ORDER BY Datepart(QUARTER, [Date]))) / Nullif(LAG(Total_Storage_Cost) OVER (Partition by Market,Logistics_Provider ORDER BY Datepart(QUARTER, [Date])),0) ) * [ExRate] AS Storage_Growth_Rate_EUR,
      ((Total_Delivery_Cost - LAG(Total_Delivery_Cost) OVER (ORDER BY Datepart(QUARTER, [Date]))) / Nullif(LAG(Total_Delivery_Cost) OVER (Partition by Market,Logistics_Provider ORDER BY Datepart(QUARTER, [Date])),0)) * [ExRate] AS Delivery_Growth_Rate_EUR,
      ((Other_Costs - LAG(Other_Costs) OVER (ORDER BY Datepart(QUARTER, [Date]))) / Nullif(LAG(Other_Costs) OVER (Partition by Market,Logistics_Provider ORDER BY Datepart(QUARTER, [Date])),0))* [ExRate] AS Other_Growth_Rate_EUR
  FROM [Logistics].[dbo].[LogisticsCostS]
  Where Datepart(Year, [Date]) = 2024
  ),

avg_growth_rates AS ( ---Calculate Average Growth Rates for Each Cost Category by market and Logistics_Provider 

----Next Quarter Logistics Cost Forecast 
SELECT   
--Quarter,
Market,
Logistics_Provider,
AVG(Inbound_Growth_Rate_EUR)  AS Avg_Inbound_Growth_Rate_EUR,
AVG(Storage_Growth_Rate_EUR)  AS Avg_Storage_Growth_Rate_EUR,
AVG(Delivery_Growth_Rate_EUR) AS Avg_Delivery_Growth_Rate_EUR,
AVG(Other_Growth_Rate_EUR)  AS Avg_Other_Growth_Rate_EUR
from growth_rates
group by Market,Logistics_Provider
),
avg_forecast as (
Select 
'Q12025' AS ForecastedQuarter,
Q4.Market,
Q4.Logistics_Provider as "Logistics_Provider",
    round(((Q4.[Total_Inbound_Cost]* Q4.[ExRate]) * (1 + AvgT.Avg_Inbound_Growth_Rate_EUR)),2) AS ForecastedInboundCost,
    round(((Q4.[Total_Storage_Cost] * Q4.[ExRate]) * (1 + AvgT.Avg_Storage_Growth_Rate_EUR)),2) AS ForecastedStorageCost,
    round(((Q4.[Total_Delivery_Cost] * Q4.[ExRate]) * (1 + AvgT.Avg_Delivery_Growth_Rate_EUR)),2) AS ForecastedDeliveryCost,
    round(((Q4.[Other_Costs]* Q4.[ExRate]) * (1 + AvgT.Avg_Other_Growth_Rate_EUR)),2) AS ForecastedOtherCosts
from [Logistics].[dbo].[LogisticsCostS] as Q4,
avg_growth_rates as AvgT 
Where Datepart(QUARTER, Q4.[Date]) = 4 and Datepart(Year, Q4.[Date]) = 2024
)
select ForecastedQuarter,
Market,
Logistics_Provider,
round(AVG(ForecastedInboundCost),2) as ForecastedInboundCost,
round(AVG(ForecastedStorageCost),2) as ForecastedStorageCost,
round(AVG(ForecastedDeliveryCost),2) as ForecastedDeliveryCost
from avg_forecast 
group by  ForecastedQuarter,Market,Logistics_Provider
order by  Market, Logistics_Provider



 