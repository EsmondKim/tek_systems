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

-- Groupbys
use classicmodels;
select * from orders as o;

select status, count(status) as `counter` 
from orders
group by status;

select status, count(status) as `counter` 
from orders
group by status
having `counter` >= 6;

select * from orderdetails;

-- a sum and a groupby
select *, sum(quantityordered*priceeach) from orderdetails as o
group by ordernumber;

start transaction;
drop table if exists example.address;
rollback

use classicmodels
select customername, creditlimit 
from customers
order by creditlimit desc;

select floor(avg(creditlimit)) from customers; 
-- Notice how this query combines the selects/avg
select customername, creditlimit 
from customers
where creditlimit >= 67556
order by creditlimit desc;
-- Now notice how you can make it dynamic with a subquery
-- It's dynamic because you can hard code in a dollar amount current avg 
-- but this dynamic subquery will self update as the average changes
select customername, creditlimit 
from customers
where creditlimit >= (select floor(avg(creditlimit)))
order by creditlimit desc;
-- the subquery should run on its own, outside the subquery.
-- So, you can write the SQ outside the query, and then merge it in.
select floor(avg(creditlimit)) from customers

-- Subqueries, slide 15, will be on SBA
SELECT orderNumber, SUM(quantityOrdered * priceEach) GR
	FROM orderdetails
	GROUP BY orderNumber
	HAVING GR >= (
		SELECT 0.9 * MAX(GR) FROM (
			SELECT orderNumber, SUM(quantityOrdered * priceEach) GR
			FROM orderdetails
			GROUP BY orderNumber) as gross);
		

select something.creditlimit 
from 
(
select customername, creditlimit 
from customers
where creditlimit >= (select floor(avg(creditlimit)) from customers) 
order by creditlimit desc
) as something;
--  KEEP SUBQUERIES STAND ALONE! THEY SHOULD RUN ON THEIR OWN!!

-- Subquery in Class Example
-- Example:
-- find all customer located in the USA and has an average credit limit greater than or equals average in the USA
-- show highest purchase order (quantityordered*priceeach) and product name
-- using classicmodels database.
use classicmodels;
-- all customers
select * from customers as c;
-- average credit limit in usa
select avg(creditlimit) from customers where country = 'USA';
-- adding the avg into a query as a subquery
-- this solves the first part of the question
select customername, creditlimit 
from customers 
where country = 'USA' 
and creditlimit >= 
(
select avg(creditlimit) from customers where country = 'USA'
);
-- second problem
-- We need cust id, product name, sum qxp
-- Examine the data to understand it 
select * from orderdetails;
select * from orders;
select * from  products; 
select * from customers; 
-- Refer to the ER Diagram when you need to to understand the data
-- Step 1Then get to work on the problem with that information and write the select and the joins
select o.customerNumber, o.ordernumber, sum(od.quantityOrdered*od.priceeach) as `highest purchase`
-- Step 3, was writing the o. selectors in the line above.
from orderdetails as od
join products as p on od.productcode = p.productCode
-- Step 2, after referring to common columns in the ERD, write your on clauses.
join orders as o on od.orderNumber = o.orderNumber
-- Step 4 is adding the groupby for the repeating element, the orderNumber
group by od.orderNumber 
-- Step 5: order the returned data for readability 
order by `highest purchase` desc;

-- Now, rewrite to combine all the info you need with correct labels.
-- Note how the subquery above runs independently
select c.customerNumber, c.customerName, sss.productname, max(sss.`highest purchase`) as `hightest purchase`  
from customers as c
join 
(
select o.customerNumber, p.productName, o.ordernumber, sum(od.quantityOrdered*od.priceeach) as `highest purchase`
from orderdetails as od
join products as p on od.productcode = p.productCode
join orders as o on od.orderNumber = o.orderNumber
group by od.orderNumber 
order by `highest purchase` desc
) as sss on c.customerNumber = sss.customerNumber 
where  c.creditlimit >= 
(
select avg(creditlimit) from customers where country = 'USA'
) and c.country = 'USA'
group by c.customerNumber 
order by `highest purchase` desc
;

-- Jafer's solution, which he slacked out to Resources
select c.customernumber as `ID`, c.customername as `Customer`,sss.productname as `Product Name`, max(sss.`highest purchase`) as `Highest Purchase`
from customers as c 
join 
(
select o.customernumber,p.productname, o.ordernumber, sum(od.quantityordered*od.priceeach) as `highest purchase`
from orderdetails as od
join products as p on od.productcode = p.productcode 
join orders as o on od.ordernumber = o.ordernumber 
group by od.ordernumber
order by `highest purchase` desc
) as sss on c.customernumber = sss.customernumber 
where c.creditlimit >= 
(
select avg(creditLimit) from customers where country = 'USA'
) and c.country = 'USA'
group by c.customernumber 
order by `highest purchase` desc
;