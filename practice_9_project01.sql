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

Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
Gợi ý: ( ADD column sau đó INSERT)
Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)
Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN
Lưu ý: với lệnh DELETE ko nên chạy trước khi bài được review
