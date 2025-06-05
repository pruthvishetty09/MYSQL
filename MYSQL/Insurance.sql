-- Create the database
CREATE DATABASE Insurance;
USE Insurance;

-- Create tables
CREATE TABLE PERSON (
    driver_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(100)
);

CREATE TABLE CAR (
    regno VARCHAR(20) PRIMARY KEY,
    model VARCHAR(50),
    year INT
);
SELECT * FROM CAR;

CREATE TABLE ACCIDENT (
    report_number INT PRIMARY KEY,
    accd_date DATE,
    location VARCHAR(100)
);
SELECT * FROM ACCIDENT;

CREATE TABLE OWNS (
    driver_id VARCHAR(20),
    regno VARCHAR(20),
    PRIMARY KEY (driver_id, regno),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (regno) REFERENCES CAR(regno)
);
SELECT * FROM OWNS;

CREATE TABLE PARTICIPATED (
    driver_id VARCHAR(20),
    regno VARCHAR(20),
    report_number INT,
    damage_amount INT,
    PRIMARY KEY (driver_id, regno, report_number),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (regno) REFERENCES CAR(regno),
    FOREIGN KEY (report_number) REFERENCES ACCIDENT(report_number)
);
SELECT * FROM PARTICIPATED;

-- PERSON table
INSERT INTO PERSON VALUES ('D001', 'John Smith', '123 Main St');
INSERT INTO PERSON VALUES ('D002', 'Alice Johnson', '456 Oak Ave');
INSERT INTO PERSON VALUES ('D003', 'Bob Williams', '789 Pine Rd');
INSERT INTO PERSON VALUES ('D004', 'Sarah Davis', '321 Elm St');

-- CAR table
INSERT INTO CAR VALUES ('KA-12', 'Toyota Camry', 1988);
INSERT INTO CAR VALUES ('MB-34', 'Honda Accord', 1989);
INSERT INTO CAR VALUES ('DL-56', 'Ford Taurus', 1990);
INSERT INTO CAR VALUES ('NY-78', 'Chevy Impala', 1989);

-- ACCIDENT table
INSERT INTO ACCIDENT VALUES (1, '1989-05-12', 'Main Street');
INSERT INTO ACCIDENT VALUES (2, '1989-08-23', 'Oak Avenue');
INSERT INTO ACCIDENT VALUES (3, '1990-02-15', 'Pine Road');
INSERT INTO ACCIDENT VALUES (4, '1991-07-30', 'Elm Street');
INSERT INTO ACCIDENT VALUES (5, '1989-11-05', 'Main Street');

-- OWNS table
INSERT INTO OWNS VALUES ('D001', 'KA-12');
INSERT INTO OWNS VALUES ('D001', 'MB-34');
INSERT INTO OWNS VALUES ('D002', 'DL-56');
INSERT INTO OWNS VALUES ('D003', 'NY-78');

-- PARTICIPATED table
INSERT INTO PARTICIPATED VALUES ('D001', 'KA-12', 1, 2500);
INSERT INTO PARTICIPATED VALUES ('D001', 'MB-34', 2, 1800);
INSERT INTO PARTICIPATED VALUES ('D002', 'DL-56', 3, 3200);
INSERT INTO PARTICIPATED VALUES ('D003', 'NY-78', 5, 1500);
INSERT INTO PARTICIPATED VALUES ('D001', 'KA-12', 5, 2000);


select count(distinct P.driver_id) as accd_1989
from Accident A,Participated P
	where A.report_number=P.report_number
	and year(A.accd_date)='1989';

select count(P.regno) as johnsmith
from Participated P,Person PN
where P.driver_id=PN.driver_id
and PN.name='john smith';



update Participated
set damage_amount=3000
where regno='KA-12'
and report_number=1;