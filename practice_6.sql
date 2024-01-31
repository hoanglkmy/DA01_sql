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

  --Câu hỏi: anh ơi, bài này em đang bị mắc kẹt ở đoạn chọn ra 2 sản phẩm có doanh thu cao nhất ở mỗi loại ạ huhu
--ex3

--ex4

--ex5

-ex6

--ex7

--ex8

--ex9

--ex10

--ex11

--ex12
