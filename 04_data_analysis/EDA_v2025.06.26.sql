---The data is stored in SQLite.

---This is the syntax to extract YYYY-mm from column Calendar_Date
SELECT Calendar_Date,
       strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2
FROM widetable;


---Q1: What are the respective revenue growth rates in each of the services over the past 12 months?
WITH cte_1 AS (   ---create cte_1 to get column Date2 and column Revenue
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,
           Service,
           SUM(Line_Total) AS Revenue
	FROM widetable
	GROUP BY Service, Date2
	ORDER BY Service, Date2
	),
	cte_2 AS (   ---use cte_2 to create column Ttl_rev_roll_12mth based on cte_1
	SELECT Date2,
	       Service,
	       Revenue,
	       SUM(Revenue) OVER (
	                          PARTITION BY service
	                          ORDER BY Date2
	                          ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
	                          ) AS Ttl_rev_roll_12mth
	FROM cte_1   
	),
	cte_3 AS (   ---use cte_3 to create column Ttl_rev_pre_12mth based on cte_2
	SELECT Date2,
	       Service,
	       Revenue,
	       Ttl_rev_roll_12mth,
	       LAG (Ttl_rev_roll_12mth, 12) OVER (PARTITION BY Service ORDER BY Date2) AS Ttl_rev_pre_12mth
	FROM cte_2
	)
SELECT Date2,   ---here gives a data table. Combines it with Q2 to give a summary table for the executive summary.
       Service,
       Ttl_rev_roll_12mth,
       Ttl_rev_pre_12mth,
       Ttl_rev_roll_12mth - Ttl_rev_pre_12mth AS Change_abs,
       (Ttl_rev_roll_12mth - Ttl_rev_pre_12mth)/Ttl_rev_pre_12mth AS Change_rate
FROM cte_3
WHERE Date2 = '2025-06'
ORDER BY Change_rate DESC;


---Q2: What is the overall revenue growth rate over the past 12 months?
WITH cte_1 AS (   ---create cte_1 to get column Date2 and column Revenue
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,
           SUM(Line_Total) AS Revenue
	FROM widetable
	GROUP BY Date2
	ORDER BY Date2
	),
	cte_2 AS (   ---use cte_2 to create column Ttl_rev_roll_12mth based on cte_1
	SELECT Date2,
	       Revenue,
	       SUM(Revenue) OVER (
	                          ORDER BY Date2
	                          ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
	                          ) AS Ttl_rev_roll_12mth
	FROM cte_1   
	),
	cte_3 AS (   ---use cte_3 to create column Ttl_rev_pre_12mth based on cte_2
	SELECT Date2,
	       Revenue,
	       Ttl_rev_roll_12mth,
	       LAG (Ttl_rev_roll_12mth, 12) OVER (ORDER BY Date2) AS Ttl_rev_pre_12mth
	FROM cte_2
	)
SELECT Date2,   ---here gives a data table. Combines it with Q1 to give a summary table for the executive summary.
       Ttl_rev_roll_12mth,
       Ttl_rev_pre_12mth,
       Ttl_rev_roll_12mth - Ttl_rev_pre_12mth AS Change_abs,
       (Ttl_rev_roll_12mth - Ttl_rev_pre_12mth)/Ttl_rev_pre_12mth AS Change_rate
FROM cte_3
WHERE Date2 = '2025-06';


---Q3: What are the respective growth rates in each of the species over the past 12 months?
WITH cte_1 AS (   ---create cte_1 to get column Date2 and column PCount
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,
	       Species,
	       COUNT(DISTINCT(Pet_Number)) AS PCount
	FROM widetable
	WHERE Species IS NOT NULL
	GROUP BY Date2, Species
	),
	cte_2 AS (   ---use cte_2 to create column Ttl_PCount_roll_12mth based on cte_1
	SELECT Date2,
	       Species,
	       PCount,
	       SUM(PCount) OVER (
	                          PARTITION BY Species
	                          ORDER BY Date2, Species
	                          ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
	                          ) AS Ttl_PCount_roll_12mth
	FROM cte_1   
	),
	cte_3 AS (   ---use cte_3 to create column Ttl_PCount_pre_12mth based on cte_2
	SELECT Date2,
	       Species,
	       PCount,
	       Ttl_PCount_roll_12mth,
	       LAG (Ttl_PCount_roll_12mth, 12) OVER (PARTITION BY Species ORDER BY Date2) AS Ttl_PCount_pre_12mth
	FROM cte_2
	)
SELECT Date2,   ---here gives the data table for the executive summary
       Species,
       Ttl_PCount_roll_12mth,
       Ttl_PCount_pre_12mth,
       Ttl_PCount_roll_12mth - Ttl_PCount_pre_12mth AS Change_abs,
       (Ttl_PCount_roll_12mth - Ttl_PCount_pre_12mth)/CAST(Ttl_PCount_pre_12mth AS REAL) AS Change_rate
FROM cte_3
WHERE Date2 = '2025-06'
ORDER BY Change_rate DESC;

---Checking Q3: to generate a .csv file for manual checking against Q3, CHECKED OKAY
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,
	       Species,
	       COUNT(DISTINCT(Pet_Number)) AS PCount
	FROM widetable
	WHERE Species IS NOT NULL
	GROUP BY Date2, Species
	ORDER BY Species, Date2;


---Q4: What is the overall case growth rate over the past 12 months?
WITH cte_1 AS (   ---create cte_1 to get column Date2 and column CCount
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,
           COUNT(DISTINCT(Case_Number)) AS CCount
	FROM widetable
	GROUP BY Date2
	ORDER BY Date2
	),
	cte_2 AS (   ---use cte_2 to create column Ttl_CCount_roll_12mth based on cte_1
	SELECT Date2,
	       CCount,
	       SUM(CCount) OVER (
	                         ORDER BY Date2
	                         ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
	                         ) AS Ttl_CCount_roll_12mth
	FROM cte_1   
	),
	cte_3 AS (   ---use cte_3 to create column Ttl_CCount_pre_12mth based on cte_2
	SELECT Date2,
	       CCount,
	       Ttl_CCount_roll_12mth,
	       LAG (Ttl_CCount_roll_12mth, 12) OVER (ORDER BY Date2) AS Ttl_CCount_pre_12mth
	FROM cte_2
	)
SELECT Date2,   ---here gives the data table for the executive summary
       Ttl_CCount_roll_12mth,
       Ttl_CCount_pre_12mth,
       Ttl_CCount_roll_12mth - Ttl_CCount_pre_12mth AS Change_abs,
       (Ttl_CCount_roll_12mth - Ttl_CCount_pre_12mth)/CAST(Ttl_CCount_pre_12mth AS REAL) AS Change_rate
FROM cte_3
WHERE Date2 = '2025-06';


---Q5: What is the revenue split between Intangible and Tangible in Item Categorization across the months?
WITH cte_1 AS (
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,
	       Item_Category,
	       sum(Line_Total) AS Rev_Ttl
	FROM widetable
	GROUP BY Date2
	),	
	cte_2 AS(
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,
	       Item_Category,
	       sum(Line_Total) AS Rev_Intangible
	FROM widetable
	WHERE Item_Category = 'Intangible'
	GROUP BY Date2
	),
	cte_3 AS (
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,
	       Item_Category,
	       sum(Line_Total) AS Rev_Tangible
	FROM widetable
	WHERE Item_Category = 'Tangible'
	GROUP BY Date2
	)
SELECT cte_1.Date2,
       cte_1.Rev_Ttl,
       cte_2.Rev_Intangible,
       cte_3.Rev_Tangible,
       cte_2.Rev_Intangible/cte_1.Rev_Ttl AS Intangible_Percentage,
       cte_3.Rev_Tangible/cte_1.Rev_Ttl AS Tangible_Percentage
FROM cte_1 JOIN cte_2 ON cte_1.Date2 = cte_2.Date2
           JOIN cte_3 ON cte_1.Date2 = cte_3.Date2
ORDER BY cte_1.Date2;


---Q6: What are the revenue and the pet count per individual vet in the first and second 12 months?
WITH cte_1 AS (
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,
	        Vet_Name,
	        Service,
	        COUNT(DISTINCT(Pet_Number)) AS PCount,
	        SUM(Line_Total) AS Revenue
	FROM widetable
	GROUP BY Date2, Vet_Name
	ORDER BY Vet_Name, Date2
	),
    cte_2 AS (
    SELECT Date2,
           Vet_Name,
           Service,
	       SUM(PCount) OVER (
	                         PARTITION BY Vet_Name
	                         ORDER BY Date2, Vet_Name
	                         ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
	                         ) AS Ttl_PCount_roll_12mth,
	       SUM(Revenue) OVER (
	                          PARTITION BY Vet_Name
	                          ORDER BY Date2
	                          ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
	                          ) AS Ttl_rev_roll_12mth
    FROM cte_1
    )
SELECT Date2,   ---here gives a data table for drawing a scatter graph in Excel
       Vet_Name,
       Service,
       Ttl_PCount_roll_12mth,
       Ttl_rev_roll_12mth
FROM cte_2
WHERE Date2 = '2024-06' OR Date2 = '2025-06'
ORDER BY Date2;


---Q7: How much does each service contribute to the total revenue in every 12 months? What are the ranks?
WITH cte_1 AS (   ---create cte_1 to get column Date2 and column Revenue
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,
           Service,
           SUM(Line_Total) AS Revenue
	FROM widetable
	GROUP BY Service, Date2
	ORDER BY Service, Date2
	),
	cte_2 AS (   ---use cte_2 to create column Ttl_rev_roll_12mth based on cte_1
	SELECT Date2,
	       Service,
	       Revenue,
	       SUM(Revenue) OVER (
	                          PARTITION BY service
	                          ORDER BY Date2
	                          ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
	                          ) AS Ttl_rev_roll_12mth
	FROM cte_1   
	),
	cte_3 AS (   ---use cte_3 to rank the service performance as of 2024-06
	SELECT Date2,   
	       Service,
	       Ttl_rev_roll_12mth,
	       RANK() OVER(
	                   ORDER by Ttl_rev_roll_12mth DESC
	                   ) as Rank_2024
	FROM cte_2
	WHERE Date2 = '2024-06'
	),
	cte_4 AS (   ---use cte_4 to rank the service performance as of 2025-06
	SELECT Date2,   
	       Service,
	       Ttl_rev_roll_12mth,
	       RANK() OVER(
	                   ORDER by Ttl_rev_roll_12mth DESC
	                   ) as Rank_2025
	FROM cte_2
	WHERE Date2 = '2025-06'
	)
SELECT cte_3.Service,   ---here gives the data table for the executive summary
       cte_4.Rank_2025,
       cte_3.Rank_2024,   
       cte_3.Rank_2024 - cte_4.Rank_2025 AS Rank_Change,       
       cte_3.Ttl_rev_roll_12mth AS Rev_2024,
       cte_4.Ttl_rev_roll_12mth AS Rev_2025
FROM cte_3 JOIN cte_4 ON cte_3.Service = cte_4.Service
ORDER BY cte_4.Rank_2025;


---Q8: Overall, how many cases and the respective ACV should we expect from each pet across the two 12-month periods?
---There are two syntax in answering this question.
WITH cte_1 AS (   ---create cte_1 to get column CCount and column Revenue
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2, 
		   Pet_Number,
	       COUNT(DISTINCT(Case_Number)) AS CCount,  
	       SUM(Line_Total) AS Revenue
	FROM widetable
	WHERE Date2 <= '2024-06'
	GROUP BY Pet_Number
	)
SELECT CCount AS Case_Count,   ---here gives the data table (2023.07 to 2024.06) for the executive summary
       Count(CCount) AS Frequency,
       SUM(Revenue) AS Revenue2,
       SUM(Revenue) / Count(CCount) / CCount AS ACV  
FROM cte_1
GROUP BY Case_Count
ORDER BY Case_Count;

WITH cte_1 AS (   ---create cte_1 to get column CCount and column Revenue
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2, 
		   Pet_Number,
	       COUNT(DISTINCT(Case_Number)) AS CCount,  
	       SUM(Line_Total) AS Revenue
	FROM widetable
	WHERE Date2 > '2024-06' AND Date2 <= '2025-06'
	GROUP BY Pet_Number
	)
SELECT CCount AS Case_Count,   ---here gives the data table (2024.07 to 2025.06) for the executive summary
       Count(CCount) AS Frequency,
       SUM(Revenue) AS Revenue2,
       SUM(Revenue) / Count(CCount) / CCount AS ACV  
FROM cte_1
GROUP BY Case_Count
ORDER BY Case_Count;


---Q9: How many cases and the respective ACV should we expect from each pet? Please break it down by species and across the two 12-month periods.
---There are two syntax in answering this question.
WITH cte_1 AS (   ---create cte_1 to get column CCount and column Revenue
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2, 
		   Pet_Number,
	       Species,
	       COUNT(DISTINCT(Case_Number)) AS CCount,  
	       SUM(Line_Total) AS Revenue
	FROM widetable
	WHERE Date2 <= '2024-06'
	GROUP BY Pet_Number
	)
SELECT Species,   ---here gives the data table for the executive summary
       CCount AS Case_Count,
       Count(CCount) AS Frequency,
       SUM(Revenue) AS Revenue2,
       SUM(Revenue) / Count(CCount) / CCount AS ACV  
FROM cte_1
GROUP BY Species, Case_Count
ORDER BY Species, Case_Count;

WITH cte_1 AS (
	SELECT strftime('%Y-%m', (substr(Calendar_Date,7,4) || '-' || substr(Calendar_Date,4,2) || '-' || substr(Calendar_Date,1,2)) ) as Date2,  
		   Pet_Number,
	       Species,
	       COUNT(DISTINCT(Case_Number)) AS CCount,  
	       SUM(Line_Total) AS Revenue
	FROM widetable
	WHERE Date2 > '2024-06' AND Date2 <= '2025-06'
	GROUP BY Pet_Number
	)
SELECT Species,
       CCount AS Case_Count,
       Count(CCount) AS Frequency,
       SUM(Revenue) AS Revenue2,
       SUM(Revenue) / Count(CCount) / CCount AS ACV 
FROM cte_1
GROUP BY Species, Case_Count
ORDER BY Species, Case_Count;


---Q10: How is age distributed in each species? How much revenue is each age group generating?
WITH cte_1 AS (
	SELECT Species,
	       Age,
	       SUM(Line_Total) AS Revenue
	FROM widetable
	GROUP BY Pet_Number
	)
SELECT Species,
       Age,
       Count(Age) AS Pet_Count,
       SUM(Revenue) AS Revenue2
FROM cte_1
GROUP BY Species, Age
ORDER BY Species, Age;


---Q11: Where are the owners and pets located?
WITH cte_1 AS (
	SELECT Owner_Number,
	       Residential_Area,
	       COUNT(DISTINCT(Pet_Number)) AS PCount,
	       Species,
	       SUM(Line_Total) AS Rev
	FROM widetable
	GROUP BY Owner_Number, Species
	),
	cte_2 AS (
	SELECT Residential_Area,
	       COUNT(DISTINCT(Owner_Number)) AS Owner,
	       SUM(Rev) AS Revenue
	FROM cte_1
	GROUP BY Residential_Area
	),
	cte_3 AS (   ---This query could be modified to utilize the PIVOT() function.
	SELECT Residential_Area,
	       SUM(PCount) AS Canine
	FROM cte_1
	WHERE Species = 'Canine'
	GROUP BY Residential_Area
	),
	cte_4 AS (
	SELECT Residential_Area,
	       SUM(PCount) AS Feline
	FROM cte_1
	WHERE Species = 'Feline'
	GROUP BY Residential_Area
	),
	cte_5 AS (
	SELECT Residential_Area,
	       SUM(PCount) AS Rabbit
	FROM cte_1
	WHERE Species = 'Rabbit'
	GROUP BY Residential_Area
	)
SELECT cte_2.Residential_Area,
       cte_2.Owner,
       cte_3.Canine,
       cte_4.Feline,
       cte_5.Rabbit,
       cte_2.Revenue
FROM cte_2 LEFT JOIN cte_3 ON cte_2.Residential_Area = cte_3.Residential_Area
           LEFT JOIN cte_4 ON cte_2.Residential_Area = cte_4.Residential_Area
           LEFT JOIN cte_5 ON cte_2.Residential_Area = cte_5.Residential_Area;


---Q12: Could we rank the owners by the number of pets and the revenue contributed?
WITH cte_1 AS (
	SELECT Owner_Number,
	       Residential_Area,
	       COUNT(DISTINCT(Pet_Number)) AS Pet_Count,
	       SUM(Line_Total) AS Rev
	FROM widetable
	GROUP BY Owner_Number
	),
	cte_2 AS (
	SELECT Owner_Number,
	       Residential_Area,
	       Pet_Count,
	       DENSE_RANK() OVER (ORDER BY Pet_Count ASC) AS Rank_PCount,
	       Rev,
	       DENSE_RANK() OVER (ORDER BY Rev ASC) AS Rank_Rev
	FROM cte_1
	)
SELECT *
FROM cte_2


---Q13: How many owners have 1, 2, 3 and so on... pets?
---There are two syntax to answer this question.
WITH cte_1 AS (   ---create cte_1 to get column PCount
	SELECT Owner_Number,
	       Species,
	       COUNT(DISTINCT(Pet_Number)) AS PCount
	FROM widetable
	where Pet_Number <> ''
	GROUP BY Owner_Number, Species
	),
	cte_2 AS (   ---here gives a list of owners who has 2 or more pets across species
	SELECT Owner_Number,
	       COUNT(Owner_Number) AS SCount
	FROM cte_1
	GROUP BY Owner_Number
	HAVING SCount > 1
	),
	cte_3 AS (   ---here breaks down the list from cte_2 by residential area, species and pet count
	SELECT widetable.Owner_Number,
	       ---cte_2.Owner_Number,
	       widetable.Residential_Area,
	       widetable.Species,
	       COUNT(DISTINCT(widetable.Pet_Number)) AS PCount
	FROM widetable LEFT JOIN cte_2 ON widetable.Owner_Number = cte_2.Owner_Number
	WHERE widetable.Pet_Number <> '' AND cte_2.Owner_Number <> ''
	GROUP BY widetable.Owner_Number, widetable.Species
	),
	cte_4 AS (   ---here gives a list of pet counts (of owners who has 2 or more pets across species)
	SELECT SUM(PCount) AS No_of_pets,
	       Residential_Area,
	       Owner_Number
	FROM cte_3
	GROUP BY cte_3.Owner_Number, cte_3.Residential_Area
	),
	cte_5 AS (   ---here gives the data table for the executive summary
	SELECT Residential_Area,
	       No_of_pets,
	       COUNT(No_of_pets) AS Owner_Count
	FROM cte_4
	GROUP BY Residential_Area, No_of_pets
	)
SELECT *
FROM cte_5

---The below syntax is a replica of the above, except for the one line specified
WITH cte_1 AS (   ---create cte_1 to get column PCount
	SELECT Owner_Number,
	       Species,
	       COUNT(DISTINCT(Pet_Number)) AS PCount
	FROM widetable
	where Pet_Number <> ''
	GROUP BY Owner_Number, Species
	),
	cte_2 AS (   ---here gives a list of owners who has only 1 species of pets
	SELECT Owner_Number,
	       COUNT(Owner_Number) AS SCount
	FROM cte_1
	GROUP BY Owner_Number
	HAVING SCount = 1   ---This line is changed, from > to =
	),
	cte_3 AS (   ---here breaks down the list from cte_2 by residential area, species and pet count
	SELECT widetable.Owner_Number,
	       cte_2.Owner_Number,
	       widetable.Residential_Area,
	       widetable.Species,
	       COUNT(DISTINCT(widetable.Pet_Number)) AS PCount
	FROM widetable LEFT JOIN cte_2 ON widetable.Owner_Number = cte_2.Owner_Number
	WHERE widetable.Pet_Number <> '' AND cte_2.Owner_Number <> ''
	GROUP BY widetable.Owner_Number, widetable.Species
	),
	cte_4 AS (   ---here gives a list of pet counts (of owners who has only 1 species of pets)
	SELECT SUM(PCount) AS No_of_pets,
	       Residential_Area,
	       Owner_Number
	FROM cte_3
	GROUP BY cte_3.Owner_Number, cte_3.Residential_Area
	),
	cte_5 AS (   ---here gives the data table for the executive summary
	SELECT Residential_Area,
	       No_of_pets,
	       COUNT(No_of_pets) AS Owner_Count
	FROM cte_4
	GROUP BY Residential_Area, No_of_pets
	)
SELECT *
FROM cte_5