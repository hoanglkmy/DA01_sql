--Tim Outliers
--Cach 1: Boxplot
with minmax as(
select Q1-1.5*IQR as Min,
Q3+1.5*IQR as Max
from (
select 
percentile_cont(0.25) within group (order by users) as Q1,
percentile_cont(0.75) within group (order by users) as Q3,
percentile_cont(0.75) within group (order by users) - percentile_cont(0.25) within group (order by users) as IQR
from user_data) as A)
select * from user_data
where users < (select Min from minmax) 
or users > (select max from minmax)

--Cach 2: Z-score
with cte as(
select data_date, users,
(select avg(users) from user_data) as avg,
(select stddev(users) from user_data) as stddev
from user_data)

select data_date, users,
(users - avg)/stddev as z_score from cte
where abs((users - avg)/stddev) >3

--Clean data Checklist:
--Tim du lieu bij trung lap

