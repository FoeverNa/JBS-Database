# CRUD : CREATE READ(SELECT) UPDATE DELETE
CREATE DATABASE test; # database 대신 table이 올 수 있다

SHOW DATABASES;

use test;
SELECT DATABASE(); # 현재 사용하고 있는 데이터베이스를 조회하는 함수

# ALTER
# 설정을 수정할 때 사용하는 것
# SHOW VARIABLES LIKE ""; #설정을 확일 할 때 사용하는 문법
SHOW VARIABLES LIKE "character_set_database";# 기본 latin1이지만 UTF-8로 바꾸어줘야 한다
ALTER DATABASE test CHARACTER SET = utf8; #다시 확인해보면 바뀐것을 알 수 있다

# ALTER: ADD, MODIFY, DROP
USE jbs;
DESC user2;
ALTER TABLE user2 ADD tmp TEXT; # tmp Columns을 추가한다
ALTER TABLE USER2 MODIFY COLUMN tmp INT;
ALTER TABLE user2 DROP tmp;
# 다른 프로그램 사용하면 더 쉽게 사용할 수 있지만 업종에 따라 직접 쿼리문 작성해야 되는 상황도 있기 때문에 직접 해보는걸 권장

#DROP
DROP DATABASE test; #옆에 네이게이터 바에도 바로 적용된다

USE jbs;
DROP TABLE user1; # userse가 안지워지는 이유는 users에 관계선이 연결되어 있기 때문이다. 지우려면 관계를 제거해하고 지워야 한다
SHOW TABLES;

DESC user2;

# INSERT(CREATE) CRUD
# 이건 day2 자료를 참고

# UPDATE
UPDATE user2
SET email = "jin@gmail.com"; # 전체 eamil을 바꾸는 것이기 때문에 쿼크벤치에서 에러 발생시켜 막아준다.
# 데이터베이스를 수정 하는 경우 위 쿼리문 같이 커다란 실수가 발생할 수 있다
# 그렇기 때문에 작업하기전에 백업해야하고 작업시에도 LIMIT통해 순차적으로 바꿔가는게 좋다


UPDATE user2
SET email = "jin@gmail.com" # 어떻게 바꿀 것인가
WHERE name = "jin" # 어떤 데이터를 바꿀 것인가
LIMIT 1;

UPDATE user2
SET email = "peter@gmail.com"
WHERE name = "peter"; # LIMIT을 꼭 사용해야하는 걸까?

use jbs;
SELECT * from user2;

#DELETE #데이터 정의어 데이터 제어, 데이터 컨트롤
SELECT * FROM user2;
DELETE FROM user2
WHERE rdate > "2020-10-26 10:00:00" #WHERE 절 다음에 SELECT FROM을 할 수도 있다
LIMIT 5; #리스트에서 위에서 5개 까지만 적용하겠다 # 앞에서 배운 것과 똑같이 적용 된다

TRUNCATE user2; # 스키마만 남기고 모두 삭제 # 데이터 정의어
SELECT * FROM user2;
 
DROP TABLE user2; #테이블 까지 모두 삭제 # 데이터 정의어

# FOREGIN KEY
# 사용이유 : 데이터 무결성을 지키기 위해서
# 데이터 무결성 : 중복값이 없도록 지켜주는 UNIQUE 같은 기능

#FOREGIN KEY 설정하려면 Column이 uinique, primary 제약 조건이 필요하다
#primary는 key는 테이블 내의 각행들을 구별하기 위한 key로 그자체로 uniuque한 특성을 가진다

# user, money
USE jbs;
DROP TABLE user;
DROP TABLE money;

create table user(
	user_id INT PRIMARY KEY AUTO_INCREMENT, # UNIQUE로 설정해도 된다
    name VARCHAR(20),
    addr VARCHAR(20)
);

ALTER TABLE user CHANGE name2 name VARCHAR(20); # Colum 명 변경
DESC user;
DESC money;

create TABLE money(
	money_id int PRIMARY key AUTO_INCREMENT, #primary 안붙여도 상관이 없다
    income INT,
    user_id INT
);

INSERT INTO user(name, addr)
VALUES ("jin", "seoul"), ("andy", "pusan");
SELECT * FROM user;

TRUNCATE TABLE money;
INSERT INTO money(income, user_id)
VALUES (5000, 1), (6000, 2);
SELECT * FROM money;

#FOREIGN KEY 확인
INSERT INTO money(income, user_id)
VALUES (7000, 3);   #forein key 생성과 함께 에러가 발생함

# FOREIGN KEY 연결 방법
# 방법1 테이블 내용을 지우고 테이블 수정
TRUNCATE money;
SELECT* FROM money;
DESC money;
#테이블 수정
ALTER TABLE money
add CONSTRAINT fk_user #제약 조건을 걸어준다, 연결자의 식별자라고 이해해주면됨
FOREIGN KEY (user_id) # money의 user_id
REFERENCES user (user_id); #user의 user_id

DESC money; # user_id가 MUL이 된다 MUL(Multiple Occurences Column)

# 방법2 테이블 생성시 fk 설정
DROP TABLE money;
CREATE TABLE money(
	money_id INT PRIMARY KEY AUTO_INCREMENT, #primary 안붙여도 상관이 없다
    income INT,
    user_id int,
    FOREIGN KEY (user_id) REFERENCES user(user_id) # table에서 바로 foreing key 설정
);

DESC money;

#데이터 삭제
SELECT*FROM money;
DELETE FROM money
WHERE user_id =2
LIMIT 1; # money는 참조하고 있는 것이니 값을 지워도 상관이 없다 

SELECT*FROM user;
DELETE FROM user
WHERE user_id =1; # money에서 참조하고 있기에 삭제가 불가능하다

DELETE FROM user
WHERE user_id =2;
SELECT*FROM user; # money에서 2를 삭제해서 참조값이 없어져서 삭제가 가능하다

DROP TABLE user; # 참조값이 있기 때문에 table자체도 지워지지 않는다. 참조하고 있는 애를 다지워야 삭제 가능

# ON DELETE, ON UPDATE 설정
# 참조를 받는 (user table) 데이터가 수정하거나 삭제 될 때 참조 하는 데이터를 설정(수정, 삭제 등등)
# 옵션
# CASCADE : 참조 받는 데이터를 수정, 삭제 하면 참조하는 데이터도 수정 삭제
# SET NULL : 참조 받는 데이터가 수정 삭제되면, 참조하는 데이터는 NULL로 수정
# 이외에도 3개가 더있다 -> 강의안 참고

# 업데이트 되면 업데이트(CASECASE), 삭제되면 NULL 값으로 수정(SET NULL)하는 예재
SELECT * FROM user;
INSERT INTO user(name,addr) VALUE("peter","incheon");

#money 삭제 후 설정 추가해서 다시 생성
DROP TABLE money;
CREATE TABLE money(
	money_id INT PRIMARY KEY AUTO_INCREMENT, 
    income INT,
    user_id int,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);

DESC money;

INSERT INTO user(name,addr)
VALUES ("andy", "pusan");
SELECT * FROM user;

INSERT INTO money(income, user_id)
VALUE (5000, 1), (6000, 3), (7000, 4);
SELECT * FROM money;

# user 업데이트
UPDATE user
SET user_id = 5
WHERE user_id =1;
SELECT * FROM user; # user_id 1이었던게 5로 변경됨 // on_update안 붙엇을 땐 변경이 안되었다
SELECT * FROM money; # update 반영됨

# user 데이터 삭제
# 삭제된 데이터 에만 Null로 두는건 다른 데이터는 남기고 싶을 때 하면 된다

DELETE FROM user
WHERE user_id =3;
SELECT * FROM user; # 3이 지워지고 4,5만 남음
SELECT * FROM money; # user_id가 3인것만 지여져서 NULL로 채워지고 나머지는 데이터가 남아있는다

# FUNCTIONS

# CEIL, ROUND, TRUNCATE(Funtion에서는 버림)
SELECT ceil(12.345); #13 #올림
SELECT ceil(12.345*100)/100; # 자릿수표시 X // 소숫점 자리수 맞춰서 올림할때는 이런식으로 수식을 통해해야 한다
SELECT round(12.345); # 12 # 반올림
SELECT round(12.345, 2); #12.35
SELECT truncate(12.345, 2); # 3번째 자리에서 버림, truncate()는 자릿수를 반드시 표기해야 한다

# 국가별 언어 사용 비율을 올림, 반올림, 버림 하는 예제
use world;
SELECT countrycode, language, percentage
	, ceil(percentage)
    , round(percentage)
    , truncate(percentage,0)
FROM countrylanguage;

# DATE FORMAT
USE sakila; #DVD 렌탈 서비스
SELECT sum(amount) as income, date_format(payment_date, "%Y-%m")as monthly # 강의안 참고문헌에 foramting더 포함되어 있다 
FROM payment
GROUP BY monthly
ORDER BY income DESC;

# 시간대별
SELECT sum(amount) as income, date_format(payment_date, "%H") as hourly
from payment
GROUP BY hourly
ORDER BY income DESC;

# 조건문 : IF, IFNULL, CASE
USE world;
# 도시의 인구가 500만이 넘으면 "big city", 아니면 "small city"를 출력하는 컬럼 추가
SELECT countrycode, name
	, if(population >= 5000000, "big city", "small city") # if(조건, 참, 거짓), 삼항연산자랑 비슷
FROM city
WHERE population > 800000
ORDER BY population DESC;

#참고 : Workbench에 자동으로 결과값 Limit이 걸려있다
#만약에 엄청큰 DB를 LIMIT 없으면 20만개 다나올수 있으니 shell에서 할때는 LIMIT 걸어서 해라. 오래걸린다 

#ifnull
#독립연도에 값이 null인 것을 0으로 바꾸고 싶다
SELECT code, name, indepyear
	,ifnull(indepyear, 0) # ifull(조건, null이면 바꿔줄 값)
FROM country;

# case when then end
# 국가 인구가 10억 이상 "leve3", 1억 이상 "leve2", 1억 이하 "level1"
SELECT code, name, population
	,CASE  # if ~else 문과 비슷하다
    WHEN population >= 100000000 THEN "level3"
    WHEN population >= 10000000  THEN "level2"
    ELSE "level1"
    END as scale
FROM country
where population > 8000000
ORDER BY population DESC;

# 미국과 한국의 국가코드와 인구수 GNP 출력, 피봇팅해서 출력
# 피봇팅 : 테이블 가로세로 축을 바꾸는 것
# 아직은 못하는데 일단 한버 ㄴ봐봐

SELECT code, name, population, gnp
FROM country
WHERE code in ("USA", "KOR");

# use WORLD; DB명은 대문자 사용이 불가능 하다

# JOIN
CREATE DATABASE test;
use test;
CREATE TABLE user(
	name VARCHAR(20),
    addr VARCHAR(20)
);

CREATE TABLE money(
	name VARCHAR(20),
    income INT
);

INSERT INTO user(name, addr)
VALUES("A", "seoul"), ("B", "pusan"), ("C", "incheon");
SELECT * FROM user;

INSERT INTO money(name, income)
VALUES("A", "100"), ("B", "200"), ("B", "300"), ("D", "400");
SELECT * FROM money;

#inner join # join앞에 아무것도 쓰지 않으면 inner join이 된다
SELECT user.name, user.addr, money.income
FROM user # LEFT
JOIN money # RIGHT
ON user.name = money.name; #기준이 되는 컬럼, 결합이 되는 컬럼
#두개의 공통 요소인 A와 B의 내용만 출력

#left join
SELECT user.name, user.addr, money.income 
FROM user 
LEFT JOIN money # LEFT라고 표시
on user.name = money.name;
# LEFT를 기준으로 JOIN, LEFT의 모든 요소만 표시된다 (A,B,C)

#right join
SELECT money.name, user.addr, money.income # user.name은 포함되지 않음
FROM user 
RIGHT JOIN money # RIGHT라고 표시
on user.name = money.name;
# RIGHT를 기준으로 JOIN, RIGHT의 모든 요소만 표시된다 (A,B,D)

#MySQL은 Outer join이 없다
# UNION을 통해 Full Outer join은 구현할 수 있다ALTER

#city 테이블과 country 테이블 join해서
#city 인구가 500만이 넘는 도시의 국가코드, 국가이름(countryTABLE값), 도시이름, 인구수를 출력
USE world;
SELECT city.countrycode, country.name, city.name, city.population
FROM city
JOIN country 
ON city.countrycode = country.code
	AND city.population >= 5000000;
#inner.join 케이스

#join 생략하고 join하는 방법 -> 여러개의 테이블을 join할 때 사용한다
USE world;
SELECT city.countrycode, country.name, city.name, city.population
FROM city, country # from을 ,로 구분하여 join을 표시할 수 있다(여러개 join도 가능)
WHERE city.countrycode = country.code #join을 안쓴경우 WHERE을 사용한다
	AND city.population >= 5000000;

#국가별, 도시별, 언어 사용율 출력
SELECT country.name as country_name
		,city.name as city_name
        ,cl.language, cl.percentage
        ,(cl.percentage * city.population) / 100 as lpp #도시별 언어사용자 인구수를 구하는 수식
FROM country, city, countrylanguage as cl #3개의 테이블 수만큼 나열된 테이블이 생성된다
WHERE country.code = city.countrycode
		AND country.code = cl.countrycode
        AND country.code in ("USA", "KOR");
        
# union : select 결과를 합쳐서 출력할 때 사용
# union : 자동으로 중복제거
# union all : 중복 제거 X
USE test;

SELECT name
FROM user
union      # 중복 제거한 값
SELECT name
FROM money;

SELECT name
FROM user
union all  # 중복 제거하지 않은 전체 값
SELECT name
FROM money;        

# 위의 나온 UNION의 특징을 활용해 full outer join을 할 수 있다
# left join UNION right join 하면 중복제거가 된 값이 join된다
SELECT user.name, user.addr, money.income
from user
left join money
on user.name = money.name
UNION
SELECT money.name, user.addr, money.income
FROM user
RIGHT JOIN money
ON user.name = money.name;

#OUTER만 출력하는 것은 오라클에서는 되고 MySQL에서는 안된다











