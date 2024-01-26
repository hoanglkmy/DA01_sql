--inner join
--challenge:Có bao nhiêu người chọn ghế ngồi theo các loại sau business, economy, comfort
select a.fare_conditions, count(b.passenger_id)
from ticket_flights as a
inner join tickets as b
on a.ticket_no=b.ticket_no
group by a.fare_conditions
  --sai vì có những khách hàng đặt nhiều hơn 1 vé và ở đây quan tâm đến có bao nhiêu khách đặt ghế  ngồi (so ghe duoc dat) => dem seat_no
--sửa:
select fare_conditions, 
count(a.seat_no)
from seats as a
inner join boarding_passes as b
on a.seat_no=b.seat_no
group by (a.fare_conditions)
  --Câu hỏi: tại sao đến flight_id mà lại k đếm seat_no 
  
--left join/right join
--VD: Hien thi thong tin chuyen  bay cuar tung may bay
select a.aircraft_code, b.flight_no, b.status
from aircrafts_data as a
left join flights as b
on a.aircraft_code=b.aircraft_code
--bonus: tim xem may bay naof dang k co chuyen bay nao ca
where b.flight_no is null

--Challenge: của Left/right join 
--tim hieu ghe naof dc dat thuong xuyen nhat
select a.seat_no,
count(b.ticket_no)
from seats as a
left join boarding_passes as b
on a.seat_no=b.seat_no
group by(a.seat_no)
order  by count(b.ticket_no) DESC
  --Cau hỏi: đếm flight_id có khác gi so voi dem ticket_no khong khi mà 1 ticket_no có thể xuất hiện ở 2 flight_id

--Co cho ngoi nao chua bao gio duoc dat khong
  -- seat_no co o bảng A nhưng ở bảng B là null
select a.seat_no,
b.ticket_no
from seats as a
left join boarding_passes as b
on a.seat_no=b.seat_no
where ticket_no is null -> Sai
where b.seat_no is null

--Chi ra hang ghe nao dduoc dat thuong xuyen nha
-- Phải tách từ trường seat_no ở phía bên phải ngoài cùng
select right(a.seat_no,1),
count(right(a.seat_no,1))
from seats as a
left join boarding_passes as b
on a.seat_no=b.seat_no
group by(right(a.seat_no,1))
order by right(a.seat_no,1) 
--Câu lệnh sai nhưng vẫn ra kết quả giống nhau vì không có ghế nào không dc đặt, phải đếm flight_id vì là số hàng ĐƯỢC ĐẶT
--Chữa
select right(a.seat_no,1) as line,
count(b.flight_id)
from seats as a
left join boarding_passes as b
on a.seat_no=b.seat_no
group by right(a.seat_no,1)
order by count(b.flight_id)

--Full Join
--Ví dụ
  --Câu hỏi: Tại sao tìm những vé máy bay không được phát thẻ lên máy bay là
where a.ticket_no is null
  -CÒn n ng có thẻ lên máy bay là k có vé máy bay lại là
where b.ticket_no is null

--Join on Multiples conditions
--Câu hỏi: làm sao để biết khi nào cần tham chiếu đến 2 bản ghi
-VD: -tìm giá TB của từng số ghế máy bay
--Bước 1: Xác định input, output => bảng cần dùng

select a.seat_no,
avg(b.amount)
from boarding_passes as a
inner join ticket_flights as b
on a.ticket_no=b.ticket_no
and a.flight_id=b.flight_id
group by a.seat_no

--Join Multiple tables
--VD:list: số vé, tên KH, giá vé, giờ bay, giờ end
select b.ticket_no, b.passenger_name, a.amount,
c.scheduled_departure, c.scheduled_arrival
from ticket_flights as a
inner join tickets as b
on a.ticket_no=b.ticket_no
inner join flights as c
on a.flight_id=c.flight_id

--Challenge:
  /*KH den tu brazil: 
first_name, last_name, email, quoc gia*/
select a.first_name, a.last_name, a.email,
d.country
from customer as a
inner join address as b on a.address_id=b.address_id
inner join city as c on b.city_id=c.city_id
inner join country as d on c.country_id=d.country_id
where d.country = 'Brazil'

--Self Join
--VD: Hien thi ten nhan vien tuong ung voi ten quan ly
select emp.employee_id, emp.name as employee, 
emp.manager_id,
ma.name as manager
from employee as emp
left join employee as ma
on emp.manager_id=ma.employee_id
-- Cau hoi: trong anh

--challenge: Tim nhung bo phim cung thowi luong phim
select f1.title as t1, f2.title as t2,
f1.length
from film as f1
left join film as f2
on f1.length=f2.length
where f1.title<>f2.title

--Union
--VD: anh 
