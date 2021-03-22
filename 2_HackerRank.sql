## get rownumber on select
-- ROW_NUMBER() OEVER (<partition_definition><order_definition>)
-- PARTITION BY clause breaks the rows into smaller sets 

-- 1) Assigning sequential numbers to rows
SELECT  ROW_NUMBER() OVER ( 
						ORDER BY price_usd/cogs_usd DESC
						) as RecordID
		,  product_id
		, price_usd/cogs_usd as Margin
FROM order_items
GROUP BY product_id
	
-- 2) Finding top N rows of every group
WITH margin 
AS (
	SELECT  ROW_NUMBER() OVER ( 
							ORDER BY price_usd/cogs_usd DESC
							) as RecordID
			, product_id
			, price_usd/cogs_usd as Margin
FROM order_items
GROUP BY product_id
) 
SELECT m.product_id
		, Margin
        , COUNT(DISTINCT o.order_id) as order_num 
FROM margin m , order_items o
WHERE m.product_id = o.product_id 
	AND RecordID <= 2						-- 왜 하나만 나와....
    
    
-- 3) Removing duplicate rows
-- to turn non-unique rows into unique rows and then delete the duplicate rows
CREATE TABLE t ( 
				id INT
                , name VARCHAR(10) NOT NULL 
                );
INSERT INTO t(id, name)
VALUES  (1,'A'), (2,'B'),(2,'B'),(3,'C'),(3,'C'),(3,'C'),(4,'D');	 		-- EXAMPLE TABLE
SELECT * FROM t ; 													 		-- DUPLICATE ROWS
SELECT id
		,name
        ,ROW_NUMBER() over (partition by id, name order by id) AS  recordID	-- set the group for id, name field 
FROM t																		
-- the unique rows are the ones whose the row number equals one
-- same example with CTE
WITH CTE
AS ( SELECT id
	, name
    , row_number() over(partition by id, name order by id) as recordID	
    FROM t
    ) 
DELETE FROM t 
USING t JOIN CTE ON CTE.id = t.id											-- USING 구문 JOIN
WHERE CTE.recordID <> 1;													-- ?


-- 4) Pagination using  ROW_NUMBER() function
-- display a list with N items per page
SELECT *
FROM 
    (SELECT productName,
         msrp,
         row_number()
        OVER (order by msrp) AS row_num
    FROM products) t
WHERE row_num BETWEEN 11 AND 20;  



## CREATE PROCEDURE statement
-- 1) right-click on the Stored Procedures from the Navigator and select the Create Stored Procedure / Click the Apply
-- 2) CREATE PROCEDURE BEGIN END 구문
DELIMITER //								-- not a part of the stored procedure : command for changing the default delimiter to // 
CREATE PROCEDURE GetAllProducts()			-- CREATE PROCEDURE procedurename()
BEGIN										-- code between the BEGIN END
	SELECT *  FROM products;
END //
DELIMITER ;									-- command for changing the delimiter back to the default one which semicolon (;)
-- check the stored procedure by opening the Stored Procedures node

## EXECUTING A STORED PROCEDURE
CALL GETALLProducts();


## My SQL REPEAT STATEMENT
-- one or more statements until a search condition is true
/** Syntax
[begin_label:] REPEAT
    statement
UNTIL search_condition
END REPEAT [end_label]
**/
