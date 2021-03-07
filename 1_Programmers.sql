## MIN MAX SUM COUNT
-- ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. 
-- ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
NAME	TYPE	NULLABLE
ANIMAL_ID	VARCHAR(N)	FALSE
ANIMAL_TYPE	VARCHAR(N)	FALSE
DATETIME	DATETIME	FALSE
INTAKE_CONDITION	VARCHAR(N)	FALSE
NAME	VARCHAR(N)	TRUE
SEX_UPON_INTAKE	VARCHAR(N)	FALSE

예시	예를 들어 ANIMAL_INS 테이블이 다음과 같다면
		ANIMAL_ID	ANIMAL_TYPE	DATETIME	INTAKE_CONDITION	NAME	SEX_UPON_INTAKE
		A399552	Dog	2013-10-14 15:38:00	Normal	Jack	Neutered Male
		A379998	Dog	2013-10-23 11:42:00	Normal	Disciple	Intact Male
		A370852	Dog	2013-11-03 15:04:00	Normal	Katie	Spayed Female
		A403564	Dog	2013-11-18 17:03:00	Normal	Anna	Spayed Female
		가장 늦게 들어온 동물은 Anna이고, Anna는 2013-11-18 17:03:00에 들어왔습니다. 따라서 SQL문을 실행하면 다음과 같이 나와야 합니다.
시간 
2013-11-18 17:03:00 ※ 컬럼 이름(위 예제에서는 "시간")은 일치하지 않아도 됩니다.

-- Q1. 가장 최근에 들어온 동물은 언제 들어왔는지 조회하는 SQL 문을 작성해주세요.
A. SELECT MAX(DATETIME) AS 시간
	FROM ANIMAL_INS

-- Q2. 동물 보호소에 가장 먼저 들어온 동물은 언제 들어왔는지 조회하는 SQL 문을 작성해주세요.
A. SELECT MIN(DATETIME) AS 시간
	FROM ANIMAL_INS
    
-- Q3. 동물 보호소에 동물이 몇 마리 들어왔는지 조회하는 SQL 문을 작성해주세요.
A. SELECT COUNT(DISTINCT ANIMAL_ID)
	FROM ANIMAL_INS

-- Q4. 동물 보호소에 들어온 동물의 이름은 몇 개인지 조회하는 SQL 문을 작성해주세요. 이때 이름이 NULL인 경우는 집계하지 않으며 중복되는 이름은 하나로 칩니다.
A. SELECT COUNT(DISTINCT NAME)
	FROM ANIMAL_INS
    WHERE NAME IS NOT NULL
    
-- Q4. 동물 보호소에 들어온 동물 중 고양이와 개가 각각 몇 마리인지 조회하는 SQL문을 작성해주세요. 이때 고양이를 개보다 먼저 조회해주세요.
A. SELECT ANIMAL_TYPE
		, COUNT(DISTINCT ANIMAL_ID)
	FROM ANIMAL_INS
    GROUP BY 1
    ORDER BY ANIMAL_TYPE
    
-- Q5. 동물 보호소에 들어온 동물 이름 중 두 번 이상 쓰인 이름과 해당 이름이 쓰인 횟수를 조회하는 SQL문을 작성해주세요. 
-- 		이때 결과는 이름이 없는 동물은 집계에서 제외하며, 결과는 이름 순으로 조회해주세요.
SELECT *
FROM 
	(SELECT NAME, 
			COUNT(NAME) AS COUNT		-- DISTINCT 쓰지 않는다
	FROM ANIMAL_INS
	WHERE NAME IS NOT NULL 
	GROUP BY 1
	ORDER BY NAME
	) AS CNT
WHERE COUNT >=2 

-- Q6. 보호소에서는 몇 시에 입양이 가장 활발하게 일어나는지 알아보려 합니다. 
-- 09:00부터 19:59까지, 각 시간대별로 입양이 몇 건이나 발생했는지 조회하는 SQL문을 작성해주세요. 이때 결과는 시간대 순으로 정렬해야 합니다.
SELECT HOUR(DATETIME) AS HOUR
			, COUNT(ANIMAL_ID) AS COUNT
FROM ANIMAL_OUTS
WHERE HOUR(DATETIME) BETWEEN '9' AND '20'       -- 9-19까지 결과만 추출
GROUP BY 1
ORDER BY HOUR

-- Q7. 보호소에서는 몇 시에 입양이 가장 활발하게 일어나는지 알아보려 합니다. 
-- 0시부터 23시까지, 각 시간대별로 입양이 몇 건이나 발생했는지 조회하는 SQL문을 작성해주세요. 이때 결과는 시간대 순으로 정렬해야 합니다.

## 로컬 변수 선언 초기값 설정 : @변수 프로시저가 종료되어도 유지됨
## 대입연산자 :=
SET @HOUR := -1 ;

SELECT (@HOUR := @HOUR+1) HOUR	 					-- @HOUR 값에 1씩 증가시키면서 SELECT 문 전체 실행 >> 0부터 
		, (
			SELECT 
				COUNT(ANIMAL_ID)
			FROM ANIMAL_OUTS
			WHERE HOUR(DATETIME) = @HOUR
			) AS COUNT
FROM ANIMAL_OUTS
WHERE @HOUR <23										-- @HOUR이<23까지 >> (@HOUR+1 이 23이 될 때까지) @HOUR값이 +1씩 증가


## IS NULL
-- Q8. 동물 보호소에 들어온 동물 중, 이름이 없는 채로 들어온 동물의 ID를 조회하는 SQL 문을 작성해주세요. 단, ID는 오름차순 정렬되어야 합니다.
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NULL
ORDER BY ANIMAL_ID

-- Q9. 동물 보호소에 들어온 동물 중, 이름이 있는 동물의 ID를 조회하는 SQL 문을 작성해주세요. 단, ID는 오름차순 정렬되어야 합니다.
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
ORDER BY ANIMAL_ID				-- DEFAULT: 오름차순

-- Q10. 입양 게시판에 동물 정보를 게시하려 합니다. 동물의 생물 종, 이름, 성별 및 중성화 여부를 아이디 순으로 조회하는 SQL문을 작성해주세요. 
-- 이때 프로그래밍을 모르는 사람들은 NULL이라는 기호를 모르기 때문에, 이름이 없는 동물의 이름은 "No name"으로 표시해 주세요.
SELECT ANIMAL_TYPE
	, IF(NAME IS NULL, "No name", NAME) AS NAME
    , SEX_UPON_INTAKE
FROM ANIMAL_INS
ORDER BY ANIMAL_ID


## JOIN
-- Q11.천재지변으로 인해 일부 데이터가 유실되었습니다. 입양을 간 기록은 있는데, 보호소에 들어온 기록이 없는 동물의 ID와 이름을 ID 순으로 조회하는 SQL문을 작성해주세요.
SELECT O.ANIMAL_ID
	, O.NAME
FROM ANIMAL_OUTS O
WHERE O.ANIMAL_ID NOT IN 
						( SELECT DISTINCT ANIMAL_ID
							FROM ANIMAL_INS )

-- Q12. 관리자의 실수로 일부 동물의 입양일이 잘못 입력되었습니다. 
-- 보호 시작일보다 입양일이 더 빠른 동물의 아이디와 이름을 조회하는 SQL문을 작성해주세요. 
-- 이때 결과는 보호 시작일이 빠른 순으로 조회해야합니다.

-- SOL 1)
SELECT O.ANIMAL_ID AS ANIMAL_ID, O.NAME AS NAME
FROM ANIMAL_OUTS O 
	LEFT JOIN ANIMAL_INS I
	ON O.ANIMAL_ID = I.ANIMAL_ID
WHERE O.DATETIME < I.DATETIME
ORDER BY I.DATETIME

-- SOL 2)
-- EQUI JOIN 등가 조인 = INNER JOIN 
-- EQUI(등가) JOIN은 두 개의 테이블 간에 컬럼 값들이 서로 정확하게 일치하는 경우에 사용되는 방법으로 대부분 PK- FK의 관계를 기반으로 합니다.
-- FROM 절에 JOIN할 테이블들
-- WHERE 절에 JOIN 조건 넣기
SELECT I.ANIMAL_ID, I.NAME
FROM ANIMAL_INS I, ANIMAL_OUTS O  -- 
WHERE I.ANIMAL_ID = O.ANIMAL_ID 
	AND I.DATETIME > O.DATETIME
ORDER BY I.DATETIME


-- Q13.
-- 아직 입양을 못 간 동물 중, 가장 오래 보호소에 있었던 동물 3마리의 이름과 보호 시작일을 조회하는 SQL문을 작성해주세요. 
-- 결과는 보호 시작일 순으로 조회해야 합니다.
-- JOIN 문제 불때 1번으로 할 것: 기준이 될 테이블 문제상황보고 판단 하기
SELECT I.NAME 			
	, I.DATETIME
FROM ANIMAL_INS I		## 입양을 가지 못한 동물 > ANIMAL_INS 테이블을 기준으로 LEFT JOIN
	LEFT JOIN ANIMAL_OUTS O
	ON O.ANIMAL_ID = I.ANIMAL_ID
WHERE O.DATETIME IS NULL
ORDER BY DATETIME ASC

-- Q14.
-- 보호소에서 중성화 수술을 거친 동물 정보를 알아보려 합니다. 
-- 보호소에 들어올 당시에는 중성화1되지 않았지만, 
-- 보호소를 나갈 당시에는 중성화된 동물의 아이디와 생물 종, 이름을 조회하는 아이디 순으로 조회하는 SQL 문을 작성해주세요.
SELECT I.ANIMAL_ID
        , I.ANIMAL_TYPE
        , I.NAME
FROM ANIMAL_INS I, ANIMAL_OUTS O
WHERE I.ANIMAL_ID = O.ANIMAL_ID
	AND I.SEX_UPON_INTAKE LIKE '%Intact%'
    AND (O.SEX_UPON_OUTCOME LIKE '%Spayed%'		-- IN LIKE 같이 쓸 수 없음
			OR O.SEX_UPON_OUTCOME LIKE '%Neutered%'
		)
        
-- Q15. 
-- 동물 보호소에 들어온 동물 중 이름이 Lucy, Ella, Pickle, Rogan, Sabrina, Mitty인 동물의 아이디와 이름, 성별 및 중성화 여부를 조회하는 SQL 문을 작성해주세요.  
-- 이때 결과는 아이디 순으로 조회해주세요.
-- 조회 정렬 순서 조건 잊지말기 
SELECT ANIMAL_ID
		, NAME
        , SEX_UPON_INTAKE
FROM ANIMAL_INS 
WHERE NAME IN ( 'Lucy', 'Ella', 'Pickle', 'Rogan', 'Sabrina', 'Mitty')
ORDER BY ANIMAL_ID

-- Q16. 
-- 보호소에 돌아가신 할머니가 기르던 개를 찾는 사람이 찾아왔습니다. 
-- 이 사람이 말하길 할머니가 기르던 개는 이름에 'el'이 들어간다고 합니다. 
-- 동물 보호소에 들어온 동물 이름 중, 이름에 "EL"이 들어가는 개의 아이디와 이름을 조회하는 SQL문을 작성해주세요. 
-- 이때 결과는 이름 순으로 조회해주세요. 단, 이름의 대소문자는 구분하지 않습니다.

-- sol1 ) like 구문
SELECT ANIMAL_ID
	, NAME
FROM ANIMAL_INS
WHERE ANIMAL_TYPE = 'Dog' AND NAME LIKE '%el%'  			-- MYSQL은 LIKE 로 검사시 대소문자 구분을 하지 않습니다.
ORDER BY NAME

-- sol2 ) regexp
SELECT ANIMAL_ID
	, NAME
FROM ANIMAL_INS
WHERE ANIMAL_TYPE = 'Dog'
	AND REGEXP_LIKE (name,'El|el')   
ORDER BY NAME


-- Q17. 
-- 보호소의 동물이 중성화되었는지 아닌지 파악하려 합니다. 중성화된 동물은 SEX_UPON_INTAKE 컬럼에 'Neutered' 또는 'Spayed'라는 단어가 들어있습니다. 
-- 동물의 아이디와 이름, 중성화 여부를 아이디 순으로 조회하는 SQL문을 작성해주세요. 이때 중성화가 되어있다면 'O', 아니라면 'X'라고 표시해주세요.
-- sol1 ) like 구문
SELECT ANIMAL_ID
	, NAME
    , IF( SEX_UPON_INTAKE LIKE '%NEUTERED%' OR SEX_UPON_INTAKE LIKE '%Spayed%', 'O','X') AS 중성화
FROM ANIMAL_INS
ORDER BY ANIMAL_ID

-- sol2) regexp
SELECT  ANIMAL_ID,
        NAME,
        IF(SEX_UPON_INTAKE REGEXP 'Neutered|Spayed', 'O' , 'X') AS 중성화
FROM    ANIMAL_INS
ORDER BY ANIMAL_ID

-- Q18. 
-- 입양을 간 동물 중, 보호 기간이 가장 길었던 동물 두 마리의 아이디와 이름을 조회하는 SQL문을 작성해주세요. 
-- 이때 결과는 보호 기간이 긴 순으로 조회해야 합니다.
-- SOL 1)
SELECT O.ANIMAL_ID
	, O.NAME
FROM ANIMAL_OUTS O, ANIMAL_INS I
WHERE O.ANIMAL_ID = I.ANIMAL_ID
ORDER BY DATEDIFF(O.DATETIME, I.DATETIME) DESC 		## ORDER BY 에 수식 넣기  DATEDIFF(A,B) A가 더 최신이면 양수 
LIMIT 2

-- SOL2)
SELECT O.ANIMAL_ID
	, O.NAME
FROM ANIMAL_OUTS O, ANIMAL_INS I
WHERE O.ANIMAL_ID = I.ANIMAL_ID
ORDER BY O.DATETIME -  I.DATETIME DESC 	
LIMIT 2

-- Q19. 
-- ANIMAL_INS 테이블에 등록된 모든 레코드에 대해, 각 동물의 아이디와 이름, 들어온 날짜1를 조회하는 SQL문을 작성해주세요. 
-- 이때 결과는 아이디 순으로 조회해야 합니다.
SELECT ANIMAL_ID
	, NAME
    , DATE_FORMAT(DATETIME, '%Y-%m-%d')	AS 날짜 			## DATE_FORMAT함수
FROM ANIMAL_INS
ORDER BY ANIMAL_ID ASC

## SELECT 문
-- 여러 기준으로 정렬하기
SELECT ANIMAL_ID
    , NAME
    , DATETIME
FROM ANIMAL_INS
ORDER BY NAME ASC, DATETIME DESC 					## 변수별로 정렬 조건 다르게 

-- 동물 보호소에 가장 먼저 들어온 동물의 이름을 조회하는 SQL 문을 작성해주세요.
SELECT NAME
FROM ANIMAL_INS
ORDER BY DATETIME ASC 								## 시간 ASC 오래된 것 부터 최신 것 까지
LIMIT 1


