--ex1: Tạo danh sách tất cả chi phí thay thế (replacement costs )  khác nhau của các film.
select  replacement_cost 
from public.film
group by replacement_cost
order by replacement_cost 
--Câu hỏi: Anh ơi cho em hỏi, tạo ds chi phí thay thế khác nhau của các film thì mình sẽ chỉ cần hiển thị 
ds các chi phí thay thể không trùng lặp và đc sx theo thứ tự thôi đúng không ạ
hay sẽ là cần hiển thị thêm film_id và chi phí thay thể có thể bị trùng lặp cũng được miễn là được sx ạ như sau nữa ạ
select  film_id, replacement_cost 
from public.film
order by replacement_cost

--ex2: 
/* số lượng phim có chi phí thay thế trong 
1.	low: 9.99 - 19.99
2.	medium: 20.00 - 24.99
3.	high: 25.00 - 29.99
Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?*/
  
select count(film_id),
case 
when replacement_cost between 9.99 and 19.99 then 'low'
when replacement_cost between 20.00 and 24.99 then 'medium'
when replacement_cost between 25.00 and 29.99 then 'high'
end as category
from film
group by category

--ex3
select a.title, a.length, c.name as category_name
from film as a
inner join film_category as b on a.film_id=b.film_id
inner join category as c on b.category_id=c.category_id
where c.name in ('Drama', 'Sports')
order by a.length DESC

--ex4: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).
select c.name, count(a.title)
from film as a
inner join film_category as b on a.film_id=b.film_id
inner join category as c on b.category_id=c.category_id
--where c.name in ('Drama', 'Sports')
group by c.name
order by count(a.film_id) DESC

--ex5
select a.last_name, a.first_name,
count(b.film_id)
from actor as a
inner join film_actor as b 
on a.actor_id=b.actor_id
group by  a.last_name, a.first_name
order by count(b.film_id) DESC
  --Câu hỏi: tại sao khi em lọc thêm trường actor_id kết quả lại ra khác ạ

--ex6
