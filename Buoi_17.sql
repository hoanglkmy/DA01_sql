--Create View
--Challenge
create view vw_movies_category as
(
select a.title, a.length, c.name as category_name
from film as a
join film_category as b on a.film_id=b.film_id
join category as c on b.category_id=c.category_id
order by a.length DESC)
select * from vw_movies_category
where category_name in ('Action', 'Comedy')

--Update
--Challenge:
create view new_table as
(
select  distinct b.first_name||' '||last_name as ten_kh, e.country,
count(a.payment_id) over (partition by a.customer_id),
sum(a.amount) over (partition by a.customer_id)
from payment as a
join customer as b on a.customer_id=b.customer_id
join address as c on c.address_id=b.address_id
join city as d on d.city_id=c.city_id
join country as e on e.country_id=d.country_id)


with xephang as (select ten_kh, country, count, 
row_number() over (partition by country order by sum) as rank
from new_table) 
select ten_kh, country, count from xephang
where rank <=3
