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
