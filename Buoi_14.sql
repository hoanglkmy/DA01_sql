--1. WINDOW FUNCTION with SUM, AVG, COUNT
--VD: Tính tỉ lệ số tiền thanh toán từng ngày với tổng số tiền đã thanh toán của mỗi khách hàng
  --Cach 1: Subquery
select a.customer_id, b.first_name, a.payment_date,
a.amount, 
(select sum(amount) from payment as c
 where c.customer_id=a.customer_id
group by customer_id),
round(a.amount/(select sum(amount) from payment as c
 where c.customer_id=a.customer_id
group by customer_id),2) as tile
from payment as a
join customer as b on a.customer_id=b.customer_id

    Cach 2: CTE
with tongsotien as
(select customer_id, sum(amount) as sum
from payment
group by customer_id)
select a.customer_id, b.first_name, a.payment_date,
a.amount, c.sum, a.amount/c.sum
from payment as a
inner join customer as b on a.customer_id=b.customer_id
inner join tongsotien as c on a.customer_id=c.customer_id

  Cach 3: window function:
select a.customer_id, b.first_name, a.payment_date, a.amount, 
sum(amount) over (partition by a.customer_id) as total,
a.amount/sum(amount) over (partition by a.customer_id)
from payment as a
inner join customer as b on a.customer_id=b.customer_id

--Challenge 1: DS phim bao gom: film_id, title, length, category, thoi luong TB cua phim torng category do. SX kq theo film_id
select a.film_id, a.title, a.length, c.name as namecategory,
avg(a.length) over (partition by c.name)
from film as a
join film_category as b on a.film_id=b.film_id
join category as c on c.category_id=b.category_id 
order by a.film_id


--Challenge 2: Chi tiet cac thanh toan gom: payment_id, customer_id, staff_id, rental_id, amount, payment_date, so lan thanh toan duoc thuc hien boi khach hang nay va so tien do
sx kq theo payment_id

select *, 
count(payment_id) over (partition by customer_id, amount)
from payment
order by payment_id

--2. RANK
--VD xep hangj do dai phim trong tung the loai
select a.film_id, c.name as category, a.length,
rank() over (partition by c.name order by  a.length DESC) as rank1, --> Xep hang dong giai, k goi tiep
dense_rank() over (partition by c.name order by  a.length DESC) as rank2, --> Xep hang dong giai, goi tiep
row_number() over (partition by c.name order by  a.length DESC, a.film_id) as rank3 --> Xep hang khong  dong giai
from film as a
join film_category as b on a.film_id=b.film_id
join category as c on b.category_id=c.category_id
order by c.name

--Challenge: ten KH, quoc gia, so luong thanh toan cua moi KH => Xep hang KH co DT cao nhat cho moi quoc gia + Loc kq 3 KH hang dau cua moi quoc gia
--Huong dan: Dung subquery de Loc kq 3 KH hang dau cua moi quoc gia
select * from 
(select a.first_name, d.country, 
count(e.payment_id) as soluong,
sum(e.amount),
rank() over (partition by  d.country order by sum(e.amount) DESC)
from customer as a
join address as b on a.address_id=b.address_id
join city as c on b.city_id=c.city_id
join country as d on c.country_id=d.country_id
join payment as e on a.customer_id=e.customer_id
group by a.first_name, d.country) as T
where T.rank <=3

--3. First Value
--VD: so tien thanh toan cho don hang dau tien vaf gan day nhat cuar tung KH
--so tien thanh toan cho don hang dau tien
select * from
(select payment_id, customer_id, amount, payment_date,
row_number() over (partition by customer_id order by payment_date)
from payment) as T
where T.row_number=1
  
--so tien thanh toan gan day nhat cuar tung KH
select * from
(select payment_id, customer_id, amount, payment_date,
row_number() over (partition by customer_id order by payment_date DESC)
from payment) as T
where T.row_number=1

--Cach First_value
select payment_id, customer_id, amount, payment_date,
first_value(amount) over (partition by customer_id order by payment_date) as first_amount,
first_value(amount) over (partition by customer_id order by payment_date DESC) as last_amount
from payment

--4. Lead(), Lag()
--VD: tim chenh lech so tien giua cac  HAI lan thanh toan lien tiep cua tung KH => cach nhau 1 lan thanh toan
select payment_id, customer_id, amount, payment_date,
lead(amount) over (partition by customer_id order by payment_date) as next_amount,
lead(payment_date) over (partition by customer_id order by payment_date) as next_payment_date,
amount-lead(amount) over (partition by customer_id order by payment_date) as diff
from payment

--tim chenh lech so tien giua cac  BA lan thanh toan cua tung KH => Cach  nhau 3 lan thanh toan
select payment_id, customer_id, amount, payment_date,
lead(amount,3) over (partition by customer_id order by payment_date) as next_amount,
lead(payment_date,3) over (partition by customer_id order by payment_date) as next_payment_date,
amount-lead(amount) over (partition by customer_id order by payment_date) as diff
from payment

--Challenge: Viet truy van tra ve DT trong ngay vaf DT cuar ngay hom truoc
Tinh toan phan tram tang truong so voi ngay hom truoc

select to_char(payment_date,'yyyy-mm-dd'), 
sum(amount),
lag(sum(amount)) over(order by to_char(payment_date,'yyyy-mm-dd')) as previour_sum,
round(100*(sum(amount)-lag(sum(amount)) over(order by to_char(payment_date,'yyyy-mm-dd')))/lag(sum(amount)) over(order by to_char(payment_date,'yyyy-mm-dd')),2)
from payment
group by  to_char(payment_date,'yyyy-mm-dd')
order by to_char(payment_date,'yyyy-mm-dd')


--Cach lay ngaythangnam tu timestamp
select date(payment_date)
from payment
