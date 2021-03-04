
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


	