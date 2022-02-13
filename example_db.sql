-- create database called example_db
-- employee table has emp id, name, and age
-- address table has address id, address street, city, state, fk_emp_id, timestamp with a default value of time now.
-- constraints fk in address table for employee table

create database example_db;
use example_db;

create table employee (
	emp_id int(4) primary key auto_increment,
-- 	the 4 here sets the "width" of the column
	name varchar(255) not null default "MISSING",
	age tinyint check(age >= 0)
);
describe employee;

insert into employee (`name`, `age`) values("keith", 25);
insert into employee (`name`, `age`) values("jafer", 1);
insert into employee (`name`, `age`) values("reema", 45);
insert into employee (`age`) values(33);
select * from EMPLOYEE;


create table address (
	address_id int(11) primary key auto_increment,
	address_street varchar(255) not null default "UNKNOWN",
	city varchar(255) not null default "UNKNOWN",
	state char(2) not null default "??",
	timestamp TIMESTAMP not null default NOW(6),
	fk_emp_id int(4),
	constraint some_name foreign key(fk_emp_id) references employee(emp_id)
);
select * from address;

insert into address (`address_street`, `city`, `state`, `fk_emp_id`)
values ("123 Street", "Plano", "TX", 2);
select * from address;