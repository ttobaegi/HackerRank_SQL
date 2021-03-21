/*
TOP COMPETITORS 
MEDIUM LEVEL
BASIC JOIN
1. hacker_id, name
2. achieved full scores for more than one challenge
3. order by total number of challenges(full score) DESC
4. more than 1 hacker received full in the same number of challenges 
    : order by hacker_id ASC
*/

# MY SOLUTION
-- INNER JOIN & SUB QUERIES
SET sql_mode = '';  

select b.hacker_id, name
from (
    select s.challenge_id, s.hacker_id
    from Submissions s
    inner join 
    (
        select distinct challenge_id, score as full
        from Challenges c left join Difficulty d on c.difficulty_level = d.difficulty_level
    ) a
        on s.challenge_id=a.challenge_id and s.score = a.full
) b
inner join Hackers h on b.hacker_id=h.hacker_id 
group by 1
having count(challenge_id)>1
order by count(challenge_id) desc, hacker_id ASC

# SOLUTIONS BY OTHER USERS
-- 서브쿼리는 최대한 쓰지 말자. 쿼리는 최대한 간단하게.
-- INNER JOIN 
select h.hacker_id, h.name
from submissions s
	inner join challenges c on s.challenge_id = c.challenge_id
	inner join difficulty d on c.difficulty_level = d.difficulty_level 
	inner join hackers h on s.hacker_id = h.hacker_id
where s.score = d.score and c.difficulty_level = d.difficulty_level 
group by h.hacker_id, h.name
having count(s.hacker_id) > 1
order by count(s.hacker_id) desc, s.hacker_id asc