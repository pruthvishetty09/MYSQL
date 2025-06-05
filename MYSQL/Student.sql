CREATE DATABASE StudentEnrollment;
USE StudentEnrollment;


CREATE TABLE STUDENT (
    regno VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    major VARCHAR(50),
    bdate DATE
);

CREATE TABLE COURSE (
    course INT PRIMARY KEY,
    cname VARCHAR(100),
    dept VARCHAR(50)
);

CREATE TABLE ENROLL (
    regno VARCHAR(20),
    course INT,
    sem INT,
    marks INT,
    PRIMARY KEY (regno, course, sem),
    FOREIGN KEY (regno) REFERENCES STUDENT(regno),
    FOREIGN KEY (course) REFERENCES COURSE(course)
);

CREATE TABLE BOOK_ADOPTION (
    course INT,
    sem INT,
    book_ISBN INT,
    PRIMARY KEY (course, sem, book_ISBN),
    FOREIGN KEY (course) REFERENCES COURSE(course)
);

CREATE TABLE TEXT (
    book_ISBN INT PRIMARY KEY,
    book_title VARCHAR(200),
    publisher VARCHAR(100),
    author VARCHAR(100)
);


INSERT INTO STUDENT VALUES ('S001', 'John Smith', 'CS', '2000-05-15');
INSERT INTO STUDENT VALUES ('S002', 'Alice Johnson', 'EE', '1999-08-22');
INSERT INTO STUDENT VALUES ('S003', 'Bob Williams', 'CS', '2001-03-10');
INSERT INTO STUDENT VALUES ('S004', 'Sarah Davis', 'ME', '2000-11-28');
INSERT INTO STUDENT VALUES ('S005', 'Michael Brown', 'CS', '2001-07-30');
SELECT * FROM STUDENT;


INSERT INTO COURSE VALUES (101, 'Database Systems', 'CS');
INSERT INTO COURSE VALUES (102, 'Data Structures', 'CS');
INSERT INTO COURSE VALUES (103, 'Algorithms', 'CS');
INSERT INTO COURSE VALUES (201, 'Circuit Theory', 'EE');
INSERT INTO COURSE VALUES (202, 'Digital Electronics', 'EE');
INSERT INTO COURSE VALUES (301, 'Thermodynamics', 'ME');
INSERT INTO COURSE VALUES (302, 'Fluid Mechanics', 'ME');
SELECT * FROM COURSE;

INSERT INTO ENROLL VALUES ('S001', 101, 1, 85);
INSERT INTO ENROLL VALUES ('S001', 102, 1, 78);
INSERT INTO ENROLL VALUES ('S002', 201, 1, 92);
INSERT INTO ENROLL VALUES ('S003', 101, 1, 88);
INSERT INTO ENROLL VALUES ('S003', 102, 1, 90);
INSERT INTO ENROLL VALUES ('S003', 103, 1, 82);
INSERT INTO ENROLL VALUES ('S004', 301, 1, 76);
INSERT INTO ENROLL VALUES ('S005', 101, 1, 95);
INSERT INTO ENROLL VALUES ('S005', 102, 1, 89);
INSERT INTO ENROLL VALUES ('S005', 103, 1, 91);
SELECT * FROM ENROLL;


INSERT INTO BOOK_ADOPTION VALUES (101, 1, 1001);
INSERT INTO BOOK_ADOPTION VALUES (101, 1, 1002);
INSERT INTO BOOK_ADOPTION VALUES (101, 1, 1003);  
INSERT INTO BOOK_ADOPTION VALUES (102, 1, 1004);
INSERT INTO BOOK_ADOPTION VALUES (102, 1, 1005);  
INSERT INTO BOOK_ADOPTION VALUES (103, 1, 1006);  
INSERT INTO BOOK_ADOPTION VALUES (201, 1, 2001);
INSERT INTO BOOK_ADOPTION VALUES (201, 1, 2002);  
INSERT INTO BOOK_ADOPTION VALUES (202, 1, 2003); 
INSERT INTO BOOK_ADOPTION VALUES (301, 1, 3001);  
INSERT INTO BOOK_ADOPTION VALUES (302, 1, 3002);  
SELECT * FROM BOOK_ADOPTION;

-- TEXT table
INSERT INTO TEXT VALUES (1001, 'Database Design', 'McGraw', 'C.J. Date');
INSERT INTO TEXT VALUES (1002, 'SQL Fundamentals', 'McGraw', 'J.D. Ullman');
INSERT INTO TEXT VALUES (1003, 'Advanced Databases', 'McGraw', 'R. Elmasri');
INSERT INTO TEXT VALUES (1004, 'Data Structures in C', 'McGraw', 'E. Horowitz');
INSERT INTO TEXT VALUES (1005, 'Algorithms', 'Pearson', 'T. Cormen');
INSERT INTO TEXT VALUES (1006, 'Algorithm Design', 'Pearson', 'J. Kleinberg');
INSERT INTO TEXT VALUES (2001, 'Electrical Circuits', 'McGraw', 'J. Nilsson');
INSERT INTO TEXT VALUES (2002, 'Circuit Analysis', 'McGraw', 'R. Boylestad');
INSERT INTO TEXT VALUES (2003, 'Digital Design', 'McGraw', 'M. Morris');
INSERT INTO TEXT VALUES (3001, 'Engineering Thermodynamics', 'Wiley', 'M. Moran');
INSERT INTO TEXT VALUES (3002, 'Fluid Dynamics', 'Wiley', 'F. White');
SELECT * FROM TEXT;


select T.book_ISBN, T.book_title,C.course,C.cname
from text T,Course C,Book_adoption B
where T.book_ISBN=B.book_ISBN and C.course=B.course and C.dept='CS'
and C.course in
(select course 
from Book_adoption 
group by course
having count(*)>=2)
order by T.book_title;

select distinct(C1.dept) 
from COURSE C1
where NOT EXISTS
(
select distinct(B.book_ISBN)
from BOOK_ADOPTION B, Course c
where B.course=C.course and C.dept=C1.dept and B.book_ISBN not in
(select book_ISBN 
from TEXT
where publisher='McGraw')
);



select T.book_ISBN,T.book_title
from TEXT T,COURSE C,BOOK_ADOPTION B
where B.course=C.course and T.book_ISBN=B.book_ISBN and C.dept
in
(select C.dept
from COURSE C,ENROLL E
where C.course=E.course
group by C.dept
having count(distinct E.regno) >= all
(select count(distinct E.regno) 
from course C,enroll E 
where C.course=E.course 
group by C.dept)
);