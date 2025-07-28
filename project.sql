-- PROJECT FOR SQL 
--- CREATE DATABASE 
CREATE DATABASE onlineBookstore;

--- SWITCH TO THE DATABASE
-- C onlinebookstore;

--- create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
		Books_ID SERIAL PRIMARY KEY,
		Title VARCHAR(100),
		Author VARCHAR(100),
		Genre VARCHAR(50),
		Published_year INT,
		Price NUMERIC(10,2),
		Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
	Customers_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(100),
	City VARCHAR(150),
	Country VARCHAR(150)
);

--DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customers_ID),
	Book_ID INT REFERENCES Books(Books_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10, 2)
);
SELECT * FROM Books;
SELECT * FROM customers;
SELECT * FROM Orders;

--- Import Data Into books Table
COPY Books(Books_ID,Title,Author,Genre,Published_year,Price,Stock)
FROM 'E:\SQL FILES\Books.csv'
CSV HEADER;

--- Import Data into customers Table
COPY customers(customers_ID,Name,Email,Phone,City,Country)
FROM ‪'E:\SQL FILES\Customers.csv'
CSV HEADER;
--- Import data into Orders Table
COPY orders(Orders_ID,customers_ID,Order_Date,Quanity,Total_Amount)
FROM 'E:\SQL FILES\Orders.csv'
CSV HEADER;

------------- Here is the question is start from here--------------

---QUES1. Retrive all books in the 'fiction' genre.
SELECT * FROM Books
WHERE Genre = 'Fiction';

---QUES2. Find books published after the year 1950.
SELECT * FROM Books
WHERE published_year > 1950;

--- QUES3. List all customers from canada.
SELECT * FROM Customers
WHERE country = 'Canada';

--- QUES4. show orders placed in November 2023.
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- QUES5. Retrieve the Total stock of books available:
SELECT SUM(stock) AS Total_stock
FROM Books;

--QUES6. -- Find the details of the most expensive book:
SELECT * FROM Books ORDER BY price DESC LIMIT 1;

--QUES7. --Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM orders
WHERE quantity >1;

--QUES8. --Retrieve all orders where the total amount exceeds $20:
SELECT * FROM orders
WHERE total_amount > 20;

--QUES9. --List all genres available in the books table:
SELECT DISTINCT(genre) FROM Books;

--QUES10. --Find the book with the lowest stock:
SELECT * FROM Books;
SELECT * FROM Books ORDER BY stock LIMIT 1; 

-- QUES11. --Calculate the total Revenue generated from all orders:
SELECT SUM(total_amount) AS Total_Revenue FROM orders;

--- ADVANCE Questions --- :-
-- QUES12. -- Retrieve the total number of books sold for each genre:
SELECT * FROM orders;
SELECT * FROM Books;

SELECT b.genre,SUM(o.quantity) AS Total_books_sold
FROM orders o JOIN Books b
ON o.book_id = b.books_id
GROUP BY  b.Genre;

--QUES13. --Find the average price of books in the "Fantasy" genre:
SELECT  AVG(price) AS Avg_price FROM Books
WHERE Genre = 'Fantasy'

--QUES14. -- List customers who have placed at least 2 orders:
SELECT * FROM orders;

SELECT customer_id, COUNT(order_id) AS Order_count FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 2;

--- Another way to describe question with names.
SELECT o.customer_id,c.name,COUNT(o.order_id)
FROM customers c JOIN orders o
ON c.customers_id = o.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id) >= 2;

--QUES15. --Find the most frequently ordered book:
SELECT * FROM Books;
SELECT * FROM orders;

SELECT Book_id,COUNT(order_id) AS count_order
FROM orders
GROUP BY Book_id
ORDER BY count_order DESC LIMIT 1;

-- another way to display the query with name of Book(title)
SELECT o.Book_id,b.title,COUNT(o.order_id) AS coun_order
FROM orders o JOIN Books b
ON b.Books_id = o.Book_id
GROUP BY o.Book_id,b.title
ORDER BY coun_order DESC LIMIT 1;

--QUES16. -- Show the top 3 most expensive books of 'fantasy' Genre:
SELECT * from Books
WHERE genre = 'Fantasy' ORDER BY price DESC LIMIT 3;

--QUES17.-- Retrive the total quantity of books sold by each author:
SELECT * FROM Books;
SELECT * FROM orders;

SELECT b.author,SUM(o.quantity) AS sold_books
FROM Books b JOIN orders o
ON b.Books_id = o.Book_id
GROUP BY b.author;

--QUES18. -- list the cities where customers who  spent over $30 are located:
SELECT * FROM orders;
SELECT * FROM customers;

SELECT DISTINCT c.city,total_amount
FROM orders o JOIN customers c
ON o.customer_id = c.customers_id
WHERE o.total_amount > 30;

--QUES19 -- Find the customer who spent the most on orders:
SELECT * FROM orders;
SELECT * FROM customers;

SELECT c.customers_id,c.name,SUM(o.total_amount) AS spent
FROM customers c JOIN orders o
ON c.customers_id = o.customer_id
GROUP BY c.customers_id,c.name
ORDER BY spent DESC LIMIT 1;

-- QUES20. -- Calculate the stock remaining after fulfilling all orders:
SELECT * FROM Books;
SELECT * FROM orders;

SELECT b.books_id,b.title,b.stock,COALESCE(SUM(o.quantity),0) AS order_quantity,
b.stock - COALESCE(SUM(o.quantity),0) AS Remainig_quantity
FROM Books b LEFT JOIN orders o
ON b.books_id = o.book_id
GROUP BY b.books_id
ORDER BY b.books_id;
























