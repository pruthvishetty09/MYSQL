
CREATE DATABASE Bookstore;
USE Bookstore;


CREATE TABLE AUTHOR (
    author_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE PUBLISHER (
    publisher_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE CATEGORY (
    category_id INT PRIMARY KEY,
    description VARCHAR(100)
);

CREATE TABLE CATALOG (
    book_id INT PRIMARY KEY,
    title VARCHAR(200),
    author_id INT,
    publisher_id INT,
    category_id INT,
    year INT,
    price DECIMAL(10,2),
    FOREIGN KEY (author_id) REFERENCES AUTHOR(author_id),
    FOREIGN KEY (publisher_id) REFERENCES PUBLISHER(publisher_id),
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)
);

CREATE TABLE ORDER_DETAILS (
    order_no INT,
    book_id INT,
    quantity INT,
    PRIMARY KEY (order_no, book_id),
    FOREIGN KEY (book_id) REFERENCES CATALOG(book_id)
);

INSERT INTO AUTHOR VALUES (1, 'J.K. Rowling', 'Edinburgh', 'UK');
INSERT INTO AUTHOR VALUES (2, 'George R.R. Martin', 'Bayonne', 'USA');
INSERT INTO AUTHOR VALUES (3, 'Ruskin Bond', 'Dehradun', 'India');
INSERT INTO AUTHOR VALUES (4, 'Chetan Bhagat', 'New Delhi', 'India');
SELECT * FROM AUTHOR;



INSERT INTO PUBLISHER VALUES (101, 'Bloomsbury', 'London', 'UK');
INSERT INTO PUBLISHER VALUES (102, 'Rupa Publications', 'New Delhi', 'India');
INSERT INTO PUBLISHER VALUES (103, 'Penguin Random House', 'New York', 'USA');
INSERT INTO PUBLISHER VALUES (104, 'HarperCollins', 'New York', 'USA');
SELECT * FROM PUBLISHER;


INSERT INTO CATEGORY VALUES (1001, 'Fiction');
INSERT INTO CATEGORY VALUES (1002, 'Fantasy');
INSERT INTO CATEGORY VALUES (1003, 'Drama');
INSERT INTO CATEGORY VALUES (1004, 'Young Adult');
SELECT * FROM CATEGORY;


INSERT INTO CATALOG VALUES (10001, 'Harry Potter and the Philosopher''s Stone', 1, 101, 1002, 1997, 12.99);
INSERT INTO CATALOG VALUES (10002, 'A Game of Thrones', 2, 103, 1002, 1996, 15.99);
INSERT INTO CATALOG VALUES (10003, 'The Room on the Roof', 3, 102, 1003, 1956, 8.99);
INSERT INTO CATALOG VALUES (10004, 'Five Point Someone', 4, 102, 1003, 2004, 7.99);
INSERT INTO CATALOG VALUES (10005, 'Harry Potter and the Chamber of Secrets', 1, 101, 1002, 1998, 13.99);
INSERT INTO CATALOG VALUES (10006, 'A Clash of Kings', 2, 103, 1002, 1998, 16.99);
SELECT * FROM CATALOG;



INSERT INTO ORDER_DETAILS VALUES (5001, 10001, 5);
INSERT INTO ORDER_DETAILS VALUES (5001, 10003, 2);
INSERT INTO ORDER_DETAILS VALUES (5002, 10001, 3);
INSERT INTO ORDER_DETAILS VALUES (5002, 10005, 4);
INSERT INTO ORDER_DETAILS VALUES (5003, 10002, 2);
INSERT INTO ORDER_DETAILS VALUES (5004, 10003, 1);
INSERT INTO ORDER_DETAILS VALUES (5004, 10004, 3);
INSERT INTO ORDER_DETAILS VALUES (5005, 10001, 6);
INSERT INTO ORDER_DETAILS VALUES (5006, 10006, 1);
INSERT INTO ORDER_DETAILS VALUES (5007, 10004, 2);
SELECT * FROM ORDER_DETAILS;



select a.name,a.author_id,sum(o.quantity)
	from AUTHOR a,ORDER_DETAILS o,CATALOG c
	where a.author_id=c.author_id and c.book_id=o.book_id 
	group by c.book_id,a.name,a.author_id
	having sum(o.quantity)>=ALL(select sum(quantity) from ORDER_DETAILS
	group by book_id);

	Select count(order_no),book_id
	from ORDER_DETAILS 
	group by book_id
	having sum(quantity)<=ALL(select sum(quantity) from ORDER_DETAILS
	group by book_id);

	update CATALOG
	set price=price*1.1
	where publisher_id in 
	(Select publisher_id
	from PUBLISHER
	where name='Rupa Publications')