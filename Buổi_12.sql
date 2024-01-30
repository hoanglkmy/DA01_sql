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
--Cách 1: JOin 2 bảng
select a.*, b.total, b.count
from payment as a
inner join 
(select customer_id, 
sum(amount)  as total, 
count(payment_id) as count 
from payment 
group by customer_id) as b
on a.customer_id=b.customer_id

--Cách 2: Cho vào phần select: nếu cho truy vấn con vào phần select -> chỉ được hiển thị 1 trường thông tin/1 câu truy cần con select thôi
select *, 
(select  sum(amount)  as total  
from payment as b
 where b.customer_id=a.customer_id
group by customer_id),
(select count(payment_id) as count 
from payment as b
where b.customer_id=a.customer_id
group by customer_id)
from payment as a

--Challenge 2: Lấy DS các phim có chi phí thay thế lớn nhất trong mỗi loại rating, 
hiển thị thêm cả CP thay thế TB của mỗi loaji rating đó
select film_id, title, rating,
replacement_cost, (select avg(replacement_cost)
from film as b
where a.film_id=b.film_id
group by rating)
from film as a
where replacement_cost = (select max(replacement_cost)
from film as c
where a.rating=c.rating
group by rating)

--CTEs
--VD: tìm khách hàng có nhiều hơn 30 hóa đơn. thông tin hiển thị bao gồm mã KH, tên KH, 
só lượng hóa đơn, tổng số tiền, thời gian thuê TB
with total as(
select customer_id, count(*) as soluong,
sum(amount) as tong from payment
group by customer_id),
avg_rental_time as (
select customer_id, 
avg(return_date - rental_date) as rental_time
from rental
group by customer_id)
select a.customer_id, a.first_name,
b.soluong, b.tong, c.rental_time 
from customer as a
inner join total as b on a.customer_id=b.customer_id
inner join avg_rental_time as c on a.customer_id=c.customer_id
where b.soluong >30

--Challenge 1: Tìm những hóa đơn có số tiền cao hơn số tiền tb của KH đó chi tiêu trên mỗi hóa đơn,
Kq trả ra gồm: mã KH, tên KH, số lượng hóa đơn, số tiền, số tiền TB của kh
with donhang as (
select customer_id, count(payment_id) as soluong,
 avg(amount) as sotientb
from payment
group by customer_id)
select a.customer_id, a.first_name,
b.amount, c.soluong, c.sotientb
from customer as a
inner join payment as b on a.customer_id=b.customer_id
inner join donhang as c on c.customer_id=a.customer_id
where b.amount > c.sotientb

