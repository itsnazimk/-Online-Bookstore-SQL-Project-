-- Create Database
CREATE DATABASE if not exists OnlineBookstore;
use onlinebookstore ;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

-- show all tables
show tables ; 

-- Import Data into Books Table
-- here we used directly importing csv file to import daata : select databse > tables > select import data > select csv file

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;



-- 1) Retrieve all books in the "Fiction" genre:
select * from books where genre = "fiction" ;


-- 2) Find books published after the year 1950:
show columns from books ;  # as we can see published year is a int not a date 
select * from books where published_year > "1950" ;



-- 3) List all customers from the Canada:
select * from customers;
select * from customers where country = "canada" ; 

-- 4) Show orders placed in November 2023:
select * from orders ;
describe orders ;   # here order date  is in data type constraint
select * from orders where year(order_date) = 2023 and month(order_date) = 11 ; 

-- 2nd way--
select * from orders where order_date between "2023-11-01" and "2023-11-30" ; 

-- 5) Retrieve the total stock of books available:
select * from books;
select sum(stock) as Total_Stock from books;

-- 6) Find the details of the most expensive book:
select * from books order by price desc limit 1 ;

select * from books where price = (select max(price) from books);  ## using sub-query

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT c.name as cutomer_Names , o.quantity 
FROM customers AS c
JOIN orders AS o 
ON c.customer_id = o.customer_id
WHERE o.quantity > 1
order by o.quantity ;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders where total_amount > 20  order by Total_amount ;

-- 9) List all unique genres available in the Books table:
select  distinct genre from books ;

-- 10) Find the book with the lowest stock:
select * from books order by stock limit 1 ; 


-- 11) Calculate the total revenue generated from all orders:
select sum(total_amount) as Total_Revenue from orders ; 


-- Advance Questions : 


-- 1) Retrieve the total number of books sold for each genre:
select b.genre ,  sum(o.quantity) as total_sold from books as b
join orders as o
on b.book_id = o.book_id 
group by b.genre ; 



-- 2) Find the average price of books in the "Fantasy" genre:
select avg(price) as Avg_Price from books where genre = "fantasy" ;



-- 3) List customers who have placed at least 2 orders:
# without showing customer Names
select * from orders where quantity >= 2 ; 


# using join to show Names of the customer
select distinct(c.customer_id) , c.name, o.quantity from customers as c
join orders as o 
on c.customer_id = o.customer_id 
where o.quantity >= 2
order by o.quantity ;

-- 4) Find the most frequently ordered book:
## without book name
select book_id , count(order_id) as order_count from orders group by book_id order by order_count desc limit 1; 


## to get book name also
select b.book_id , b.Title , count(o.order_id) as count_of_orders from books as b
join orders as o 
on b.book_id = o.book_id
group by b.book_id 
order by count_of_orders desc limit 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books where genre = "fantasy" order by price desc limit 3 ;



-- 6) Retrieve the total quantity of books sold by each author:
select b.author , sum(o.quantity) as total_books_sold from books b
join orders o
on b.book_id = o.book_id
group by b.author ;


-- 7) List the cities where customers who spent over $30 are located: 
select distinct c.city , o.Total_amount from customers as c
join orders as  o
on c.customer_id = o.customer_id 
where o.total_amount > 30 ;


-- 8) Find the customer who spent the most on orders:
select c.customer_id , c.name , sum(o.Total_Amount) as Total_sum from customers as c
join orders as o
on c.customer_id = o.customer_id 
group by c.customer_id
order by Total_sum desc limit 1;


-- 9) Calculate the stock remaining after fulfilling all orders:
select * from orders ;
select * from books ;

select b.book_id  , b.title , b.stock  , sum(o.quantity) , b.stock - sum(o.quantity) as stock_remaining
from books as b
left join orders as o
on b.book_id = o.book_id
group by  b.book_id ;

-- more filtered
## IFNULL(expr1, expr2)	Returns expr1 if it's not null, else returns expr2

select b.book_id  , b.title , b.stock  , ifnull(sum(o.quantity) , 0)as quantity_ordered  , b.stock - ifnull(sum(o.quantity) , 0) as stock_remaining
from books as b
left join orders as o
on b.book_id = o.book_id
group by  b.book_id ;

-- -----------------------------
## THANKS DONE ##
-- -----------------------------














