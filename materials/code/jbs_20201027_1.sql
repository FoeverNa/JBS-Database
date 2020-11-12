use world;

# sub query : select, from, where

# 전체 나라수, 도시수, 언어수를 출력
select 
( select count(*) from country ) as total_country,
( select count(*) from city ) as total_city,
( select count(distinct(language)) from countrylanguage ) 
as total_language
from dual;

# 800만 이상이 되는 도시의 국가코드, 국가이름, 도시인구수를 출력
select city.countrycode, country.name, city.population
from city # 4079
join country # 239
on city.countrycode = country.code
having city.population >= 8000000;

select city.countrycode, country.name, city.population
from (select * from city where population >= 8000000) as city # 10
join country # 239
on city.countrycode = country.code;

# 900만 이상 도시를 가진 국가의 국가코드, 국가이름, 대통령이름을 출력
select code, name, headofstate 
from country
where code in ( # BRA, IDN, IND ...
	select distinct(countrycode) 
    from city 
    where population >= 9000000
);

# VIEW : 가상 테이블
# 실제 데이터를 저장하지 않습니다. 수정 및 인덱스 설정이 불가능
# 쿼리를 단순하게 만들어 주기 위해서 사용 됩니다.

# 국가코드와 국가이름이 있는 뷰
create view code_name_k as
select code, name
from country
where code like "K%";

select * from code_name_k;

select *
from city
join code_name_k
on code_name_k.code = city.countrycode;

# 1. 멕시코(Mexico)보다 인구가 많은 나라의 이름과 인구수를 조회하고 인구수 순으로 정렬
# 멕시코 인구수는 업데이트 될수 있습니다.
# Mexico를 쿼리문에서 사용 가능, 숫자는 쿼리문에서 사용 불가
# where절 sub-query
select name, population
from country
where population >= (
	select population 
    from country
    where name = "Mexico"
)
order by population desc;

# 2. 국가별 몇개의 도시가 있는 출력하고 10위까지 내림차순(도시수)으로 정렬
# 국가명, 도시수
# join, group by
select country.name, count(city.name) as count
from city
join country
on city.countrycode = country.code
group by country.name
order by count desc
limit 10;

# 3. 언어별 사용인구수를 출력하고 사용인구순으로 상위 10개의 언어를 출력
# 언어, 사용인구(country 테이블의 population)
# sub-query, join, group by
# 국가별 언어별 사용인구 데이터 만들기 > 언어별 그룹핑(sum)
select sub.language, sum(sub.count) as population
from (
	select ct.code, cl.language
			, round(ct.population * cl.percentage * 0.01) as count
	from country as ct
	join countrylanguage as cl
	on ct.code = cl.countrycode
) as sub
group by sub.language
order by population desc
limit 10;













































