1. hacker_id | name | total # challenges by each student
2. order by #total DESC, hacker_id ASC
3. #total 같은 hacker_id존재 & #total < max(#total) :: EXCLUDE them

1. COUNT TOTAL  : Challenges group by hacker_id 별 #total, MAX(#total)  파악
3. count >=2 중 MAX(#total) 아닌것 제외
4. order by 
;
/**
create table challenges(challenge_id integer, hacker_id integer);

insert into challenges values(61654, 5077);
insert into challenges values(58302, 21283);
insert into challenges values(40587, 88255);
insert into challenges values(29477, 5077);
insert into challenges values(1220, 21283);
insert into challenges values(69514, 21283);
insert into challenges values(46561, 62743);
insert into challenges values(58077, 62743);
insert into challenges values(18483, 88255);
insert into challenges values(76766, 21283);
insert into challenges values(52382, 5077);
insert into challenges values(74467, 21283);
insert into challenges values(33625, 96196);
insert into challenges values(26053, 88255);
insert into challenges values(42665, 62743);
insert into challenges values(12859, 62743);
insert into challenges values(70094, 21283);
insert into challenges values(34599, 88255);
insert into challenges values(54680, 88255);
insert into challenges values(61881, 5077);

create table hackers(hacker_id integer, name varchar(50));
INSERT INTO `hackers` (`hacker_id`,`name`) VALUES (5077,'Rose');
INSERT INTO `hackers` (`hacker_id`,`name`) VALUES (21283,'Angela');
INSERT INTO `hackers` (`hacker_id`,`name`) VALUES (62743,'Frank');
INSERT INTO `hackers` (`hacker_id`,`name`) VALUES (88255,'Patrick');
INSERT INTO `hackers` (`hacker_id`,`name`) VALUES (96196,'Lisa');
**/

-- hacker_id | total |
select * from hackers;
select * from challenges;
with a as 
(
select hacker_id, count(challenge_id) as total
from Challenges
group by hacker_id
),
b as (
select total, count(hacker_id) as cnt
from a
group by total
),
c as
(
select total as max from b order by 1 desc limit 1
)
-- , d as (
select * from a,b where b.cnt = 1
union 
select a.* from a,b,c where cnt !=1 and cnt = c.max 
-- )
select d.hacker_id, name, total
from d 
left join hackers h 
on d.hacker_id = h.hacker_id
order by 3 desc, 1 asc ; 