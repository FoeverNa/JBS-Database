# SELECT FROM
# SELECT는 컬럼을 선택
SELECT code, name, population
FROM world.country; 

#사용할 DB를 선택
USE world; 
SELECT code, name, population
FROM country;

# WHERE : 비교연산, 논리연산
# 인구가 1억 이상인 국가 데이터 출력
SELECT code, name, population
FROM country
WHERE population >= 100000000;

# 인구가 2억 ~ 3억인 국가를 출력
SELECT code, name, population
FROM country
WHERE population >= 200000000 AND population <= 300000000;

# BETWEEN
SELECT code, name, population
FROM country
WHERE population BETWEEN 200000000 AND 300000000; 

# 아시아와 아프리카대륙의 국가 데이터 출력
SELECT code, name, continent, population
FROM country
WHERE (continent = "Asia" OR continent = "Africa")
AND population >= 100000000;

# IN = OR 조건문
SELECT code, name, continent, population
FROM country
WHERE continent IN ("Asia","Africa");

#NOT IN은 NOT OR
SELECT code, name, continent, population
FROM country
WHERE continent NOT IN ("Asia","Africa");

# LIKE : 특정 문자열이 포함된 데이터를 출력
# 정부형태가 Republic 인 국가를 출력
SELECT code, name, governmentform
FROM country
WHERE governmentform Like "%Republic%";
# &은 문자가 올수있다는 표시

# ORDER BY : 데이터 정렬
# 국가 데이터를 인구수 순으로 오름차순으로 정렬
SELECT code, name, population
FROM country
ORDER BY population ASC; #ASC는 오름차순 (생략가능)

# 내림차순
SELECT code, name, population
FROM country
ORDER BY population DESC;
#DESC는 내림차순

# 기준 컬럼을 여러개 설정 : 1번째 조건으로 소팅 > 같으면 2번째 조건으로 소팅
# city 테이블에서 국가 코드 순으로 정렬(오름차순)하고 국가 코드가 같으면 인구수(내림차순) 순으로 정렬
SELECT countrycode, name, population
FROM city
WHERE countrycode IN ("USA", "KOR", "JPN")
ORDER BY countrycode ASC, population DESC;

# LIMIT : 조회하는 데이터의 수를 제한
# 인구가 많은 상위 5개 도시를 출력
SELECT countrycode, name, population
from city
ORDER BY population DESC
LIMIT 5;


# LIMIT 5, 2 : 앞에 5개의 데이터를 스킵하고 뒤에 2개 데이터를 출력
SELECT countrycode, name, population
from city
ORDER BY population DESC
LIMIT 5,2; # 6위 7위 데이터가 출력
# 5개 자르고 2개 출력

SELECT 10 / 5;

# 한국(KOR)의 경기도(Kyonggi)에 해당하는 도시에서 
# 인구가 많은 3개의 도시를 출력
SELECT *
FROM city
WHERE countrycode = "KOR" AND district = "Kyonggi"
ORDER BY population DESC
LIMIT 3;

# 동북아시아에서 인당 GNP가 높은 5개 나라를 출력
SELECT code, name, gnp, Population
, (gnp/population) AS gnp_per_population
FROM country
WHERE region = "Eastern ASIA"
ORDER BY gnp_per_population DESC
LIMIT 5;

# 인구밀도가 높은 국가 6위에서 ~ 10위 까지 출력
SELECT code, name, population, surfacearea
		, (population/surfacearea) AS Density
FROM country
ORDER BY Density DESC
LIMIT 5,5;

# GROPU BY : 특정 칼럼의 동일한 데이터를 합쳐주는 방법
# 데이터를 합칠 때 다른 컬럼들에 대한 처리는 그룹함수를 이용합니다
# COUNT, MAX, MIN, AVG, VAR_SAMP(분산), STDDEV(표준편차)
# COUNT : city 테이블에서 국가별 도신의 갯수를 출력
SELECT countrycode, COUNT(countrycode)
FROM city
GROUP BY countrycode;

# MAX : 대륙별 인구수와 GNP의 최대값을 출력
SELECT continent, MAX(population), MAX(GNP)
FROM country
GROUP BY continent;

# SUM : 대륙별 전체 인구수와 전체 GNP, 인당 GNP를 출력
SELECT continent, SUM(population), SUM(GNP)
		, SUM(GNP) / SUM(population) AS gpp 
FROM country
GROUP BY continent;

# AVG : 대륙별 평균 인구수와 평균 GNP 인구순으로 내림차순 정렬
SELECT continent, AVG(population) as population
		, AVG(GNP) as gnp
FROM country
WHERE population != 0 AND gnp != 0 #as는 Where에서 원래 못쓴다
GROUP BY continent
ORDER BY AVG(population) DESC;

# HAVING : GROUP BY 로 출력되는 결과를 필터링할때 사용
# 대률별 전체 인구수를 출력하고 대륙별 2억 이상이 되는 대륙만 출력
SELECT continent, SUM(population) as sum_population
FROM country
#WHERE sum_population >= 20000 #Group by에 결과를 필터링할 수 없음
GROUP BY continent
HAVING sum_population >= 500000000;

# 1. 언어별 사용하는 국가의 수를 조회 많이 사용되는 언어 6위 ~ 8위 출력
SELECT language, COUNT(language) as count
FROM countrylanguage
GROUP BY language
ORDER BY count DESC
LIMIT 5,3;

# 2. 대륙별 나라의 갯수를 출력하고 국가 많은 대륙 1위 ~ 3위 까지 출력
SELECT continent, count(continent) as count
FROM country
GROUP BY continent
ORDER BY count DESC
LIMIT 3;

# 3. CITY 테이블에서 국가코드별 총인구를 출력, 총인구순으로 내림차순 정렬
# 총 인구가 5천만 이상인 국가코드만 출력 하세요.
SELECT countrycode,  SUM(population) as total_population
FROM city
GROUP BY countrycode
HAVING total_population >= 50000000
ORDER BY total_population DESC;

USE jbs;
SELECT DATABASE(); # 현재사용하고 있는 데이터 출력이 된다

CREATE TABLE user1(
	user_id INT, #컬럼명 데이터타입, 제약조건
    name VARCHAR(20),
    email VARCHAR(30),
    age INT(3),
    rdate DATE
);

show tables;
desc user1;

CREATE TABLE user2(
	user_id INT PRIMARY KEY AUTO_INCREMENT, #2개는 띄어쓰기로 구분
    name VARCHAR(20) NOT NULL,
    email VARCHAR(30) UNIQUE NOT NULL, #UNIQUE뒤에는 NOTNULL해주어야된다안하면NULL들
    age INT(3) DEFAULT 30,
    rdate TIMESTAMP
);

show tables;
DESC user2;

# INSERT : 데이터 추가
INSERT INTO user1(user_id, name, email, age, rdate)
VALUES(1, "andy", "andy@gamil.com", 23, now());

INSERT INTO user1(user_id, name, email, age, rdate)
VALUES(2, "jin", "andy@gamil.com", 23, nowuser1itemsuser1()),
(3, "peter", "andy@gamil.com", 23, now()),
(4, "jhon", "andy@gamil.com", 23, now());

SELECT * FROM user1;

INSERT INTO user2(name, email)
VALUES("andy", "andy@gamil.com");

INSERT INTO user2(name, email)
VALUES("jin", "andy2@gamil.com"),
("peter", "andy3@gamil.com"),
("tom", "andy4@gamil.com");name

SELECT * FROM user2;

DESC user2; #Description table -> 테이블 설명, 위치에 따라 다른역할한다

# SELECT 문을 실행한 결과를 INSERT
USE world;

CREATE TABLE city2 (
	Name VARCHAR(50),
    CountryCode CHAR(3),
    Population INT
);

SELECT Name, CountryCode, Population
FROM city
WHERE Population >= 8000000;

INSERT INTO city2
SELECT Name, CountryCode, Population
FROM city
WHERE Population >= 8000000;

SELECT * from city2;

DROP TABLE city2; # 삭제

show tables;
DROP TABLE user1;
show tables;




