CREATE TABLE BRANCH (
    branch_name VARCHAR(100) PRIMARY KEY,
    branch_city VARCHAR(100),
    assets REAL
);
create database bank;
use bank

CREATE TABLE CUSTOMER (
    customer_name VARCHAR(100) PRIMARY KEY,
    customer_street VARCHAR(100),
    customer_city VARCHAR(100)
);

CREATE TABLE ACCOUNT (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(100),
    balance REAL,
    FOREIGN KEY (branch_name) REFERENCES BRANCH(branch_name)
);

CREATE TABLE DEPOSITOR (
    customer_name VARCHAR(100),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES CUSTOMER(customer_name),
    FOREIGN KEY (accno) REFERENCES ACCOUNT(accno)
);

CREATE TABLE LOAN (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(100),
    amount REAL,
    FOREIGN KEY (branch_name) REFERENCES BRANCH(branch_name)
);

CREATE TABLE BORROWER (
    customer_name VARCHAR(100),
    loan_number INT,
    PRIMARY KEY (customer_name, loan_number),
    FOREIGN KEY (customer_name) REFERENCES CUSTOMER(customer_name),
    FOREIGN KEY (loan_number) REFERENCES LOAN(loan_number)
);



-- BRANCHES
INSERT INTO BRANCH VALUES ('Main', 'New York', 1000000);
INSERT INTO BRANCH VALUES ('Uptown', 'New York', 800000);
INSERT INTO BRANCH VALUES ('Downtown', 'Chicago', 750000);
INSERT INTO BRANCH VALUES ('Central', 'Los Angeles', 900000);

-- CUSTOMERS
INSERT INTO CUSTOMER VALUES ('Alice', '1st Ave', 'New York');
INSERT INTO CUSTOMER VALUES ('Bob', '2nd St', 'Chicago');
INSERT INTO CUSTOMER VALUES ('Charlie', '3rd Blvd', 'Los Angeles');
INSERT INTO CUSTOMER VALUES ('David', '4th Ln', 'New York');

-- ACCOUNTS
INSERT INTO ACCOUNT VALUES (101, 'Main', 5000);
INSERT INTO ACCOUNT VALUES (102, 'Uptown', 6000);
INSERT INTO ACCOUNT VALUES (103, 'Downtown', 7000);
INSERT INTO ACCOUNT VALUES (104, 'Central', 8000);
INSERT INTO ACCOUNT VALUES (105, 'Main', 9000);
INSERT INTO ACCOUNT VALUES (106, 'Uptown', 10000);
INSERT INTO ACCOUNT VALUES (107, 'Central', 11000);

-- DEPOSITORS
-- Alice: 2 accounts in New York (Main + Uptown)
INSERT INTO DEPOSITOR VALUES ('Alice', 101);
INSERT INTO DEPOSITOR VALUES ('Alice', 102);
INSERT INTO DEPOSITOR values('Alice ',105);
INSERT INTO DEPOSITOR values('Alice',106);

-- Bob: 1 account in Chicago, 1 in LA
INSERT INTO DEPOSITOR VALUES ('Bob', 103);
INSERT INTO DEPOSITOR VALUES ('Bob', 104);

-- Charlie: 1 account in each of 3 different cities
INSERT INTO DEPOSITOR VALUES ('Charlie', 101);  -- NY
INSERT INTO DEPOSITOR VALUES ('Charlie', 103);  -- Chicago
INSERT INTO DEPOSITOR VALUES ('Charlie', 104);  -- LA

-- David: 2 accounts in NY
INSERT INTO DEPOSITOR VALUES ('David', 105);
INSERT INTO DEPOSITOR VALUES ('David', 106);

-- LOANS
INSERT INTO LOAN VALUES (201, 'Main', 10000);
INSERT INTO LOAN VALUES (202, 'Central', 15000);

-- BORROWERS
INSERT INTO BORROWER VALUES ('Alice', 201);
INSERT INTO BORROWER VALUES ('Charlie', 202);
select * from BRANCH
select * from CUSTOMER
select * from ACCOUNT
select * from DEPOSITOR
select * from LOAN
select * from BORROWER

select c.customer_name 
from CUSTOMER c
where not exists 
(select b.branch_name
from BRANCH b
where b.branch_city='New York' and b.branch_name not in(
select a.branch_name
from ACCOUNT a,DEPOSITOR d
where b.branch_name=a.branch_name and a.accno=d.accno and d.customer_name=c.customer_name
group by a.branch_name
having count(*)>=2));


select c.customer_name
from CUSTOMER c
where not exists 
(Select distinct (B1.branch_city) 
from BRANCH B1
where not exists 
(Select count(distinct b.branch_name)
from BRANCH b , ACCOUNT a , DEPOSITOR d
where b1.branch_city=b.branch_city and b.branch_name=a.branch_name and a.accno=d.accno and d.customer_name=c.customer_name
group by b.branch_city 
having count(*)>=1))


 select C.customer_name from CUSTOMER  C where  exists
 ( select  count( distinct B.branch_name)
 from BRANCH B, ACCOUNT A ,DEPOSITOR D 
   where A.branch_name = B.branch_name and D.accno = A.accno and B.branch_city  = 'New York'  and D.customer_name = C.customer_name  
   group by B.branch_city having count(*) >=2) 
