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

--Cachs khasc
/*Bước 1: Khám phá và làm sạch dữ liệu
Quan tâm đến trường dư liệu nào?
Check null: 135080 banr ghi cos customerid null
Chuyển đổi kiểu dữ liệu
Số tiền và số lượng >0
Check dup */
/*
with online_retail_cast as
(
select invoiceno, stockcode, 
cast(quantity as int),
cast(invoicedate as timestamp),
cast(unitprice as numeric),
cast(customerid as int)
from public.online_retail
where customerid <>'' 
and cast(quantity as int) >0
and cast(unitprice as numeric) >0)
, online_retail_dup as
(
select *, 
row_number() over (partition by invoiceno, stockcode, quantity order by invoicedate) as stt
from online_retail_cast)
, online_retail_clean as
(
select * from online_retail_dup
where stt=1)
/*Bước 2:
- Tìm ngày mua hàng đầu tiên của mỗi KH => count_date
- Tìm index=tháng (ngày mua hàng đầu tiên) + 1
- Count só lượng KH hoặc tổng DT tại mỗi cohort_date và index tương ứng
- Pivot table*/
, online_retail_firstpurchase as
(
select 
invoiceno,
customerid,
quantity*unitprice as amount,
invoicedate,
min(invoicedate) over(partition by customerid) as first_purchase
from online_retail_clean)
,online_retail_index as
(
select invoiceno, customerid, amount,
invoicedate, first_purchase,
to_char(first_purchase, 'yyyy-mm') as  cohort_date,
(extract('year' from invoicedate)- extract('year' from first_purchase))*12+(extract('month' from invoicedate)-extract('month' from first_purchase)) +1 as index
from online_retail_firstpurchase)
select cohort_date, index,
count(distinct customerid) as cnt,
sum(amount) as revenue
from online_retail_index
group by cohort_date, index
*/

-- Cachs cuar chij JULIE
with online_retail_covert as(
select 
invoiceno,
description,
stockcode,
cast(quantity as int) as quantity,
cast(invoicedate as timestamp) invoicedate,
cast(unitprice as numeric) as unitprice,
customerid,
country
from public.online_retail
where customerid <>''
and cast(quantity as int) >0 and cast(unitprice as numeric) >0)

,online_retail_main as
(select * from 
(select t.* ,
row_number() over(partition by invoiceno, stockcode, quantity order by invoicedate) as dup_flag
from online_retail_covert t ) x
where dup_flag =1 )
 --- begin analyst 
--select * from online_retail_main
,online_retail_index as(
SELECT 
customerid,
	amount,
	TO_CHAR(first_purchase_date, 'yyyy-mm') as cohort_date,
	invoicedate,
	(extract('year' from invoicedate)-extract('year' from first_purchase_date))*12
	+(extract('month' from invoicedate)-extract('month' from first_purchase_date))+1 as index
FROM(
	SELECT customerid,
	quantity*unitprice AS amount,
MIN(invoicedate) over(PARTITION BY customerid) as first_purchase_date ,
invoicedate
from online_retail_main t
) a)

, xxx as
  (
SELECT 
cohort_date,
index,
count(distinct customerid) as cnt,
sum(amount) as revenue
from online_retail_index
group by )
/*Bước 3:
pivot table => cohort chart */

--Customer Cohort
select cohort_date,
sum(case when index = 1 then cnt else 0 end) as m1,
sum(case when index = 2 then cnt else 0 end) as m2,
sum(case when index = 3 then cnt else 0 end) as m3,
sum(case when index = 4 then cnt else 0 end) as m4,
sum(case when index = 5 then cnt else 0 end) as m5,
sum(case when index = 6 then cnt else 0 end) as m6,
sum(case when index = 7 then cnt else 0 end) as m7,
sum(case when index = 8 then cnt else 0 end) as m8,
sum(case when index = 9 then cnt else 0 end) as m9,
sum(case when index = 10 then cnt else 0 end) as m10,
sum(case when index = 11 then cnt else 0 end) as m11,
sum(case when index = 12 then cnt else 0 end) as m12,
sum(case when index = 13 then cnt else 0 end) as m13
from xxx
group by cohort_date

--Retenton Cohort
customer_cohort as
(
select cohort_date,
sum(case when index = 1 then cnt else 0 end) as m1,
sum(case when index = 2 then cnt else 0 end) as m2,
sum(case when index = 3 then cnt else 0 end) as m3,
sum(case when index = 4 then cnt else 0 end) as m4,
sum(case when index = 5 then cnt else 0 end) as m5,
sum(case when index = 6 then cnt else 0 end) as m6,
sum(case when index = 7 then cnt else 0 end) as m7,
sum(case when index = 8 then cnt else 0 end) as m8,
sum(case when index = 9 then cnt else 0 end) as m9,
sum(case when index = 10 then cnt else 0 end) as m10,
sum(case when index = 11 then cnt else 0 end) as m11,
sum(case when index = 12 then cnt else 0 end) as m12,
sum(case when index = 13 then cnt else 0 end) as m13
from xxx
group by cohort_date)
select cohort_date, 
round(100* m1/m1,2) ||'%' as m1,
round(100* m2/m1,2) ||'%' as m2,
round(100* m3/m1,2) ||'%' as m3,
round(100* m4/m1,2) ||'%' as m4,
round(100* m5/m1,2) ||'%' as m5,
round(100* m6/m1,2) ||'%' as m6,
round(100* m7/m1,2) ||'%' as m7,
round(100* m8/m1,2) ||'%' as m8,
round(100* m9/m1,2) ||'%' as m9,
round(100* m10/m1,2) ||'%' as m10,
round(100* m11/m1,2) ||'%' as m11,
round(100* m12/m1,2) ||'%' as m12,
round(100* m13/m1,2) ||'%' as m13

from customer_cohort
