-- TOTAL NUMBER OF UNIQUE HACKERS 
-- AT LEAST 1 SUBMISSION EACH DAY
-- MARCH 01-15, 2016

-- hacker_id name who made maximum number of submissions each day
-- 2명이상일 경우 lowest hacker_id를 추출
-- BY DATE


-- CREATE TABLE submissions (submission_date date, submission_id integer, hacker_id integer, score integer);
-- INSERT INTO submissions VALUES('2016-03-01',8494,20703,0);
-- INSERT INTO submissions VALUES('2016-03-01',22403,53473,15);
-- INSERT INTO submissions VALUES('2016-03-01',23965,79722,60);
-- INSERT INTO submissions VALUES('2016-03-01',30173,36396,70);
-- INSERT INTO submissions VALUES('2016-03-02',34928,20703,0);
-- INSERT INTO submissions VALUES('2016-03-02',38740,15758,60);
-- INSERT INTO submissions VALUES('2016-03-02',42769,79722,60);
-- INSERT INTO submissions VALUES('2016-03-02',44364,79722,60);
-- INSERT INTO submissions VALUES('2016-03-03',45440,20703,0);
-- INSERT INTO submissions VALUES('2016-03-03',49050,36396,70);
-- INSERT INTO submissions VALUES('2016-03-03',50273,79722,5);
-- INSERT INTO submissions VALUES('2016-03-04',50344,20703,0);
-- INSERT INTO submissions VALUES('2016-03-04',51360,44065,90);
-- INSERT INTO submissions VALUES('2016-03-04',54404,53473,65);
-- INSERT INTO submissions VALUES('2016-03-04',61533,79722,45);
-- INSERT INTO submissions VALUES('2016-03-05',72852,20703,0);
-- INSERT INTO submissions VALUES('2016-03-05',74546,38289,0);
-- INSERT INTO submissions VALUES('2016-03-05',76487,62529,0);
-- INSERT INTO submissions VALUES('2016-03-05',82439,36396,10);
-- INSERT INTO submissions VALUES('2016-03-05',9006,36396,40);
-- INSERT INTO submissions VALUES('2016-03-06',90404,20703,0);
-- CREATE TABLE hackers (hacker_id integer, name varchar(20));
-- INSERT INTO hackers VALUES(15758,'Rose');
-- INSERT INTO hackers VALUES(20703,'Angela');
-- INSERT INTO hackers VALUES(36396,'Frank');
-- INSERT INTO hackers VALUES(38289,'Patrick');
-- INSERT INTO hackers VALUES(44065,'Lisa');
-- INSERT INTO hackers VALUES(53473,'Kimberly');
-- INSERT INTO hackers VALUES(62529,'Bonnie');
-- INSERT INTO hackers VALUES(79722,'Michael');

select * from submissions
group by submission_date 
having count(hacker_id) >= 2;
WITH a as (
    select s.submission_date date
			, submission_id
            , s.hacker_id
            , h.name
    from Submissions s Left join Hackers h
    on s.hacker_id = h.hacker_id 
),
	b as (
    select date, hacker_id,
	case when count(submission_id) = 1 then 1 
		else count(submission_id) end  as max_submission
	from a
	group by 1,2
), 
 c as (select date
	, sum(max_submission)
    , case when count(hacker_id) > 1 then min(hacker_id) 
			else hacker_id end as hacker_id
	from b l
	group by 1
)
select c.* , h.name from c left join hackers h on c.hacker_id = h.hacker_id