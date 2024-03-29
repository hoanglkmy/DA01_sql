
--II. Ad-hoc tasks
--This value "2022-07-23 04:16:51 UTC" is not a DATE it is a TIMESTAMP which is the issue you are seeing.
--1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng: Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
--Output: month_year ( yyyy-mm) , total_user, total_orde

with cte as 
(select order_id, user_id,  date(created_at)  as date_value
from bigquery-public-data.thelook_ecommerce.orders
where status = 'Complete')
select count(distinct order_id) as total_order,
 count(distinct user_id) as total_user, 
 month_year  from 
(select order_id, user_id,  extract(year from date_value)||'-'||extract(month from date_value) as month_year 
from cte) as a
where month_year between '2019-1' and '2022-4' 
group by month_year 
order by month_year 
-> Câu hỏi: vẫn bị dính thông tin của tháng 10,11,12 năm 2022

--2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
--Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng ( Từ 1/2019-4/2022)
--Output: month_year ( yyyy-mm), distinct_users, average_order_value


  
