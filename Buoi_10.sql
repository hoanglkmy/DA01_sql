--inner join
--challenge

--left join/right join
--VD: Hien thi thong tin chuyen  bay cuar tung may bay
select a.aircraft_code, b.flight_no, b.status
from aircrafts_data as a
left join flights as b
on a.aircraft_code=b.aircraft_code
--bonus: tim xem may bay naof dang k co chuyen bay nao ca
where b.flight_no is null

--Challenge: 
--tim hieu ghe naof dc dat thuong xuyen nhat
select a.seat_no,
count(b.ticket_no)
from seats as a
left join boarding_passes as b
on a.seat_no=b.seat_no
group by(a.seat_no)
order  by count(b.ticket_no) DESC
  --Cau hoir: dem flight_id cos khac gi so voi dem ticket_no khong

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
