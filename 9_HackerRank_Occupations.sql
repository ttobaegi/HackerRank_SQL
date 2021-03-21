/*
## OCCUPATIONS
1. PIVOT the Occupation column in Occupations
    : Output headers = Occupation
2. Order by Name ASC
*/

-- PIVOT 
-- 결과 행 null값 없애기  
SET @r1=0, @r2=0, @r3=0, @r4=0;
select Min(Doctor), Min(Professor), Min(Singer), Min(Actor)
from (
select 
    case when Occupation = 'Doctor' then (@r1:=@r1+1)
        when Occupation = 'Professor' then (@r2:=@r2+1)
        when Occupation = 'Singer' then (@r3:=@r3+1)
        when Occupation = 'Actor' then (@r4:=@r4+1)    END AS rn
    , case when Occupation = 'Doctor' then Name END AS Doctor
    , case when Occupation = 'Professor' then Name END AS Professor
    , case when Occupation = 'Singer' then Name END AS Singer
    , case when Occupation = 'Actor' then Name END AS Actor
    from OCCUPATIONS
    order by Name
) a
group by rn ;

# LERANINGS
-- ROW NUM 활용하기 
select e.*, (@rownum := @rownum + 1)
 from emp e, (select @rownum := 0) rn;  -- 행번호 

# EXTENSION !
-- 급여 800 기준으로 두개의 그룹으로 나누어 사원 리스트 작성하기
select * from emp;

-- (1) 그룹 컬럼(higher lower) 생성 
select 
		case when salary >= 800 then ename END AS higher
		, case when salary < 800 then ename END AS lower
from emp;

-- (2) row number 변수 활용하여 row number 칼럼 생성 
SET @r1=0, @r2=0;
select case when salary >= 800 then (@r1:=@r1+1) 
		when salary< 800 then (@r2:=@r2+1)
        end as rn
		,case when salary >= 800 then ename END AS higher
		, case when salary < 800 then ename END AS lower
from emp;

-- (3) row number 변수 활용하여 row number 칼럼 생성 
SET @r1=0, @r2=0;

select min(higher), min(lower) 			
	-- AGG 함수 안쓰면 에러 발생 
    -- 원인 : GROUP BY rn 
from 
(
select case when salary >= 800 then (@r1:=@r1+1) 
		when salary< 800 then (@r2:=@r2+1)
        end as rn
		,case when salary >= 800 then ename END AS higher
		, case when salary < 800 then ename END AS lower
from emp
order by ename
) a
group by rn ;
		