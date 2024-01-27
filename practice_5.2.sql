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
--Câu lệnh trên ra kết quả bằng 0, nhưng khi em đếm và tách thành 2 cột thì vẫn ra 1 cột bằng 2, 1 cột bằng 6 ạ
--Lý do:  dividing an integer with another integer would sometimes result in '0'=> chuyển kiểu dữ liệu: Cast
--Sửa

select round((cast(count(b.email_id) as dec))/count(a.email_id),2) 
as confirm_rate
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

  --Câu hỏi: em đang không biết làm thế nào để gộp thành phép chia vì nếu tính các tử số sẽ phải 
  có thêm điều kiện where ạ còn mẫu số thì không cần ạ

--ex4
select cus.customer_id
from customer_contracts as cus
left join products as prd
on cus.product_id=prd.product_id
group by cus.customer_id, prd.product_category
having count(distinct prd.product_category)=3
order by cus.customer_id

--Câu hỏi: em làm như trên không ra kết quả, tại sao lại sai ạ


--ex5
/*report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.*/
select ma.employee_id, ma.name, count(emp.employee_id) as reports_count, 
round(avg(emp.age),0) as average_age
from Employees as emp
right join employees as ma
on emp.reports_to=ma.employee_id
where emp.reports_to is not null
group by ma.employee_id, ma.name
order by ma.employee_id

--ex6
select a.product_name, sum(b.unit) as unit
from products as a
left join orders as b
on a.product_id=b.product_id
where b.order_date between '2020-02-01' and '2020-02-29'
group by a.product_name
having  sum(b.unit) >= 100
  
--ex7
SELECT a.page_id
FROM pages as a
left join page_likes as b
on a.page_id=b.page_id
where b.user_id is null
order by a.page_id

