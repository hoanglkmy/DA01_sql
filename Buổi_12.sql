--SUBQUERIES
--VD: tìm nhữn hóa đơn của KH tên Adam
select a.first_name, b.payment_id, b.amount
from customer as a
inner join payment as b
on a.customer_id=b.customer_id
where a.first_name='ADAM'

  --Cách dùng SUBQUERIES: Sẽ tối ưu hơn vì có thể hiện thị hết tất cả các thông tin hóa đơn nhanh chóng mà không cần phải select từng trường thông tin để hiện thị
select * from payment
where customer_id = (select customer_id from customer
where first_name='ADAM')

--Challenge 1: tìm các bộ phim có thời lượng lớn hơn TB các bộ phim 
select * from film
where length > (select avg(length) from film)

--Challenge 2: Tìm những film có ở store 2 ít nhất 3 lần
select a.film_id, a.title,
count(b.inventory_id)
from film as a
inner join inventory as b
on a.film_id=b.film_id
where b.store_id=2
group by a.film_id, b.store_id
having count(b.inventory_id)>=3 
order by film_id

  --cách dùng subqueries:
select film_id, title from film
where film_id in (select film_id from inventory
where store_id=2
group by film_id
having count(*)>=3)

  
--Challenge 3: Tìm những KH đến từ California và chi tiêu nhiều hơn 100
select a.customer_id, a.first_name, a.last_name, a.email
from customer as a
inner join address as b on a.address_id=b.address_id
inner join payment as c on a.customer_id=c.customer_id
where b.district='California' 
group by a.customer_id
having sum(c.amount)>100
order by customer_id

--SUBQUERIES IN SELECT
--Challenge: tìm số tiền chênh lệch giữa số tiền từng hóa đơn với số tiền thanh toán lớn nhất
select *,
(select max(amount) from payment) as max,
abs(amount - (select max(amount) from payment)) as chenh_lech
from payment

--Correlated Subqueries
--VD: lấy ra thông tin KH có tổng hóa đơn lớn hơn 100
--Cách 1:
select * from customer
where customer_id in (select customer_id from payment
group by customer_id
having sum(amount)>100)
--Cách 2: 

--Correlated subqueries in select
--Challenge: Liệt kê các khoản thanh toán với tổng số hóa đơn và tổng số tiền mỗi khách hàng phải trả
