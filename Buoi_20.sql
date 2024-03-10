-- Apply SQL for Cohort Analysis
/*Bước 1: Khám phá và làm sạch dữ liệu
Quan tâm đến trường dư liệu nào?
Check null
Chuyển đổi kiểu dữ liệu
Số tiền và số lượng >0
Check dup */

--So ban ghi: 541909 records
select count (*) 
from public.online_retail

--Check null
select * from online_retail
where invoiceno = ''

select * from online_retail
where stockcode = ''

select * from online_retail
where customerid = ''
-> Câu hỏi: Tại sao khi dùng câu lệnh where customerid is null thì k có gtr nào bị null còn dùng câu lệnh where customerid = '' thì mới ra giá trị

select count(*) from online_retail
where customerid = ''
-> có 135080 giá trị customerid bị null
-> Lấy những hóa đơn mà có customerid khác null
select * from online_retail
where customerid <>''

-- Chuyen doi kieu du lieu
select invoiceno,
stockcode,
description,
cast(quantity as integer),
cast(invoicedate as timestamp),
cast(unitprice as numeric),
customerid,
country
from online_retail
where customerid <>''

  -- Số tiền và số lượng >0
select invoiceno,
stockcode,
description,
cast(quantity as integer),
cast(invoicedate as timestamp),
cast(unitprice as numeric),
customerid,
country
from online_retail
where customerid <>''
and cast(quantity as integer) >0
and cast(unitprice as numeric) >0

-- Check duplicate => SD row-number (ki thuat check duplicate)
with online_retail_convert as
(
select invoiceno,
stockcode,
description,
cast(quantity as integer),
cast(invoicedate as timestamp),
cast(unitprice as numeric),
customerid,
country
from online_retail
where customerid <>''
and cast(quantity as integer) >0
and cast(unitprice as numeric) >0
),

online_retail_clean as
(
select * from (select *,
row_number() over(partition by invoiceno, stockcode, quantity order by invoicedate) as STT
from online_retail_convert) as T
where STT=1)

select * from online_retail_clean

/*Bước 2:
- Tìm ngày mua hàng đầu tiên của mỗi KH => count_date
- Tìm index=tháng (ngày mua hàng đầu tiên) + 1
- Count só lượng KH hoặc tổng DT tại mỗi cohort_date và index tương ứng
- Pivot table*/


select * from (select *,
row_number() over (partition by customerid order by invoicedate) as sttdate
from online_retail_clean) as T1
where sttdate =1
--> Không dùng câu lệnh này vì nếu dùng câu lệnh này sẽ chỉ hiện ra thông tin của những ngày mua hàng đầu tiên. 
Mục đích chính ở đây là THÊM 1 cột chứa thông tin ngày mua hàng đầu tiên để sau đó so sánh với ngahy mua hàng hiện tại
--> nên dùng:
min(invoicedate) over(partition by customerid) as first_purchase

, online_retail_index as(
select 
 customerid, amount,
 invoicedate, 
 to_char(first_purchase, 'yyyy-mm') as cohort_date,
 (extract('year' from invoicedate)-extract('year' from first_purchase))*12
+(extract('month' from invoicedate)-extract('month' from first_purchase))+1 as index
from
(select 
  customerid, 
  quantity*unitprice as amount,
  invoicedate, 
min(invoicedate) over(partition by customerid) as first_purchase
from online_retail_clean) as M)
select cohort_date, index,
count(distinct customerid) as cnt,
sum(amount) as revenue
from online_retail_index
group by cohort_date, index

/*Bước 3:
pivot table => cohort chart */
