# functions

# ceil, round, truncate
select ceil(12.345);
select ceil(12.345 * 100) / 100;
select round(12.345);
select round(12.345, 2);
select truncate(12.345, 2);

# 국가별 언어 사용 비율을 올림, 반올림, 버림
use world;
select countrycode, language, percentage
	, ceil(percentage)
    , round(percentage)
    , truncate(percentage, 0)
from countrylanguage;

# DATE FORMAT
use sakila;
select sum(amount), date_format(payment_date, "%Y-%m") as monthly
from payment
group by monthly;

select sum(amount) as income, date_format(payment_date, "%H") as monthly
from payment
group by monthly
order by income desc;


# 조건문 : IF, IFNILL, CASE
use world;
# 도시의 인구가 500만이 넘으면 "big city", 아니면 "small city"를 출력 컬럼
select countrycode, name, population
		, if(population >= 5000000, "big city", "small city")
from city
where population >= 1000000
order by population desc;

# ifnull
select code, name, indepyear
		, ifnull(indepyear, 0)
from country;

# case when then end
# 국가 인구가 10억 이상 "level3", 1억이상 "level2", 1억이하 "level1"
select code, name, population
	, CASE
		WHEN population >= 1000000000 THEN "level3"
        WHEN population >= 100000000 THEN "level2"
        ELSE "level1"
	END as scale
from country
where population >= 80000000
order by population desc;

# 미국과 한국의 국가코드와 인구수 GNP 출력, 피봇팅해서 출력
select code, name, population, gnp
from country
where code in ("USA", "KOR");

# JOIN
create database test;
use test;
create table user(
	name varchar(20),
    addr varchar(20)
);
create table money(
	name varchar(20),
    income int
);
insert into user(name, addr)
values("A", "seoul"), ("B", "pusan"), ("C", "incheon");
select * from user;
insert into money(name, income)
values("A", 100), ("B", 200), ("B", 300), ("D", 400);
select * from money;

select money.name, user.addr, money.income
from user
inner join money
on user.name = money.name;

# city 테이블과 country 테이블을 조인해서
# city 인구가 500만이 넘는 도시의 국가코드, 국가이름, 도시이름, 인구수를 출력
use world;
select city.countrycode, country.name
		, city.name, city.population
from city, country
where city.countrycode = country.code 
	and city.population >= 5000000;

# 국가별, 도시별, 언어 사용률을 출력
select country.name as country_name
		, city.name as city_name
        , cl.language, cl.percentage
        , (cl.percentage * city.population) / 100 as lpp
from country, city, countrylanguage as cl
where country.code = city.countrycode 
	and country.code = cl.countrycode
    and country.code in ("USA", "KOR");
    
# union : select 결과를 합쳐서 출력할때 사용
# union : 자동으로 중복제거
# union all : 중복제거 X
use test;

select name
from user
union
select name
from money;

select name
from user
union all
select name
from money;

select user.name, user.addr, money.income
from user
left join money
on user.name = money.name
union
select money.name, user.addr, money.income
from user
right join money
on user.name = money.name;
