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

--ex3

--ex4

--ex5

--ex6

--ex7

--ex8
