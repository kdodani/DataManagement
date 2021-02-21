# M02 Homework Solutions


* You can find the exercises from the slides.







### Second, drop and recreate the table.

```sql
drop table mytable;

create table MyTable(
  A VARCHAR2(100) NOT NULL,
  B VARCHAR2(100),
  C INT,
  CONSTRAINT uk_ab UNIQUE (a, b)
);
```


### Third, add a column D of type VARCHAR2(1000)

```sql
ALTER TABLE MyTable ADD D VARCHAR2(1000);
```

### Fourth, make column D the primary key using “ALTER”.

```
ALTER TABLE MyTable ADD CONSTRAINT pk_mytable_d PRIMARY KEY (D);
```



### Fifth, remove primary key but keep column D.

```sql
ALTER TABLE MyTable DROP CONSTRAINT pk_mytable_d;
```

## Exercise 4



10.222: succeeds. But 10.22 is inserted. digits after the decimal point are ROUNDED per precision.

10000.22: fails. There is more than 2 digits before decimal point.

0.2: succeeds. 0.2 is inserted.

0.222222: succeeds. But 0.22 is inserted. digits after the decimal point are ROUNDED per precision.

123: fails. There is more than 2 digits before decimal point.

9: succeeds and 9 is inserted.

0: succeeds and 0 is inserted.


More test cases:

10.227: succeeds. But 10.23 is inserted. digits after the decimal place are ROUNDED per precision.

0.227: succeeds. But 0.23 is inserted. digits after the decimal place are ROUNDED per precision.


## Exercise 5

```sql
CREATE TABLE ThreeIntWithUK (
	A INT,
	B INT,
	C INT,
	CONSTRAINT uk_ThreeIntWithUK UNIQUE (A,B)
);

INSERT INTO ThreeIntWithUK VALUES (0, 1, 1);
-- succeeds

INSERT INTO ThreeIntWithUK VALUES (1, 0, 2);
-- succeeds

INSERT INTO ThreeIntWithUK VALUES (0, NULL, 3);
-- succeeds

INSERT INTO ThreeIntWithUK VALUES (0, NULL, 4);
-- fails due to unique constraint

INSERT INTO ThreeIntWithUK VALUES (NULL, 1, 5);
-- succeeds

INSERT INTO ThreeIntWithUK VALUES (NULL, 1, 6);
-- fails due to unique constraint

INSERT INTO ThreeIntWithUK VALUES (NULL, NULL, 7);
-- succeeds

INSERT INTO ThreeIntWithUK VALUES (NULL, NULL, 8);
-- succeeds. When ALL columns in the unique constraint are NULL, the unique constraint does not apply.


SELECT * FROM ThreeIntWithUK ORDER BY c;
-- This will display the inserts that succeeds.
```




# Basic SQL 2 Notes

## Slide 8

What is the country of the musician who has won the most awards? If there is a tie, find the country that ranks first in alphabetical order.

```sql
select country
from musicians
order by
	awards desc,
	country;
```

## Slide 18 MOD(x, 10)

```
MOD(12, 100) = 12
MOD(123, 100) = 23

SELECT MOD(x, 100000) FROM DUAL;
SELECT MOD(987654321, 100000) FROM DUAL;
```

## Slide 21

```
!= is equivalent to <> (testing not equal)
```

## Slide 23 Exercise

Find “Pop” genre albums whose price is larger than 10.

```sql
SELECT * FROM ALBUMS
WHERE genre = 'Pop' AND price>10;
```

```sql
select * from musicians
where country = 'US' OR country = 'Canada';
```

```sql
select * from albums
where year >=2010;
```

## Slide 24

```sql
SELECT
    CASE
        WHEN tips > 100 THEN 'extraordinary'
        WHEN tips > 50  THEN 'high'
        WHEN tips > 10  THEN 'medium'
        ELSE 'low'
    END AS tip_category,
    tips, bill
FROM restaurant_payments;
```

## Slide 25 Exercise

Instead of assign payments to categories based on tip amount alone, assign it according to the tip percentage (i.e., tip / bill)
* more than 100%: extra-ordinary
* 50% - 100%: high
* 20% - 50%: medium
* 0 - 20%: small

```sql
SELECT
    tips, bill,
    CASE
        WHEN tips/bill > 1 THEN 'extraordinary'
        WHEN tips/bill > 0.5  THEN 'high'
        WHEN tips/bill > 0.2  THEN 'medium'
        ELSE 'small'
    END AS tip_category
FROM restaurant_payments;
```

## Slide 35 String Concatenation

-- Special case: concat with empty string
```sql
select 'James' || '' || 'Bond' AS concat_with_empty
from dual;
```

## Slide 37 LENGTH(string)

```sql
-- Special case
-- * This might produce different result in other DBs
-- * In Oracle, empty string is NULL.
select length('') length_of_empty_string from dual;
```

## Slide 39

```sql
select substr('University', 3, 6) from dual;
-- result is 'iversi'

select substr('Business Analytics', 10, 9) from dual;
-- result is 'Analytics'

select substr('Business Analytics', 10) from dual;
-- result is 'Analytics'
-- When the third parameter length is omitted
--   SUBSTR returns the sub-string from starting position to end.
```







-- When each edge has a single digit.
with triangles as (
    select '2,3,4' edges from dual
    union all select '4,4,4' from dual
    union all select '5,5,7' from dual
    union all select '2,2,4' from dual
),
t as (
    select
        cast(substr(edges, 1, 1) as int) a,
        cast(substr(edges, 3, 1) as int) b,
        cast(substr(edges, 5, 1) as int) c
    from triangles
)
select * from t;


-- Arbitrary number of digits.

with triangles as (
    select '2,3,4' edges from dual
    union all select '4,4,4' from dual
    union all select '5,5,7' from dual
    union all select '2,2,4' from dual
    union all select '20,12,9' from dual
),
commas as (
    select
        edges,
        instr(edges,',',1,1) comma1,
        instr(edges,',',1,2) comma2
    from triangles
),
sedges as (
    select
        substr(edges, 1, comma1-1) a,
        substr(edges, comma1+1, comma2-comma1-1) b,
        substr(edges, comma2+1) c
    from commas
),
iedges as (
    select
        cast(a as int) a,
        cast(b as int) b,
        cast(c as int) c
    from sedges
)
select * from iedges;


-- Using regex
with triangles as (
    select '2,3,4' edges from dual
    union all select '4,4,4' from dual
    union all select '5,5,7' from dual
    union all select '2,2,4' from dual
    union all select '50,10,9' from dual
),
step1 as (
    select
        cast(regexp_substr(edges, '\d+', 1, 1) as int) a,
        cast(regexp_substr(edges, '\d+', 1, 2) as int) b,
        cast(regexp_substr(edges, '\d+', 1, 3) as int) c
    from triangles
)
select * from step1;





Alternative solution to [Type of Triangle](https://www.hackerrank.com/challenges/what-type-of-triangle/problem)




```sql
with t as (
    select
        least(a,b,c) x,
        a+b+c - least(a,b,c) - greatest(a,b,c) y,
        greatest(a,b,c) z
    from triangles
)
select
    case when x <= 0 or (x + y <= z) then 'Not A Triangle' 
         when x = z then 'Equilateral'
         when x = y or y = z then 'Isosceles'
         else 'Scalene'
    end as type_of_triangle
from t;
```




# HackerRank Homework 1 


# Basic Select


## Q1. Select All

https://www.hackerrank.com/challenges/select-all-sql/problem

```sql
select * from city;
```



## Q2. Select By ID
https://www.hackerrank.com/challenges/select-by-id/problem

```sql
select * from city where id=1661;
```



## Q3. Revising the Select Query I

https://www.hackerrank.com/challenges/revising-the-select-query/

```sql 
select * from city
where population>100000
  and countrycode='USA';
```



## Q4. Revising the Select Query II

https://www.hackerrank.com/challenges/revising-the-select-query-2/problem

```sql
select name from city
where population > 120000
  and countrycode = 'USA';
```



## Q5. Japanese Cities' Attributes

https://www.hackerrank.com/challenges/japanese-cities-attributes/problem

```sql
select * from city where countrycode = 'JPN';
```



## Q6. Japanese Cities' Names

https://www.hackerrank.com/challenges/japanese-cities-name/problem

```sql
select name from city where countrycode = 'JPN';
```



## Q7. Weather Observation Station 1

https://www.hackerrank.com/challenges/weather-observation-station-1/problem

```sql
select city, state from station;
```



## Q8. Weather Observation Station 3

https://www.hackerrank.com/challenges/weather-observation-station-3/problem



```sql
select distinct city from station where mod(id, 2)=0;
```



## Q9. Weather Observation Station 6

https://www.hackerrank.com/challenges/weather-observation-station-6/problem



First letter of city name IN a list ...

```sql
select distinct city from station
where lower(substr(city, 1, 1)) in ('a','e','i','o','u');
```



## Q10. Weather Observation Station 7

https://www.hackerrank.com/challenges/weather-observation-station-7/problem



```sql
select distinct city from station
where lower(substr(city, -1, 1)) in ('a','e','i','o','u');
```

OR

```sql
select distinct city from station 
where lower(substr(city, length(city), 1)) in ('a','e','i','o','u');
```



## Q11. Weather Observation Station 8

https://www.hackerrank.com/challenges/weather-observation-station-8/problem



```sql
select distinct city from station 
where lower(substr(city, 1, 1)) in ('a','e','i','o','u') 
  and lower(substr(city, -1,1)) in ('a','e','i','o','u');
```



## Q12. Weather Observation Station 9

https://www.hackerrank.com/challenges/weather-observation-station-9/problem

```sql
select distinct city from station 
where lower(substr(city, 1, 1)) NOT IN ('a','e','i','o','u');
```



## Q13. Weather Observation Station 10

https://www.hackerrank.com/challenges/weather-observation-station-10/problem

```sql
select distinct city from station 
where lower(substr(city, -1, 1)) NOT IN ('a','e','i','o','u');
```



## Q14. Weather Observation Station 11

https://www.hackerrank.com/challenges/weather-observation-station-11/problem

```sql
select distinct city 
from station 
where lower(substr(city, 1, 1)) NOT IN ('a','e','i','o','u') 
   or lower(substr(city, -1, 1)) NOT IN ('a','e','i','o','u');
```



## Q15. Weather Observation Station 12

https://www.hackerrank.com/challenges/weather-observation-station-12/problem

```sql
select distinct city from station 
where lower(substr(city, 1, 1)) NOT IN ('a','e','i','o','u') 
  and lower(substr(city, -1, 1)) NOT IN ('a','e','i','o','u');
```



## Q16. Higher Than 75 Marks

https://www.hackerrank.com/challenges/more-than-75-marks/problem



```sql
select name from students where marks>75 
order by substr(name, -3, 3), id;
```



## Q17. Employee Names

https://www.hackerrank.com/challenges/name-of-employees/problem

```sql
select name from employee order by name;
```



## Q18. Employee Salaries

https://www.hackerrank.com/challenges/salary-of-employees/problem

```sql
select name from employee
where salary>2000
  and months<10
order by employee_id;
```



# Advanced SELECT


## Q19. Type of Triangle

https://www.hackerrank.com/challenges/what-type-of-triangle/problem



```sql
select 
	case
		when NOT( A+B>C and B+C>A and A+C>B ) then 'Not A Triangle'
		when A=B and B=C then 'Equilateral'
		when A=B or B=C or A=C then 'Isosceles'
		else 'Scalene'
    end as triangle_type
from triangles;
```



## Q20. The PADS

https://www.hackerrank.com/challenges/the-pads/problem


```sql
select name || '(' || substr(occupation, 1, 1) || ')' from occupations order by name;

select 'There are a total of ' || count(occupation) || ' ' || lower(occupation) || 's.' from occupations group by occupation order by count(occupation), occupation;
```



# Aggregation


## Q1: Revising Aggregations - The Sum Function

https://www.hackerrank.com/challenges/revising-aggregations-sum/problem

```sql
SELECT SUM(population)
FROM city
WHERE district='California'; 
```

## Q2: Revising Aggregations - Averages

https://www.hackerrank.com/challenges/revising-aggregations-the-average-function/problem

```sql
SELECT AVG(population)
FROM city
WHERE district='California'; 
```

## Q3: Average Population

https://www.hackerrank.com/challenges/average-population/problem

```sql
SELECT FLOOR(AVG(population)) FROM city; 
```

## Q4: Japan Population

https://www.hackerrank.com/challenges/japan-population/problem

```sql
SELECT SUM(population) FROM city 
WHERE countrycode='JPN'; 
```


## Q5: Population Density Difference

https://www.hackerrank.com/challenges/population-density-difference/problem

```sql
SELECT MAX(population) - MIN(population) 
FROM city;
```

## Q6: The Blunder

https://www.hackerrank.com/challenges/the-blunder/problem



```sql
SELECT CEIL(AVG(Salary) - AVG(REPLACE(Salary, '0', ''))) 
FROM EMPLOYEES;
```


## Q7: Weather Observation Station 2

https://www.hackerrank.com/challenges/weather-observation-station-2/problem

```sql
SELECT 
	ROUND(sum(LAT_N),2) lat,
	ROUND(sum(LONG_W),2) lon
FROM STATION;
```


## Q8: Weather Observation Station 13


https://www.hackerrank.com/challenges/weather-observation-station-13/problem

```sql
SELECT
	TRUNC(SUM(LAT_N),4) FROM STATION
WHERE LAT_N > 38.7880 AND LAT_N < 137.2345;
```


## Q9: Weather Observation Station 14

https://www.hackerrank.com/challenges/weather-observation-station-14/problem

```sql
SELECT
	TRUNC(MAX(LAT_N),4)
FROM STATION
WHERE LAT_N < 137.2345;
```

## Q10: Weather Observation Station 15

https://www.hackerrank.com/challenges/weather-observation-station-15/problem



```sql
SELECT ROUND(LONG_W, 4) 
FROM STATION
WHERE LAT_N = (
	SELECT MAX(LAT_N)
	FROM STATION
	WHERE LAT_N<137.2345
);
```

## Q11: Weather Observation Station 16

https://www.hackerrank.com/challenges/weather-observation-station-16/problem

```sql
SELECT ROUND(MIN(LAT_N), 4) 
FROM STATION
WHERE LAT_N>38.7780;
```

## Q12: Weather Observation Station 17

https://www.hackerrank.com/challenges/weather-observation-station-17/problem

```sql
SELECT ROUND(LONG_W, 4) FROM STATION
WHERE LAT_N = (
	SELECT MIN(LAT_N)
	FROM STATION
	WHERE LAT_N>38.7780
);
```

## Q13: Weather Observation Station 18

https://www.hackerrank.com/challenges/weather-observation-station-18/problem



```sql
SELECT
	ROUND(MAX(LAT_N)-MIN(LAT_N) + MAX(LONG_W)-MIN(LONG_W), 4) 
FROM STATION;
```

## Q14: Weather Observation Station 19

https://www.hackerrank.com/challenges/weather-observation-station-19/problem



```sql
SELECT TRUNC(SQRT(
	(MAX(LAT_N)-MIN(LAT_N))*(MAX(LAT_N)-MIN(LAT_N))
	+ (MAX(LONG_W)-MIN(LONG_W))*(MAX(LONG_W)-MIN(LONG_W))
),4) FROM STATION;
```

# Basic Join

## Q15: Average Population of Each Continent

https://www.hackerrank.com/challenges/average-population-of-each-continent/problem

```sql
SELECT country.continent, FLOOR(avg(city.population))
FROM city
JOIN country ON CITY.CountryCode = COUNTRY.Code
GROUP BY country.continent;
```

## Q16: Top Competitors

https://www.hackerrank.com/challenges/full-score/problem

```sql
WITH t AS (
	SELECT h.hacker_id, h.name, COUNT(*) cnt
	FROM submissions s
	JOIN hackers h ON s.hacker_id = h.hacker_id
	JOIN challenges c ON s.challenge_id=c.challenge_id
	JOIN difficulty d 
	  ON c.difficulty_level = d.difficulty_level AND s.score = d.score
	GROUP BY h.hacker_id, h.name
)
SELECT
	hacker_id,
	name
FROM t
WHERE cnt>1
ORDER BY cnt DESC, hacker_id;
```


## Q17: Challenges

https://www.hackerrank.com/challenges/challenges/problem

```sql
WITH step1 AS (
	SELECT h.hacker_id, name, count(1) cnt
	FROM hackers h 
	JOIN challenges c ON h.hacker_id = c.hacker_id
	GROUP BY h.hacker_id, name
)
SELECT hacker_id, name, cnt 
FROM step1
WHERE cnt IN (
	SELECT cnt FROM step1 GROUP BY cnt HAVING count(*)=1
	UNION SELECT MAX(cnt) FROM step1
)
ORDER BY cnt DESC, hacker_id;
```


## Q18: Contest Leaderboard

https://www.hackerrank.com/challenges/contest-leaderboard/problem

```sql
SELECT h.hacker_id, h.name, SUM(score) score
FROM (
	SELECT hacker_id, challenge_id, MAX(score) score
	FROM submissions
	GROUP BY hacker_id, challenge_id
) t
JOIN Hackers h ON t.hacker_id = h.hacker_id
GROUP BY h.hacker_id, h.name
HAVING SUM(score)>0
ORDER BY 3 DESC, 1;
```


# Advanced Join

## Q19: Placements

https://www.hackerrank.com/challenges/placements/problem

```sql
select s.name
from friends f, packages p1, packages p2, students s
where f.id=p1.id
  and f.friend_id=p2.id 
  and p1.salary<p2.salary
  and s.id=p1.id
order by p2.salary;
```


## Q20: Symmetric Pairs

https://www.hackerrank.com/challenges/symmetric-pairs/problem



```sql
WITH t AS (
    SELECT
        a.x, a.y, count(*) c
    FROM functions a, functions b
    WHERE a.x<=a.y AND a.x=b.y AND a.y=b.x
    GROUP BY a.x, a.y
)
SELECT x, y
FROM t
WHERE c>1 OR x!=y
ORDER BY x;
```





## 175. Combine Two Tables

https://leetcode.com/problems/combine-two-tables/

```sql
select
    FirstName,
    LastName,
    City,
    State
from Person p
left join Address a 
on p.PersonId = a.PersonId;
```



## 176. Second Highest Salary

https://leetcode.com/problems/second-highest-salary/

```sql
select max(salary) SecondHighestSalary
from Employee
where salary < (select max(salary) from Employee);
```



## 178. Rank Scores

https://leetcode.com/problems/rank-scores/



```
with scores_dedup as (
    select distinct score from scores
),
ranks as (
    select l.score, count(*) rank
    from scores_dedup l, scores_dedup r
    where l.score<=r.score
    group by l.score
)
select s.score, r.rank
from Scores s
join ranks r
on s.score = r.score
order by r.rank;
```



## 180. Consecutive Numbers

https://leetcode.com/problems/consecutive-numbers/

```sql
select distinct l.Num ConsecutiveNums
from Logs l
join Logs l1 on (l.id -1 = l1.id and l.Num=l1.Num)
join Logs l2 on (l.id -2 = l2.id and l.Num=l2.Num);
```



## 181. Employees Earning More Than Their Managers

https://leetcode.com/problems/employees-earning-more-than-their-managers/

```sql
select e.Name Employee
from Employee e
join Employee m on (e.ManagerId = m.Id)
where e.Salary>m.Salary;
```



## 182. Duplicate Emails

https://leetcode.com/problems/duplicate-emails/

```sql
select Email from Person group by Email having count(*)>1;
```



## 183. Customers Who Never Order

https://leetcode.com/problems/customers-who-never-order/

```sql
select Name Customers
from Customers
where Id not in (select CustomerId from Orders);
```



## 184. Department Highest Salary

https://leetcode.com/problems/department-highest-salary/

```sql
select d.Name Department, e.Name Employee, e.Salary
from employee e 
join department d on (e.DepartmentId=d.Id)
where not exists (
    select 1 from employee where DepartmentId=e.DepartmentId and Salary>e.Salary
);
```



## 185. Department Top Three Salaries

https://leetcode.com/problems/department-top-three-salaries/



```sql
select
    d.Name Department,
    a.Name Employee,
    a.Salary
from employee a
join department d on (a.DepartmentId=d.Id)
left join employee b on (a.DepartmentId=b.DepartmentId and a.Salary<b.Salary)
group by d.Name, a.Name, a.Salary
having count(distinct b.Salary) < 3;
```



## 197. Rising Temperature

https://leetcode.com/problems/rising-temperature/

```sql
select a.Id
from Weather a
join Weather b on a.recordDate-1=b.recordDate
where a.Temperature>b.Temperature;
```



## 262. Trips and Users

https://leetcode.com/problems/trips-and-users/

```sql
select
    request_at AS "Day",
    round(avg(case t.status when 'completed' then 0 else 1 end), 2) AS "Cancellation Rate"
from trips t
join users u on t.client_id=u.users_id and banned='No' and role='client'
where request_at between '2013-10-01' and '2013-10-03'
group by request_at;
```



## 595. Big Countries

https://leetcode.com/problems/big-countries/

```sql
select name, population, area
from World
where area>3000000 or population>25000000;
```



## 596. Classes More Than 5 Students

https://leetcode.com/problems/classes-more-than-5-students/

```sql
select class
from courses
group by class
having count(distinct student)>=5;
```



## 601. Human Traffic of Stadium

https://leetcode.com/problems/human-traffic-of-stadium/

```sql
-- to_char() is required to pass Oracle online judge in LeetCode.
-- This seems a bug of the online judge for this question.
-- Your answer is good enough if you get everything else correct except the TO_CHAR part.

select
    id,
    to_char(visit_date, 'YYYY-MM-DD') visit_date,
    people
from stadium s
where exists (
    select 1
    from stadium s1, stadium s2, stadium s3
    where s1.id+1 = s2.id and s2.id+1 = s3.id 
      and s1.people>=100 and s2.people>=100 and s3.people>=100
      and s.id in (s1.id,s2.id,s3.id)
)
order by visit_date;
```



## 620. Not Boring Movies

https://leetcode.com/problems/not-boring-movies/

```sql
select * from cinema
where mod(id,2)<>0 and description<>'boring'
order by rating desc;
```



## 626. Exchange Seats

https://leetcode.com/problems/exchange-seats/

```sql
select 
    least(id + 2*mod(id,2)-1, (select max(id) from seat)) AS id, 
    student
from seat
order by id;
```



## 627. Swap Salary

https://leetcode.com/problems/swap-salary/

```sql
update salary set sex = case sex when 'f' then 'm' else 'f' end;
```



## 1179. Reformat Department Table

https://leetcode.com/problems/reformat-department-table/

Hint: You may have learned pivot table in Excel which seems applicable to solve this question, and thus you may be tempted to learn how to do pivot table in Oracle. While Oracle does support pivot table, I encourage you to find a solution using only what we have learned in class.

```sql
-- Other aggregate functions such as MAX/AVG/SUM should also work.

SELECT
    id,
    MIN(CASE month WHEN 'Jan' THEN revenue ELSE NULL END) Jan_Revenue,
    MIN(CASE month WHEN 'Feb' THEN revenue ELSE NULL END) Feb_Revenue,
    MIN(CASE month WHEN 'Mar' THEN revenue ELSE NULL END) Mar_Revenue,
    MIN(CASE month WHEN 'Apr' THEN revenue ELSE NULL END) Apr_Revenue,
    MIN(CASE month WHEN 'May' THEN revenue ELSE NULL END) May_Revenue,
    MIN(CASE month WHEN 'Jun' THEN revenue ELSE NULL END) Jun_Revenue,
    MIN(CASE month WHEN 'Jul' THEN revenue ELSE NULL END) Jul_Revenue,
    MIN(CASE month WHEN 'Aug' THEN revenue ELSE NULL END) Aug_Revenue,
    MIN(CASE month WHEN 'Sep' THEN revenue ELSE NULL END) Sep_Revenue,
    MIN(CASE month WHEN 'Oct' THEN revenue ELSE NULL END) Oct_Revenue,
    MIN(CASE month WHEN 'Nov' THEN revenue ELSE NULL END) Nov_Revenue,
    MIN(CASE month WHEN 'Dec' THEN revenue ELSE NULL END) Dec_Revenue
FROM Department
GROUP BY id;
```









## Q1. Matching Specific String

https://www.hackerrank.com/challenges/matching-specific-string/problem

```
hackerrank
```



## Q2. Matching Digits & Non-Digit Characters

https://www.hackerrank.com/challenges/matching-digits-non-digit-character/problem

```
\d{2}\D\d{2}\D\d{4}
```



## Q3. Matching Whitespace & Non-Whitespace Character

https://www.hackerrank.com/challenges/matching-whitespace-non-whitespace-character/problem

```
\S{2}\s\S{2}\s\S{2}
```



## Q4. Matching Word & Non-Word Character

https://www.hackerrank.com/challenges/matching-word-non-word/problem

```
\w{3}\W\w{10}\W\w{3}
```



## Q5. Matching Start & End

https://www.hackerrank.com/challenges/matching-start-end/problem

```
^\d\w{4}\.$
```



## Q6. Matching Specific Characters

https://www.hackerrank.com/challenges/matching-specific-characters/problem

```
^[1-3][0-2][xs0][30Aa][xsu][.,]$
```



## Q7. Excluding Specific Characters

https://www.hackerrank.com/challenges/excluding-specific-characters/problem

```
^\D[^aeiou][^bcDF]\S[^AEIOU][^.,]$
```



## Q8. Matching Character Ranges

https://www.hackerrank.com/challenges/matching-range-of-characters/problem

```
^[a-z][1-9][^a-z][^A-Z][A-Z]
```



## Q9. Matching {x} Repetitions

https://www.hackerrank.com/challenges/matching-x-repetitions/problem

```
^[a-zA-Z02468]{40}[13579\s]{5}$
```



## Q10. Matching {x, y} Repetitions

https://www.hackerrank.com/challenges/matching-x-y-repetitions/problem

```
^\d{1,2}[A-Za-z]{3,}\.{0,3}$
```



## Q11. Matching Zero Or More Repetitions

https://www.hackerrank.com/challenges/matching-zero-or-more-repetitions/problem

```
^\d{2,}[a-z]*[A-Z]*$
```



## Q12. Matching One Or More Repetitions

https://www.hackerrank.com/challenges/matching-one-or-more-repititions/problem

```
^\d+[A-Z]+[a-z]+$
```



## Q13. Matching Ending Items

https://www.hackerrank.com/challenges/matching-ending-items/problem

```
^[A-Za-z]*s$
```



## Q14. Capturing & Non-Capturing Groups

https://www.hackerrank.com/challenges/capturing-non-capturing-groups/problem



```
(ok){3,}
```



## Q15. Alternative Matching

https://www.hackerrank.com/challenges/alternative-matching/problem

```
^(Mrs?|Ms|Dr|Er)\.[A-Za-z]+$
```



## Q16. Matching Same Text Again & Again

https://www.hackerrank.com/challenges/matching-same-text-again-again/problem

```
^([a-z]\w\s\W\d\D[A-Z][A-Za-z][aeiouAEIOU]\S)\1$
```




