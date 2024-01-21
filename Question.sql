--Buoi 6: interval & timestam challenge
--Bai lam
--KH co thoi gian thue TB max
select customer_id,
(extract(day from sum(return_date-rental_date))*24*60
+ extract(hour from sum(return_date-rental_date))*60
+  extract(minute from sum(return_date-rental_date)))/count(inventory_id) as thoi_gian_TB
from rental
group by customer_id
order by thoi_gian_TB DESC

--Solution cua khoa hoc
select customer_id,
avg(return_date-rental_date)
from rental
group by customer_id
order by customer_id DESC
/*Cau hoi: Tại sao tìm KH có thời gian thue TB max lại order by customer_id DESC. Và nếu sửa thành: order by avg(return_date-rental_date) DESC
thì kết quả sẽ ra khác kết quả khi tính ra phút*/
