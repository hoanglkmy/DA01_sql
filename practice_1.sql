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
