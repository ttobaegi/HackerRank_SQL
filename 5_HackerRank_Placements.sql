/*
1. name of those students 
2. whose best firends got offered a higher salary than them
3. order by salary amount offered to the friends 
    : Descending 조건 없을 경우 디폴트인 ASC로 
4. no two students got same salary
*/

# MY SOLUTION 
with a as (
select f.ID, p.Salary mine, Friend_ID
from Friends f left join Packages p on f.id=p.id 
),
b as (
    select a.*, p.Salary friends from a left join Packages p on a.Friend_ID = p.id
)
select Name from b left join Students on Students.ID = b.ID
where mine < friends
order by friends ASC


# SOLUTIONS BY OTHER USERS
-- INNER JOIN * 3
select name
from students s 
inner join friends f on s.id=f.id           -- FRIENDS LIST
inner join packages p on p.id=s.id          -- SALARY 1 p.salary
inner join packages p1 on p1.id=f.friend_id -- SALARY 2 p1.salary
where (p1.salary-p.salary)>0                -- SALARY 1 < SALARY 2
order by p1.salary;                         -- ordar by SALARY 2