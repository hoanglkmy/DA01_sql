--ex1: Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.
select extract(year from transaction_date) as year,
product_id, spend as curr_year_spend,
lag(spend) over (partition by product_id 
order by extract(year from transaction_date)) as prev_year_spend,
round(100*(spend-lag(spend) over (partition by product_id 
order by extract(year from transaction_date)))/lag(spend) over (partition by product_id 
order by extract(year from transaction_date)),2) as yoy_rate
from user_transactions
  
--ex2: Write a query that outputs the name of the credit card, and how many cards were issued in its launch month
select  card_name, issued_amount from 
(select card_name, issue_month,	issue_year, issued_amount,
row_number() over(partition by card_name order by issue_year, issue_month)
as rank
from monthly_cards_issued) as T
where T.rank = 1
order by  issued_amount DESC

--ex3 the third transaction of every user
select user_id, spend, transaction_date from 
(select *, row_number() over (PARTITION BY user_id order by transaction_date)
as rank
from transactions) as T
where T.rank=3

--ex4
select  transaction_date, user_id, purchase_count from
(select user_id, transaction_date,
count(product_id) over(PARTITION BY user_id order by transaction_date DESC) as purchase_count,
row_number() over(PARTITION BY user_id order by transaction_date DESC) as rank
from user_transactions) as T
where T.rank=1
order by  transaction_date

--ex5
select user_id, tweet_date, 
(tweet_count+second_count+third_count)/3 as rolling_avg_3d
from
(select *, 
lead(second_day) over(partition by user_id order by tweet_date) as third_day,
lead(second_count) over(partition by user_id order by tweet_date) as third_count
from 
(select user_id, tweet_date, tweet_count, 
lead(tweet_date) over(partition by user_id order by tweet_date) as second_day,
lead(tweet_count) over(partition by user_id order by tweet_date) as second_count
from tweets) as second) as third

  --Caau hỏi: Em chưa hiểu đề bài này lắm ạ, em tưởng là tính TB của 3 ngày nhưng mà so với example output thì không phải ạ
--ex6
select count(*) from 
(select transaction_id from 
(select *, 
lag(credit_card_id) over(PARTITION BY merchant_id, credit_card_id order by merchant_id) as pre_credit_card,
lag(amount) over(PARTITION BY merchant_id, credit_card_id order by merchant_id) as pre_amount,
lag(transaction_timestamp) over(PARTITION BY merchant_id, credit_card_id order by merchant_id) as pre_time
from transactions) as T
where T.pre_credit_card - T.credit_card_id = 0   and 
	T.pre_amount- T.amount=0  and date(T.pre_time) = date(T.transaction_timestamp) AND
	 (abs((extract(hour from T.pre_time)*60+extract(minute from pre_time)) - (extract(hour from transaction_timestamp)*60+extract(minute from transaction_timestamp))) <= 10)) as M 


--ex7
  --Cách 1
with appliance as (
select category, product, sum(spend) as total_spend from product_spend
where category = 'appliance' and extract(year from transaction_date)  = 2022
group by product, category
order by total_spend DESC
limit 2),
electronics as (
select category, product, sum(spend) as total_spend from product_spend
where category = 'electronics' and extract(year from transaction_date)  = 2022
group by product, category
order by total_spend DESC
limit 2)

select * from appliance
UNION ALL
select * from electronics

  --Cách 2 Window Function
select category, product, total from 
(select category, product, total, 
dense_rank() over (partition by category order by total DESC) as rank
from
(select category, product,
sum(spend) as total from product_spend
where extract(year from transaction_date) = '2022'
group by  category, product) as M
) as T
where T.rank in ('1', '2')

--ex8
with cte AS
(select a.artist_id, a.artist_name, b.song_id, c.rank
from artists as a
join songs as b on a.artist_id=b.artist_id
join global_song_rank as c on c.song_id=b.song_id),

cte2 as (select artist_name, 
count(*) as count
from cte
where rank <=10
group by artist_name),

cte3 as(select artist_name,
dense_rank() over (order by cte2.count DESC) as artist_rank
from cte2)
select * from cte3
where artist_rank <=5
