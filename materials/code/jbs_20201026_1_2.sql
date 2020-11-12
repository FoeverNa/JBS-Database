# CRUD : CREATE READ(SELECT) UPDATE DELETE

# create use alter drop
create database test;
show databases;
use test;
select database();

# ALTER
show variables like "character_set_database";
alter database test CHARACTER SET = utf8;
alter database world CHARACTER SET = utf8;

# ALTER : ADD, MODIFY, DROP
use jbs;
desc user2;
alter table user2 add tmp text;
alter table user2 modify column tmp int;
alter table user2 drop tmp;

# DROP
drop database test;

use jbs;

drop table user1;

show tables;

desc user2;

# INSERT(create)

# UPDATE
update user2
set email="jin@gmail.com", age=22
where name in ("jin", "andy")
limit 2;

select * from user2;

select * from user2
where name="jin";

# DELETE
select * from user2;
delete from user2
where rdate > "2020-10-25"
limit 5;

delete from user2
where rdate < "2020-09-25"
limit 5;

truncate user2;
select * from user2;

drop table user2;

# foreign key
# 사용이유 : 데이터 무결성을 지키기 위해서
# foreign key 설정 하려면 컬럼이 unique, primary 제약조건이 필요

# user, money
use jbs;
create table user(
	user_id int primary key auto_increment,
    name varchar(20),
    addr varchar(20)
);
desc user;
create table money(
	money_id int primary key auto_increment,
    income int,
    user_id int
);

insert into user(name, addr)
values ("jin", "seoul"), ("andy", "pusan");
select * from user;

insert into money(income, user_id)
values (5000, 1),(6000, 2);

select * from money;

insert into money(income, user_id)
values (7000, 3);

truncate money;
select * from money;
desc money;

# 테이블 수정으로 FK 설정
alter table money
add constraint fk_user
foreign key (user_id) # money의 user_id
references user (user_id); # user의 user_id

desc money;

# 테이블 생성시 FK 설정
drop table money;
create table money(
	money_id int primary key auto_increment,
    income int,
    user_id int,
    foreign key (user_id) references user(user_id)
);
desc money;

# 데이터 삭제
select * from money;
delete from money
where user_id = 2
limit 1;

# 다른 테이블에서 데이터를 참조하고 있으면 삭제하지 못함
select * from user;
select * from money;
delete from user
where user_id = 1;

delete from user
where user_id = 2;

drop table user;

# ON DELETE, ON UPDATE 설정
# 참조를 받는 데이터가 수정하거나 삭제될때 참조 하는 데이터를 설정(수정,삭제 등등)
# CASCADE : 참조 받는 데이터가 수정 삭제하면, 참조하는 데이터도 수정 삭제
# SET NULL : 참조 받는 데이터가 수정 삭제하면, 참조하는 데이터는 NULL로 수정

# 업데이트 되면 업데이트(cascade), 삭제되면 NULL값으로 수정(set null) 
select * from user;
insert into user(name, addr) values ("peter", "incheon");

drop table money;
create table money(
	money_id int primary key auto_increment,
    income int,
    user_id int,
    foreign key (user_id) references user(user_id)
    on update cascade on delete set null
);
desc money;
insert into money(income, user_id)
values (5000, 1),(6000, 3);

select * from user;
select * from money;

# user 업데이트
update user
set user_id = 4
where user_id = 1;

# user 데이터 삭제
delete from user
where user_id = 3;













































use sakila;
select count(*)
from customer_list
where country="India";

select * from customer_list;

use world;
select count(distinct(continent))
from country;

select count(distinct(continent))
from country;

select count(*)
from 
	(select continent
	from country
	group by continent) as ct;
use sakila;
select title, description, category, length, price
from film_list
where price between 1 and 4 and length >= 180 and category not in ("Sci-Fi", "Animation")













