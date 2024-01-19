--ex1
select distinct city from station
where ID mod 2 = 0
--hoặc
select distinct city from station
where ID % 2 = 0

--ex2
select count(city)-count(distinct city)
from station

--ex3

--ex4
/*Bước 1: phân tích yêu cầu
- output: gốc hay phái sinh: mean=tổng items/số đơn hàng
- input
- Điều kiện lọc theo trường nào: gốc hay phái sinh
Bổ sung: Cast (Non_Updated as decimal) -> để chuyển đổi kiểu thành số thập phân*/
  
select round(cast(sum(order_occurrences*item_count)/sum(order_occurrences)
as decimal),1) as mean from items_per_order

--ex5

