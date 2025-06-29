--- To identify number of rows in widetable

SELECT COUNT(*) FROM widetable;


--- https://www.youtube.com/watch?v=4UltKCnnnTA
--- 1. Remove Duplicates
--- 2. Null Values or blank values


--- 1. Remove Duplicates

WITH duplicate_cte AS (
	SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY Calendar_Date, Invoice_Number, Pet_Number, Item_Code
		) AS row_num
	FROM widetable
	)
SELECT count(row_num), sum(Line_Total)
FROM duplicate_cte
WHERE row_num > 1
ORDER BY row_num DESC;


---2. Null or blank values
SELECT *
FROM widetable
WHERE Calendar_Date IS NULL
      OR Calendar_Date = '';

SELECT *
FROM widetable
WHERE Line_Time IS NULL
      OR Line_Time = '';

SELECT *
FROM widetable
WHERE Invoice_Number IS NULL
      OR Invoice_Number = '';

SELECT count(*), sum(Line_Total)
FROM widetable
WHERE Case_Number IS NULL
      OR Case_Number = '';

SELECT *
FROM widetable
WHERE Owner_Number IS NULL
      OR Owner_Number = '';

SELECT *
FROM widetable
WHERE Residential_Area IS NULL
      OR Residential_Area = '';

SELECT *
FROM widetable
WHERE Residential_District IS NULL
      OR Residential_District = '';

SELECT count(*), sum(Line_Total)
FROM widetable
WHERE Pet_Number IS NULL
      OR Pet_Number = '';

SELECT count(*), sum(Line_Total)
FROM widetable
WHERE Species IS NULL
      OR Species = '';

SELECT count(*), sum(Line_Total)
FROM widetable
WHERE Breed IS NULL
      OR Breed = '';

SELECT count(*), sum(Line_Total)
FROM widetable
WHERE Age IS NULL
      OR Age = '';

SELECT *
FROM widetable
WHERE Vet_Name IS NULL
      OR Vet_Name = '';

SELECT *
FROM widetable
WHERE Service IS NULL
      OR Service = '';

SELECT *
FROM widetable
WHERE Item_Code IS NULL
      OR Item_Code = '';

SELECT *
FROM widetable
WHERE Item_Category IS NULL
      OR Item_Category = '';

SELECT *
FROM widetable
WHERE Item_Group IS NULL
      OR Item_Group = '';

SELECT *
FROM widetable
WHERE Unit_Cost IS NULL
      OR Unit_Cost = '';

SELECT *
FROM widetable
WHERE Quantity IS NULL
      OR Quantity = '';

SELECT *
FROM widetable
WHERE Unit_Price IS NULL
      OR Unit_Price = '';

SELECT *
FROM widetable
WHERE Line_Total IS NULL
      OR Line_Total = '';