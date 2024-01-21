--ex1
select name
from students
where marks>75
order by right(name,3) , ID ASC

--Tai sao khong khi dung nhu sau lai sai: order by right(name,3) and ID ASC
  
--ex2
select user_id,
Upper(left(name,1))||Lower(right(name,length(name)-1)) as name
from users
order by user_id
  
--ex3
select manufacturer,
'$'||round(sum(total_sales)/1000000,0)|| ' ' || 'million'
from pharmacy_sales
group by manufacturer
order by sum(total_sales) DESC , manufacturer ASC

--Round the answer to the nearest million: /1000000
  
--ex4
select 
extract(month from submit_date) as mth,
product_id as product,
round(avg(stars),2) as avg_stars
from reviews
group by product_id, extract(month from submit_date) 
order by extract(month from submit_date), product_id

--ex5
select sender_id,
count(content) as message_count
from messages
where sent_date between '2022-08-01' and '2022-09-01'
group by sender_id
order by count(content) DESC
limit 2

--ex6
select tweet_id
from Tweets
group by tweet_id, content
having length(content)>15

--Tai sao phai group by content nua
--ex7

--ex8

--ex9

--ex10
