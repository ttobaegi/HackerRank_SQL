/*
1. hacker_id name total_score
2. score DESC hacker_id ASC
3. exclude total_score = 0
*/

# MY SOLUTION
select h.hacker_id, name, sum(a.max) total_score
from  Hackers h
left join ( 
		select hacker_id, challenge_id, max(score) max from Submissions s group by 1,2
        ) a
on a.hacker_id = h.hacker_id 
group by 1,2
having sum(a.max) != 0
order by 3 DESC, 1 ASC;

-- 왜.. WITH 구문이 안될까?

#SOLUTIONS BY OTHERS
