
-- JOIN 구문 ON Clause 없이 사용 가능
-- 키값 설정하지 않아 카테시안 곱 생성
SELECT IF(Grade<8,NULL,Name),
        Grade,
        Marks
FROM Students
    JOIN Grades
WHERE Marks BETWEEN Min_Mark AND Max_Mark
ORDER BY Grade DESC, Name, Grade;

CREATE TEMPORARY TABLE test1 
SELECT *  
FROM mavenfuzzyfactory.orders   -- SELECT as Default DB on the Side bar 에러 
LIMIT 1

CREATE TEMPORARY TABLE test2 
SELECT *  
FROM mavenfuzzyfactory.products   -- SELECT as Default DB on the Side bar 에러 
LIMIT 3

SELECT * 
FROM test1

SELECT * 
FROM test2

SELECT * 
FROM test1
	JOIN test2
    
    
## SQL INTERMEDIATE 

## ADVANCED SELECT : NEW COMPANIES 
-- company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees. 
-- Order your output by ascending company_code.
-- First SUBMIT
SELECT c.company_code
		, c.founder
        , COUNT(DISTINCT l.lead_manager_code) as LM
        , COUNT(DISTINCT s.senior_manager_code) as SM
		, COUNT(DISTINCT m.manager_code) as M
        , COUNT(DISTINCT e.employee_code) as E
FROM Company c, Lead_Manager l, Senior_Manager s, Manager m, Employee e				
WHERE c.company_code = l.company_code
	AND l.lead_manager_code = s.lead_manager_code
	AND s.senior_manager_code =m.senior_manager_code
    AND m.manager_code = e.manager_code
GROUP BY 1,2												-- 3,4,5,6  AGG함수 안쓴 필드 
ORDER BY company_code asc

-- NEAT Answer by Somebody! ! ! 
SELECT c.company_code
		, c.founder
        , COUNT(DISTINCT e.lead_manager_code) as LM
        , COUNT(DISTINCT e.senior_manager_code) as SM
		, COUNT(DISTINCT e.manager_code) as M
        , COUNT(DISTINCT e.employee_code) as E
FROM Company c, Employee e				
WHERE c.company_code = e.company_code
GROUP BY 1 
ORDER BY company_code asc


## Basic Join
-- hacker_id, name, and the total number of challenges created by each student. 
-- (1) Sort your results by the total number of challenges in descending order. 
-- (2) If more than one student created the same number of challenges, then sort the result by hacker_id. 
-- (3) If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result.
WITH c1 AS (SELECT hacker_id, COUNT(DISTINCT challenge_id) cnt FROM Challenges GROUP BY 1)
SELECT h.hacker_id, h.name, c1.cnt
FROM Hackers h, c1
GROUP BY 1,2
HAVING c1.cnt = (
				SELECT MAX(cnt)
                FROM c1
                GROUP BY hacker_id
                )
		OR cnt = (
				SELECT hacker_id 
                FROM c1
				GROUP BY cnt
                HAVING COUNT(DISTINCT hacker_id) =1
                )
LEFT JOIN
	SELECT c2.CNT
    FROM
    	(SELECT c.hacker_id, count(distinct c.challenge_id)  as CNT
		FROM Challenges c 
		GROUP BY 1
	) c2
    GROUP BY c2.CNT
    HAVING COUNT(c2.hacker_id) = 1 OR c2.CNT=MAX(c2.CNT)
	WHERE 
                
SELECT h.hacker_id
		, h.name
		, COUNT(DISTINCT c.challenge_id) as cnt
 FROM Hackers h, Challenges c
 WHERE h.hacker_id = c.hacker_id
 
	AND c.hacker_id in 								
		( 
        SELECT  hacker_id
			FROM Challenges
            GROUP BY hacker_id
            HAVING COUNT(DISTINCT challenge_id) = MAX(COUNT(DISTINCT challenge_id))
				OR COUNT(DISTINCT challenge_id)
				
            )
 GROUP BY 1,2
 ORDER BY  cnt DESC, hacker_id ASC 							-- (1)
 

	