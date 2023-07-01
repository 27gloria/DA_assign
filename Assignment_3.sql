##SET 3
-- -----
use assignment;



## 1. Write a stored procedure that accepts the month and year as inputs and prints the ordernumber, orderdate and status of the orders placed in that month. 

## Example:  call order_status(2005, 11);

-- order_status-Routine
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `order_status`(year int, month int)
BEGIN
select orderNumber, orderdate, status from orders where year(orderDate) = year and month(orderDate) = month;
END 
DELIMITER //

-- order_status
call assignment.order_status(2005, 11);




## 2. a. Write function that takes the customernumber as input and returns the purchase_status based on the following criteria . [table:Payments]

-- if the total purchase amount for the customer is < 25000 status = Silver, amount between 25000 and 50000, status = Gold
-- if amount > 50000 Platinum

select *,
	   CASE
			WHEN amount < 25000 THEN 'Silver'
			WHEN amount BETWEEN 25000 AND 50000 THEN 'Gold'
            ELSE 'Platinum'
            END AS Status
from payments;

-- purchase_status-Routine
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `purchase_status`(customerNumber int) RETURNS varchar(10) CHARSET utf8mb4
BEGIN
declare amount decimal(10,2);
select sum(amount) into amount from payments where customerNumber = customerNumber;
if amount < 25000 then
return 'Siler';
elseif amount >= 25000 and amount <= 50000 then
return 'Gold';
else
return 'Platinum';
end if;
END
DELIMITER //
 
 -- prchase_status
select assignment.purchase_status(114);


-- b. Write a query that displays customerNumber, customername and purchase_status from customers table.
select c.customerNumber, c.customerName, purchase_status(c.customerNumber) as purchase_status from customers c;





## 3. Replicate the functionality of 'on delete cascade' and 'on update cascade' using triggers on movies and rentals tables. Note: Both tables - movies and rentals - don't have primary or foreign keys. Use only triggers to implement the above.
-- On Movies Table
-- 'ON DELETE CASCADE':
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `movies_BEFORE_DELETE` BEFORE DELETE ON `movies` FOR EACH ROW 
BEGIN
-- Delete related rentals
    DELETE FROM rentals WHERE movie_id = OLD.id;
END
DELIMITER //


-- 'ON UPDATE CASCADE':
DELIMITER //
 CREATE DEFINER=`root`@`localhost` TRIGGER `movies_BEFORE_UPDATE_1` BEFORE UPDATE ON `movies` FOR EACH ROW 
 BEGIN
 -- Update related rentals
    UPDATE rentals SET movie_id = NEW.id WHERE movie_id = OLD.id;
END
DELIMITER //


-- On Rentals Table
-- 'ON DELETE CASCADE':
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `rentals_BEFORE_DELETE` BEFORE DELETE ON `rentals` FOR EACH ROW BEGIN
DELETE FROM movies WHERE id = OLD.movieid;
END
DELIMITER //


-- 'ON UPDATE CASCADE':
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `rentals_BEFORE_UPDATE` BEFORE UPDATE ON `rentals` FOR EACH ROW BEGIN
 UPDATE movies SET id = NEW.movieid WHERE id = OLD.movieid;
END
DELIMITER //




## 4. Select the first name of the employee who gets the third highest salary. [table: employee]
select *
	from employee
		order by salary desc
			limit 2,1;





## 5. Assign a rank to each employee  based on their salary. The person having the highest salary has rank 1. [table: employee]
select *,
	   dense_rank () OVER (order by salary desc) as Rank_salary
	from employee;
