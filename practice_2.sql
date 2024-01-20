--ex1
select distinct city from station
where ID mod 2 = 0
--hoặc
select distinct city from station
where ID % 2 = 0

--ex2
select count(city)-count(distinct city)
from station

--ex3
select 
ceiling(avg(salary)-avg(replace(salary, '0', '')))
from employees

--ex4
/*Bước 1: phân tích yêu cầu
- output: gốc hay phái sinh: mean=tổng items/số đơn hàng
- input
- Điều kiện lọc theo trường nào: gốc hay phái sinh
Bổ sung: Cast (Non_Updated as decimal) -> để chuyển đổi kiểu thành số thập phân*/
  
select round(cast(sum(order_occurrences*item_count)/sum(order_occurrences)
as decimal),1) as mean from items_per_order

--ex5
Select distinct candidate_id from candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having count(skill)=3
order by candidate_id

--ex6
select user_id, 
max(date(post_date))-min(date(post_date)) as day_between from posts
where Date(post_date) between '2021-01-01' and '2021-12-31'
group by user_id
having count(user_id)>=2 

--ex7
select card_name, 
max(issued_amount)-min(issued_amount) as difference from monthly_cards_issued
group by card_name
order by max(issued_amount)-min(issued_amount) DESC

--ex8
select manufacturer,
count (drug),
sum(cogs-total_sales) as losses from pharmacy_sales
where cogs-total_sales >0
group by manufacturer
order by sum(cogs-total_sales) DESC

--ex9
select * from cinema
where id%2  <> 0 and description <> 'boring'
order by rating DESC

--ex10
select teacher_id,
count(distinct subject_id) as cnt from teacher
group by teacher_id

--ex11
select user_id,
count (follower_id) as followers_count from followers
group by user_id
order by user_id

--ex12
select class from courses
group by class
having count(student)>=5
