--ex1
select a.continent, floor(avg(b.population))
from country as a
inner join city as b
on a.code=b.countrycode
group by a.continent
  
--ex2
select round(((count(b.email_id)/count(a.email_id))*100),2) as confirm_rate 
from emails as a
left join texts as b
on a.email_id = b.email_id
and b.signup_action = 'Confirmed'
-- Câu hỏi: Câu lệnh trên ra kết quả bằng 0, nhưng khi em đếm và tách thành 2 cột thì vẫn ra 1 cột bằng 2, 1 cột bằng 6 ạ
select count(b.email_id), count(DISTINCT a.email_id)
from emails as a
left join texts as b
on a.email_id = b.email_id
and b.signup_action = 'Confirmed'

--ex3
--Cần tính time opening, time sending, total time
--tính riêng lẻ:
    --total time
SELECT sum(act.time_spent)
from activities as act 
left join age_breakdown as age
on act.user_id=age.user_id
group by age.age_bucket

  --Opening time
SELECT sum(act.time_spent)
from activities as act 
left join age_breakdown as age
on act.user_id=age.user_id
where activity_type =  'open'
group by age.age_bucket

--ex4
select cus.customer_id
from customer_contracts as cus
left join products as prd
on cus.product_id=prd.product_id
where prd.product_category = 'Analytics'and
prd.product_category = 'Containers'and
prd.product_category = 'Compute'
group by cus.customer_id
order by cus.customer_id

--không ra kết quả, tại sao lại sai

