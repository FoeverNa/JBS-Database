# sub Query
# 쿼리문안에 쿼리문이 들어가는 구조
# 쿼리문이 복잡해지기 시작한다

use world;

# sub query : select, from, where

# 전체 나라수, 도시수, 언어수를 출력
SELECT count(*) from country;
SELECT count(*) from city;
SELECT * from countrylanguage; #중복을 제거해주고 갯수를 세주어야한다
SELECT count(distinct(language)) from countrylanguage;

#위의 코드를 sub query를 통해 한번에 사용
SELECT (SELECT count(*) from country) as total_country,
( SELECT count(*) from city) as total_city,
( SELECT count(DISTINCT(language)) from countrylanguage)
as total_language
FROM dual; # from절에 들어가는게 없을때 dual을 사용한다
# 이런식으로 쿼리를 겹쳐서쓰는것을 서브쿼리라고 한다
# 원래는 from을 써야하는데 워크벤치에서는 생략해도 사용이 가능하다

# 800만 이상이 되는 도시의 국가코드, 국가이름, 도시인구수를 출력
# sub쿼리 쓰지 않은 방식
SELECT city.countrycode, country.name, city.population
FROM city # 4079
JOIN country # 239 => join시 4079 x 239 테이블이 생김(비효율발생)
ON city.countrycode = country.code
HAVING city.population >= 8000000;

#sub 쿼리통해 미리 수를 줄이는 방식
SELECT city.countrycode, country.name, city.population
FROM (SELECT * from city where population >= 8000000) as city #10
JOIN country # 239 지금은 차이가 크지않을수도 있지만 나중에 큰데이터에서는 엄청난 차이발생
ON city.countrycode = country.code;

# WHERE 절에서 subquery
# 800만 이상 도시를 가진 국가의 국가코드, 국가이름, 대통령이름을 출력
SELECT distinct(countrycode) FROM city where population >= 9000000;

SELECT code, name, headofstate  
FROM country
WHERE code in ("BRA", "IDN", "IND"); # 위 쿼리의 결과를 하나하나 처주어야 한다

SELECT code, name, headofstate  
FROM country
WHERE code in ( # BRA, IDN, IND...)
	SELECT distinct(countrycode)
    FROM city
    where population >= 9000000
);
# WHERE 절에 위의 쿼리를 넣어버리면 따로 입력할 필요없이 바로 사용할 수 있다

# VIEW : 가상 테이블, 테이블 처럼 사용할 수있지만 실제로 데이터를 가지고 있지 않는다
# 실제데이터는 테이블에 있고 실제 데이터를 참조해서 사용한다
# 실제 데이터를 저장하지 않습니다. 수정 및 인덱스 설정이 불가능
# 쿼리를 단순하게 만들어 주기 위해서 사용 된다.(복잡한 쿼리를 간소화 할 수 있다)

# 국가코드와 국가 이름이 있는 뷰
# create view code_name as 
CREATE VIEW code_name_k as
SELECT code, name
FROM country
WHERE code like "k%";

SELECT * FROM code_name_k;

#city table에 나라이름이 K로 시작하는 도시만 구하기
SELECT *
from city
join code_name_k
ON code_name_k.code = city.countrycode;
#원래대로 하려면 더긴 쿼리가 되겠지만 많이 줄여줄 수 있다

#sub쿼리, join, index를 쓰면서 SQL이 시작된다

# 연습 문제

# 1. 멕시코(Mexico) 보다 인구가 많은 나라의 이름과 인구수를 조회하고 인구수 순으로 정렬
# 멕시코 인구수는 업데이트 될 수 있습니다. 
# 정확한 숫자를 입력하는게 아니라 테이블내에서 가져와서 풀어라

SELECT name, population
FROM country
where population >= (
	select population
	from country
	where name = "Mexcico"
)
ORDER BY population DESC;
#이것도 안됬네

# 2. 국가별 몇개의 도시가 있는지 출력하고 10위까지 내림차순(도시수)으로 정렬
# 국가명, 도시수 # 테이블 위치확인하고 테이블 다른위치에있으면 join부터 한다
# join, group by
SELECT country.name, count(city.name) as count
FROM city
JOIN country
ON city.countrycode = country.code
GROUP BY country.name
ORDER BY count DESC
LIMIT 10;
#복습 필수이겠다 혼자 풀어볼려니 각각 사용하는 문법도 햇깔린다
#하나씩 문제를 해결해나가면 된다고강사님이 하신다

# 3. 언어별 사용인구수를 출력하고 사용인구순으로 상위 10개의 언어를 출력
# 언어, 사용인구(country 테이블의 population)
# 국가별 언어별 사용인구 데이터 만들기 > 언어별 그룹핑(sum)
SELECT  country.name, countrylanguage.language
	, (country.population * countrylanguage.percentage) as usingpopulation
    , sum(usingpopulation)
from country
join countrylanguage
on country.code = countrylanguage.countrycode
GROUP BY countrylanguage.language; 
#내가 푼것 => 못풀었음
#group by로 하는건 내가찾아서 해보기

select sub.language, sum(sub.count) as population
from(
SELECT ct.code, cl.language
	, round(ct.population * cl.percentage * 0.01) as count
from country as ct
join countrylanguage as cl
on ct.code = cl.countrycode
) as sub
GROUP BY sub.language
ORDER BY population DESC
limit 10;

#(as많이 쓰니까 쿼리문 가독성 올라가고 도움되는것 같다)

# 4. 국가 인구의 10% 이상의 인구가 있는 도시에서 도시인구가 500만 이상인 도시를 출력
SELECT ct.code , ct.name, city.name, ct.population
        , (ct.population / city.population *100)
from country as ct
join city
on ct.code = city.countrycode
Having city.population >(ct.population* 0.1);

# join 후에 having 절에서 필터링 하는 방법
SELECT country.code, country.name, city.name
		, country.population as country_p , city.population as city_p
        , round(city.population / country.population * 100, 2) as percentage
from country, city
where country.code = city.countrycode
HAVING city_p >= 5000000 and percentage >= 10
order by percentage desc;

# sub query에서 필터링 후 join하는 방법

SELECT country.code, country.name, city.name
		, country.population as country_p , city.population as city_p
        , round(city.population / country.population * 100, 2) as percentage
from country, (SELECT * from city WHERE population >= 5000000) as city
where country.code = city.countrycode
HAVING percentage >= 10
order by percentage desc;
#(이렇게 쉽다구??)
# 아래쪽이 더 좋은 쿼리문이다

# 5. 인구밀도가 200이상인 국가중에 사용하는 언어의 갯수가 2개인 국가들을 출력 하세요
# 인구밀도(desity) surface(country) population / surface
# (2) 사용하는 언어가 2개인 국가를 출력 : countrylanguage를 join
# (3) 국가를 기준으로 group by, count()를 하면 나온다 >having =2

(select code, name, round( population / surfacearea,2) as density
from country
having density >= 200) as ctdensity;

#백엔드 개발자라면 이정도 쿼리는 작성할 수 있어야 된다.

# gropu_concat() 결합함수중에 하나
select ct.name, max(ct.density), count(cl.language) as language_count #density도 결합함수써야되서 아무거나쓴것
		, GROUP_CONCAT(cl.language) as language_list #어떤게 결합됬는지 숫자가 아닌 문자로되어있을 때 활용가능 방법
from(
SELECT code, name, population / surfacearea as density
from country
having density >= 200
) as ct
join countrylanguage as cl
on ct.code = cl.countrycode
group by ct.name
having language_count =2;

create viw density as
SELECT code, name, round(population /surfacearea, 2) as density
from country
having density >= 200;

SELECT * from country;

#뷰만들고 사용하는 것 봤는데 이해 못했다
#뷰만들어서 바로 넣기

# 6. 한국과 미국의 인구와 GNP 세로로 출력하세요

# if, sub-query, union

# category   | KOR      | USA
# population | 4680000  | 27800000
# gnp        | 32000    | 8500000

SELECT "population" as category, sum(ct.KOR) as KOR , sum(ct.USA) USA
from (
	SELECT
		if(code = "KOR", population, 0) as KOR,
		if(code = "USA", population, 0) as USA,
		1 as temp
	from country
);


#(에러)
#having은 결과 데이터에 조건을 줄 때

#다운 받는 중에 에자일 개발방법론에 대해서 설명해 주셨다

# index
# 하기전에 empolyee 데이터다운
# 파일로 옮기는것 하기위해 Cyberduck 다운
# Cyberduck에서 서버 연결
# 드래그앤 드랍으로 sql파일 넣을수있음
# sql파일을 mysql에서 실행시켜주면 데이터베이스에 값이 채워진다
# 과정은 sql파일을 서버에 복사 -> database생성
# -> 해당 database 에 sql파일에 쿼리문을 실행하도록 터미널에서 명령
# -> 쿼리문 실행되서 table만들고 해당 table에 데이터를 INSERT한다 wow
# 쿼리문을 바로 워크벤치에서 실행시킬수있지만 불안정하고 느리다(?)

#절대경로는 최상위부터 다적는것
# 상대 경로는 현재경로 기준으로 이동하는것
# tree깔았고 tree를 입력하면 파일구조파악 가능

use employees;
show tables;
SELECT count(*) from salaries;

# index : 테이블에서 데이터를 빠르게 검색할 수 있도록 도와주는 기능
# 장점 : 검색속도가 빨라짐(select 쿼리가 빨라짐)
# 단점 : 저장공간을 더 많이 차지, insert, update, delete 속도가 느려짐

# 원리
# 인덱스가 없는 경우 처음부터 찾는 곳까지 쭉 찾아야 한다(Full search)
# 컬럼을 인덱스로 사용하겠다고 추가해주면 인덱스를 따로 관리하여 거기부터 찾는다
# 그래서 용량 증가하고 속도 감소한다
# 단점도 존재하기 때문에 잘 사용해야 한다
# 사용방법 : WHERE 절에서 조건으로 사용하는 컬럼을 index로 설정하면 좋음
# 값이 잘려나가기 때문에 속도가 빨라진다
# 작동원리 : B-Tree 알고리즘으로 작동 (검색해보길)

# 0.047 sec
SELECT *
from salaries
where from_date < "1986-01-01";


EXPLAIN # index사용하는지 물어보는 예약어 #possible_keys(index이름) Extra 를 보면 index사용하는지 알 수 있다
SELECT *
from salaries
where from_date < "1986-01-01";

EXPLAIN 
SELECT *
from salaries
where from_date < "1986-01-01";

EXPLAIN 
SELECT *
from salaries
where to_date < "1986-01-01";

show index from salaries; #Cardinality가 index가 몇개인지 알수있는데 너무많으면 의미가 없다

create index fdate
on salaries (from_date);

create index tdate
on salaries (to_date);

EXPLAIN #실행계획이 생김(키값이 생김) 
SELECT *
from salaries
where from_date < "1986-01-01";

#0.062 sec
SELECT *
from salaries
where from_date < "1986-01-01";

# 0.015sec
SELECT *
from salaries
where to_date < "1986-01-01";

drop index fdate on salaries;
drop index tdate on salaries;

create index ftdate
on salaries (from_date, to_date);

SELECT *
from salaries
where from_date < "1986-01-01" and to_date < "1986-01-01";

# 두개를 같이사용할때는 두개같이 인덱스화하는게 빠르고 하나씩 쓸때가 있으면 그냥 하나씩 생성하는게 빠르다
EXPLAIN
SELECT *
from salaries
where from_date < "1986-01-01" and to_date < "1986-01-01";

# TRIGGER
# 특정 테이블을 감시하고 있다가 설정된 조건의 쿼리가 실행되면 지정한 쿼리가 자동으로 실행되도록 하는 방법
# 다른사람이 drop할거같으면 drop하기 전에 backup하기 같이
# syntax
# create trigger {trigger name}
# {before | after} {insert | update | delete} 지정해놓은 쿼리가 실행되기전에 할것인지 아니면 후에 할 것인지
#                    이것들 할때 trigger 걸수 있다
# on <table name> for each row
# begine
# 	<excute query>
# end

use jbs;

create table data1 (
	id varchar(20),
    msg varchar(50) not null
);
CREATE table data_backup(
	id varchar(20),
    msg varchar(50) not null
);

delimiter |  #특수문자 이후에 문장이 하나의 문장이라는 것을 정의해줌
create trigger backup #backup은 trigger이름
before DELETE on data1  #삭제할 때 쿼리실행
for each row
begin 
	INSERT INTO data_backup(id, msg)
    VALUES(old.id, old.msg); # 쿼리문 실행하기전 데이터는 old , 쿼리문 실행한 후데이터는 new
end |
# 왜 안되지

show triggers;

insert into data1(id, msg)
valuse ("dss", "good!"),("jbs", "nice"), ("dss", "bad!!");

select * from data1;

delete from data1
where id = "dss"
limit 10;

select * from data_backup; #한줄씩 delete되기전에 백업이 된다

# 회원이 계정 탈퇴할 때 db에서 삭제해야되는데 그 때 backup을 해놓으면 된다
# 그럼 나중에 회원이 복구해달라고 할때 복구해 줄 수 가 있다

#목요일 배울것
#1) mongdb -> log저장할때 주로 사용
#2) crontab -> 특정시간에 코드 실행(스케쥴러)
#3) back-up -> backup code를 만들어서 crontab으로 시간마다 돌리면 시간별 백업가능
#4) replication -> 동기화







