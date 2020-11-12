# 4. 국가 인구의 10% 이상의 인구가 있는 도시에서 도시인구가 500만 이상인 도시를 출력
# 국가코드, 국가이름, 도시이름, 국가인구수, 도시인구수, 도시인구비율
# join, sub-query

# join 후에 having절에서 필터링하는 방법
select country.code, country.name, city.name
		, country.population as country_p, city.population as city_p
        , round(city.population / country.population * 100, 2) as percentage
from country, city
where country.code = city.countrycode
having city_p >= 5000000 and percentage >= 10
order by percentage desc;

# sub query에서 필터링 후 join하는 방법
select country.code, country.name, city.name
		, country.population as country_p, city.population as city_p
        , round(city.population / country.population * 100, 2) as percentage
from country, (select * from city where population >= 5000000) as city
where country.code = city.countrycode
having percentage >= 10
order by percentage desc;

# 5. 인구밀도가 200이상인 국가중에 사용하는 언어의 갯수가 2개인 국가들을 출력
# (1) 인구밀도(density) surface(country)
# (2) 사용하는 언어가 2개인 국가를 출력 : countrylanguage를 join
# (3) 국가를 기준으로 group by, count() > having = 2
# (4) 인구밀도를 출력하는 쿼리를 view로 생성

# group_concat()
select ct.name, max(ct.density) as density, count(cl.language) as language_count
	, group_concat(cl.language) as language_list
from (
	select code, name, population / surfacearea as density
	from country
	having density >= 200
) as ct
join countrylanguage as cl
on ct.code = cl.countrycode
group by ct.name
having language_count = 2;

create view density as
select code, name, round(population / surfacearea, 2)as density
from country
having density >= 200;

select * from density;

select ct.name, max(ct.density) as density, count(cl.language) as language_count
	, group_concat(cl.language) as language_list
from density as ct
join countrylanguage as cl
on ct.code = cl.countrycode
group by ct.name
having language_count = 2;

# 6. 한국과 미국의 인구와 GNP를 세로로 출력하세요.

# if, sub-query, union

# category    | KOR      | USA
# population  | 46800000 | 27800000
# gnp         | 320000   | 8500000

select "poplation" as category, sum(ct.KOR) as KOR, sum(ct.USA) as USA
from (
	select 
		if(code="KOR", population, 0) as KOR,
		if(code="USA", population, 0) as USA,
		1 as tmp
	from country
) as ct
group by tmp
union
select "gnp" as category, sum(ct.KOR) as KOR, sum(ct.USA) as USA
from (
	select 
		if(code="KOR", gnp, 0) as KOR,
		if(code="USA", gnp, 0) as USA,
		1 as tmp
	from country
) as ct
group by tmp;





























