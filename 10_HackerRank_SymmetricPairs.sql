/*
1. ALL Symmetric Pairs
2. order by the value of X ASC
3. X<=Y
*/

select row_number () over() index
        , X 
FROM Functions 
where X in (select Y from Functions)