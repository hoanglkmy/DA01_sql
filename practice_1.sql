--ex1
select name from city
where population > 120000
and countrycode = 'USA'
  
--ex2
select * from city
where countrycode ='JPN'
  
--ex3
select city, state from station
  
--ex4
select distinct city from station 
where city like 'a%' or city like 'e%' or city like 'i%' or city like 'o%'
or city like 'u%'

--ex5
select distinct city from station
where city like '%a' or city like '%e' or city like '%i' 
or city like '%o' or city like '%u'

-- ex6
select distinct city from station
where not (city like 'u%' or city like 'e%' or city like 'o%' 
          or city like 'a%' or city like 'i%')

--ex7
select name from employee
order by name 

--ex8
select name from employee
where salary >2000 and months <10
order by employee_id ASC

--ex9
select product_id from products
where low_fats = 'Y' and recyclable = 'y'

--ex10
select name from customer
where referee_id <> 2 or referee_id is null

--ex11
select name, population, area from World
where area >=3000000 or population >=25000000

--ex12
select distinct author_id as id from Views
where viewer_id = author_id
order by author_id ASC

--ex13
SELECT part, assembly_step FROM parts_assembly
where finish_date is null

--ex14
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >= 70000

--ex15
select * from uber_advertising
where money_spent >= 100000 and year = 2019
