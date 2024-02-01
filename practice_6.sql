--ex1
with socv as(
select company_id, count(job_id) as duplicate from job_listings
group by title, company_id)
select count(company_id) from socv
where duplicate>=2

--ex2
with new as(
select category, product, sum(spend) as total from product_spend
where extract(year from transaction_date) = 2022
group by category, product
order by sum(spend) DESC)

select category, product, total from new
limit 4

  --Câu hỏi: anh ơi, bài này em đang bị mắc kẹt ở đoạn chọn ra 2 sản phẩm có doanh thu cao nhất ở MỖI loại ạ huhu
  
--ex3 Lỗi hay sao đó ạ, em chạy thử những câu lệnh đơn giản cx k ra ạ
  SELECT policy_holder_id, count(case_id) FROM callers
group by policy_holder_id

--ex4  
SELECT a.page_id
FROM pages as a
left join page_likes as b
on a.page_id=b.page_id
where b.user_id is null
order by a.page_id
  
--ex5
--Câu hỏi: bài này em không biết làm ạ
  
-ex6
with new as(
    select id, country, state, amount,
to_char(trans_date, 'yyyy-mm') as month  from transactions),

total as (select month, country, count(id) as trans_count, 
sum(amount) as trans_total_amount from new
group by month, country),

approved as (select month, country, count(id) as approved_count, 
sum(amount) as approved_total_amount from new
where state ='approved'
group by month, country)

select total.*, approved.approved_count, approved.approved_total_amount  from total
left join approved
on total.month=approved.month and total.country=approved.country

--Câu hỏi: Tại sao bài này em run thì dc accepted nhưng submit vẫn sai ạ :( 
  
--ex7
-- Cách 1: CTE
 with min as(select product_id, min(year) as first_year from sales
group by product_id)

select min.*, sales.quantity, sales.price
from min 
left join sales
on min.product_id=sales.product_id and min.first_year=sales.year

--Cách 2: Subquery
  SELECT product_id, year AS first_year, quantity, price
FROM Sales
WHERE (product_id, year) in (
    SELECT product_id, MIN(year) 
    FROM Sales
    GROUP BY product_id)
  
--ex8
select customer_id from customer
group by customer_id
having count(distinct product_key) = (select count(product_key) as count from product)
  
--ex9
select employee_id from employees
where salary < 30000 and manager_id not in (select employee_id from employees)
order by employee_id
  
--ex10 link bài 10 bị nhầm hay sao đó ạ, em ấn vào thì dẫn ra link này https://datalemur.com/questions/duplicate-job-listings
with socv as(
select company_id, count(job_id) as duplicate from job_listings
group by title, company_id)
select count(company_id) from socv
where duplicate>=2

--ex11
with countfilm as (select user_id, count(movie_id) from movierating
group by user_id),

ratemovie as (select movie_id from  movierating
where rating = (select max(rating) from movierating) 
and (created_at between '2020-02-01' and '2020-02-29')),

nameuser as(select a.name, max(b.count)
from users as a
left join countfilm as b
on a.user_id=b.user_id
group by a.name
order by a.name
limit 1),

namemoives as (select d.title
from ratemovie as c
left join movies as d
on c.movie_id=d.movie_id
order by d.title
limit 1)

select title as results from namemoives
union
select name from nameuser

--Câu hỏi: Tại sao bài này em run thì dc accepted nhưng submit vẫn sai ạ :( em không biết tại sao test case khác thì câu lệnh này lại không còn đúng nữa ạ
--ex12
--Câu hỏi: bài 12 em khong hiểu để ạ :(
