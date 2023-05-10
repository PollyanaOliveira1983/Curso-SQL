/*
A1. Create a database called A00123456_Project.

A2. Run the script ProjectData.sql to create the tables listed below, and to populate the tables
with data.
*/

/*
B1. List the order details where the quantity is between 65 and 70. 
Display the order id and quantity from the OrderDetails table, 
the product id and reorder level from the Products table, 
and the supplier id from the Suppliers table.
 Order the result set by the order id. The
query should produce the result set listed below.

49 registros
*/

SELECT 
	OD.OrderID,
	OD.Quantity,
	P.ProductID,
	P.ReorderLevel,
	S.SupplierID

FROM OrderDetails OD 
	INNER JOIN Products  P 
		ON (OD.ProductID = P.ProductID)
	INNER JOIN Suppliers S 
		ON (P.SupplierID = S.SupplierID)
WHERE OD.Quantity BETWEEN 65 AND 70
ORDER BY OD.OrderID

/*
B2. List the product id, product name, English name, and unit price from the Products table
where the unit price is less than $8.00. 
Order the result set by the product id. The query
should produce the result set listed below.

6 registros
*/

SELECT 
	P.ProductID,
	P.ProductName,
	P.EnglishName,
	P.UnitPrice

FROM Products AS P
WHERE P.UnitPrice < 8.00
ORDER BY P.ProductID

/*
B3. List the customer id, company name, country, and phone from the Customers table where the country is equal to Canada or USA. 
Order the result set by the customer id. The query should produce the result set listed below.
16 REGISTROS
*/

SELECT 
	C.CustomerID,
	C.CompanyName,
	C.Country,
	C.Phone
FROM Customers AS C
WHERE C.Country = 'CANADA' OR C.Country = 'USA' --C.Country IN ('','')
ORDER BY C.CustomerID


/*
B4. List the products where the reorder level is equal to the units in stock. 
Display the supplier id and supplier name from the Suppliers table, 
the product name, reorder level, and units in stock from the Products table. 
Order the result set by the supplier id. The query should produce the result set listed below.
(4 row(s) affected)
*/

SELECT 
	S.SupplierID,
	S.Name AS 'NAME SUPPLIER',
	P.ProductName,
	P.ReorderLevel,
	P.UnitsInStock
FROM Products AS P
	INNER JOIN Suppliers AS S
		ON P.SupplierID = S.SupplierID
WHERE P.ReorderLevel = P.UnitsInStock
ORDER BY S.SupplierID

/*
B5. List the orders where the shipped date is greater than or equal to 1st of Jan 1994, 
and calculate the length in years from the shipped date to 1st of Jan 2009. 
Display the order id, and the shipped date from the Orders table, 
the company name, and the contact name from the Customers table, and the calculated length in years for each order. 
Display the shipped date in the format MMM DD YYYY. Order the result set by order id and the calculated years. 
The query should produce the result set listed below.
(198 row(s) affected)
*/

select 
	o.OrderID,
	c.CompanyName,
	c.ContactName,
	convert(varchar,o.ShippedDate,107) as newShippedDate,
	DATEDIFF(YEAR, o.ShippedDate, '2009-01-01') as calculated_years
from Orders as o
	inner join Customers as c
		on (o.CustomerID = c.CustomerID)
where o.ShippedDate >= '1994-01-01'
order by o.OrderID


/*
B6. List all the orders where the order date is between 1st of Jan and 30th of Mar 1992, 
and the cost of the order is greater than or equal to $1500.00. 
Display the order id, order date, and a new shipped date calculated by adding 10 days to the shipped date from the Orders table, 
the product name from the Products table, the company name from the Customer table, and the cost of the order. 
Format the date order date and the shipped date as MON DD YYYY. 
Use the formula (OrderDetails.Quantity * Products.UnitPrice) to calculate the cost of the order. 
Order the result set by order id. The query should produce the result set listed below.
11 registros 
*/

select 
	o.OrderID,
	o.OrderDate,
	DATEADD(DAY, 10, o.ShippedDate) as newShippedDate,
	p.ProductName,
	c.CompanyName,
	(od.Quantity * p.UnitPrice) as costOrder
from Orders as o
	inner join OrderDetails as od
		on o.OrderID = od.OrderID
	inner join Products as p
		on od.ProductID = p.ProductID
	inner join Customers as c
		on o.CustomerID = c.CustomerID
where o.OrderDate between '1992-01-01' and '1992-03-30' and
(od.Quantity * p.UnitPrice) > 1500
order by o.OrderID

/*
B7. List all the orders with a shipping city of Vancouver. Display the order from the Orders table, 
and the unit price and quantity from the OrderDetails table. 
Order the result set by the order id. 
The query should produce the result set listed below.
8 registros
*/

select 
	o.OrderID,
	od.UnitPrice,
	od.Quantity

from Orders as o
	inner join OrderDetails as od
		on od.OrderID = o.OrderID
where o.ShipCity = 'Vancouver'
order by o.OrderID

/*
B8. List all the orders that have not been shipped (shipped date is null). 
Display the customer id, company name and fax number from the Customers table, and the order id and order date from the Orders table. 
Order the result set by the customer id and order date. 
The query should produce the result set listed below.
21 registros
*/

select
	c.CustomerID,
	c.CompanyName,
	c.Fax,
	o.OrderID
from Orders as o
	inner join Customers as c
		on c.CustomerID = o.CustomerID
where o.ShippedDate is null
order by c.CustomerID, o.OrderDate


/*
B9. List the products which contain choc or tofu in their name. 
Display the product id, product name, quantity per unit and unit price from the Products table. 
Order the result set by product id. 
The query should produce the result set listed below.
4 registros
*/

select 
	p.ProductID,
	p.ProductName,
	p.QuantityPerUnit,
	p.UnitPrice
from Products as p
where p.ProductName like '%choc%' or p.ProductName like '%tofu%'
order by p.ProductID

/*
B10. List the number of products and their names beginning with each letter of the alphabet. 
Only display the letter and count if there are at least three product names begin with the letter. 
The query should produce the result set listed below.
10 registros
*/
select 
	SUBSTRING (p.ProductName,1,1) as primeira_letra,
	count (p.ProductName) as contagem_produtos_letra
from Products as p
group by SUBSTRING (p.ProductName,1,1)
having count (ProductName) >= 3

--ou 

select 
	LEFT (p.ProductName,1) as primeira_letra,
	count (p.ProductName) as contagem_produtos_letra
from Products as p
group by LEFT (p.ProductName,1)
having count (ProductName) >= 3

/*
C1. Create a view called vw_supplier_items listing the distinct suppliers and the items they have shipped. 
Display the supplier id and name from the Suppliers table, and the product id and product name from the Products table. 
Use the following query to test your view to produce the result set listed below.

SELECT *
FROM vw_supplier_items
ORDER BY Name, ProductID

77 registros
*/
create view vw_supplier_items
as
select
	distinct
	s.SupplierID,
	s.Name as 'Supplier Name',
	p.ProductID,
	p.ProductName as 'Product Name'
from Suppliers as s
	inner join Products as p
		on s.SupplierID = p.SupplierID

SELECT *
FROM vw_supplier_items
ORDER BY [Supplier Name], ProductID

/*
C2. Create a view called vw_employee_info to list all the employees in the Employee table. 
Display the employee id, last name, first name, and birth date. 
Format the name as first name followed by a space followed by the last name. 
Use the following query to test your view to produce the result set listed below.
SELECT *
FROM vw_employee_info
WHERE EmployeeID IN ( 3, 6, 9 )
3 registros
*/
create view vw_employee_info
as
select
	e.EmployeeID,
	CONCAT (e.FirstName, ' ', e.LastName) as nameEmployee,
	e.BirthDate
from Employees as e

SELECT *
FROM vw_employee_info
WHERE EmployeeID IN ( 3, 6, 9 )

/*
C3. Using the UPDATE statement, change the fax value to Unknown for all rows 
in the Customers table where the current fax value is null (22 rows affected).
*/

select 
*
from Customers c
where c.Fax is null

--begin tran
--update c
--set c.Fax = 'Unknown'
--from Customers as c
--where c.Fax is null
--rollback


/*
C4. Create a view called vw_order_cost to list the cost of orders. 
Display the order id and order_date from the Orders table,
the product id from the Products table, 
the company name from the Customers table, and the order cost. 
To calculate the cost of the orders, use the formula: (OrderDetails.Quantity * OrderDetails.UnitPrice).
Use the following query to test your view to produce the result set listed below.

SELECT *
FROM vw_order_cost
WHERE orderID BETWEEN 10100 AND 10200
ORDER BY ProductID
257 registros
*/
create view  vw_order_cost
as
select
	o.OrderID,
	o.OrderDate,
	p.ProductID,
	c.CompanyName,
	(od.Quantity * od.UnitPrice) as orderCost
from Orders as o
	inner join OrderDetails as od
		on (o.OrderID = od.OrderID)
	inner join Products as p
		on (od.ProductID = p.ProductID)
	inner join Customers as c
		on (o.CustomerID = c.CustomerID)

SELECT *
FROM vw_order_cost
WHERE orderID BETWEEN 10100 AND 10200
ORDER BY ProductID

/*
C5. Using the INSERT statement, add a row to the Suppliers table with a supplier id of 16 and a name of �Supplier P�.
*/

insert into Suppliers (SupplierID,Name)
values (16, 'Supplier P')

SELECT * FROM Suppliers

/*
C6. Using the UPDATE statement, increase the unit price in the Products table by 15% 
for rows with a current unit price less than $5.00 (2 rows affected).
*/

select 
	p.UnitPrice,
	(p.UnitPrice * 1.15) as newUnitPrice
from Products as p
where p.UnitPrice > 5

--begin tran
--update p
--set p.UnitPrice = p.UnitPrice * 1.15
--from Products as p
--where p.UnitPrice < 5
--ROLLBACK

--UPDATE Products
--SET UnitPrice = UnitPrice * 1.15
--WHERE UnitPrice < 5

/*
C7. Create a view called vw_orders to list orders. 
Display the order id and shipped date from the Orders table, 
and the customer id, company name, city, and country from the Customers table. 
Use the following query to test your view to produce the result set listed below.
SELECT *
FROM vw_orders
WHERE ShippedDate BETWEEN '1993-01-01' AND '1993-01-31'
ORDER BY CompanyName, Country

33 registros
*/
create view vw_orders
as
select
	o.OrderID,
	o.ShippedDate,
	c.CustomerID,
	c.CompanyName,
	c.City,
	c.Country
from Orders as o
	inner join Customers as c
		on (o.CustomerID = c.CustomerID)

SELECT *
FROM vw_orders
WHERE ShippedDate BETWEEN '1993-01-01' AND '1993-01-31'
ORDER BY CompanyName, Country

/*
D1. Create a stored procedure called sp_emp_info to display 
the employee id, last name, first name, and phone number from the Employees table for a particular employee. 
The employee id will be an input parameter for the stored procedure. 
Use the following query to test your stored procedure to produce the result set listed below.
EXEC sp_emp_info 7
1 registro
*/
ALTER procedure sp_emp_info (@IDEmployee INT)
as
begin
	select 
		e.EmployeeID,
		e.LastName,
		e.FirstName,
		e.Phone
	from Employees as e
	where e.EmployeeID = @IDEmployee
end

EXECUTE sp_emp_info 7

/*
D2. Create a stored procedure called sp_orders_by_dates displaying the orders shipped between particular dates. 
The start and end date will be input parameters for the stored procedure. 
Display the order id, customer id, and shipped date from the Orders table, 
the company name from the Customer table, and the shipper name from the Shippers table. 
Use the following query to test your stored procedure to produce the result set listed below.
EXEC sp_orders_by_dates '1991-01-01', '1991-12-31'
134 registros
*/
create procedure sp_orders_by_dates (@dtini date, @dtend date)
as
begin
	select 
		o.OrderID,
		o.CustomerID,
		o.ShippedDate,
		c.CompanyName as CompanyName,
		s.CompanyName as ShipperName
	from Orders as o
		inner join Customers as c
			on o.CustomerID = c.CustomerID
		inner join Shippers as s
			on o.ShipperID = s.ShipperID
	where o.ShippedDate between @dtini and @dtend
end

EXEC sp_orders_by_dates '1991-01-01', '1991-12-31'

/*
D3. Create a stored procedure called sp_products listing a specified product ordered during a specified month and year. 
The product name, month, and year will be input parameters for the stored procedure. 
Display the product name, unit price, and units in stock from the Products table, and the supplier name from the Suppliers table. 
Use the following query to test your stored procedure to produce the result set listed below.
EXEC sp_products '%tofu%', 'December', 1992
4 registros
*/
create procedure sp_products (@Nameproduct varchar(100), @NameMonth varchar(20), @year int)
as 
begin
	select 
		p.ProductName,
		p.UnitPrice,
		p.UnitsInStock,
		s.Name as SupplierName

	from Products as p
		inner join Suppliers as s
			on (p.SupplierID = s.SupplierID)

		INNER JOIN  orderdetails od  
			ON od.productid = p.productid
		INNER JOIN  orders o         
			ON od.orderid = o.orderid

	where p.ProductName like @Nameproduct and datename(MONTH,o.OrderDate) = @NameMonth and YEAR(o.OrderDate) = @year
end

EXEC sp_products '%tofu%', 'December', 1992

/*
D4. Create a stored procedure called sp_unit_prices listing the products where the unit price
is between particular values. The two unit prices will be input parameters for the stored
procedure. Display the product id, product name, English name, and unit price from the
Products table. Use the following query to test your stored procedure to produce the result
set listed below.
EXEC sp_unit_prices 6.00, 8.00
4 registros
*/
create procedure sp_unit_prices (@price1 money, @price2 money)
as 
begin
	select
		p.ProductID,
		p.ProductName,
		p.EnglishName,
		p.UnitPrice
	from Products as p
	where p.UnitPrice between @price1 and @price2
end

EXEC sp_unit_prices 6.00, 8.00

/*
D5. Create a stored procedure called sp_customer_city displaying the customers living in a
particular city. The city will be an input parameter for the stored procedure. Display the
customer id, company name, address, city and phone from the Customers table. Use the
following query to test your stored procedure to produce the result set listed below.
EXEC sp_customer_city 'Paris'
2 registros
*/
create procedure sp_customer_city (@nameCity varchar(100))
as
begin
	select
		c.CustomerID,
		c.CompanyName,
		c.Address,
		c.City,
		c.Phone
	from Customers as c
	where c.City = @nameCity
end

EXEC sp_customer_city 'Paris'
/*
D6. Create a stored procedure called sp_reorder_qty to show when the reorder level
subtracted from the units in stock is less than a specified value. The unit value will be an
input parameter for the stored procedure. Display the product id, product name, units in
stock, and reorder level from the Products table, and the supplier name from the Suppliers
table. Use the following query to test your stored procedure to produce the result set listed
below.
EXEC sp_reorder_qty 9
26 registros
*/
alter procedure sp_reorder_qty (@unitValue money)
as 
begin
	select
		p.ProductID,
		p.ProductName,
		p.UnitsInStock,
		p.ReorderLevel,
		s.SupplierID
	from Products as p
		inner join Suppliers as s
			on (p.SupplierID = s.SupplierID)
	where (p.UnitsInStock - p.ReorderLevel) < @unitValue
end

EXEC sp_reorder_qty 9
/*
D7. Create a stored procedure called sp_shipping_date where the shipped date is equal to the
order date plus 10 days. The shipped date will be an input parameter for the stored
procedure. Display the order id, order date and shipped date from the Orders table, the
company name from the Customers table, and the company name from the Shippers table.
Use the following query to test your stored procedure to produce the result set listed below.
EXEC sp_shipping_date '1993-11-29'
3 registros
*/
create procedure sp_shipping_date (@dateShipped date)
as
begin

	select
		o.OrderID,
		o.OrderDate,
		o.ShippedDate,
		c.CompanyName as CusctomerCompany,
		s.CompanyName as ShippersCompany
	from Orders as o
		inner join Customers as c
			on (o.CustomerID = c.CustomerID)
		inner join Shippers as s
			on (o.ShipperID= s.ShipperID)
	where DATEADD(DAY,10,o.OrderDate) = @dateShipped

end
EXEC sp_shipping_date '1993-11-29'

/*
D8. Create a stored procedure called sp_del_inactive_cust to delete customers that have no
orders. Use the following query to test your procedure. The stored procedure should delete
1 row.
EXEC sp_del_inactive_cust
*/
alter procedure sp_del_inactive_cust1
as
begin
	delete from Customers
	where CustomerID not in (select CustomerID from Orders )
end

alter procedure sp_del_inactive_cust2
as
begin
	delete from c
	from Customers as c
		left join Orders as o
			on (o.CustomerID = c.CustomerID)
	where o.CustomerID is null
end

--begin tran
--EXEC sp_del_inactive_cust2
--rollback

select 
	c.CustomerID as IdCustomer,
	o.CustomerID as IdCustomerOrders
from Customers as c
	left join Orders as o
		on (o.CustomerID = c.CustomerID)
where o.CustomerID is null

select * from Customers
where CustomerID not in (select CustomerID from Orders )
/*
D9. Create an UPDATE trigger called tr_check_qty on the OrderDetails table to prevent the
updating of orders for products in the Products table that have units-in-stock less than the
quantity ordered. Use the following query to test your trigger.

UPDATE OrderDetails
SET Quantity = 40
WHERE OrderID = 10044
AND ProductID = 77
*/
alter trigger tr_check_qty
on OrderDetails
instead of update
AS
Begin
	DECLARE @A1 INT, @A2 INT
	SET @A1 = (select i.Quantity from inserted as i )
	SET @A2 = (select p.UnitsInStock from OrderDetails as o 
		inner join Products as p 
			on p.ProductID = o.ProductID 
		where o.OrderID = (select i.OrderID from inserted as i) 
		and o.ProductID = (select i.ProductID from inserted as i) )


	if ( @A1 > @A2)
		--(select i.Quantity from inserted as i ) > 
		--(select p.UnitsInStock from OrderDetails as o 
		--inner join Products as p 
		--	on p.ProductID = o.ProductID 
		--where o.OrderID = (select i.OrderID from inserted as i) 
		--and o.ProductID = (select i.ProductID from inserted as i) 
		--)
		--)
	begin 
		print 'Quantidade maior que o estoque'
	end
	else
		begin
			print ('Quantidade menor que o estoque - atualiza��o executada com sucesso')
			update OrderDetails
			set OrderDetails.Quantity = inserted.Quantity
			from OrderDetails inner join inserted
			on inserted.OrderID = OrderDetails.OrderID and inserted.ProductID = OrderDetails.ProductID	
		end
end 
begin tran
UPDATE OrderDetails
SET Quantity = 20
WHERE OrderID = 10044
AND ProductID = 77

rollback
commit

select 
	od.OrderID,
	od.ProductID,
	od.Quantity,
	p.UnitsInStock
from OrderDetails as od
	inner join Products as p
		on (p.ProductID = od.ProductID)
where od.OrderID = 10044
AND p.ProductID = 77