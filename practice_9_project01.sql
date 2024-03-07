--Hãy làm sạch dữ liệu theo hướng dẫn sau:
--1.Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 

alter table sales_dataset_rfm_prj
alter column priceeach type numeric
using (priceeach :: numeric) 

alter table sales_dataset_rfm_prj
alter column ordernumber type integer 
using (ordernumber :: integer)

alter table sales_dataset_rfm_prj
alter column orderlinenumber type integer 
using (orderlinenumber :: integer)

alter table sales_dataset_rfm_prj
alter column orderdate type timestamp 
using (orderdate :: timestamp)

alter table sales_dataset_rfm_prj
alter column sales type numeric
using (sales :: numeric) 

--2. Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
-- => Không có dữ liệu null ở các trường thông tin trên
select * from public.sales_dataset_rfm_prj
where ordernumber is null

select * from public.sales_dataset_rfm_prj
where QUANTITYORDERED is null

select * from public.sales_dataset_rfm_prj
where ORDERLINENUMBER is  null

select * from public.sales_dataset_rfm_prj
where SALES is  null

select * from public.sales_dataset_rfm_prj
where ORDERDATE is  null
  
--3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
--Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
-- Gợi ý: ( ADD column sau đó INSERT)
--Thêm cột
  alter table sales_dataset_rfm_prj
add column contactlastname varchar(50) 

 alter table sales_dataset_rfm_prj
add column contactfirstname varchar(50) 

--Chèn dữ liệu
  insert into sales_dataset_rfm_prj(contactfullname)
values(select left(contactfullname, position('-' in contactfullname)-1 )
	   from sales_dataset_rfm_prj)
  => You can't put a SELECT into a values clause like that. 
  The VALUES clause is intended for constant values and is not needed here.
--Sửa
update sales_dataset_rfm_prj
set contactfirstname = cte.contactfirstname1
from 
(select ordernumber, 
 left(contactfullname, position('-' in contactfullname)-1 ) as contactfirstname1
	   from sales_dataset_rfm_prj) as cte
where sales_dataset_rfm_prj.ordernumber = cte.ordernumber

update sales_dataset_rfm_prj
set contactlastname = cte1.contactlastname1
from 
(select ordernumber, 
 right(contactfullname, length(contactfullname) - position('-' in contactfullname) ) as contactlastname1
	   from sales_dataset_rfm_prj) as cte1
where sales_dataset_rfm_prj.ordernumber = cte1.ordernumber

--Chuẩn hóa

  update sales_dataset_rfm_prj
set contactfirstname=upper(left(contactfirstname,1))||lower(substring(contactfirstname,2,length(contactfirstname)))

  update sales_dataset_rfm_prj
set contactfirstname=upper(left(contactfirstname,1))||lower(substring(contactfirstname,2,length(contactfirstname)))
  
--4. Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
alter table sales_dataset_rfm_prj
add column MONTH_ID numeric

alter table sales_dataset_rfm_prj
add column  YEAR_ID numeric

alter table sales_dataset_rfm_prj
add column  QTR_ID numeric

  --Nếu vẫn làm tương tự như cách thêm cột fistname và lastname thì sẽ bị sai vì mỗi ordernumber tương ứng với 1 fullname 
  nhưng 1 người thì lại có thể order ở những ngày tháng năm khác nhau vs cùng 1 ordernumber nên khi sửa dữ liệu sẽ bị lỗi 
  
--5. Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) 
  ( Không chạy câu lệnh trước khi bài được review)
--tìm outlier
  with cte as
(select ordernumber, quantityordered,
(select avg(quantityordered) from sales_dataset_rfm_prj)as avg,
(select stddev(quantityordered) from  sales_dataset_rfm_prj)as stddev
from sales_dataset_rfm_prj),

  outlier as (
select ordernumber, quantityordered, 
(quantityordered - avg)/stddev as z_score
from cte
where abs((quantityordered - avg)/stddev) >3)

--Xử lý bản ghi
  update  sales_dataset_rfm_prj
  set quantityordered = (select avg(quantityordered) from sales_dataset_rfm_prj)
  where quantityordered in (select quantityordered from outlier
  
--6. Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN
Lưu ý: với lệnh DELETE ko nên chạy trước khi bài được review
