/*
end_date of the tasks are consecutive > same projects
** find total number of different projects
1. start_date end_date
2. days it took to complete it ASC > the start date of project ASC
*/
# MY APPOACH
-- Consecutive 한 것을 파악하여 취합 후 제외 :: IN 
# SOLUTIONS 
-- 결과값에서 제외되어야하는 것 : Consecutive Date > Consecutive 하지 않은 것만 취합 :: NOT IN

-- (1) on 구문 없는 join 카테시안 곱 & WHERE 절 조건 
SET sql_mode = '';  		-- Change the SQL Mode
select Start_Date, Min(End_Date) 
from
	(SELECT Start_Date FROM Projects where Start_Date NOT IN (SELECT End_Date from Projects)) a,
	(SELECT End_Date FROM Projects where End_Date NOT IN (SELECT Start_Date from Projects)) b
WHERE Start_Date < End_Date
GROUP BY Start_Date
ORDER BY Datediff(Min(End_Date), Start_Date) ASC, Start_Date ASC;

-- (2) cross join 
select Start_Date, Min(End_Date) 
from
	(SELECT Start_Date FROM Projects where Start_Date NOT IN (SELECT End_Date from Projects)) a
    cross join
	(SELECT End_Date FROM Projects where End_Date NOT IN (SELECT Start_Date from Projects)) b
WHERE Start_Date < End_Date
GROUP BY Start_Date
ORDER BY Datediff(Min(End_Date), Start_Date) ASC, Start_Date ASC;
