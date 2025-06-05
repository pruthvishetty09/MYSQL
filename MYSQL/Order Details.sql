create database orderdet
use orderdet

CREATE TABLE CUSTOMER (
    cust_no INT PRIMARY KEY,
    cname VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE ORDER_TABLE (
    order_no INT PRIMARY KEY,
    odate DATE,
    cust_no INT,
    ord_amt INT,
    FOREIGN KEY (cust_no) REFERENCES CUSTOMER(cust_no)
);


CREATE TABLE ORDER_ITEM (
    order_no INT,
    item_no INT,
    qty INT,
    PRIMARY KEY (order_no, item_no),
    FOREIGN KEY (order_no) REFERENCES ORDER_TABLE(order_no)
);

CREATE TABLE ITEM (
    item_no INT PRIMARY KEY,
    unit_price INT
);

CREATE TABLE SHIPMENT (
    order_no INT,
    warehouse_no INT,
    ship_date DATE,
    PRIMARY KEY (order_no, warehouse_no),
    FOREIGN KEY (order_no) REFERENCES ORDER_TABLE(order_no)
);

CREATE TABLE WAREHOUSE (
    warehouse_no INT PRIMARY KEY,
    city VARCHAR(100)
);


-- CUSTOMER
INSERT INTO CUSTOMER VALUES (1, 'Alice', 'New York');
INSERT INTO CUSTOMER VALUES (2, 'Bob', 'Los Angeles');
INSERT INTO CUSTOMER VALUES (3, 'Charlie', 'Chicago');

-- ORDER_TABLE
INSERT INTO ORDER_TABLE VALUES (101, '2024-01-10', 1, 500);
INSERT INTO ORDER_TABLE VALUES (102, '2024-01-11', 1, 300);
INSERT INTO ORDER_TABLE VALUES (103, '2024-01-15', 2, 700);
INSERT INTO ORDER_TABLE VALUES (104, '2024-01-20', 2, 900);
INSERT INTO ORDER_TABLE VALUES (105, '2024-01-22', 3, 400);






-- ITEM
INSERT INTO ITEM VALUES (201, 50);
INSERT INTO ITEM VALUES (202, 30);
INSERT INTO ITEM VALUES (203, 70);
INSERT INTO ITEM VALUES (204, 100);

-- ORDER_ITEM
INSERT INTO ORDER_ITEM VALUES (101, 201, 2);
INSERT INTO ORDER_ITEM VALUES (101, 202, 3);
INSERT INTO ORDER_ITEM VALUES (102, 201, 1);
INSERT INTO ORDER_ITEM VALUES (103, 202, 4);
INSERT INTO ORDER_ITEM VALUES (103, 203, 2);
INSERT INTO ORDER_ITEM VALUES (104, 201, 5);
INSERT INTO ORDER_ITEM VALUES (104, 203, 1);
INSERT INTO ORDER_ITEM VALUES (105, 201, 3);
INSERT INTO ORDER_ITEM VALUES (105, 202, 1);
INSERT INTO ORDER_ITEM VALUES (105, 204, 2);
INSERT INTO ORDER_ITEM VALUES (105, 203, 3);

-- WAREHOUSE
INSERT INTO WAREHOUSE VALUES (1, 'New York');
INSERT INTO WAREHOUSE VALUES (2, 'Los Angeles');
INSERT INTO WAREHOUSE VALUES (3, 'Chicago');

-- SHIPMENT
INSERT INTO SHIPMENT VALUES (101, 1, '2024-01-12');
INSERT INTO SHIPMENT VALUES (102, 2, '2024-01-13');
INSERT INTO SHIPMENT VALUES (103, 1, '2024-01-16');
INSERT INTO SHIPMENT VALUES (103, 2, '2024-01-17');
INSERT INTO SHIPMENT VALUES (104, 3, '2024-01-21');
INSERT INTO SHIPMENT VALUES (105, 2, '2024-01-23');
INSERT INTO SHIPMENT VALUES (105, 3, '2024-01-24');


select O.cust_no,C.cname, count(O.order_no) AS NO_OF_ORDERS, avg(O.ord_amt) AS 
AVG_ORDER_AMT from CUSTOMER C, ORDER_TABLE O 
where C.cust_no=O.cust_no  
group by O.cust_no,C.cname; 

select  item_no,count(order_no) AS NO_OF_ORDERS,sum(qty)  AS 
TOTAL_QTY_SHIPPED 
from  ORDER_ITEM  
where order_no in 
               (select order_no                  
			   from SHIPMENT                
			   group by order_no                 
			   having count(warehouse_no) >=2)  
			   group by   item_no  having count(order_no) > =2; 
 
 select C.cname   
from CUSTOMER C  
where NOT EXISTS  
( 
(select item_no from ITEM) 
EXCEPT 
(select distinct(OI.item_no)  
from ORDER_TABLE O,ORDER_ITEM OI  
where  O.order_no = OI.order_no and  O.cust_no = C.cust_no ) 
); 
  

select * from CUSTOMER

select * from ORDER_TABLE
select * from ORDER_ITEM
select * from ITEM
select * from SHIPMENT
select * from WAREHOUSE