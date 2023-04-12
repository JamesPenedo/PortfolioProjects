SELECT *
FROM train$
ORDER BY 2;

-- BREAKING DOWN BY INDIVIDUAL STORES
--Which store generated the most total revenue between 2010-2013

SELECT store, SUM(weekly_sales) as TotalRevenue
FROM train$
GROUP BY store
ORDER BY 2 DESC;

-- BREAKING DOWN BY INDIVIDUAL DEPARTMENTS WITHIN THE STORES
--Which department generated the most revenue between 2010-2013 in top store number 2010-2013

SELECT  dept, store, SUM(weekly_sales) as TotalRevenue, 
FROM PortfolioProject3..train$
WHERE store=20
GROUP BY dept, store
ORDER BY 3 DESC;


--TYPE OF STORES
--Do we see a large desparity between store types

SELECT  st.type, (SUM(tr.weekly_sales)) as TotalRevenue
FROM PortfolioProject3..train$ tr
LEFT JOIN PortfolioProject3..stores$ st ON st.store=tr.store
GROUP BY  st.type
ORDER BY 1;


-- BUYING SEASON TRENDS BY WEATHER
--Does temperature have a correlation with weekly sales?

SELECT  fe.date, AVG(fe.temperature) as AverageTemperature, (SUM(tr.weekly_sales)) as TotalRevenue
FROM PortfolioProject3..train$ tr
LEFT JOIN PortfolioProject3..features$ fe ON fe.date=tr.date
GROUP BY fe.date
ORDER BY 2;


-- MONTHS REVENUE
--What months can we experience higher revenue/transactions?

SELECT DATEPART(Month,date) as Month, (SUM(weekly_sales)) as TotalRevenue
FROM PortfolioProject3..train$
GROUP BY DATEPART(Month,date)
ORDER BY 2 DESC;


-- 2012 YEARLY REVENUE
-- 

SELECT DATEPART(Month,date) as DateOfMonth, (SUM(weekly_sales)) OVER (Partition by DATEPART(Month,date)) as TotalRevenue
FROM PortfolioProject3..train$
WHERE DATEPART(Year,date)=2012
GROUP BY DATEPART(Month,date)
ORDER BY 1 ASC;