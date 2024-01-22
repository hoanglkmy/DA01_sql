--Case - when challenge
--1:
select fare_conditions,
case
when sum(amount) < 20000 then 'low_price_ticket'
when sum(amount) between 20000 and 150000 then 'mid_price_ticket'
else 'high_price_ticket'
end category,
count (*) 
from ticket_flights
group by fare_conditions
--SAI vì đếm xem cty bán dc bao nhiên vé ở các loại giá cao/thấp/tb chứ k phải đếm xem cty bán dc bnh về theo phân loại business/economy


select 
case
when amount < 20000 then 'low_price_ticket'
when amount between 20000 and 150000 then 'mid_price_ticket'
else 'high_price_ticket'
end category,
count (*) 
from ticket_flights
group by category
--2:
select 
case
when extract(month from scheduled_departure) 
in ('02', '03', '04') then 'Xuan'
when extract(month from scheduled_departure) 
in ('05', '06', '07') then 'Ha'
when extract(month from scheduled_departure) 
in ('08', '09', '10') then 'Thu'
when extract(month from scheduled_departure) 
in ('11', '12', '01') then 'Dong'
end mua,
count (*)
from flights
group by mua

--3:
select 
case
when rating in ('PG', 'PG-13') or length>210
then 'Great rating or long (tier 1)'
when description like '%Drama%' and length >90
then 'Long drama (tier 2)'
when description like '%Drama%' and length<90 
then 'Shcity drame (tier 3)'
when rental_rate<1 then 'Very cheap (tier 4)'
end category
from film

/*Để đáp ứng điều kiện: nếu 1 bộ phim có thể thuộc nhiều danh mục, nó sẽ được chỉ định ở cấp cao hơn. 
Dể có thể chỉ lọc những phim xuất hiện ở 1 trong 4 cấp độ cần thêm điều kiện:*/
where
case
when rating in ('PG', 'PG-13') or length>210
then 'Great rating or long (tier 1)'
when description like '%Drama%' and length >90
then 'Long drama (tier 2)'
when description like '%Drama%' and length<90 
then 'Shcity drame (tier 3)'
when rental_rate<1 then 'Very cheap (tier 4)'
end
is not null


