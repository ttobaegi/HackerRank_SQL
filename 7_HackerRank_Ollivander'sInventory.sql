/*
1. minimum number of gold galleons to buy non-evil
2. id age coins_needed power
3. order by power DESC
4. same power order by age DESC
*/

# MY SOLUTION
set sql_mode='';
select a.id, b.age, b.coins_needed, a.power
from Wands a
inner join (
        select w.code, p.age, w.power, min(w.coins_needed) as coins_needed
        from Wands w 
        inner join Wands_Property p where w.code=p.code and p.is_evil = 0
            -- inner join시, where 절 키 조건과 조인할 테이블 추출 조건 함께 
        group by 1,2,3
    ) b
    on a.code= b.code
    and a.coins_needed=b.coins_needed			-- **** coins_needed 일치하는 것만 조회
    and a.power=b.power
order by 4 desc, 2 desc 

# SOLUTIONS BY OTHERS
select id,age,coins_needed,power   
from (
	select id,age,coins_needed,power
		, min(coins_needed) over (partition by w.code,age,power) as min_coins from wands w 
									-- window 함수 사용 
                                    -- group by로 대체해도 됨 전체에 한번만 적용하니까
	inner join wands_property wp on w.code = wp.code 
	where wp.is_evil =0
	) 
where coins_needed = min_coins 
order by power desc, age desc;
