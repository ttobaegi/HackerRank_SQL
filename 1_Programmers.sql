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
FROM ANIAL_OUTS O
RIGHT JOIN  AANIMAL_INS I
    ON O.ANIMAL_ID = I.ANIMAL_ID
WHERE 

