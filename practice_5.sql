--ex1
select a.continent, floor(avg(b.population))
from country as a
inner join city as b
on a.code=b.countrycode
group by a.continent

--ex2

--ex3

--ex4

--ex5

--ex6

--ex7
