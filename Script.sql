use classicmodels;
describe offices;
select * from employees;

select * from employees where employeenumber = 1102;

-- This gives you the number of rows in orders table:
select count(*) from orders;

-- --This is how you comment a single line.
/* 
*This is how you comment multiple lines,
*because it's longer than 1 line and,
when you have a lot to say.
*/

select contactFirstName, customerNumber from customers;
select contactFirstName as `First Name`, customerNumber as `Last Name` from customers;
-- 
-- for readability, it's good to split commands onto separate lines.
select contactFirstName as `First Name`, customerNumber as `Last Name` 
from customers
order by contactfirstname;

-- check out how count works for these different arguments:
select * from offices;
select count(*) from offices;
select count(addressline2) from offices;
select count(country) from offices;

select * from orderdetails;
select distinct ordernumber from orderdetails;

describe offices;
select * from offices;
insert into offices values("8", "Plano", "5553334444", "123 Street", null, "TX", "USA", "12345", "NA");
select * from offices where officeCode = "8";
delete from offices where officeCode = "8";

insert into offices (`officeCode`, `city`, `phone`, `addressLine1`, `country`, `postalCode`, `territory`)
values
("8", "Plano", "5554443333", "123 Street", "USA", "12345", "NA")
;

insert into offices  (`officeCode`, `city`, `phone`, `addressLine1`, `country`, `postalCode`, `territory`)
values
("9", "Plano", "5553334444", "123 Street", "USA", "12345", "NA"),
("10", "Plano", "5553334444", "123 Street", "USA", "12345", "NA")
;

insert into offices values("11", "Plano", "5553334444", "123 Street", null, "TX", "USA", "12345", "NA");

-- This is one way to delete 3 lines (8-10) where cities are Plano:
select from offices where city = "Plano";
delete from offices where city = "Plano";
-- 
-- This is a safe way to delete those 3 lines while leaving a chance to commit or rollback the delete:
start transaction;
delete frmo offices where city = "Plano";
-- commit;
-- rollback

select * from offices;

-- 
-- where clauses are SO IMPORTANT because if you don't specify the WHERE you, for example, DELETE IT ALL!!
-- Jafer likes to do a select clause before a delete to see exactly what will be deleted.

