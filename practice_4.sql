--ex1
SELECT
sum(case 
when device_type = 'laptop' then 1
else 0
end) as laptop_reviews,

sum(case 
when device_type = 'tablet' then 1
when device_type = 'phone' then 1
else 0
end) as mobile_views
FROM viewership

--ex2
select x,y,z,
case 
when (x+y)>z and (y+z)>x and (x+z)>y
and x>0 and  y>0 and z>0 then 'Yes'
else 'No'
end as triangle
 from triangle

--ex3 A ơi BT 3 này có bị lỗi k ạ, em select * k ra bảng mà count như dưới thì bằng 0

  SELECT
count (case_id) 
from callers
where call_category = 'n/a' or call_category is null

--ex4
select name from customer
where referee_id <>2 or referee_id is null

--ex5
--cach 1
select
case 
when pclass = 1 then 'first_class'
when pclass = 2 then 'second_class'
when pclass = 3 then 'third_class'
end as category,

sum(case 
when survived = 0 then 1
else 0
end) as non_survivors,

sum(case 
when survived = 1 then 1
else 0
end) as survivors
from titanic
group by category

cach 2
select survived,
sum(case 
when pclass=1 then 1
else 0
end) as first_class,

sum(case 
when pclass=2 then 1
else 0
end) as second_class,

sum(case 
when pclass=3 then 1
else 0
end) as third_class
from titanic
group by survived
