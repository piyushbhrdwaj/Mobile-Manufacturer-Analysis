--SQL Advance Case Study


--Q1--BEGIN
SELECT [STATE], COUNT(IDCUSTOMER) CUST_COUNT, [YEAR]
FROM DIM_LOCATION A
JOIN FACT_TRANSACTIONS B
ON A.IDLOCATION=B.IDLOCATION
LEFT JOIN DIM_DATE C
ON B.[Date]=C.[DATE]
WHERE [YEAR]>=2005
GROUP BY [STATE],[YEAR]

	





--Q1--END

--Q2--BEGIN
	SELECT TOP 1 [STATE],COUNT(IDCUSTOMER) AS CUST_COUNT, COUNTRY,Manufacturer_Name
	FROM DIM_LOCATION A
	JOIN FACT_TRANSACTIONS B
	ON A.IDLocation=B.IDLocation
	JOIN DIM_MODEL C
	ON B.IDModel=C.IDModel
	JOIN DIM_MANUFACTURER D
	ON C.IDManufacturer=D.IDManufacturer
	WHERE COUNTRY='US'AND MANUFACTURER_NAME='SAMSUNG'
	GROUP BY [STATE],COUNTRY,MANUFACTURER_NAME
	ORDER BY COUNT(IDCUSTOMER) DESC









--Q2--END

--Q3--BEGIN      
	
	SELECT DISTINCT[STATE] ,IDMODEL, COUNT(IDCUSTOMER)AS CUST_TRANS ,ZipCode
	FROM FACT_TRANSACTIONS A
	LEFT JOIN DIM_LOCATION B
	ON A.IDLOCATION=B.IDLOCATION
	GROUP BY IDMODEL,ZIPCODE,[STATE]










--Q3--END

--Q4--BEGIN
SELECT TOP 1 MODEL_NAME,UNIT_PRICE FROM DIM_MODEL 
GROUP BY MODEL_NAME,UNIT_PRICE
ORDER BY UNIT_PRICE ASC







--Q4--END

--Q5--BEGIN
select T.IDModel,AVG(totalprice) as AVG_AMT 
	from FACT_TRANSACTIONS T
	left join DIM_MODEL as MO on T.IDModel = MO.IDModel
    left join DIM_MANUFACTURER as M on MO.IDManufacturer = M.IDManufacturer 
	where Manufacturer_Name in 
	(Select top 5 Manufacturer_Name   from FACT_TRANSACTIONS T
      left join DIM_MODEL as MO on T.IDModel = MO.IDModel
      left join DIM_MANUFACTURER as M on MO.IDManufacturer = M.IDManufacturer 
	  group by Manufacturer_Name
	  order by sum(quantity) desc) 
	group by T.IDModel 
	order by AVG_AMT desc











--Q5--END

--Q6--BEGIN
SELECT CUSTOMER_NAME,AVG(TOTALPRICE) AS TOT_AMOUNT,[YEAR]
fROM DIM_CUSTOMER A
LEFT JOIN FACT_TRANSACTIONS B
ON A.IDCustomer=B.IDCustomer
left join dim_date C
on B.[DATE]=C.[DATE]
WHERE [YEAR]=2009
GROUP BY CUSTOMER_NAME,[YEAR]
HAVING AVG(TOTALPRICE)>500











--Q6--END
	
--Q7--BEGIN
SELECT*FROM
(SELECT TOP 5 MODEL_NAME,SUM(QUANTITY)AS TOT_QUANTITY,[YEAR]
FROM DIM_MODEL A
 JOIN FACT_TRANSACTIONS B
ON A.IDMODEL=B.IDMODEL
JOIN DIM_DATE C
ON B.[DATE]=C.[DATE]
WHERE [YEAR] =2008
GROUP BY MODEL_NAME,[YEAR]
ORDER BY SUM(QUANTITY) DESC) AS X

intersect
SELECT*FROM
(SELECT TOP 5 MODEL_NAME,SUM(QUANTITY)AS TOT_QUANTITY,[YEAR]
FROM DIM_MODEL A
 JOIN FACT_TRANSACTIONS B
ON A.IDMODEL=B.IDMODEL
JOIN DIM_DATE C
ON B.[DATE]=C.[DATE]
WHERE [YEAR] =2009
GROUP BY MODEL_NAME,[YEAR]
ORDER BY SUM(QUANTITY) DESC) AS Y
intersect
SELECT*FROM
(SELECT TOP 5 MODEL_NAME,SUM(QUANTITY)AS TOT_QUANTITY,[YEAR]
FROM DIM_MODEL A
 JOIN FACT_TRANSACTIONS B
ON A.IDMODEL=B.IDMODEL
JOIN DIM_DATE C
ON B.[DATE]=C.[DATE]
WHERE [YEAR] =2010
GROUP BY MODEL_NAME,[YEAR]
ORDER BY SUM(QUANTITY) DESC) AS Z














--Q7--END	
--Q8--BEGIN
SELECT*FROM
(SELECT*, RANK()OVER(ORDER BY TOT_AMOUNT DESC) AS RANK_NO FROM
(SELECT MANUFACTURER_NAME,SUM(TOTALPRICE)AS TOT_AMOUNT,[YEAR]
FROM DIM_MANUFACTURER W
LEFT JOIN DIM_MODEL X
ON W.IDManufacturer=X.IDManufacturer
LEFT JOIN FACT_TRANSACTIONS Y
ON X.IDModel=Y.IDModel
LEFT JOIN DIM_DATE Z
ON Y.[DATE]=Z.[DATE]
WHERE [YEAR]=2009
GROUP BY MANUFACTURER_NAME,[YEAR])AS A) AS C
WHERE RANK_NO=2

UNION ALL

SELECT*FROM
(SELECT*,RANK()OVER(ORDER BY TOT_AMOUNT) AS RANK_NO FROM
(SELECT  MANUFACTURER_NAME,SUM(TOTALPRICE)AS TOT_AMOUNT,[YEAR]
FROM DIM_MANUFACTURER W
LEFT JOIN DIM_MODEL X
ON W.IDManufacturer=X.IDManufacturer
LEFT JOIN FACT_TRANSACTIONS Y
ON X.IDModel=Y.IDModel
LEFT JOIN DIM_DATE Z
ON Y.[DATE]=Z.[DATE]
WHERE [YEAR]=2010
GROUP BY MANUFACTURER_NAME,[YEAR]) AS B) AS D
WHERE RANK_NO=2



















--Q8--END
--Q9--BEGIN
	

SELECT MANUFACTURER_NAME 
FROM DIM_MANUFACTURER W
LEFT JOIN DIM_MODEL X
ON W.IDManufacturer=X.IDManufacturer
LEFT JOIN FACT_TRANSACTIONS Y
ON X.IDModel=Y.IDModel
LEFT JOIN DIM_DATE Z
ON Y.[DATE]=Z.[DATE]
WHERE [YEAR]=2010
GROUP BY MANUFACTURER_NAME
EXCEPT
SELECT MANUFACTURER_NAME
FROM DIM_MANUFACTURER W
LEFT JOIN DIM_MODEL X
ON W.IDManufacturer=X.IDManufacturer
LEFT JOIN FACT_TRANSACTIONS Y
ON X.IDModel=Y.IDModel
LEFT JOIN DIM_DATE Z
ON Y.[DATE]=Z.[DATE]
WHERE [YEAR]=2009
GROUP BY MANUFACTURER_NAME













--Q9--END

--Q10--BEGIN
select*From
(SELECT *,row_number()OVER( PARTITION BY [YEAR]ORDER BY AVG_SPEND DESC) AS RANK_NO FROM
    ( SELECT*,(AVG_SPEND-LAG(AVG_SPEND)OVER(PARTITION BY [YEAR] ORDER BY AVG_SPEND DESC))/( LAG(AVG_SPEND)OVER(PARTITION BY [YEAR] ORDER BY AVG_SPEND DESC))*100 as [Difference] FROM
	( SELECT*, LAG(AVG_SPEND)OVER(PARTITION BY [YEAR] ORDER BY AVG_SPEND DESC) AS PREV_SPEND FROM
	(SELECT IDCUSTOMER, AVG(TOTALPRICE) AS AVG_SPEND,AVG(QUANTITY) AS AVG_QUANTITY,[YEAR]
	FROM FACT_TRANSACTIONS A	
	LEFT JOIN DIM_DATE B
	ON A.DATE=B.DATE
	GROUP BY IDCUSTOMER,[YEAR]) AS X)as final)AS C)as y
	WHERE RANK_NO <= 10
	
	   
	

	
	
	



